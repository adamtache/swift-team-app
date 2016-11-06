//
//  PeripheralViewController.swift
//  Bluetooth
//
//  Created by Ric Telford on 7/4/15.
//  Copyright (c) 2015 Ric Telford. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var advertisingSwitch: UISwitch!
    var peripheralManager:CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!
    var dataToSend:Data!
    var student: Student!
    var jsonString: String = ""
    var json: [String:Any] = [:]
    var sentDataCount:Int = 0
    var sentEOM:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.peripheralManager.stopAdvertising()
        super.viewWillDisappear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Peripheral Methods
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state != CBManagerState.poweredOn) {
            return
        }
        else {
            print("Powered on and ready to go")
            // This is an example of a Notify Characteristic for a Readable value
            transferCharacteristic = CBMutableCharacteristic(type:
            characteristicUUID, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.readable)
            // This sets up the Service we will use, loads the Characteristic and then adds the Service to the Manager so we can start advertising
            let transferService = CBMutableService(type: serviceUUID, primary: true)
            transferService.characteristics = [self.transferCharacteristic]
            self.peripheralManager.add(transferService)
            
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Data request connection coming in")
        // A subscriber was found, so send them the data
        self.dataToSend = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        // Connect JSON above^
        self.sentDataCount = 0
        self.sendData()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        dataToSend.removeAll()
        print("Unsubscribed")
    }
    
    func updateStudent(student: Student) {
        self.student = student
        dataToJSON()
    }
    
    func dataToDict() {
        json = ["name": student.name,
                "from": student.location,
                "sex": student.isMale,
                "degree": student.degree,
                "hobbies" : student.interests,
                "languages": student.languages,
                "team": "Krombopulos"]
    }
    
    func dataToJSON() {
        var gender: String
        if (student.isMale) {
            gender = "true"
        } else {
            gender = "false"
        }
        jsonString = "{\"name\":\"\(student.name)\",\"from\":\"\(self.student.location)\",\"sex\":\"\(gender)\",\"degree\":\"\(student.degree)\",\"hobbies\":["
        for (index, hobby) in student.interests.enumerated() {
            if (index < student.interests.count-1) {
                jsonString+="\"\(hobby)\","
            } else {
                jsonString+="\"\(hobby)\""
            }
        }
        jsonString+="],\"languages\":["
        for (index, language) in student.languages.enumerated() {
            if (index < student.languages.count-1) {
                jsonString+="\"\(language)\","
            } else {
                jsonString+="\"\(language)\""
            }
        }
        jsonString+="],"
        jsonString+="\"team\":\"Krombopulos\"}"
        print(jsonString)
    }
    
    func sendData() {
        if (sentEOM) {                // sending the end of message indicator
            let didSend:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)

            if (didSend) {
                sentEOM = false
                print("Sent: EOM, Outer loop")
            }
            else {
                return
            }
        }
        else {                          // sending the payload
            if (self.sentDataCount >= self.dataToSend.count) {
                return
            }
            else {
                var didSend:Bool = true
                while (didSend) {
                    var amountToSend = self.dataToSend.count - self.sentDataCount
                    if (amountToSend > MTU) {
                        amountToSend = MTU
                    }

                    let range = Range(uncheckedBounds: (lower: self.sentDataCount, upper: self.sentDataCount+amountToSend))
                    var buffer = [UInt8](repeating: 0, count: amountToSend)
                    
                    self.dataToSend.copyBytes(to: &buffer, from: range)
                    let sendBuffer = Data(bytes: &buffer, count: amountToSend)
                   
                    didSend = self.peripheralManager.updateValue(sendBuffer, for: self.transferCharacteristic, onSubscribedCentrals: nil)
                    if (!didSend) {
                        return
                    }
                    if let printOutput = NSString(data: sendBuffer, encoding: String.Encoding.utf8.rawValue) {
                        print("Sent: \(printOutput)")
                    }
                    self.sentDataCount += amountToSend
                    if (self.sentDataCount >= self.dataToSend.count) {
                        sentEOM = true
                        let eomSent:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)
                        if (eomSent) {
                            sentEOM = false
                            print("Sent: EOM, Inner loop")
                        }
                        return
                    }
                }
            }
        }
    }    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        self.sendData()
    }
    
  
    
    // MARK: - TextView Methods
    
    func textViewDidChange(_ textView: UITextView) {
        if (self.advertisingSwitch.isOn) {
            self.advertisingSwitch.setOn(false, animated: true)
            self.peripheralManager.stopAdvertising()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PeripheralViewController.dismissKeyboard))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func dismissKeyboard() {
        self.textView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Switch Methods
    
    @IBAction func switchChanged(_ sender: AnyObject) {
        if (self.advertisingSwitch.isOn) {
            let dataToBeAdvertised: [String:Any]! = [
                CBAdvertisementDataServiceUUIDsKey : serviceUUIDs]
            self.peripheralManager.startAdvertising(dataToBeAdvertised)
        //    self.peripheralManager.startAdvertising(<#T##advertisementData: [String : Any]?##[String : Any]?#>)
        }
        else {
            self.peripheralManager.stopAdvertising()
        }
    }
    
    

}
