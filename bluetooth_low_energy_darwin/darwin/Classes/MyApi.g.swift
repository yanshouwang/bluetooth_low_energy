// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

enum MyCentralStateArgs: Int {
  case unknown = 0
  case unsupported = 1
  case unauthorized = 2
  case poweredOff = 3
  case poweredOn = 4
}

enum MyGattCharacteristicPropertyArgs: Int {
  case read = 0
  case write = 1
  case writeWithoutResponse = 2
  case notify = 3
  case indicate = 4
}

enum MyGattCharacteristicWriteTypeArgs: Int {
  case withResponse = 0
  case withoutResponse = 1
}

/// Generated class from Pigeon that represents data sent in messages.
struct MyCentralControllerArgs {
  var myStateNumber: Int64

  static func fromList(_ list: [Any?]) -> MyCentralControllerArgs? {
    let myStateNumber = list[0] is Int64 ? list[0] as! Int64 : Int64(list[0] as! Int32)

    return MyCentralControllerArgs(
      myStateNumber: myStateNumber
    )
  }
  func toList() -> [Any?] {
    return [
      myStateNumber,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MyPeripheralArgs {
  var key: Int64
  var uuid: String

  static func fromList(_ list: [Any?]) -> MyPeripheralArgs? {
    let key = list[0] is Int64 ? list[0] as! Int64 : Int64(list[0] as! Int32)
    let uuid = list[1] as! String

    return MyPeripheralArgs(
      key: key,
      uuid: uuid
    )
  }
  func toList() -> [Any?] {
    return [
      key,
      uuid,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MyAdvertisementArgs {
  var name: String? = nil
  var manufacturerSpecificData: [Int64?: FlutterStandardTypedData?]
  var serviceUUIDs: [String?]
  var serviceData: [String?: FlutterStandardTypedData?]

  static func fromList(_ list: [Any?]) -> MyAdvertisementArgs? {
    let name: String? = nilOrValue(list[0])
    let manufacturerSpecificData = list[1] as! [Int64?: FlutterStandardTypedData?]
    let serviceUUIDs = list[2] as! [String?]
    let serviceData = list[3] as! [String?: FlutterStandardTypedData?]

    return MyAdvertisementArgs(
      name: name,
      manufacturerSpecificData: manufacturerSpecificData,
      serviceUUIDs: serviceUUIDs,
      serviceData: serviceData
    )
  }
  func toList() -> [Any?] {
    return [
      name,
      manufacturerSpecificData,
      serviceUUIDs,
      serviceData,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MyGattServiceArgs {
  var key: Int64
  var uuid: String

  static func fromList(_ list: [Any?]) -> MyGattServiceArgs? {
    let key = list[0] is Int64 ? list[0] as! Int64 : Int64(list[0] as! Int32)
    let uuid = list[1] as! String

    return MyGattServiceArgs(
      key: key,
      uuid: uuid
    )
  }
  func toList() -> [Any?] {
    return [
      key,
      uuid,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MyGattCharacteristicArgs {
  var key: Int64
  var uuid: String
  var myPropertyNumbers: [Int64?]

  static func fromList(_ list: [Any?]) -> MyGattCharacteristicArgs? {
    let key = list[0] is Int64 ? list[0] as! Int64 : Int64(list[0] as! Int32)
    let uuid = list[1] as! String
    let myPropertyNumbers = list[2] as! [Int64?]

    return MyGattCharacteristicArgs(
      key: key,
      uuid: uuid,
      myPropertyNumbers: myPropertyNumbers
    )
  }
  func toList() -> [Any?] {
    return [
      key,
      uuid,
      myPropertyNumbers,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MyGattDescriptorArgs {
  var key: Int64
  var uuid: String

  static func fromList(_ list: [Any?]) -> MyGattDescriptorArgs? {
    let key = list[0] is Int64 ? list[0] as! Int64 : Int64(list[0] as! Int32)
    let uuid = list[1] as! String

    return MyGattDescriptorArgs(
      key: key,
      uuid: uuid
    )
  }
  func toList() -> [Any?] {
    return [
      key,
      uuid,
    ]
  }
}

private class MyCentralControllerHostApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return MyCentralControllerArgs.fromList(self.readValue() as! [Any?])
      case 129:
        return MyGattCharacteristicArgs.fromList(self.readValue() as! [Any?])
      case 130:
        return MyGattDescriptorArgs.fromList(self.readValue() as! [Any?])
      case 131:
        return MyGattServiceArgs.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class MyCentralControllerHostApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? MyCentralControllerArgs {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? MyGattCharacteristicArgs {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? MyGattDescriptorArgs {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? MyGattServiceArgs {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class MyCentralControllerHostApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return MyCentralControllerHostApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return MyCentralControllerHostApiCodecWriter(data: data)
  }
}

class MyCentralControllerHostApiCodec: FlutterStandardMessageCodec {
  static let shared = MyCentralControllerHostApiCodec(readerWriter: MyCentralControllerHostApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol MyCentralControllerHostApi {
  func setUp(completion: @escaping (Result<MyCentralControllerArgs, Error>) -> Void)
  func tearDown() throws
  func startDiscovery() throws
  func stopDiscovery() throws
  func connect(myPeripheralKey: Int64, completion: @escaping (Result<Void, Error>) -> Void)
  func disconnect(myPeripheralKey: Int64, completion: @escaping (Result<Void, Error>) -> Void)
  func getMaximumWriteLength(myPeripheralKey: Int64) throws -> Int64
  func discoverGATT(myPeripheralKey: Int64, completion: @escaping (Result<Void, Error>) -> Void)
  func getServices(myPeripheralKey: Int64) throws -> [MyGattServiceArgs]
  func getCharacteristics(myServiceKey: Int64) throws -> [MyGattCharacteristicArgs]
  func getDescriptors(myCharacteristicKey: Int64) throws -> [MyGattDescriptorArgs]
  func readCharacteristic(myPeripheralKey: Int64, myServiceKey: Int64, myCharacteristicKey: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void)
  func writeCharacteristic(myPeripheralKey: Int64, myServiceKey: Int64, myCharacteristicKey: Int64, value: FlutterStandardTypedData, myTypeNumber: Int64, completion: @escaping (Result<Void, Error>) -> Void)
  func notifyCharacteristic(myPeripheralKey: Int64, myServiceKey: Int64, myCharacteristicKey: Int64, state: Bool, completion: @escaping (Result<Void, Error>) -> Void)
  func readDescriptor(myPeripheralKey: Int64, myCharacteristicKey: Int64, myDescriptorKey: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void)
  func writeDescriptor(myPeripheralKey: Int64, myCharacteristicKey: Int64, myDescriptorKey: Int64, value: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class MyCentralControllerHostApiSetup {
  /// The codec used by MyCentralControllerHostApi.
  static var codec: FlutterStandardMessageCodec { MyCentralControllerHostApiCodec.shared }
  /// Sets up an instance of `MyCentralControllerHostApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: MyCentralControllerHostApi?) {
    let setUpChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.setUp", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setUpChannel.setMessageHandler { _, reply in
        api.setUp() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      setUpChannel.setMessageHandler(nil)
    }
    let tearDownChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.tearDown", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      tearDownChannel.setMessageHandler { _, reply in
        do {
          try api.tearDown()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      tearDownChannel.setMessageHandler(nil)
    }
    let startDiscoveryChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.startDiscovery", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      startDiscoveryChannel.setMessageHandler { _, reply in
        do {
          try api.startDiscovery()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      startDiscoveryChannel.setMessageHandler(nil)
    }
    let stopDiscoveryChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.stopDiscovery", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      stopDiscoveryChannel.setMessageHandler { _, reply in
        do {
          try api.stopDiscovery()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      stopDiscoveryChannel.setMessageHandler(nil)
    }
    let connectChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.connect", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      connectChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        api.connect(myPeripheralKey: myPeripheralKeyArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      connectChannel.setMessageHandler(nil)
    }
    let disconnectChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.disconnect", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      disconnectChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        api.disconnect(myPeripheralKey: myPeripheralKeyArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      disconnectChannel.setMessageHandler(nil)
    }
    let getMaximumWriteLengthChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.getMaximumWriteLength", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getMaximumWriteLengthChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        do {
          let result = try api.getMaximumWriteLength(myPeripheralKey: myPeripheralKeyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getMaximumWriteLengthChannel.setMessageHandler(nil)
    }
    let discoverGATTChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.discoverGATT", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      discoverGATTChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        api.discoverGATT(myPeripheralKey: myPeripheralKeyArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      discoverGATTChannel.setMessageHandler(nil)
    }
    let getServicesChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.getServices", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getServicesChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        do {
          let result = try api.getServices(myPeripheralKey: myPeripheralKeyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getServicesChannel.setMessageHandler(nil)
    }
    let getCharacteristicsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.getCharacteristics", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getCharacteristicsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myServiceKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        do {
          let result = try api.getCharacteristics(myServiceKey: myServiceKeyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getCharacteristicsChannel.setMessageHandler(nil)
    }
    let getDescriptorsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.getDescriptors", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getDescriptorsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myCharacteristicKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        do {
          let result = try api.getDescriptors(myCharacteristicKey: myCharacteristicKeyArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getDescriptorsChannel.setMessageHandler(nil)
    }
    let readCharacteristicChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.readCharacteristic", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      readCharacteristicChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        let myServiceKeyArg = args[1] is Int64 ? args[1] as! Int64 : Int64(args[1] as! Int32)
        let myCharacteristicKeyArg = args[2] is Int64 ? args[2] as! Int64 : Int64(args[2] as! Int32)
        api.readCharacteristic(myPeripheralKey: myPeripheralKeyArg, myServiceKey: myServiceKeyArg, myCharacteristicKey: myCharacteristicKeyArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      readCharacteristicChannel.setMessageHandler(nil)
    }
    let writeCharacteristicChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.writeCharacteristic", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      writeCharacteristicChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        let myServiceKeyArg = args[1] is Int64 ? args[1] as! Int64 : Int64(args[1] as! Int32)
        let myCharacteristicKeyArg = args[2] is Int64 ? args[2] as! Int64 : Int64(args[2] as! Int32)
        let valueArg = args[3] as! FlutterStandardTypedData
        let myTypeNumberArg = args[4] is Int64 ? args[4] as! Int64 : Int64(args[4] as! Int32)
        api.writeCharacteristic(myPeripheralKey: myPeripheralKeyArg, myServiceKey: myServiceKeyArg, myCharacteristicKey: myCharacteristicKeyArg, value: valueArg, myTypeNumber: myTypeNumberArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      writeCharacteristicChannel.setMessageHandler(nil)
    }
    let notifyCharacteristicChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.notifyCharacteristic", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      notifyCharacteristicChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        let myServiceKeyArg = args[1] is Int64 ? args[1] as! Int64 : Int64(args[1] as! Int32)
        let myCharacteristicKeyArg = args[2] is Int64 ? args[2] as! Int64 : Int64(args[2] as! Int32)
        let stateArg = args[3] as! Bool
        api.notifyCharacteristic(myPeripheralKey: myPeripheralKeyArg, myServiceKey: myServiceKeyArg, myCharacteristicKey: myCharacteristicKeyArg, state: stateArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      notifyCharacteristicChannel.setMessageHandler(nil)
    }
    let readDescriptorChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.readDescriptor", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      readDescriptorChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        let myCharacteristicKeyArg = args[1] is Int64 ? args[1] as! Int64 : Int64(args[1] as! Int32)
        let myDescriptorKeyArg = args[2] is Int64 ? args[2] as! Int64 : Int64(args[2] as! Int32)
        api.readDescriptor(myPeripheralKey: myPeripheralKeyArg, myCharacteristicKey: myCharacteristicKeyArg, myDescriptorKey: myDescriptorKeyArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      readDescriptorChannel.setMessageHandler(nil)
    }
    let writeDescriptorChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.writeDescriptor", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      writeDescriptorChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let myPeripheralKeyArg = args[0] is Int64 ? args[0] as! Int64 : Int64(args[0] as! Int32)
        let myCharacteristicKeyArg = args[1] is Int64 ? args[1] as! Int64 : Int64(args[1] as! Int32)
        let myDescriptorKeyArg = args[2] is Int64 ? args[2] as! Int64 : Int64(args[2] as! Int32)
        let valueArg = args[3] as! FlutterStandardTypedData
        api.writeDescriptor(myPeripheralKey: myPeripheralKeyArg, myCharacteristicKey: myCharacteristicKeyArg, myDescriptorKey: myDescriptorKeyArg, value: valueArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      writeDescriptorChannel.setMessageHandler(nil)
    }
  }
}
private class MyCentralControllerFlutterApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return MyAdvertisementArgs.fromList(self.readValue() as! [Any?])
      case 129:
        return MyPeripheralArgs.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class MyCentralControllerFlutterApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? MyAdvertisementArgs {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? MyPeripheralArgs {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class MyCentralControllerFlutterApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return MyCentralControllerFlutterApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return MyCentralControllerFlutterApiCodecWriter(data: data)
  }
}

class MyCentralControllerFlutterApiCodec: FlutterStandardMessageCodec {
  static let shared = MyCentralControllerFlutterApiCodec(readerWriter: MyCentralControllerFlutterApiCodecReaderWriter())
}

/// Generated class from Pigeon that represents Flutter messages that can be called from Swift.
class MyCentralControllerFlutterApi {
  private let binaryMessenger: FlutterBinaryMessenger
  init(binaryMessenger: FlutterBinaryMessenger){
    self.binaryMessenger = binaryMessenger
  }
  var codec: FlutterStandardMessageCodec {
    return MyCentralControllerFlutterApiCodec.shared
  }
  func onStateChanged(myStateNumber myStateNumberArg: Int64, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onStateChanged", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([myStateNumberArg] as [Any?]) { _ in
      completion()
    }
  }
  func onDiscovered(myPeripheralArgs myPeripheralArgsArg: MyPeripheralArgs, rssi rssiArg: Int64, myAdvertisementArgs myAdvertisementArgsArg: MyAdvertisementArgs, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onDiscovered", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([myPeripheralArgsArg, rssiArg, myAdvertisementArgsArg] as [Any?]) { _ in
      completion()
    }
  }
  func onPeripheralStateChanged(myPeripheralKey myPeripheralKeyArg: Int64, state stateArg: Bool, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onPeripheralStateChanged", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([myPeripheralKeyArg, stateArg] as [Any?]) { _ in
      completion()
    }
  }
  func onCharacteristicValueChanged(myCharacteristicKey myCharacteristicKeyArg: Int64, value valueArg: FlutterStandardTypedData, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onCharacteristicValueChanged", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([myCharacteristicKeyArg, valueArg] as [Any?]) { _ in
      completion()
    }
  }
}
