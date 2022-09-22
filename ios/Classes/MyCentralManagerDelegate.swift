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
        let completion = items.removeValue(forKey: KEY_AUTHORIZE_COMPLETION) as? (NSNumber?, FlutterError?) -> Void
        if state != .unknown && completion != nil {
            let authorized = NSNumber(value: central.state != .unauthorized)
            completion!(authorized, nil)
        }
        // Checks whether the state is changed.
        let oldNumber = items[KEY_STATE_OBSERVER] as? Int
        if oldNumber == nil {
            return
        }
        let number = central.stateNumber
        if number == oldNumber {
            return
        }
        items[KEY_STATE_OBSERVER] = number
        let stateNumber = NSNumber(value: number)
        centralFlutterApi.notifyState(stateNumber) {_ in }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool
        let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        let manufacturerSpecificData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data ?? Data()
        let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] ?? [CBUUID: Data]()
        let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? [CBUUID]()
        let solicitedServiceUUIDs = advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID] ?? [CBUUID]()
        let txPowerLevel = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber
        let data = try! Proto_Advertisement.with {
            $0.uuid = Proto_UUID.with {
                $0.value = peripheral.identifier.uuidString
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
        let advertisementBuffer = FlutterStandardTypedData(bytes: data)
        centralFlutterApi.notifyAdvertisement(advertisementBuffer) {_ in }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let completion = items.removeValue(forKey: "\(peripheral.hash)/\(KEY_CONNECT_COMPLETION)") as! (FlutterStandardTypedData?, FlutterError?) -> Void
        let data = try! Proto_Peripheral.with {
            $0.id = Int64(peripheral.hash)
            $0.maximumWriteLength = Int32(peripheral.maximumWriteLength)
        }.serializedData()
        let peripheralValue = FlutterStandardTypedData(bytes: data)
        completion(peripheralValue, nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let completion = items.removeValue(forKey: "\(peripheral.hash)/\(KEY_CONNECT_COMPLETION)") as! (FlutterStandardTypedData?, FlutterError?) -> Void
        let errorMessage = error?.localizedDescription
        let error = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
        completion(nil, error)
        let id = NSNumber(value: peripheral.hash)
        instances.removeValue(forKey: id)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let completion = items.removeValue(forKey: "\(peripheral.hash)/\(KEY_DISCONNECT_COMPLETION)") as? (FlutterError?) -> Void
        if completion == nil {
            let id = identifiers[peripheral]!
            let data = try! Proto_BluetoothLowEnergyException.with {
                $0.message = error?.localizedDescription ?? "Peripheral connection lost."
            }.serializedData()
            let errorBuffer = FlutterStandardTypedData(bytes: data)
            peripheralFlutterApi.notifyConnectionLost(id, errorBuffer: errorBuffer) {_ in }
        } else if error == nil {
            completion!(nil)
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion!(flutterError)
        }
    }
}
