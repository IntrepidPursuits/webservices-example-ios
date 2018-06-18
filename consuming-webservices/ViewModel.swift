//
//  ViewModel.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit

class ViewModel {
    
    let searchName = "alex"
    
    var colorUrl: String {
        return "https://apprentice-webservices-demo.firebaseio.com/apprenti/\(searchName).json"
    }
    
    var colorDidSet: ((UIColor) -> Void)? = nil
    var color: UIColor = UIColor("#FF0000") {
        didSet {
            DispatchQueue.main.async {
                self.colorDidSet?(self.color)
            }
        }
    }

    var nameDidSet: ((String) -> Void)? = nil
    var name: String = "Alex" {
        didSet {
            DispatchQueue.main.async {
                self.nameDidSet?(self.name)
            }
        }
    }
    
    init(colorDidSet: ((UIColor) -> Void)?, nameDidSet: ((String) -> Void)?) {
        self.colorDidSet = colorDidSet
        self.nameDidSet = nameDidSet
    }
    
    func getColor() {
        NetworkRequest(path: colorUrl, method: .get).execute { result in
            switch result {
            case .success(let data):
                guard let colorData = data as? ColorData else {
                    print("Data format incorrect")
                    return
                }
                let currentColor = UIColor(colorData.color)
                let currentName = colorData.name
                self.color = currentColor
                self.name = currentName
            case .failure(let error):
                print("NetworkRequest error: ", error)
            }
        }
    }
    
    func setColor(_ color: UIColor) {
        let colorRgbaString = color.hexString()
        let index = colorRgbaString.index(colorRgbaString.startIndex, offsetBy: 7)
        let colorString = String(colorRgbaString[..<index])

        let nameString = name.capitalized
        let headers = ["Content-Type": "application/json"]
        let body: ColorData = ColorData(color: colorString, name: nameString)

        NetworkRequest(path: colorUrl, method: .put, headers: headers, body: body).execute { result in
            switch result {
            case .success(let data):
                guard let colorData = data as? ColorData else {
                    print("Data format incorrect")
                    return
                }
                let newColor = UIColor(colorData.color)
                let newName = colorData.name
                self.color = newColor
                self.name = newName
            case .failure(let error):
                print("NetworkRequest error: ", error)
            }
        }
    }
}
