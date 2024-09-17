//
//  MyPeripheralDelegate.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth

class PeripheralDelegateImpl: NSObject, CBPeripheralDelegate {
    private let mCentralManager: MyCentralManager
    
    init(centralManager: MyCentralManager) {
        self.mCentralManager = centralManager
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        mCentralManager.didReadRSSI(peripheral: peripheral, rssi: RSSI, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        mCentralManager.didDiscoverServices(peripheral: peripheral, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        mCentralManager.didDiscoverIncludedServices(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        mCentralManager.didDiscoverCharacteristics(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        mCentralManager.didDiscoverDescriptors(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        mCentralManager.didUpdateCharacteristicValue(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        mCentralManager.didWriteCharacteristicValue(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        mCentralManager.didUpdateCharacteristicNotificationState(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        mCentralManager.didUpdateDescriptorValue(peripheral: peripheral, descriptor: descriptor, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        mCentralManager.didWriteDescriptorValue(peripheral: peripheral, descriptor: descriptor, error: error)
    }
}
