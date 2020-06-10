//
//  ChangeDateViewController.swift
//  LootLogger
//
//  Created by Marko Kramar on 13/05/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ChangeDateViewController: UIViewController {
    @IBOutlet var itemDateChangedDatePicker: UIDatePicker!
    
    var item: Item! {
        didSet {
            navigationItem.title = "Change date for \(item.name)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        itemDateChangedDatePicker.setDate(item.dateCreated, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        item.dateCreated = itemDateChangedDatePicker.date
    }
    
}
