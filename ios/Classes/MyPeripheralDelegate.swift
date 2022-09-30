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
        let id = String(peripheral.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_DISCOVER_SERVICES_COMPLETION)") as! ([FlutterStandardTypedData]?, FlutterError?) -> Void
        if error == nil {
            var serviceBuffers = [FlutterStandardTypedData]()
            let services = peripheral.services
            if services != nil {
                for service in services! {
                    let serviceBuffer = registerService(service)
                    serviceBuffers.append(serviceBuffer)
                }
            }
            completion(serviceBuffers, nil)
        } else {
            let errorMessage = error!.localizedDescription
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
            completion(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let id = String(service.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_DISCOVER_CHARACTERISTICS_COMPLETION)") as! ([FlutterStandardTypedData]?, FlutterError?) -> Void
        if error == nil {
            var characteristicBuffers = [FlutterStandardTypedData]()
            let characteristics = service.characteristics
            if characteristics != nil {
                for characteristic in characteristics! {
                    let characteristicBuffer = registerCharacteristic(characteristic)
                    characteristicBuffers.append(characteristicBuffer)
                }
            }
            completion(characteristicBuffers, nil)
        } else {
            let errorMessage = error!.localizedDescription
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
            completion(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        let id = String(characteristic.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_DISCOVER_DESCRIPTORS_COMPLETION)") as! ([FlutterStandardTypedData]?, FlutterError?) -> Void
        if error == nil {
            var descriptorBuffers = [FlutterStandardTypedData]()
            let descriptors = characteristic.descriptors
            if descriptors != nil {
                for descriptor in descriptors! {
                    let descriptorBuffer = registerDescriptor(descriptor)
                    descriptorBuffers.append(descriptorBuffer)
                }
            }
            completion(descriptorBuffers, nil)
        } else {
            let errorMessage = error!.localizedDescription
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
            completion(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let id = String(characteristic.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_READ_COMPLETION)") as? (FlutterStandardTypedData?, FlutterError?) -> Void
        let characteristicValue = characteristic.value
        let value = characteristicValue == nil ? FlutterStandardTypedData() : FlutterStandardTypedData(bytes: characteristicValue!)
        if completion == nil {
            characteristicFlutterApi.onValueChanged(id, value: value) {_ in }
        } else if error == nil {
            completion!(value, nil)
        } else {
            let errorMessage = error!.localizedDescription
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
            completion!(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        let id = String(characteristic.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_WRITE_COMPLETION)") as! (FlutterError?) -> Void
        if error == nil {
            completion(nil)
        } else {
            let errorMessage = error!.localizedDescription
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
            completion(flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        let id = String(characteristic.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_SET_NOTIFY_COMPLETION)") as! (FlutterError?) -> Void
        if error == nil {
            completion(nil)
        } else {
            let errorMessage = error!.localizedDescription
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
            completion(flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        let id = String(descriptor.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_READ_COMPLETION)") as! (FlutterStandardTypedData?, FlutterError?) -> Void
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
            let errorMessage = error!.localizedDescription
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
            completion(nil, flutterError)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        let id = String(descriptor.hash)
        let completion = instances.removeValue(forKey: "\(id)/\(KEY_WRITE_COMPLETION)") as! (FlutterError?) -> Void
        if error == nil {
            completion(nil)
        } else {
            let errorMessage = error!.localizedDescription
            let flutterError = FlutterError(code: BLUETOOTH_LOW_ENERGY_ERROR, message: errorMessage, details: nil)
            completion(flutterError)
        }
    }
    
    private func registerService(_ service: CBService) -> FlutterStandardTypedData {
        let id = String(service.hash)
        var items = register(id)
        items[KEY_SERVICE] = service
        // This is a copy on write.
        instances[id] = items
        let data = try! Proto_GattService.with {
            $0.id = id
            $0.uuid = Proto_UUID.with {
                $0.value = service.uuid.uuidString
            }
        }.serializedData()
        return FlutterStandardTypedData(bytes: data)
    }
    
    private func registerCharacteristic(_ characteristic: CBCharacteristic) -> FlutterStandardTypedData {
        let id = String(characteristic.hash)
        var items = register(id)
        items[KEY_CHARACTERISTIC] = characteristic
        // This is a copy on write.
        instances[id] = items
        let data = try! Proto_GattCharacteristic.with {
            $0.id = id
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
    
    private func registerDescriptor(_ descriptor: CBDescriptor) -> FlutterStandardTypedData {
        let id = String(descriptor.hash)
        var items = register(id)
        items[KEY_DESCRIPTOR] = descriptor
        // This is a copy on write.
        instances[id] = items
        let data = try! Proto_GattDescriptor.with {
            $0.id = id
            $0.uuid = Proto_UUID.with {
                $0.value = descriptor.uuid.uuidString
            }
        }.serializedData()
        return FlutterStandardTypedData(bytes: data)
    }
}
