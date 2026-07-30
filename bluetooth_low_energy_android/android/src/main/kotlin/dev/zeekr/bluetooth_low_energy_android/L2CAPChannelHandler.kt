package dev.zeekr.bluetooth_low_energy_android

import android.Manifest
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import androidx.annotation.RequiresPermission
import java.util.concurrent.Executor
import java.util.concurrent.Executors

// Owns a single secure L2CAP CoC socket to a device and bridges its blocking
// input/output streams to byte callbacks.
//
// BluetoothSocket.connect() and read() block, so the connect and the read loop
// run on dedicated worker threads; received bytes and lifecycle callbacks are
// marshalled back onto [mainExecutor] (the main thread) because Pigeon's
// FlutterApi must be invoked there.
//
// The read loop does not start with the socket: [start] begins it once the Dart
// side has a stream to deliver to. Reading any earlier would hand us bytes with
// nowhere to put them; until then the peer's data waits in the socket buffer.
class L2CAPChannelHandler(
    private val device: BluetoothDevice,
    private val psm: Int,
    private val mainExecutor: Executor,
    private val onReceived: (ByteArray) -> Unit,
    private val onClosed: (String?) -> Unit,
) {
    private val ioExecutor = Executors.newSingleThreadExecutor()
    private var readThread: Thread? = null

    // Written on the io worker, read from the main thread in [start].
    @Volatile
    private var socket: BluetoothSocket? = null

    @Volatile
    private var started = false

    @Volatile
    private var finished = false

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    fun open(callback: (Result<Unit>) -> Unit) {
        ioExecutor.execute {
            try {
                // Secure (authenticated/encrypted) channel: required when the
                // peer enforces bonding/encryption on the PSM.
                // createInsecureL2capChannel would skip that.
                val s = device.createL2capChannel(psm)
                socket = s
                s.connect()
                mainExecutor.execute { callback(Result.success(Unit)) }
            } catch (e: Throwable) {
                finish(e.message)
                mainExecutor.execute { callback(Result.failure(e)) }
            }
        }
    }

    @Synchronized
    fun start() {
        if (started || finished) {
            return
        }
        val s = socket ?: return
        started = true
        startReadLoop(s)
    }

    fun write(value: ByteArray, callback: (Result<Unit>) -> Unit) {
        if (finished) {
            mainExecutor.execute { callback(Result.failure(IllegalStateException("L2CAP channel is closed"))) }
            return
        }
        ioExecutor.execute {
            try {
                val out = socket?.outputStream ?: throw IllegalStateException("L2CAP channel is not open")
                out.write(value)
                out.flush()
                mainExecutor.execute { callback(Result.success(Unit)) }
            } catch (e: Throwable) {
                mainExecutor.execute { callback(Result.failure(e)) }
            }
        }
    }

    fun close() {
        finish(null)
    }

    private fun startReadLoop(s: BluetoothSocket) {
        val thread = Thread {
            val input = s.inputStream
            val buffer = ByteArray(8192)
            try {
                while (!finished) {
                    val read = input.read(buffer)
                    if (read < 0) {
                        break // EOF: peer closed the channel = transfer complete.
                    }
                    if (read > 0) {
                        val chunk = buffer.copyOf(read)
                        mainExecutor.execute { if (!finished) onReceived(chunk) }
                    }
                }
                finish(null)
            } catch (e: Throwable) {
                // If we initiated the close, the read exception is expected.
                finish(if (finished) null else e.message)
            }
        }
        thread.isDaemon = true
        readThread = thread
        thread.start()
    }

    @Synchronized
    private fun finish(error: String?) {
        if (finished) {
            return
        }
        finished = true
        try {
            socket?.close()
        } catch (_: Throwable) {
            // Ignore - already tearing down.
        }
        readThread?.interrupt()
        ioExecutor.shutdown()
        mainExecutor.execute { onClosed(error) }
    }
}
