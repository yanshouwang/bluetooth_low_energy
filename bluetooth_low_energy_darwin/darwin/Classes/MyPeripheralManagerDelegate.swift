//
//  MyPeripheralManagerDelegate.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/10/7.
//

import Foundation
import CoreBluetooth

class MyPeripheralManagerDelegate: NSObject, CBPeripheralManagerDelegate {
    private let _peripheralManager: MyPeripheralManager
    
    init(peripheralManager: MyPeripheralManager) {
        _peripheralManager = peripheralManager
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        _peripheralManager.didUpdateState(peripheral: peripheral)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        _peripheralManager.didAdd(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        _peripheralManager.didStartAdvertising(peripheral: peripheral, error: error)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        _peripheralManager.didReceiveRead(peripheral: peripheral, request: request)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        _peripheralManager.didReceiveWrite(peripheral: peripheral, requests: requests)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        _peripheralManager.didSubscribeTo(peripheral: peripheral, central: central, characteristic: characteristic)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        _peripheralManager.didUnsubscribeFrom(peripheral: peripheral, central: central, characteristic: characteristic)
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        _peripheralManager.isReadyToUpdateSubscribers(peripheral: peripheral)
    }
}
