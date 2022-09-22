// Autogenerated from Pigeon (v4.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN


/// The codec used by PigeonCentralManagerHostApi.
NSObject<FlutterMessageCodec> *PigeonCentralManagerHostApiGetCodec(void);

@protocol PigeonCentralManagerHostApi
- (void)authorize:(void(^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getState:(FlutterError *_Nullable *_Nonnull)error;
- (void)addStateObserver:(FlutterError *_Nullable *_Nonnull)error;
- (void)removeStateObserver:(FlutterError *_Nullable *_Nonnull)error;
- (void)startScan:(nullable NSArray<FlutterStandardTypedData *> *)uuidBuffers completion:(void(^)(FlutterError *_Nullable))completion;
- (void)stopScan:(FlutterError *_Nullable *_Nonnull)error;
- (void)connect:(FlutterStandardTypedData *)uuidBuffer completion:(void(^)(FlutterStandardTypedData *_Nullable, FlutterError *_Nullable))completion;
@end

extern void PigeonCentralManagerHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonCentralManagerHostApi> *_Nullable api);

/// The codec used by PigeonCentralManagerFlutterApi.
NSObject<FlutterMessageCodec> *PigeonCentralManagerFlutterApiGetCodec(void);

@interface PigeonCentralManagerFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)notifyState:(NSNumber *)stateNumber completion:(void(^)(NSError *_Nullable))completion;
- (void)notifyAdvertisement:(FlutterStandardTypedData *)advertisementBuffer completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by PigeonPeripheralHostApi.
NSObject<FlutterMessageCodec> *PigeonPeripheralHostApiGetCodec(void);

@protocol PigeonPeripheralHostApi
- (void)allocate:(NSNumber *)id instanceId:(NSNumber *)instanceId error:(FlutterError *_Nullable *_Nonnull)error;
- (void)free:(NSNumber *)id error:(FlutterError *_Nullable *_Nonnull)error;
- (void)disconnect:(NSNumber *)id completion:(void(^)(FlutterError *_Nullable))completion;
- (void)discoverServices:(NSNumber *)id completion:(void(^)(NSArray<FlutterStandardTypedData *> *_Nullable, FlutterError *_Nullable))completion;
@end

extern void PigeonPeripheralHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonPeripheralHostApi> *_Nullable api);

/// The codec used by PigeonPeripheralFlutterApi.
NSObject<FlutterMessageCodec> *PigeonPeripheralFlutterApiGetCodec(void);

@interface PigeonPeripheralFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)notifyConnectionLost:(NSNumber *)id errorBuffer:(FlutterStandardTypedData *)errorBuffer completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by PigeonGattServiceHostApi.
NSObject<FlutterMessageCodec> *PigeonGattServiceHostApiGetCodec(void);

@protocol PigeonGattServiceHostApi
- (void)allocate:(NSNumber *)id instanceId:(NSNumber *)instanceId error:(FlutterError *_Nullable *_Nonnull)error;
- (void)free:(NSNumber *)id error:(FlutterError *_Nullable *_Nonnull)error;
- (void)discoverCharacteristics:(NSNumber *)id completion:(void(^)(NSArray<FlutterStandardTypedData *> *_Nullable, FlutterError *_Nullable))completion;
@end

extern void PigeonGattServiceHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonGattServiceHostApi> *_Nullable api);

/// The codec used by PigeonGattCharacteristicHostApi.
NSObject<FlutterMessageCodec> *PigeonGattCharacteristicHostApiGetCodec(void);

@protocol PigeonGattCharacteristicHostApi
- (void)allocate:(NSNumber *)id instanceId:(NSNumber *)instanceId error:(FlutterError *_Nullable *_Nonnull)error;
- (void)free:(NSNumber *)id error:(FlutterError *_Nullable *_Nonnull)error;
- (void)discoverDescriptors:(NSNumber *)id completion:(void(^)(NSArray<FlutterStandardTypedData *> *_Nullable, FlutterError *_Nullable))completion;
- (void)read:(NSNumber *)id completion:(void(^)(FlutterStandardTypedData *_Nullable, FlutterError *_Nullable))completion;
- (void)write:(NSNumber *)id value:(FlutterStandardTypedData *)value withoutResponse:(NSNumber *)withoutResponse completion:(void(^)(FlutterError *_Nullable))completion;
- (void)setNotify:(NSNumber *)id value:(NSNumber *)value completion:(void(^)(FlutterError *_Nullable))completion;
@end

extern void PigeonGattCharacteristicHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonGattCharacteristicHostApi> *_Nullable api);

/// The codec used by PigeonGattCharacteristicFlutterApi.
NSObject<FlutterMessageCodec> *PigeonGattCharacteristicFlutterApiGetCodec(void);

@interface PigeonGattCharacteristicFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)notifyValue:(NSNumber *)id value:(FlutterStandardTypedData *)value completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by PigeonGattDescriptorHostApi.
NSObject<FlutterMessageCodec> *PigeonGattDescriptorHostApiGetCodec(void);

@protocol PigeonGattDescriptorHostApi
- (void)allocate:(NSNumber *)id instanceId:(NSNumber *)instanceId error:(FlutterError *_Nullable *_Nonnull)error;
- (void)free:(NSNumber *)id error:(FlutterError *_Nullable *_Nonnull)error;
- (void)read:(NSNumber *)id completion:(void(^)(FlutterStandardTypedData *_Nullable, FlutterError *_Nullable))completion;
- (void)write:(NSNumber *)id value:(FlutterStandardTypedData *)value completion:(void(^)(FlutterError *_Nullable))completion;
@end

extern void PigeonGattDescriptorHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonGattDescriptorHostApi> *_Nullable api);

NS_ASSUME_NONNULL_END
