//
//  MyCentralManagerDelegate.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth

class MyCentralManagerDelegate: NSObject, CBCentralManagerDelegate {
    private let myCentralManager: MyCentralManager
    
    init(_ myCentralController: MyCentralManager) {
        self.myCentralManager = myCentralController
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let state = central.state
        myCentralManager.didUpdateState(state)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        myCentralManager.didDiscover(peripheral, advertisementData, RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        myCentralManager.didConnect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        myCentralManager.didFailToConnect(peripheral, error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        myCentralManager.didDisconnectPeripheral(peripheral, error)
    }
}
