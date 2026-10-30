package dev.zeekr.bluetooth_low_energy_android

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertTrue

private const val DEVICE = "00:11:22:33:44:55"
private const val OTHER_DEVICE = "66:77:88:99:AA:BB"

internal class GattOperationQueueTest {
    private val queue = GattOperationQueue()
    private val started = mutableListOf<String>()
    private val abandoned = mutableListOf<String>()

    private fun enqueue(
        name: String,
        operation: GattOperation = GattOperation.READ_DESCRIPTOR,
        address: String = DEVICE,
        startsInFlight: Boolean = true,
    ) {
        queue.enqueue(
            address,
            operation,
            start = {
                started += name
                startsInFlight
            },
            abandon = { abandoned += name },
        )
    }

    @Test
    fun startsTheNextOperationOnlyWhenTheCurrentOneFinishes() {
        enqueue("first")
        enqueue("second")

        assertEquals(listOf("first"), started)

        queue.complete(DEVICE, GattOperation.READ_DESCRIPTOR)

        assertEquals(listOf("first", "second"), started)
    }

    @Test
    fun keepsEachDeviceInItsOwnLine() {
        enqueue("first")
        enqueue("other", address = OTHER_DEVICE)

        assertEquals(listOf("first", "other"), started)
    }

    @Test
    fun movesOnWhenAnOperationCannotStart() {
        enqueue("refused", startsInFlight = false)
        enqueue("next")

        assertEquals(listOf("refused", "next"), started)
        assertEquals(GattOperation.READ_DESCRIPTOR, queue.inFlight(DEVICE))
    }

    @Test
    fun aCallbackOfAnotherKindDoesNotFinishTheOperationInFlight() {
        enqueue("read")
        enqueue("next")

        assertFalse(queue.complete(DEVICE, GattOperation.REQUEST_MTU))
        assertEquals(listOf("read"), started)

        assertTrue(queue.complete(DEVICE, GattOperation.READ_DESCRIPTOR))
        assertEquals(listOf("read", "next"), started)
    }

    @Test
    fun aCompletionWithNothingInFlightIsIgnored() {
        assertFalse(queue.complete(DEVICE, GattOperation.REQUEST_MTU))
    }

    @Test
    fun clearingADeviceAbandonsWhatWaitsAndFreesTheLine() {
        enqueue("inFlight")
        enqueue("waiting")

        queue.clear(DEVICE, IllegalStateException("disconnected"))

        assertEquals(listOf("waiting"), abandoned)
        assertNull(queue.inFlight(DEVICE))

        enqueue("afterReconnect")

        assertEquals(listOf("inFlight", "afterReconnect"), started)
    }
}
