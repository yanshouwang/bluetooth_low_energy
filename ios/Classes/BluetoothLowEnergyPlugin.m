#import "BluetoothLowEnergyPlugin.h"
#if __has_include(<bluetooth_low_energy/bluetooth_low_energy-Swift.h>)
#import <bluetooth_low_energy/bluetooth_low_energy-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bluetooth_low_energy-Swift.h"
#endif

@implementation BluetoothLowEnergyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBluetoothLowEnergyPlugin registerWithRegistrar:registrar];
}
@end
