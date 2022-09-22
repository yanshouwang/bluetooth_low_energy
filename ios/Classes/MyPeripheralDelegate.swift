//
//  MyPeripheralDelegate.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyPeripheralDelegate: NSObject, CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let completion = items.removeValue(forKey: "\(peripheral.hash)/\(KEY_DISCOVER_SERVICES_COMPLETION)") as! ([FlutterStandardTypedData]?, FlutterError?) -> Void
        if error == nil {
            let services = peripheral.services
            if services == nil {
                let serviceBuffers = [FlutterStandardTypedData]()
                completion(serviceBuffers, nil)
            } else {
                let serviceBuffers: [FlutterStandardTypedData] = services!.map { service in
                    let data = try! Proto_GattService.with {
                        $0.id = Int64(service.hash)
                        $0.uuid = Proto_UUID.with {
                            $0.value = service.uuid.uuidString
                        }
                    }.serializedData()
                    return FlutterStandardTypedData(bytes: data)
                }
                completion(serviceBuffers, nil)
                for service in services! {
                    let id = NSNumber(value: service.hash)
                    instances[id] = service
                }
            }
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let completion = items.removeValue(forKey: "\(service.hash)/\(KEY_DISCOVER_CHARACTERISTICS_COMPLETION)") as! ([FlutterStandardTypedData]?, FlutterError?) -> Void
        if error == nil {
            let characteristics = service.characteristics
            if characteristics == nil {
                let characteristicBuffers = [FlutterStandardTypedData]()
                completion(characteristicBuffers, nil)
            } else {
                let characteristicBuffers: [FlutterStandardTypedData] = characteristics!.map { characteristic in
                    let data = try! Proto_GattCharacteristic.with {
                        $0.id = Int64(characteristic.hash)
                        $0.uuid = Proto_UUID.with {
                            $0.value = characteristic.uuid.uuidString
                        }
                        $0.canRead = characteristic.properties.contains(.read)
                        $0.canWrite = characteristic.properties.contains(.write)
                        $0.canWriteWithoutResponse = characteristic.properties.contains(.writeWithoutResponse)
                        $0.canNotify = characteristic.properties.contains(.notify)
                    }.serializedData()
                    return FlutterStandardTypedData(bytes: data)
                }
                completion(characteristicBuffers, nil)
                for characteristic in characteristics! {
                    let id = NSNumber(value: characteristic.hash)
                    instances[id] = characteristic
                }
            }
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        let completion = items.removeValue(forKey: "\(characteristic.hash)/\(KEY_DISCOVER_DESCRIPTORS_COMPLETION)") as! ([FlutterStandardTypedData]?, FlutterError?) -> Void
        if error == nil {
            let descriptors = characteristic.descriptors
            if descriptors == nil {
                let descriptorBuffers = [FlutterStandardTypedData]()
                completion(descriptorBuffers, nil)
            } else {
                let descriptorBuffers: [FlutterStandardTypedData] = descriptors!.map { descriptor in
                    let data = try! Proto_GattDescriptor.with {
                        $0.id = Int64(descriptor.hash)
                        $0.uuid = Proto_UUID.with {
                            $0.value = descriptor.uuid.uuidString
                        }
                    }.serializedData()
                    return FlutterStandardTypedData(bytes: data)
                }
                completion(descriptorBuffers, nil)
                for descriptor in descriptors! {
                    let id = NSNumber(value: descriptor.hash)
                    instances[id] = descriptor
                }
            }
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let completion = items.removeValue(forKey: "\(characteristic.hash)/\(KEY_READ_COMPLETION)") as? (FlutterStandardTypedData?, FlutterError?) -> Void
        let characteristicValue = characteristic.value
        let value = characteristicValue == nil ? FlutterStandardTypedData() : FlutterStandardTypedData(bytes: characteristicValue!)
        if completion == nil {
            let id = identifiers[characteristic]!
            characteristicFlutterApi.notifyValue(id, value: value) {_ in }
        } else if error == nil {
            completion!(value, nil)
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion!(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        let completion = items.removeValue(forKey: "\(characteristic.hash)/\(KEY_WRITE_COMPLETION)") as! (FlutterError?) -> Void
        if error == nil {
            completion(nil)
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion(flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        let completion = items.removeValue(forKey: "\(characteristic.hash)/\(KEY_SET_NOTIFY_COMPLETION)") as! (FlutterError?) -> Void
        if error == nil {
            completion(nil)
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion(flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        let completion = items.removeValue(forKey: "\(descriptor.hash)/\(KEY_READ_COMPLETION)") as! (FlutterStandardTypedData?, FlutterError?) -> Void
        if error == nil {
            let value: FlutterStandardTypedData
            if descriptor.value == nil {
                value = FlutterStandardTypedData()
            } else {
                switch descriptor.uuid.uuidString {
                case CBUUIDCharacteristicExtendedPropertiesString:
                    fallthrough
                case CBUUIDClientCharacteristicConfigurationString:
                    fallthrough
                case CBUUIDServerCharacteristicConfigurationString:
                    let item = descriptor.value as! NSNumber
                    value = FlutterStandardTypedData(bytes: item.data)
                case CBUUIDCharacteristicUserDescriptionString:
                    fallthrough
                case CBUUIDCharacteristicAggregateFormatString:
                    let item = descriptor.value as! String
                    value = FlutterStandardTypedData(bytes: item.data)
                case CBUUIDCharacteristicFormatString:
                    let data = descriptor.value as! Data
                    value = FlutterStandardTypedData(bytes: data)
                case CBUUIDL2CAPPSMCharacteristicString:
                    let item = descriptor.value as! UInt16
                    value = FlutterStandardTypedData(bytes: item.data)
                default:
                    value = FlutterStandardTypedData()
                }
            }
            completion(value, nil)
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        let completion = items.removeValue(forKey: "\(descriptor.hash)/\(KEY_WRITE_COMPLETION)") as! (FlutterError?) -> Void
        if error == nil {
            completion(nil)
        } else {
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: error!.localizedDescription, details: nil)
            completion(flutterError)
        }
    }
}
