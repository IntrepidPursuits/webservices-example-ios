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
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = ViewModel(ledStatusDidSet: updateLEDStatus)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleLEDButtonPressed(_ sender: UIButton) {
        viewModel?.toggleLED(to: true)
    }

    @IBAction func getLEDStatusButtonPressed(_ sender: UIButton) {
        viewModel?.refreshLEDStatus()
    }
    
    func updateLEDStatus() {
        ledStatusLabel.text = viewModel?.ledStatus
    }
    
}

