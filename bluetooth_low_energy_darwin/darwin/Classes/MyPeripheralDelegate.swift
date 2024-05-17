//
//  MyPeripheralDelegate.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth

class MyPeripheralDelegate: NSObject, CBPeripheralDelegate {
    private let centralManager: MyCentralManager
    
    init(centralManager: MyCentralManager) {
        self.centralManager = centralManager
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        centralManager.didReadRSSI(peripheral: peripheral, rssi: RSSI, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        centralManager.didDiscoverServices(peripheral: peripheral, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        centralManager.didDiscoverIncludedServices(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        centralManager.didDiscoverCharacteristics(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        centralManager.didDiscoverDescriptors(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        centralManager.didUpdateCharacteristicValue(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        centralManager.didWriteCharacteristicValue(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        centralManager.didUpdateCharacteristicNotificationState(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        centralManager.didUpdateDescriptorValue(peripheral: peripheral, descriptor: descriptor, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        centralManager.didWriteDescriptorValue(peripheral: peripheral, descriptor: descriptor, error: error)
    }
}
