//
//  ViewController.swift
//  consuming-webservices
//
//  Created by Stephen Wong on 9/12/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HSBColorPickerDelegate {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorPicker: HSBColorPicker!
    
    var viewModel: ViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPicker.delegate = self
        viewModel = ViewModel(colorDidSet: updateColorView)
    }

    @IBAction func refreshColorPressed(_ sender: UIButton) {
        viewModel?.getColor()
    }
    
    func updateColorView(to color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        viewModel?.setColor(color)
    }
}

