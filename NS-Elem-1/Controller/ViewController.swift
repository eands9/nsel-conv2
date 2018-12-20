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
    var randomC: Double = 0.00
    let meterUnits = [UnitLength.millimeters,UnitLength.centimeters,UnitLength.decimeters,UnitLength.meters,UnitLength.decameters,UnitLength.hectometers,UnitLength.kilometers]
    var indexCount = 0
    
    var questionTxt : String = ""
    var answerCorrect : Double = 0
    var answerUser : Double = 0
    var isShow: Bool = false
    
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
        
        indexCount = meterUnits.count - 1
        
        while randomA == randomB{
            randomA = Int.random(in: 0 ... indexCount)
            randomB = Int.random(in: 0 ... indexCount)
        }
        
        randomC = Double.random(in: 1 ... 20)
        var fromUnit = meterUnits[randomA]
        var toUnit = meterUnits[randomB]
        
        let length1 = Measurement(value: randomC, unit: fromUnit)
        let length2 = length1.converted(to: toUnit)
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        let unitAnswer = formatter.string(from: toUnit)
        let userAnswer = "1"
        let answer = "\(userAnswer) \(unitAnswer)"
        
        let formatter1 = MeasurementFormatter()
        formatter1.unitOptions = .providedUnit
        let correctAnswer = formatter1.string(from: length2)
        
        questionLabel.text = length1
        answerCorrect = round((numA - numB)*100)/100
    }
    
    @IBAction func showBtn(_ sender: Any) {
        answerTxt.text = String(answerCorrect)
        isShow = true
    }
    
    func checkAnswer(){
        answerUser = (answerTxt.text! as NSString).doubleValue
        
        if answerUser == answerCorrect && isShow == false {
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            askQuestion()
            answerTxt.text = ""
        }
        else if isShow == true {
            readMe(myText: "Next Question")
            askQuestion()
            isShow = false
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
        else{
            randomTryAgain()
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
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

