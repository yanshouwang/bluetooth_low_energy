//
//  MyPeripheralDelegate.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth

class MyPeripheralDelegate: NSObject, CBPeripheralDelegate {
    private let myCentralController: MyCentralController
    
    init(_ myCentralController: MyCentralController) {
        self.myCentralController = myCentralController
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        myCentralController.didDiscoverServices(peripheral, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        myCentralController.didDiscoverCharacteristics(peripheral, service, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        myCentralController.didDiscoverDescriptors(peripheral, characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        myCentralController.didUpdateCharacteristicValue(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        myCentralController.didWriteCharacteristicValue(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        myCentralController.didUpdateNotificationState(characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        myCentralController.didUpdateDescriptorValue(descriptor, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        myCentralController.didWriteDescriptorValue(descriptor, error)
    }
}
