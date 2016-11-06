//
//  CentralViewController.swift
//  Bluetooth
//
//  Created by Ric Telford on 6/30/15.
//  Copyright (c) 2015 Ric Telford. All rights reserved.
//

import UIKit
import CoreBluetooth

class CentralViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    @IBOutlet weak var textView: UITextView!
    var centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!
    
    var data:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.centralManager.stopScan()
        print("scanning stopped")
        super.viewWillDisappear(animated)
    }

    
    // MARK:  Central Manager Delegate methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("checking state")
        switch(central.state) {
        case .poweredOff:
            print("CB BLE hw is powered off")
            
        case .poweredOn:
            print("CB BLE hw is powered on")
            self.scan()
            
        default:
            return
        }
    }
    
    func scan() {
        self.centralManager.scanForPeripherals(withServices: serviceUUIDs,options: nil)
        print("scanning started\n\n\n")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if RSSI.intValue > -15 {
            return
        }
        print("discovered \(peripheral.name) at \(RSSI)")
        if connectingPeripheral != peripheral {
            connectingPeripheral = peripheral
            connectingPeripheral.delegate = self
            print("connecting to peripheral \(peripheral)")
            centralManager.connect(connectingPeripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect to \(peripheral) due to error \(error)")
        self.cleanup()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("\n\nperipheral connected\n\n")
        centralManager.stopScan()
        peripheral.delegate = self as CBPeripheralDelegate
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("error discovering services \(error)")
            self.cleanup()
        }
        else {
            for service in peripheral.services! as [CBService] {
                print("service UUID  \(service.uuid)\n")
                if (service.uuid == serviceUUID) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            self.cleanup()
        }
        else {
            for characteristic in service.characteristics! as [CBCharacteristic] {
                print("characteristic is \(characteristic)\n")
                if (characteristic.uuid == characteristicUUID) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("error")
        }
        else {
            let dataString = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            
            if dataString == "EOM" {
                //textView.text = self.data
                peripheral.setNotifyValue(false, for: characteristic)
                centralManager.cancelPeripheralConnection(peripheral)
            }
            else {
                let strng:String = dataString as! String
                self.data += strng
                print("received \(dataString)")
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("error changing notification state \(error)")
        }
        if (characteristic.uuid != serviceUUID) {
            return
        }
        if (characteristic.isNotifying) {
            print("notification began on \(characteristic)")
        }
        else {
            print("notification stopped on \(characteristic). Disconnecting")
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnect error is \(error)")
    }
    
    func cleanup() {
        
        switch connectingPeripheral.state {
        case .disconnected:
            print("cleanup called, .Disconnected")
            return
        case .connected:
            if (connectingPeripheral.services != nil) {
                print("found")
                //add any additional cleanup code here
            }
        default:
            return
        }
    }
}
