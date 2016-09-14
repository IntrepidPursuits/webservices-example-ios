//
//  LED.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/13/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation

enum LEDState {
    case on, off
}

struct LED {
    var status: LEDState = .off
}
