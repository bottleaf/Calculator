//
//  ViewController.swift
//  Calculator
//
//  Created by Andrew Su on 8/4/17.
//  Copyright © 2017 Andrew Su. All rights reserved.
//

//TODO:memory of operation
//landscape mode
//Test Change through subl
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sequenceOfOperands: UILabel!
     var userIsTyping = false //or userCanAddDigits
//    var numberAlreadyHasDecimal = false
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." {
            if userIsTyping {
                if !display.text!.contains(".") {
                    display.text = display.text! + "."
                }
            } else {
                display.text = "0."
                userIsTyping = true
            }
        } else { //regular digit
            if userIsTyping {
                let textCurrentlyInDisplay = display.text!
                if textCurrentlyInDisplay == "0" {
                    display.text = digit
                } else {
                    display.text = textCurrentlyInDisplay + digit
                }
            } else {
                display.text = digit
                userIsTyping = true //if the first digit is zero, keep userIsTyping as false to prevent leading zeroes
            }
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
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            calculatorBrain.setOperand(displayValue)
            userIsTyping = false
        }
        if let operatorSymbol = sender.currentTitle {
            calculatorBrain.performOperation(representedBy: operatorSymbol)
        }
        sequenceOfOperands.text = calculatorBrain.getDescription()
        if let result = calculatorBrain.result {
            displayValue = result //does result need to be unwrapped
            userIsTyping = false
        }
    }
    
    /*/*probably need a func to makeDisplayable(Double)->string that fits and
    takes off trailing zeros*/
    nvm, we can used computer properties */
}

