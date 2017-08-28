//
//  ViewController.swift
//  Calculator
//
//  Created by Andrew Su on 8/4/17.
//  Copyright © 2017 Andrew Su. All rights reserved.
//

//TODO: no leading zeros
//TODO: integers displayed as integers

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsTyping = false //or userCanAddDigits
//    var numberAlreadyHasDecimal = false
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsTyping = digit != "0" //if the first digit is zero, keep userIsTyping as false to prevent leading zeroes
        }
    }
   
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            if newValue == floor(newValue) { //if displayValue is set to an integer, display as an integer
                display.text = String(Int(newValue))
            } else {
            display.text = String(newValue)
            }
        }
    }
    
    private var calculatorBrain = CalcBrain();
    
    
//    @IBAction func touchDecimal(_ sender: UIButton) {
//        if !numberAlreadyHasDecimal {
//            if let textCurrentlyInDisplay = display.text {
//                display.text = textCurrentlyInDisplay + "."
//                numberAlreadyHasDecimal = true;
//            }
//        }
//    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            calculatorBrain.setOperand(displayValue)
            userIsTyping = false
        }
        if let operatorSymbol = sender.currentTitle {
            calculatorBrain.performOperation(operatorSymbol)
        }
        if let result = calculatorBrain.result {
            displayValue = result //does result need to be unwrapped
        }
    }
    
    /*/*probably need a func to makeDisplayable(Double)->string that fits and
    takes off trailing zeros*/
    nvm, we can used computer properties */
}

