//
//  MyCentralManagerDelegate.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyCentralManagerDelegate: NSObject, CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Checks whether the authorize completion is nil.
        let state = central.state
        let completion = instances.removeValue(forKey: KEY_AUTHORIZE_COMPLETION) as? (NSNumber?, FlutterError?) -> Void
        if state != .unknown && completion != nil {
            let authorized = NSNumber(value: state != .unauthorized)
            completion!(authorized, nil)
        }
        // Checks whether the state is changed.
        let oldNumber = instances[KEY_STATE_NUMBER] as? Int
        let number = central.stateNumber
        if number == oldNumber {
            return
        }
        instances[KEY_STATE_NUMBER] = number
        let stateNumber = NSNumber(value: number)
        centralFlutterApi.onStateChanged(stateNumber) {_ in }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripheral.delegate = peripheralDelegate
        let id = String(peripheral.hash)
        var items = register(id)
        items[KEY_PERIPHERAL] = peripheral
        // This is a copy on write.
        instances[id] = items
        let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool
        let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        let manufacturerSpecificData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data ?? Data()
        let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] ?? [CBUUID: Data]()
        let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? [CBUUID]()
        let solicitedServiceUUIDs = advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID] ?? [CBUUID]()
        let txPowerLevel = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber
        let data = try! Proto_Broadcast.with {
            $0.peripheral = Proto_Peripheral.with {
                $0.id = id
                $0.uuid = Proto_UUID.with {
                    $0.value = peripheral.identifier.uuidString
                }
            }
            $0.rssi = RSSI.int32Value
            if(connectable != nil) {
                $0.connectable = connectable!
            }
            // We can't get the advertisement's raw value on iOS.
            $0.data = Data()
            if(localName != nil) {
                $0.localName = localName!
            }
            $0.manufacturerSpecificData = manufacturerSpecificData
            $0.serviceDatas = serviceData.map { item in
                Proto_ServiceData.with {
                    $0.uuid = Proto_UUID.with {
                        $0.value = item.key.uuidString
                    }
                    $0.data = item.value
                }
            }
            $0.serviceUuids = serviceUUIDs.map { item in
                Proto_UUID.with {
                    $0.value = item.uuidString
                }
            }
            $0.solicitedServiceUuids = solicitedServiceUUIDs.map { item in
                Proto_UUID.with {
                    $0.value = item.uuidString
                }
            }
            if(txPowerLevel != nil) {
                $0.txPowerLevel = txPowerLevel!.int32Value
            }
        }.serializedData()
        let broadcastBuffer = FlutterStandardTypedData(bytes: data)
        centralFlutterApi.onScanned(broadcastBuffer) {_ in }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let id = String(peripheral.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_CONNECT_COMPLETION)") as! (FlutterError?) -> Void
        completion(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let id = String(peripheral.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_CONNECT_COMPLETION)") as! (FlutterError?) -> Void
        let errorMessage = error?.localizedDescription
        let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
        completion(flutterError)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let id = String(peripheral.hash)
        if error == nil {
            let completion = instances.removeValue(forKey: "\(id)/\(KEY_DISCONNECT_COMPLETION)") as! (FlutterError?) -> Void
            completion(nil)
        } else {
            let errorMessage = error!.localizedDescription
            peripheralFlutterApi.onConnectionLost(id, errorMessage: errorMessage) {_ in }
        }
    }
}
