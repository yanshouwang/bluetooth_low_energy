#import "BluetoothLowEnergyIosPlugin.h"
#if __has_include(<bluetooth_low_energy_ios/bluetooth_low_energy_ios-Swift.h>)
#import <bluetooth_low_energy_ios/bluetooth_low_energy_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bluetooth_low_energy_ios-Swift.h"
#endif

@implementation BluetoothLowEnergyIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBluetoothLowEnergyIosPlugin registerWithRegistrar:registrar];
}
@end
