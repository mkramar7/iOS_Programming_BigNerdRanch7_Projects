//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Marko Kramar on 04/05/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    var customView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        print("ConversionViewController loaded its view.")
    }
    
    override func loadView() {
        customView = UIView()
        customView.backgroundColor = UIColor.white
        view = customView

        // view.backgroundColor = UIColor.white
        
        let orangeColor = UIColor(red: CGFloat(225.0 / 255.0), green: CGFloat(88.0 / 255.0), blue: CGFloat(41.0 / 255.0), alpha: 1.0)
        
        // Fahrenheit number label
        let fahrenheitNumberLabel = UILabel()
        fahrenheitNumberLabel.text = "200"
        fahrenheitNumberLabel.textColor = orangeColor
        fahrenheitNumberLabel.font = UIFont.systemFont(ofSize: 70.0)
        view.addSubview(fahrenheitNumberLabel)
        fahrenheitNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Degrees fahrenheit label
        let degreesFahrenheitLabel = UILabel()
        degreesFahrenheitLabel.text = "degrees Fahrenheit"
        degreesFahrenheitLabel.textColor = orangeColor
        degreesFahrenheitLabel.font = UIFont.systemFont(ofSize: 36.0)
        view.addSubview(degreesFahrenheitLabel)
        degreesFahrenheitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Is really label
        let isReallyLabel = UILabel()
        isReallyLabel.text = "is really"
        isReallyLabel.font = UIFont.systemFont(ofSize: 36.0)
        view.addSubview(isReallyLabel)
        isReallyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Celsius number label
        let celsiusNumberLabel = UILabel()
        celsiusNumberLabel.text = "100"
        celsiusNumberLabel.textColor = orangeColor
        celsiusNumberLabel.font = UIFont.systemFont(ofSize: 70.0)
        view.addSubview(celsiusNumberLabel)
        celsiusNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Degrees celsius label
        let degreesCelsiusLabel = UILabel()
        degreesCelsiusLabel.text = "degrees Celsius"
        degreesCelsiusLabel.textColor = orangeColor
        degreesCelsiusLabel.font = UIFont.systemFont(ofSize: 36.0)
        view.addSubview(degreesCelsiusLabel)
        degreesCelsiusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Positioning
        fahrenheitNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        fahrenheitNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        degreesFahrenheitLabel.topAnchor.constraint(equalTo: fahrenheitNumberLabel.bottomAnchor, constant: 8).isActive = true
        degreesFahrenheitLabel.centerXAnchor.constraint(equalTo: fahrenheitNumberLabel.centerXAnchor).isActive = true
        
        isReallyLabel.topAnchor.constraint(equalTo: degreesFahrenheitLabel.bottomAnchor, constant: 8).isActive = true
        isReallyLabel.centerXAnchor.constraint(equalTo: fahrenheitNumberLabel.centerXAnchor).isActive = true
        
        celsiusNumberLabel.topAnchor.constraint(equalTo: isReallyLabel.bottomAnchor, constant: 8).isActive = true
        celsiusNumberLabel.centerXAnchor.constraint(equalTo: fahrenheitNumberLabel.centerXAnchor).isActive = true
        
        degreesCelsiusLabel.topAnchor.constraint(equalTo: celsiusNumberLabel.bottomAnchor, constant: 8).isActive = true
        degreesCelsiusLabel.centerXAnchor.constraint(equalTo: fahrenheitNumberLabel.centerXAnchor).isActive = true
    }
    
}
