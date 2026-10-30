package dev.zeekr.bluetooth_low_energy_android

/**
 * The kind of a GATT operation. A callback the peer starts on its own, such as
 * an MTU change, must not finish an operation of another kind.
 */
internal enum class GattOperation {
    REQUEST_MTU,
    READ_RSSI,
    DISCOVER_SERVICES,
    READ_CHARACTERISTIC,
    WRITE_CHARACTERISTIC,
    READ_DESCRIPTOR,
    WRITE_DESCRIPTOR,
}

/**
 * Runs the GATT operations of each device one at a time.
 *
 * Android keeps a single outstanding operation per `BluetoothGatt` and refuses
 * a second one: the call returns false. Callers that overlap, such as a
 * descriptor read issued while notifications are being enabled, then fail at
 * random instead of waiting their turn.
 */
internal class GattOperationQueue {
    private class Entry(
        val operation: GattOperation,
        val start: () -> Boolean,
        val abandon: (Throwable) -> Unit,
    )

    private val waiting = mutableMapOf<String, ArrayDeque<Entry>>()
    private val inFlight = mutableMapOf<String, Entry>()

    /**
     * Queues an operation for [address] and starts it when the device has
     * nothing in flight.
     *
     * [start] returns true when it issued an operation that a GATT callback
     * finishes, and false when it already answered its caller because the
     * operation could not start. [abandon] answers the caller when the operation
     * is dropped before it starts.
     */
    fun enqueue(address: String, operation: GattOperation, start: () -> Boolean, abandon: (Throwable) -> Unit) {
        waiting.getOrPut(address) { ArrayDeque() }.addLast(Entry(operation, start, abandon))
        if (address !in inFlight) {
            startNext(address)
        }
    }

    /**
     * Finishes the operation in flight for [address] when it is an [operation],
     * then starts the next one. Returns whether an operation was finished.
     */
    fun complete(address: String, operation: GattOperation): Boolean {
        val current = inFlight[address] ?: return false
        if (current.operation != operation) {
            return false
        }
        inFlight.remove(address)
        startNext(address)
        return true
    }

    /** The kind of the operation in flight for [address], or null. */
    fun inFlight(address: String): GattOperation? = inFlight[address]?.operation

    /**
     * Forgets the operation in flight for [address] and drops every waiting
     * one, answering their callers with [error]. The caller of the operation in
     * flight is answered by whoever holds its callback.
     */
    fun clear(address: String, error: Throwable) {
        inFlight.remove(address)
        waiting.remove(address)?.forEach { entry -> entry.abandon(error) }
    }

    /** [clear] for every device. */
    fun clearAll(error: Throwable) {
        for (address in (waiting.keys + inFlight.keys).toSet()) {
            clear(address, error)
        }
    }

    private fun startNext(address: String) {
        val queue = waiting[address] ?: return
        while (queue.isNotEmpty()) {
            val entry = queue.removeFirst()
            if (entry.start()) {
                inFlight[address] = entry
                return
            }
        }
        waiting.remove(address)
    }
}
