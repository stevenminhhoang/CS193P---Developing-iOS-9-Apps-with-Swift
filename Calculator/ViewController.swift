//
//  ViewController.swift
//  Calculator
//
//  Created by Steven Dao on 5/11/16.
//  Copyright © 2016 Hoang Dao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    //private var userIsInTheMiddleOfFloatingPointNumber = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
//        if (digit == "." && display.text!.rangeOfString(".") == nil && userIsInTheMiddleOfTyping) {
//            display.text = display.text! + "."
//        }
        if userIsInTheMiddleOfTyping {
            if (digit == "." && display.text!.rangeOfString(".") != nil) {
                return
            } else {
                let textInDisplay = display.text!
                display.text = textInDisplay + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    @IBAction func clearEverything(sender: UIButton) {
        display.text! = "0"
        brain = CalculatorBrain()
    }
}

