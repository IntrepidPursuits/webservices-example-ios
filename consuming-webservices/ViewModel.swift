//
//  ViewModel.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit

class ViewModel {
    
    let name = "wingchi"
    
    var colorUrl: String {
        return "https://apprentice-webservices-demo.firebaseio.com/apprenti/\(name).json"
    }
    
    var colorDidSet: ((UIColor)->Void)? = nil
    var color: UIColor = UIColor("#FF0000") {
        didSet {
            DispatchQueue.main.async {
                self.colorDidSet?(self.color)
            }
        }
    }
    
    private var led = LED()
    
    var ledStatusDidSet: ((LEDState)->Void)? = nil
    var ledStatus: LEDState = .off {
        didSet {
            DispatchQueue.main.async {
                self.ledStatusDidSet?(self.ledStatus)
            }
        }
    }
    
    init(colorDidSet: ((UIColor)->Void)?) {
        self.colorDidSet = colorDidSet
    }
    
    func getColor() {
        NetworkRequest(path: colorUrl, method: .get).execute { result in
            switch result {
            case .success(let data):
                guard
                    let data = data as? [String: Any],
                    let color = data["color"] as? String
                    else { return }
                let currentColor = UIColor(color)
                self.color = currentColor
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setColor(_ color: UIColor) {
        let colorRgbaString = color.hexString()
        let index = colorRgbaString.index(colorRgbaString.startIndex, offsetBy: 7)
        let colorString = colorRgbaString[..<index]

        let nameString = name.capitalized
        let headers = ["Content-Type": "application/json"]
        let body = [
                "color": "\(colorString)",
                "name": "\(nameString)"
            ]
        NetworkRequest(path: colorUrl, method: .put, headers: headers, body: body).execute { result in
            switch result {
            case .success(let data):
                guard
                    let data = data as? [String: Any],
                    let color = data["color"] as? String
                    else { return }
                self.color = UIColor(color)
            case .failure(let error):
                print(error)
            }
        }
    }
}
