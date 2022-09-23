//
//  MyGattCharacteristicHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyGattCharacteristicHostApi: NSObject, PigeonGattCharacteristicHostApi {
    func allocate(_ id: NSNumber, instanceId: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let instance = instances.removeValue(forKey: instanceId) as! CBCharacteristic
        instances[id] = instance
        identifiers[instance] = id
    }
    
    func free(_ id: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let instance = instances.removeValue(forKey: id) as! CBCharacteristic
        identifiers.removeValue(forKey: instance)
    }
    
    func discoverDescriptors(_ id: NSNumber, completion: @escaping ([FlutterStandardTypedData]?, FlutterError?) -> Void) {
        let characteristic = instances[id] as! CBCharacteristic
        let peripheral = characteristic.service!.peripheral!
        peripheral.discoverDescriptors(for: characteristic)
        items["\(characteristic.hash)/\(KEY_DISCOVER_DESCRIPTORS_COMPLETION)"] = completion
    }
    
    func read(_ id: NSNumber, completion: @escaping (FlutterStandardTypedData?, FlutterError?) -> Void) {
        let characteristic = instances[id] as! CBCharacteristic
        let peripheral = characteristic.service!.peripheral!
        peripheral.readValue(for: characteristic)
        items["\(characteristic.hash)/\(KEY_READ_COMPLETION)"] = completion
    }
    
    func write(_ id: NSNumber, value: FlutterStandardTypedData, withoutResponse: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        let characteristic = instances[id] as! CBCharacteristic
        let peripheral = characteristic.service!.peripheral!
        let data = value.data
        let type: CBCharacteristicWriteType = withoutResponse.boolValue ? .withoutResponse : .withResponse
        peripheral.writeValue(data, for: characteristic, type: type)
        items["\(characteristic.hash)/\(KEY_WRITE_COMPLETION)"] = completion
    }
    
    func setNotify(_ id: NSNumber, value: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        let characteristic = instances[id] as! CBCharacteristic
        let peripheral = characteristic.service!.peripheral!
        peripheral.setNotifyValue(value.boolValue, for: characteristic)
        items["\(characteristic.hash)/\(KEY_SET_NOTIFY_COMPLETION)"] = completion
    }
}
