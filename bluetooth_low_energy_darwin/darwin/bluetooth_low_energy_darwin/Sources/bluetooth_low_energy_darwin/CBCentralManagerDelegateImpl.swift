//
//  CBCentralManagerDelegateImpl.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth

class CBCentralManagerDelegateImpl: NSObject, CBCentralManagerDelegate {
    private let mCentralManager: CentralManagerImpl
    
    init(_ centralManager: CentralManagerImpl) {
        self.mCentralManager = centralManager
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.mCentralManager.didUpdateState(central: central)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.mCentralManager.didDiscover(central: central, peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.mCentralManager.didConnect(central: central, peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.mCentralManager.didFailToConnect(central: central, peripheral: peripheral, error: error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.mCentralManager.didDisconnectPeripheral(central: central, peripheral: peripheral, error: error)
    }
}
