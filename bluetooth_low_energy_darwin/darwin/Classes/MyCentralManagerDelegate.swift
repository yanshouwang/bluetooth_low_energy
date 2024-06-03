//
//  MyCentralManagerDelegate.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth

class MyCentralManagerDelegate: NSObject, CBCentralManagerDelegate {
    private let mCentralManager: MyCentralManager
    
    init(centralManager: MyCentralManager) {
        self.mCentralManager = centralManager
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        mCentralManager.didUpdateState(central: central)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        mCentralManager.didDiscover(central: central, peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        mCentralManager.didConnect(central: central, peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        mCentralManager.didFailToConnect(central: central, peripheral: peripheral, error: error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        mCentralManager.didDisconnectPeripheral(central: central, peripheral: peripheral, error: error)
    }
}
