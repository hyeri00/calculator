//
//  ViewController.swift
//  Calculator
//
//  Created by 혜리 on 2022/01/12.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new Calculator (count = \(calculatorCount))")
        brain.addUnaryOperation(symbol: "Z") { [ unowned me = self] in
            me.display.textColor = UIColor.red
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator left the the heap (count = \(calculatorCount))")
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.titleLabel?.text!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display!.text = textCurrentlyInDisplay + digit!
        } else {
            display!.text = digit!
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    var savedProgram: CalculatorBrain.PropertyList?
    @IBAction func save() {
        savedProgram = brain.program
    }

    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicakSymbol = sender.titleLabel?.text {
            brain.performOperation(symbol: mathematicakSymbol)
        }
        displayValue = brain.result
    }
    
}
