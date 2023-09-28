//
//  MyPeripheralDelegate.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth

class MyPeripheralDelegate: NSObject, CBPeripheralDelegate {
    private let myCentralManager: MyCentralManager
    
    init(_ myCentralController: MyCentralManager) {
        self.myCentralManager = myCentralController
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        myCentralManager.didReadRSSI(peripheral, RSSI, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        myCentralManager.didDiscoverServices(peripheral, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        myCentralManager.didDiscoverCharacteristics(peripheral, service, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        myCentralManager.didDiscoverDescriptors(peripheral, characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        myCentralManager.didUpdateCharacteristicValue(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        myCentralManager.didWriteCharacteristicValue(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        myCentralManager.didUpdateNotificationState(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        myCentralManager.didUpdateDescriptorValue(descriptor, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        myCentralManager.didWriteDescriptorValue(descriptor, error)
    }
}
