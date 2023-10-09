//
//  MyPeripheralManagerDelegate.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/10/7.
//

import Foundation
import CoreBluetooth

class MyPeripheralManagerDelegate: NSObject, CBPeripheralManagerDelegate {
    init(_ peripheralManager: MyPeripheralManager) {
        self.peripheralManager = peripheralManager
    }
    
    private let peripheralManager: MyPeripheralManager
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        peripheralManager.didUpdateState()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        peripheralManager.didAdd(service, error)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        peripheralManager.didStartAdvertising(error)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        peripheralManager.didReceiveRead(request)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        peripheralManager.didReceiveWrite(requests)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        peripheralManager.didSubscribeTo(central, characteristic)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        peripheralManager.didUnsubscribeFrom(central, characteristic)
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        peripheralManager.isReadyToUpdateSubscribers()
    }
}
