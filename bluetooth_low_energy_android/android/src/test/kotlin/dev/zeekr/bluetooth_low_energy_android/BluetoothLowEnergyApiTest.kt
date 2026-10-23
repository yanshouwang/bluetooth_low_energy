package dev.zeekr.bluetooth_low_energy_android

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

/**
 * Unit tests of the GATT permission mapping.
 *
 * The permissions are what makes a peripheral ask its centrals for an encrypted
 * link, they have to survive the trip from the pigeon args to the Android ones.
 */
internal class BluetoothLowEnergyApiTest {
    private val uuidArgs = "00002a4d-0000-1000-8000-00805f9b34fb"

    @Test
    fun getPermissionsMapsPlainPermissions() {
        val args = characteristicArgsOf(encrypted = false)

        assertEquals(
            BluetoothGattCharacteristic.PERMISSION_READ or BluetoothGattCharacteristic.PERMISSION_WRITE,
            args.getPermissions(),
        )
    }

    @Test
    fun getPermissionsMapsEncryptedPermissions() {
        val args = characteristicArgsOf(encrypted = true)

        assertEquals(
            BluetoothGattCharacteristic.PERMISSION_READ_ENCRYPTED or BluetoothGattCharacteristic.PERMISSION_WRITE_ENCRYPTED,
            args.getPermissions(),
        )
    }

    @Test
    fun getPermissionsPrefersEncryptedOverPlain() {
        val permissionsArgs = listOf(
            GATTCharacteristicPermissionArgs.READ,
            GATTCharacteristicPermissionArgs.READ_ENCRYPTED,
            GATTCharacteristicPermissionArgs.WRITE,
            GATTCharacteristicPermissionArgs.WRITE_ENCRYPTED,
        )
        val args = characteristicArgsOf(permissionsArgs)

        assertEquals(
            BluetoothGattCharacteristic.PERMISSION_READ_ENCRYPTED or BluetoothGattCharacteristic.PERMISSION_WRITE_ENCRYPTED,
            args.getPermissions(),
        )
    }

    @Test
    fun getPermissionsMapsWriteOnlyPermissions() {
        val args = characteristicArgsOf(
            listOf(GATTCharacteristicPermissionArgs.WRITE_ENCRYPTED),
        )

        assertEquals(BluetoothGattCharacteristic.PERMISSION_WRITE_ENCRYPTED, args.getPermissions())
    }

    @Test
    fun getPermissionsMapsNoPermissions() {
        val args = characteristicArgsOf(listOf())

        assertEquals(0, args.getPermissions())
    }

    @Test
    fun getDescriptorPermissionsMapsReadOnlyPermissions() {
        val args = descriptorArgsOf(listOf(GATTCharacteristicPermissionArgs.READ))

        assertEquals(BluetoothGattDescriptor.PERMISSION_READ, args.getPermissions())
    }

    @Test
    fun getDescriptorPermissionsMapsReadWritePermissions() {
        val args = descriptorArgsOf(
            listOf(
                GATTCharacteristicPermissionArgs.READ,
                GATTCharacteristicPermissionArgs.WRITE,
            ),
        )

        assertEquals(
            BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE,
            args.getPermissions(),
        )
    }

    private fun characteristicArgsOf(
        permissionsArgs: List<GATTCharacteristicPermissionArgs>,
    ): MutableGATTCharacteristicArgs {
        val permissionNumbersArgs = permissionsArgs.toNumbers()
        return MutableGATTCharacteristicArgs(
            0L,
            uuidArgs,
            permissionNumbersArgs,
            listOf(),
            listOf(),
        )
    }

    private fun characteristicArgsOf(encrypted: Boolean): MutableGATTCharacteristicArgs {
        val permissionsArgs = if (encrypted) {
            listOf(
                GATTCharacteristicPermissionArgs.READ_ENCRYPTED,
                GATTCharacteristicPermissionArgs.WRITE_ENCRYPTED,
            )
        } else {
            listOf(
                GATTCharacteristicPermissionArgs.READ,
                GATTCharacteristicPermissionArgs.WRITE,
            )
        }
        return characteristicArgsOf(permissionsArgs)
    }

    private fun descriptorArgsOf(
        permissionsArgs: List<GATTCharacteristicPermissionArgs>,
    ): MutableGATTDescriptorArgs {
        val permissionNumbersArgs = permissionsArgs.toNumbers()
        return MutableGATTDescriptorArgs(0L, uuidArgs, permissionNumbersArgs)
    }

    private fun List<GATTCharacteristicPermissionArgs>.toNumbers(): List<Long> {
        return map { args -> args.raw.toLong() }
    }
}
