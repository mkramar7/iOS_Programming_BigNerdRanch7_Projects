//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Marko Kramar on 04/05/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        print("ConversionViewController loaded its view.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("View will appear..")
    
        view.backgroundColor = randomColor()
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(Double.random(in: 0...255) / 255.0), green: CGFloat(Double.random(in: 0...255) / 255.0), blue: CGFloat(Double.random(in: 0...255) / 255.0), alpha: 1)
    }
    
}
