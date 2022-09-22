//
//  MyPeripheralHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyPeripheralHostApi: NSObject, PigeonPeripheralHostApi {
    func allocate(_ id: NSNumber, instanceId: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let instance = instances.removeValue(forKey: instanceId) as! CBPeripheral
        instances[id] = instance
        identifiers[instance] = id
        instance.delegate = peripheralDelegate
    }
    
    func free(_ id: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let instance = instances.removeValue(forKey: id) as! CBPeripheral
        identifiers.removeValue(forKey: instance)
    }
    
    func disconnect(_ id: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        let peripheral = instances[id] as! CBPeripheral
        central.cancelPeripheralConnection(peripheral)
        items["\(peripheral.hash)/\(KEY_DISCONNECT_COMPLETION)"] = completion
    }
    
    func discoverServices(_ id: NSNumber, completion: @escaping ([FlutterStandardTypedData]?, FlutterError?) -> Void) {
        let peripheral = instances[id] as! CBPeripheral
        peripheral.discoverServices(nil)
        items["\(peripheral.hash)/\(KEY_DISCOVER_SERVICES_COMPLETION)"] = completion
    }
}
