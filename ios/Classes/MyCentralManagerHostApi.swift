//
//  MyCentralManagerHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyCentralManagerHostApi: NSObject, PigeonCentralManagerHostApi {
    func authorize(_ completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let state = central.state
        if state == .unknown {
            instances[KEY_AUTHORIZE_COMPLETION] = completion
        } else {
            let authorized = NSNumber(value: state != .unauthorized)
            completion(authorized, nil)
        }
    }
    
    func getState(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        return NSNumber(value: central.stateNumber)
    }
    
    func startScan(_ uuidBuffers: [FlutterStandardTypedData]?, completion: @escaping (FlutterError?) -> Void) {
        let withServices: [CBUUID]? = uuidBuffers?.map {
            let uuid = try! Proto_UUID(serializedData: $0.data)
            return CBUUID(string: uuid.value)
        }
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        central.scanForPeripherals(withServices: withServices, options: options)
        completion(nil)
    }
    
    func stopScan(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        central.stopScan()
    }
}
