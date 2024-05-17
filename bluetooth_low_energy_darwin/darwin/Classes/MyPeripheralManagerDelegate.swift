//
//  MyPeripheralManagerDelegate.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/10/7.
//

import Foundation
import CoreBluetooth

class MyPeripheralManagerDelegate: NSObject, CBPeripheralManagerDelegate {
    private let peripheralManager: MyPeripheralManager
    
    init(peripheralManager: MyPeripheralManager) {
        self.peripheralManager = peripheralManager
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        peripheralManager.didUpdateState(peripheral: peripheral)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        peripheralManager.didAdd(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        peripheralManager.didStartAdvertising(peripheral: peripheral, error: error)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        peripheralManager.didReceiveRead(peripheral: peripheral, request: request)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        peripheralManager.didReceiveWrite(peripheral: peripheral, requests: requests)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        peripheralManager.didSubscribeTo(peripheral: peripheral, central: central, characteristic: characteristic)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        peripheralManager.didUnsubscribeFrom(peripheral: peripheral, central: central, characteristic: characteristic)
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        peripheralManager.isReadyToUpdateSubscribers(peripheral: peripheral)
    }
}
