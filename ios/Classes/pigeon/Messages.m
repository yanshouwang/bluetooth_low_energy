// Autogenerated from Pigeon (v4.2.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "Messages.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ?: [NSNull null]),
        @"message": (error.message ?: [NSNull null]),
        @"details": (error.details ?: [NSNull null]),
        };
  }
  return @{
      @"result": (result ?: [NSNull null]),
      @"error": errorDict,
      };
}
static id GetNullableObject(NSDictionary* dict, id key) {
  id result = dict[key];
  return (result == [NSNull null]) ? nil : result;
}
static id GetNullableObjectAtIndex(NSArray* array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}



@interface PigeonCentralManagerHostApiCodecReader : FlutterStandardReader
@end
@implementation PigeonCentralManagerHostApiCodecReader
@end

@interface PigeonCentralManagerHostApiCodecWriter : FlutterStandardWriter
@end
@implementation PigeonCentralManagerHostApiCodecWriter
@end

@interface PigeonCentralManagerHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PigeonCentralManagerHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PigeonCentralManagerHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PigeonCentralManagerHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PigeonCentralManagerHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    PigeonCentralManagerHostApiCodecReaderWriter *readerWriter = [[PigeonCentralManagerHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void PigeonCentralManagerHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonCentralManagerHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.CentralManagerHostApi.authorize"
        binaryMessenger:binaryMessenger
        codec:PigeonCentralManagerHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(authorize:)], @"PigeonCentralManagerHostApi api (%@) doesn't respond to @selector(authorize:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api authorize:^(NSNumber *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.CentralManagerHostApi.getState"
        binaryMessenger:binaryMessenger
        codec:PigeonCentralManagerHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getState:)], @"PigeonCentralManagerHostApi api (%@) doesn't respond to @selector(getState:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api getState:&error];
        callback(wrapResult(output, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.CentralManagerHostApi.startScan"
        binaryMessenger:binaryMessenger
        codec:PigeonCentralManagerHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startScan:completion:)], @"PigeonCentralManagerHostApi api (%@) doesn't respond to @selector(startScan:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSArray<FlutterStandardTypedData *> *arg_uuidBuffers = GetNullableObjectAtIndex(args, 0);
        [api startScan:arg_uuidBuffers completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.CentralManagerHostApi.stopScan"
        binaryMessenger:binaryMessenger
        codec:PigeonCentralManagerHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(stopScan:)], @"PigeonCentralManagerHostApi api (%@) doesn't respond to @selector(stopScan:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api stopScan:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface PigeonCentralManagerFlutterApiCodecReader : FlutterStandardReader
@end
@implementation PigeonCentralManagerFlutterApiCodecReader
@end

@interface PigeonCentralManagerFlutterApiCodecWriter : FlutterStandardWriter
@end
@implementation PigeonCentralManagerFlutterApiCodecWriter
@end

@interface PigeonCentralManagerFlutterApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PigeonCentralManagerFlutterApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PigeonCentralManagerFlutterApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PigeonCentralManagerFlutterApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PigeonCentralManagerFlutterApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    PigeonCentralManagerFlutterApiCodecReaderWriter *readerWriter = [[PigeonCentralManagerFlutterApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


@interface PigeonCentralManagerFlutterApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation PigeonCentralManagerFlutterApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onStateChanged:(NSNumber *)arg_stateNumber completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.CentralManagerFlutterApi.onStateChanged"
      binaryMessenger:self.binaryMessenger
      codec:PigeonCentralManagerFlutterApiGetCodec()];
  [channel sendMessage:@[arg_stateNumber ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
- (void)onScanned:(FlutterStandardTypedData *)arg_broadcastBuffer completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.CentralManagerFlutterApi.onScanned"
      binaryMessenger:self.binaryMessenger
      codec:PigeonCentralManagerFlutterApiGetCodec()];
  [channel sendMessage:@[arg_broadcastBuffer ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end
@interface PigeonPeripheralHostApiCodecReader : FlutterStandardReader
@end
@implementation PigeonPeripheralHostApiCodecReader
@end

@interface PigeonPeripheralHostApiCodecWriter : FlutterStandardWriter
@end
@implementation PigeonPeripheralHostApiCodecWriter
@end

@interface PigeonPeripheralHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PigeonPeripheralHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PigeonPeripheralHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PigeonPeripheralHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PigeonPeripheralHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    PigeonPeripheralHostApiCodecReaderWriter *readerWriter = [[PigeonPeripheralHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void PigeonPeripheralHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonPeripheralHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.PeripheralHostApi.free"
        binaryMessenger:binaryMessenger
        codec:PigeonPeripheralHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(free:error:)], @"PigeonPeripheralHostApi api (%@) doesn't respond to @selector(free:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api free:arg_id error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.PeripheralHostApi.connect"
        binaryMessenger:binaryMessenger
        codec:PigeonPeripheralHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(connect:completion:)], @"PigeonPeripheralHostApi api (%@) doesn't respond to @selector(connect:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        [api connect:arg_id completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.PeripheralHostApi.disconnect"
        binaryMessenger:binaryMessenger
        codec:PigeonPeripheralHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(disconnect:completion:)], @"PigeonPeripheralHostApi api (%@) doesn't respond to @selector(disconnect:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        [api disconnect:arg_id completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.PeripheralHostApi.requestMtu"
        binaryMessenger:binaryMessenger
        codec:PigeonPeripheralHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(requestMtu:completion:)], @"PigeonPeripheralHostApi api (%@) doesn't respond to @selector(requestMtu:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        [api requestMtu:arg_id completion:^(NSNumber *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.PeripheralHostApi.discoverServices"
        binaryMessenger:binaryMessenger
        codec:PigeonPeripheralHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(discoverServices:completion:)], @"PigeonPeripheralHostApi api (%@) doesn't respond to @selector(discoverServices:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        [api discoverServices:arg_id completion:^(NSArray<FlutterStandardTypedData *> *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface PigeonPeripheralFlutterApiCodecReader : FlutterStandardReader
@end
@implementation PigeonPeripheralFlutterApiCodecReader
@end

@interface PigeonPeripheralFlutterApiCodecWriter : FlutterStandardWriter
@end
@implementation PigeonPeripheralFlutterApiCodecWriter
@end

@interface PigeonPeripheralFlutterApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PigeonPeripheralFlutterApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PigeonPeripheralFlutterApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PigeonPeripheralFlutterApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PigeonPeripheralFlutterApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    PigeonPeripheralFlutterApiCodecReaderWriter *readerWriter = [[PigeonPeripheralFlutterApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


@interface PigeonPeripheralFlutterApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation PigeonPeripheralFlutterApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onConnectionLost:(NSString *)arg_id errorMessage:(NSString *)arg_errorMessage completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.PeripheralFlutterApi.onConnectionLost"
      binaryMessenger:self.binaryMessenger
      codec:PigeonPeripheralFlutterApiGetCodec()];
  [channel sendMessage:@[arg_id ?: [NSNull null], arg_errorMessage ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end
@interface PigeonGattServiceHostApiCodecReader : FlutterStandardReader
@end
@implementation PigeonGattServiceHostApiCodecReader
@end

@interface PigeonGattServiceHostApiCodecWriter : FlutterStandardWriter
@end
@implementation PigeonGattServiceHostApiCodecWriter
@end

@interface PigeonGattServiceHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PigeonGattServiceHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PigeonGattServiceHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PigeonGattServiceHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PigeonGattServiceHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    PigeonGattServiceHostApiCodecReaderWriter *readerWriter = [[PigeonGattServiceHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void PigeonGattServiceHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonGattServiceHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattServiceHostApi.free"
        binaryMessenger:binaryMessenger
        codec:PigeonGattServiceHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(free:error:)], @"PigeonGattServiceHostApi api (%@) doesn't respond to @selector(free:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api free:arg_id error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattServiceHostApi.discoverCharacteristics"
        binaryMessenger:binaryMessenger
        codec:PigeonGattServiceHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(discoverCharacteristics:completion:)], @"PigeonGattServiceHostApi api (%@) doesn't respond to @selector(discoverCharacteristics:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        [api discoverCharacteristics:arg_id completion:^(NSArray<FlutterStandardTypedData *> *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface PigeonGattCharacteristicHostApiCodecReader : FlutterStandardReader
@end
@implementation PigeonGattCharacteristicHostApiCodecReader
@end

@interface PigeonGattCharacteristicHostApiCodecWriter : FlutterStandardWriter
@end
@implementation PigeonGattCharacteristicHostApiCodecWriter
@end

@interface PigeonGattCharacteristicHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PigeonGattCharacteristicHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PigeonGattCharacteristicHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PigeonGattCharacteristicHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PigeonGattCharacteristicHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    PigeonGattCharacteristicHostApiCodecReaderWriter *readerWriter = [[PigeonGattCharacteristicHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void PigeonGattCharacteristicHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonGattCharacteristicHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattCharacteristicHostApi.free"
        binaryMessenger:binaryMessenger
        codec:PigeonGattCharacteristicHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(free:error:)], @"PigeonGattCharacteristicHostApi api (%@) doesn't respond to @selector(free:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api free:arg_id error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattCharacteristicHostApi.discoverDescriptors"
        binaryMessenger:binaryMessenger
        codec:PigeonGattCharacteristicHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(discoverDescriptors:completion:)], @"PigeonGattCharacteristicHostApi api (%@) doesn't respond to @selector(discoverDescriptors:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        [api discoverDescriptors:arg_id completion:^(NSArray<FlutterStandardTypedData *> *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattCharacteristicHostApi.read"
        binaryMessenger:binaryMessenger
        codec:PigeonGattCharacteristicHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(read:completion:)], @"PigeonGattCharacteristicHostApi api (%@) doesn't respond to @selector(read:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        [api read:arg_id completion:^(FlutterStandardTypedData *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattCharacteristicHostApi.write"
        binaryMessenger:binaryMessenger
        codec:PigeonGattCharacteristicHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(write:value:withoutResponse:completion:)], @"PigeonGattCharacteristicHostApi api (%@) doesn't respond to @selector(write:value:withoutResponse:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        FlutterStandardTypedData *arg_value = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_withoutResponse = GetNullableObjectAtIndex(args, 2);
        [api write:arg_id value:arg_value withoutResponse:arg_withoutResponse completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattCharacteristicHostApi.setNotify"
        binaryMessenger:binaryMessenger
        codec:PigeonGattCharacteristicHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setNotify:value:completion:)], @"PigeonGattCharacteristicHostApi api (%@) doesn't respond to @selector(setNotify:value:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_value = GetNullableObjectAtIndex(args, 1);
        [api setNotify:arg_id value:arg_value completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface PigeonGattCharacteristicFlutterApiCodecReader : FlutterStandardReader
@end
@implementation PigeonGattCharacteristicFlutterApiCodecReader
@end

@interface PigeonGattCharacteristicFlutterApiCodecWriter : FlutterStandardWriter
@end
@implementation PigeonGattCharacteristicFlutterApiCodecWriter
@end

@interface PigeonGattCharacteristicFlutterApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PigeonGattCharacteristicFlutterApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PigeonGattCharacteristicFlutterApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PigeonGattCharacteristicFlutterApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PigeonGattCharacteristicFlutterApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    PigeonGattCharacteristicFlutterApiCodecReaderWriter *readerWriter = [[PigeonGattCharacteristicFlutterApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


@interface PigeonGattCharacteristicFlutterApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation PigeonGattCharacteristicFlutterApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)onValueChanged:(NSString *)arg_id value:(FlutterStandardTypedData *)arg_value completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.GattCharacteristicFlutterApi.onValueChanged"
      binaryMessenger:self.binaryMessenger
      codec:PigeonGattCharacteristicFlutterApiGetCodec()];
  [channel sendMessage:@[arg_id ?: [NSNull null], arg_value ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end
@interface PigeonGattDescriptorHostApiCodecReader : FlutterStandardReader
@end
@implementation PigeonGattDescriptorHostApiCodecReader
@end

@interface PigeonGattDescriptorHostApiCodecWriter : FlutterStandardWriter
@end
@implementation PigeonGattDescriptorHostApiCodecWriter
@end

@interface PigeonGattDescriptorHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PigeonGattDescriptorHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PigeonGattDescriptorHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PigeonGattDescriptorHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *PigeonGattDescriptorHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    PigeonGattDescriptorHostApiCodecReaderWriter *readerWriter = [[PigeonGattDescriptorHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void PigeonGattDescriptorHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PigeonGattDescriptorHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattDescriptorHostApi.free"
        binaryMessenger:binaryMessenger
        codec:PigeonGattDescriptorHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(free:error:)], @"PigeonGattDescriptorHostApi api (%@) doesn't respond to @selector(free:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api free:arg_id error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattDescriptorHostApi.read"
        binaryMessenger:binaryMessenger
        codec:PigeonGattDescriptorHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(read:completion:)], @"PigeonGattDescriptorHostApi api (%@) doesn't respond to @selector(read:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        [api read:arg_id completion:^(FlutterStandardTypedData *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.GattDescriptorHostApi.write"
        binaryMessenger:binaryMessenger
        codec:PigeonGattDescriptorHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(write:value:completion:)], @"PigeonGattDescriptorHostApi api (%@) doesn't respond to @selector(write:value:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_id = GetNullableObjectAtIndex(args, 0);
        FlutterStandardTypedData *arg_value = GetNullableObjectAtIndex(args, 1);
        [api write:arg_id value:arg_value completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
