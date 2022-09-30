//
//  MyGattCharacteristicHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyGattCharacteristicHostApi: NSObject, PigeonGattCharacteristicHostApi {
    func free(_ id: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        unregister(id)
    }
    
    func discoverDescriptors(_ id: String, completion: @escaping ([FlutterStandardTypedData]?, FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let characteristic = items[KEY_CHARACTERISTIC] as! CBCharacteristic
        let peripheral = characteristic.service!.peripheral!
        peripheral.discoverDescriptors(for: characteristic)
        instances["\(id)/\(KEY_DISCOVER_DESCRIPTORS_COMPLETION)"] = completion
    }
    
    func read(_ id: String, completion: @escaping (FlutterStandardTypedData?, FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let characteristic = items[KEY_CHARACTERISTIC] as! CBCharacteristic
        let peripheral = characteristic.service!.peripheral!
        peripheral.readValue(for: characteristic)
        instances["\(id)/\(KEY_READ_COMPLETION)"] = completion
    }
    
    func write(_ id: String, value: FlutterStandardTypedData, withoutResponse: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let characteristic = items[KEY_CHARACTERISTIC] as! CBCharacteristic
        let peripheral = characteristic.service!.peripheral!
        let data = value.data
        let type: CBCharacteristicWriteType = withoutResponse.boolValue ? .withoutResponse : .withResponse
        peripheral.writeValue(data, for: characteristic, type: type)
        instances["\(id)/\(KEY_WRITE_COMPLETION)"] = completion
    }
    
    func setNotify(_ id: String, value: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let characteristic = items[KEY_CHARACTERISTIC] as! CBCharacteristic
        let peripheral = characteristic.service!.peripheral!
        peripheral.setNotifyValue(value.boolValue, for: characteristic)
        instances["\(id)/\(KEY_SET_NOTIFY_COMPLETION)"] = completion
    }
}
