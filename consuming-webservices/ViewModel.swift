//
//  ViewModel.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation

typealias Block = (Void) -> Void

struct ViewModel {
    
    var ledStatusDidSet: Block? = nil
    var ledStatus = "⚪️" {
        didSet {
            ledStatusDidSet?()
        }
    }
    
    init(ledStatusDidSet: Block?) {
        self.ledStatusDidSet = ledStatusDidSet
    }
    
    mutating func toggleLED(to on: Bool) {
        ledStatus = on ? "🔵" : "⚪️"
    }
    
    mutating func refreshLEDStatus() {
        ledStatus = "⚪️"
    }
}
