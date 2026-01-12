//
//  CBPeripheralDelegateImpl.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/8/13.
//

import CoreBluetooth
import Foundation

class CBPeripheralDelegateImpl: NSObject, CBPeripheralDelegate {
    private let mCentralManager: CentralManagerImpl
    
    init(_ centralManager: CentralManagerImpl) {
        self.mCentralManager = centralManager
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        self.mCentralManager.didReadRSSI(peripheral: peripheral, rssi: RSSI, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        self.mCentralManager.didDiscoverServices(peripheral: peripheral, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        self.mCentralManager.didDiscoverIncludedServices(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        self.mCentralManager.didDiscoverCharacteristics(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        self.mCentralManager.didDiscoverDescriptors(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        self.mCentralManager.didUpdateCharacteristicValue(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        self.mCentralManager.didWriteCharacteristicValue(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        self.mCentralManager.didUpdateCharacteristicNotificationState(peripheral: peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        self.mCentralManager.didUpdateDescriptorValue(peripheral: peripheral, descriptor: descriptor, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        self.mCentralManager.didWriteDescriptorValue(peripheral: peripheral, descriptor: descriptor, error: error)
    }
}
