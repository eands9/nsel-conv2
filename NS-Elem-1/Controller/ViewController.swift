//
//  ViewController.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var timer = Timer()
    var counter = 0.0

    var randomA = 0
    var randomB = 0
    var randomC: Int = 0
    let convUnits = [UnitLength.inches,UnitLength.feet,UnitLength.yards]
    var indexCount = 0
    let inchValues = [12,24,36,48,60,72,84,96,108,120,132,144]
    var randomInchValue = 0
    var inchCount = 0
    
    var questionValue = 0
    
    var questionTxt : String = ""
    var answerCorrect : String = ""
    var answerUser : String = ""
    var isShow: Bool = false
    var unitAnswer = ""
    var unitQuestion = ""
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.answerTxt.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    
    func askQuestion(){
        
        indexCount = convUnits.count - 1
        inchCount = inchValues.count - 1
        
        randomA = Int.random(in: 0 ... indexCount)
        randomB = Int.random(in: 0 ... indexCount)
        
        randomInchValue = Int.random(in: 0 ... inchCount)
        
        while randomA == randomB{
            randomA = Int.random(in: 0 ... indexCount)
            randomB = Int.random(in: 0 ... indexCount)
        }
        
        if randomA == 0{
            questionValue = inchValues[randomInchValue]
        }
        else if randomA == 1{
            questionValue = Int.random(in: 1 ... 12)
        }
        else{
            questionValue = Int.random(in: 1 ... 10)
        }
        
        /*
        if randomA > randomB{
            randomC = Int.random(in: 1 ... 10)
        }
        else{
            randomC = ((Int.random(in: 10 ... 100))*100)/100
        }
        */
        
        let fromUnit = convUnits[randomA]
        let toUnit = convUnits[randomB]
        
        let formatter = MeasurementFormatter()
        let length1 = Measurement(value: Double(questionValue), unit: fromUnit)
        //formatter.unitOptions = .providedUnit
        //let q = formatter.string(from: length1)
        //questionLabel.text = q
        
        print(length1)
        
        let length2 = length1.converted(to: toUnit)
        let formatter2 = MeasurementFormatter()
        formatter2.unitOptions = .providedUnit
        formatter2.numberFormatter.maximumFractionDigits = 6
        answerCorrect = formatter2.string(from: length2)

        formatter.unitStyle = .short
        unitAnswer = formatter.string(from: toUnit)
        unitQuestion = formatter.string(from: fromUnit)
        
        questionLabel.text = "\(questionValue) \(unitQuestion)"
        /*
        if unitAnswer == "liter" {
            unitAnswer = "L"
        }
        */
        
        answerTxt.text = unitAnswer
        
    }
    
    @IBAction func showBtn(_ sender: Any) {
        answerTxt.text = answerCorrect
        isShow = true
    }
    
    func checkAnswer(){
        answerUser = answerTxt.text!
        
        if answerUser == answerCorrect && isShow == false {
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            answerTxt.text = ""
            askQuestion()
        }
        else if isShow == true {
            readMe(myText: "Next Question")
            answerTxt.text = ""
            askQuestion()
            isShow = false
            numberAttempts += 1
            updateProgress()
        }
        else{
            randomTryAgain()
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
            answerTxt.text = unitAnswer
        }
    }
    
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    
    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(9))
        readMe(myText: congratulateArray[randomPick])
    }
    
    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
    
    func randomTryAgain(){
        randomPick = Int(arc4random_uniform(2))
        readMe(myText: retryArray[randomPick])
    }
}

