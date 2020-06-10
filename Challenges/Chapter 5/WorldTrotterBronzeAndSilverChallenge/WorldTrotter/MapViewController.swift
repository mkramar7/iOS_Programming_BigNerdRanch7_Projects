//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Marko Kramar on 05/05/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.showsPointsOfInterest = false
        
        // Set it as *the* view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // Adding POI label and switch
        let poiLabel = UILabel()
        poiLabel.text = "Points of Interest"
        view.addSubview(poiLabel)
        
        let poiSwitch = UISwitch()
        view.addSubview(poiSwitch)
        
        poiLabel.translatesAutoresizingMaskIntoConstraints = false
        poiSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        poiLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15).isActive = true
        poiLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        poiSwitch.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true
        poiSwitch.leadingAnchor.constraint(equalTo: poiLabel.trailingAnchor, constant: 5).isActive = true
        
        poiSwitch.addTarget(self, action: #selector(poiSwitchChanged(_:)), for: .valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    @objc func poiSwitchChanged(_ switchControl: UISwitch) {
        mapView.showsPointsOfInterest = switchControl.isOn
    }
}
