//
//  ViewController.swift
//  Mandala
//
//  Created by Marko Kramar on 20/05/2020.
//  Copyright © 2020 Marko Kramar. All rights reserved.
//

import UIKit

class MoodSelectionViewController: UIViewController {
    @IBOutlet var addMoodButton: UIButton!
    @IBOutlet var moodSelector: ImageSelector!
    
    private var moodsConfigurable: MoodsConfigurable!
    
    private var moods: [Mood] = [] {
        didSet {
            currentMood = moods.first
            moodSelector.images = moods.map { $0.image }
        }
    }
    
    private var currentMood: Mood? {
        didSet {
            guard let currentMood = currentMood else {
                addMoodButton?.setTitle(nil, for: .normal)
                addMoodButton?.backgroundColor = nil
                return
            }
            
            addMoodButton?.setTitle("I'm \(currentMood.name)", for: .normal)
            addMoodButton.backgroundColor = currentMood.color
        }
    }
    
    @IBAction private func moodSelectionChanged(_ sender: ImageSelector) {
        currentMood = moods[sender.selectedIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moods = [.happy, .sad, .angry, .goofy, .crying, .confused, .sleepy, .meh]
        addMoodButton.layer.cornerRadius = addMoodButton.bounds.height / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "embedContainerViewController":
            guard let moodsConfigurable = segue.destination as? MoodsConfigurable else {
                preconditionFailure("View controller expected to conform to MoodsConfigurable")
            }
            self.moodsConfigurable = moodsConfigurable
            segue.destination.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @IBAction func addMoodTapped(_ sender: UIButton) {
        guard let currentMood = currentMood else {
            return
        }
        
        let newMoodEntry = MoodEntry(mood: currentMood, timestamp: Date())
        moodsConfigurable.add(newMoodEntry)
    }
    
}

