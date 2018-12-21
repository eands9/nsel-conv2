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
    let meterUnits = [UnitLength.millimeters,UnitLength.centimeters,UnitLength.decimeters,UnitLength.meters,UnitLength.decameters,UnitLength.hectometers,UnitLength.kilometers]
    var indexCount = 0
    
    var questionTxt : String = ""
    var answerCorrect : String = ""
    var answerUser : String = ""
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
        
        randomC = Int.random(in: 1 ... 20)
        let fromUnit = meterUnits[randomA]
        let toUnit = meterUnits[randomB]
        
        let length1 = Measurement(value: Double(randomC), unit: fromUnit)
        let length2 = length1.converted(to: toUnit)
        
        let m = MeasurementFormatter()
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        let unitAnswer = formatter.string(from: toUnit)
        let unitQuestion = formatter.string(from: fromUnit)

        print(unitAnswer)
        
        questionLabel.text = "\(randomC) \(unitQuestion)"
        answerCorrect = m.string(from: length2)
    }
    
    @IBAction func showBtn(_ sender: Any) {
        answerTxt.text = String(answerCorrect)
        isShow = true
    }
    
    func checkAnswer(){
        //answerUser = (answerTxt.text! as NSString).doubleValue
        answerUser = answerTxt.text!
        
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

