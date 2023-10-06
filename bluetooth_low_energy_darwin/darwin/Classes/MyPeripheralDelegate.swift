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
    
    init(_ centralManager: MyCentralManager) {
        self.centralManager = centralManager
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        centralManager.didReadRSSI(peripheral, RSSI, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        centralManager.didDiscoverServices(peripheral, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        centralManager.didDiscoverCharacteristics(peripheral, service, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        centralManager.didDiscoverDescriptors(peripheral, characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        centralManager.didUpdateCharacteristicValue(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        centralManager.didWriteCharacteristicValue(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        centralManager.didUpdateNotificationState(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        centralManager.didUpdateDescriptorValue(descriptor, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        centralManager.didWriteDescriptorValue(descriptor, error)
    }
}
