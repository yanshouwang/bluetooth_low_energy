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
            items[KEY_AUTHORIZE_COMPLETION] = completion
        } else {
            let authorized = NSNumber(value: state != .unauthorized)
            completion(authorized, nil)
        }
    }
    
    func getState(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        return NSNumber(value: central.stateNumber)
    }
    
    func addStateObserver(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        items[KEY_STATE_OBSERVER] = central.stateNumber
    }
    
    func removeStateObserver(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        items.removeValue(forKey: KEY_STATE_OBSERVER)
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
    
    func connect(_ uuidBuffer: FlutterStandardTypedData, completion: @escaping (FlutterStandardTypedData?, FlutterError?) -> Void) {
        let uuid = try! Proto_UUID(serializedData: uuidBuffer.data)
        let withIdentifiers = [UUID(uuidString: uuid.value)!]
        let peripheral = central.retrievePeripherals(withIdentifiers: withIdentifiers).first!
        central.connect(peripheral)
        items["\(peripheral.hash)/\(KEY_CONNECT_COMPLETION)"] = completion
        // Keep a refrence right now to avoid system cancel the connection.
        let id = NSNumber(value: peripheral.hash)
        instances[id] = peripheral
    }
}
