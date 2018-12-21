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

    var questionValue = 0
    
    var questionTxt : String = ""
    var answerCorrect : String = ""
    var answerUser : String = ""
    var isShow: Bool = false
    var unitAnswer = ""
    var unitQuestion = ""
    
    var caterogyLists = 0
    var randomA = 0
    var randomB = 0
    
    var fromUnit = UnitLength.meters
    var toUnit = UnitLength.meters
    
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
        caterogyLists = Int.random(in: 0...1)
       
        switch caterogyLists{
        case 0:
            var lengthUnitLists = [UnitLength.inches,UnitLength.feet,UnitLength.yards]
            let indexCount = lengthUnitLists.count - 1
            randomA = Int.random(in: 0 ... indexCount)
            randomB = Int.random(in: 0 ... indexCount)
            
            while randomA == randomB{
                randomA = Int.random(in: 0 ... indexCount)
                randomB = Int.random(in: 0 ... indexCount)
            }
            
            let fromUnit = lengthUnitLists[randomA]
            let toUnit = lengthUnitLists[randomB]
            
            switch randomA{
            case 0:
                questionValue = Int.random(in: 1...20)*12               
            default:
                questionValue = Int.random(in: 1 ... 24)*3
            }
            let formatter = MeasurementFormatter()
            let length1 = Measurement(value: Double(questionValue), unit: fromUnit)
            let length2 = length1.converted(to: toUnit)
            let formatter2 = MeasurementFormatter()
            formatter2.unitOptions = .providedUnit
            formatter2.numberFormatter.maximumFractionDigits = 0
            answerCorrect = formatter2.string(from: length2)
            formatter.unitStyle = .short
            unitAnswer = formatter.string(from: toUnit)
            unitQuestion = formatter.string(from: fromUnit)
        case 1:
            var volumeUnitLists = [UnitVolume.cups,UnitVolume.pints,UnitVolume.quarts,UnitVolume.gallons]
            let indexCount = volumeUnitLists.count - 1
            
            randomA = Int.random(in: 0 ... indexCount)
            randomB = Int.random(in: 0 ... indexCount)
            
            while randomA == randomB{
                randomA = Int.random(in: 0 ... indexCount)
                randomB = Int.random(in: 0 ... indexCount)
            }
            
            let fromUnit = volumeUnitLists[randomA]
            let toUnit = volumeUnitLists[randomB]
            
            switch randomA{
            case 0:
                questionValue = Int.random(in: 10...20)*2
            case 3:
                questionValue = Int.random(in: 1...5)*2
            default:
                questionValue = Int.random(in: 1...8)*2
            }
            let formatter = MeasurementFormatter()
            let length1 = Measurement(value: Double(questionValue), unit: fromUnit)
            let length2 = length1.converted(to: toUnit)
            let formatter2 = MeasurementFormatter()
            formatter2.unitOptions = .providedUnit
            formatter2.numberFormatter.maximumFractionDigits = 0
            answerCorrect = formatter2.string(from: length2)
            formatter.unitStyle = .short
            unitAnswer = formatter.string(from: toUnit)
            unitQuestion = formatter.string(from: fromUnit)
            
        default:
            questionValue = 9999
        }
        questionLabel.text = "\(questionValue) \(unitQuestion)"
        if unitAnswer == "cup"{
            unitAnswer = "c"
        }
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

