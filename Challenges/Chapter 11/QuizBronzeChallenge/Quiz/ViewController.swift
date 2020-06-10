//
//  ViewController.swift
//  Quiz
//
//  Created by Marko Kramar on 03/05/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
    
    let questions: [String] = [
        NSLocalizedString("SevenPlusSevenQuestion", comment: "7+7 question"), //"What is 7+7?"
        NSLocalizedString("VermontCapitalQuestion", comment: "Capital of Vermont question"), //"What is the capital of Vermont?"
        NSLocalizedString("CognacQuestion", comment: "Cognac question") //"What is cognac made from?
    ]
    
    let answers: [String] = [
        NSLocalizedString("14Answer", comment: "A 14 answer"), //"14"
        NSLocalizedString("MontpelierAnswer", comment: "A Montpelier answer"), //"Montpelier"
        NSLocalizedString("GrapesAnswer", comment: "A grapes answer") //"Grapes"
    ]
    
    var currentQuestionIndex: Int = 0
    
    @IBAction func showNextQuestion(_ sender: UIButton) {
        // currentQuestionIndex = currentQuestionIndex == questions.count - 1 ? 0 : currentQuestionIndex + 1
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        let question: String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
}

