//
//  MyGattServiceHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyGattServiceHostApi: NSObject, PigeonGattServiceHostApi {
    func free(_ id: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        unregister(id)
    }
    
    func discoverCharacteristics(_ id: String, completion: @escaping ([FlutterStandardTypedData]?, FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let service = items[KEY_SERVICE] as! CBService
        let peripheral = service.peripheral!
        peripheral.discoverCharacteristics(nil, for: service)
        instances["\(id)/\(KEY_DISCOVER_CHARACTERISTICS_COMPLETION)"] = completion
    }
}
