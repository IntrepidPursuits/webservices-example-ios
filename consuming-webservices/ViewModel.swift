//
//  ViewModel.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation

class ViewModel {
    
    let toggleURL = "https://api.particle.io/v1/devices/27001c001647343339383037/led/?access_token=1cb212aac21fba67dbe6fea474b896b11cc2af59"
    let statusURL = "https://api.particle.io/v1/devices/27001c001647343339383037/ledStatus/?access_token=1cb212aac21fba67dbe6fea474b896b11cc2af59"
    
    private var led = LED()
    
    var ledStatusDidSet: ((LEDState)->Void)? = nil
    var ledStatus: LEDState = .off {
        didSet {
            DispatchQueue.main.async {
                self.ledStatusDidSet?(self.ledStatus)
            }
        }
    }
    
    init(ledStatusDidSet: ((LEDState)->Void)?) {
        self.ledStatusDidSet = ledStatusDidSet
    }
    
    func toggleLED(to on: Bool) {
        let headers = ["Content-Type": "application/json"]
        let body = ["args": "\(on ? "on" : "off")"]
        NetworkRequest(path: toggleURL, method: .post, headers: headers, body: body).execute { result in
            switch result {
            case .Success(let data):
                guard
                    let data = data as? [String: Any],
                    let reportedLEDStatus = data["return_value"] as? Int
                    else { return }
                self.led.status = reportedLEDStatus == 1 ? .on : .off
                self.ledStatus = self.led.status
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func refreshLEDStatus() {
        NetworkRequest(path: statusURL, method: .get).execute { result in
            switch result {
            case .Success(let data):
                guard
                    let data = data as? [String: Any],
                    let reportedLEDStatus = data["result"] as? Int
                    else { return }
                self.led.status = reportedLEDStatus == 1 ? .on : .off
                self.ledStatus = self.led.status
            case .Failure(let error):
                print(error)
            }
        }
    }
}
