# bluetooth_low_energy_platform_interface

A common platform interface for the [`bluetooth_low_energy`][1] plugin.

This interface allows platform-specific implementations of the `bluetooth_low_energy`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.

# Usage

To implement a new platform-specific implementation of `bluetooth_low_energy`, 
extend [`PlatformCentralManager`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`PlatformCentralManager` by calling `PlatformCentralManager.instance = XXXCentralManager()`, 
extend [`PlatformPeripheralManager`][3] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`PlatformPeripheralManager` by calling `PlatformPeripheralManager.instance = XXXPeripheralManager()`.

# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See https://flutter.dev/go/platform-interface-breaking-changes for a discussion
on why a less-clean interface is preferable to a breaking change.

[1]: https://pub.dev/packages/bluetooth_low_energy
[2]: lib/src/central_manager.dart
[3]: lib/src/peripheral_manager.dart
