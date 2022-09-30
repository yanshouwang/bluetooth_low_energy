//
//  MyPeripheralHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyPeripheralHostApi: NSObject, PigeonPeripheralHostApi {
    func free(_ id: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        unregister(id)
    }
    
    func connect(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let peripheral = items[KEY_PERIPHERAL] as! CBPeripheral
        central.connect(peripheral)
        instances["\(id)/\(KEY_CONNECT_COMPLETION)"] = completion
    }
    
    func disconnect(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let peripheral = items[KEY_PERIPHERAL] as! CBPeripheral
        central.cancelPeripheralConnection(peripheral)
        instances["\(id)/\(KEY_DISCONNECT_COMPLETION)"] = completion
    }
    
    func requestMtu(_ id: String, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let peripheral = items[KEY_PERIPHERAL] as! CBPeripheral
        let value = peripheral.maximumWriteValueLength(for: .withoutResponse)
        let maximumWriteLength = NSNumber(value: value)
        completion(maximumWriteLength, nil)
    }
    
    func discoverServices(_ id: String, completion: @escaping ([FlutterStandardTypedData]?, FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let peripheral = items[KEY_PERIPHERAL] as! CBPeripheral
        peripheral.discoverServices(nil)
        instances["\(id)/\(KEY_DISCOVER_SERVICES_COMPLETION)"] = completion
    }
}
