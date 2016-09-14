//
//  ViewController.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/12/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ledStatusLabel: UILabel!
    
    var viewModel: ViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel(ledStatusDidSet: updateLEDStatus)
    }

    @IBAction func toggleLEDButtonPressed(_ sender: UIButton) {
        let newStatus = viewModel?.ledStatus == .on ? false : true
        viewModel?.toggleLED(to: newStatus)
    }

    @IBAction func getLEDStatusButtonPressed(_ sender: UIButton) {
        viewModel?.refreshLEDStatus()
    }
    
    func updateLEDStatus(status: LEDState) {
        switch status {
        case .on:
            ledStatusLabel.text = "🔵"
        case .off:
            ledStatusLabel.text = "⚪️"
        }
    }
    
}

