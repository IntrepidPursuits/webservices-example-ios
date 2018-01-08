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
    
    init(colorDidSet: ((UIColor)->Void)?) {
        self.colorDidSet = colorDidSet
    }
    
    func getColor() {
        NetworkRequest(path: colorUrl, method: .get).execute { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    return
                }
                do {
                    let colorData = try JSONDecoder().decode(ColorData.self, from: jsonData)
                    let currentColor = UIColor(colorData.color)
                    self.color = currentColor
                }
                catch (let error) {
                    print("JSONDecoder error: ", error)
                }
            case .failure(let error):
                print("NetworkRequest error: ", error)
            }
        }
    }
    
    func setColor(_ color: UIColor) {
        let colorRgbaString = color.hexString()
        let index = colorRgbaString.index(colorRgbaString.startIndex, offsetBy: 7)
        let colorString = colorRgbaString[..<index]

        let nameString = name.capitalized
        let headers = ["Content-Type": "application/json"]
        let body: ColorData = ColorData(color: colorString, name: nameString)

        NetworkRequest(path: colorUrl, method: .put, headers: headers, body: body).execute { result in
            switch result {
            case .success(let data):
                guard let jsonData = data as? Data else {
                    return
                }
                do {
                    let colorData = try JSONDecoder().decode(ColorData.self, from: jsonData)
                    let newColor = UIColor(colorData.color)
                    self.color = newColor
                }
                catch (let error) {
                    print("JSONDecoder error: ", error)
                }
            case .failure(let error):
                print("NetworkRequest error: ", error)
            }
        }
    }
}
