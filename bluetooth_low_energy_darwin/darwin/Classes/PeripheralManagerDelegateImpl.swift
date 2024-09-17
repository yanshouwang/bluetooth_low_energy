//
//  MyPeripheralManagerDelegate.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/10/7.
//

import Foundation
import CoreBluetooth

class PeripheralManagerDelegateImpl: NSObject, CBPeripheralManagerDelegate {
    private let mPeripheralManager: PeripheralManagerImpl
    
    init(peripheralManager: PeripheralManagerImpl) {
        self.mPeripheralManager = peripheralManager
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        mPeripheralManager.didUpdateState(peripheral: peripheral)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        mPeripheralManager.didAdd(peripheral: peripheral, service: service, error: error)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        mPeripheralManager.didStartAdvertising(peripheral: peripheral, error: error)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        mPeripheralManager.didReceiveRead(peripheral: peripheral, request: request)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        mPeripheralManager.didReceiveWrite(peripheral: peripheral, requests: requests)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        mPeripheralManager.didSubscribeTo(peripheral: peripheral, central: central, characteristic: characteristic)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        mPeripheralManager.didUnsubscribeFrom(peripheral: peripheral, central: central, characteristic: characteristic)
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        mPeripheralManager.isReadyToUpdateSubscribers(peripheral: peripheral)
    }
}
