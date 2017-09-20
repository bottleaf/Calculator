//
//  ViewController.swift
//  Calculator
//
//  Created by Andrew Su on 8/4/17.
//  Copyright © 2017 Andrew Su. All rights reserved.
//

//TODO:memory of operation
//landscape mode

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sequenceOfOperands: UILabel!
    @IBOutlet weak var useVariableButton: UIButton!
    @IBOutlet weak var variablesDisplay: UILabel!
    
    var userIsTyping = false
    //TODO CLEAR NEEDS TO CLEAR VARIABLES and call displayVariables
    //Clear stack in model
    //reset display
    @IBAction func touchDigit(_ sender: UIButton) {
        //if user is putting in numbers, a variable in display is cleared
        
        if variableInDisplay != nil {
            variableInDisplay = nil
            userIsTyping = false
        }
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
    private var variableDictionary = [String: Double]()
    private var variableInDisplay: String?
    

    
    
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
        if variableInDisplay != nil {
            calculatorBrain.setOperand(variableName: variableInDisplay!)
            variableInDisplay = nil
        }
        if let operatorSymbol = sender.currentTitle {
            calculatorBrain.performOperation(representedBy: operatorSymbol)
        }
        evaluate()
    }
    
    @IBAction func performOperationWithVariabValue(_ sender: UIButton) {
        variableDictionary["M"] = displayValue
        displayVariables()
        calculatorBrain.performOperation(representedBy: "=")
        evaluate()
    }
    //TODO: verify reset Works
    //for now can't test because variable and other dont' work
    @IBAction func resetCalculatorModel(_ sender: UIButton) {
        variableDictionary = [String: Double]()
        displayVariables()
        variableInDisplay = nil
        userIsTyping = false
        displayValue = 0.0
        sequenceOfOperands.text = " "
        calculatorBrain.resetCalculatorBrain()
    }
    
    func evaluate() {
        let evalOutput = calculatorBrain.evaluate(using: variableDictionary)
        sequenceOfOperands.text = evalOutput.description
        if let result = evalOutput.result {
            displayValue = result
            userIsTyping = false
        }
    }
    
    func displayVariables() {
        variablesDisplay.text = " "
        for (variableName, variableValue) in variableDictionary {
            variablesDisplay.text = variablesDisplay.text! + variableName + ": " + String(variableValue) + " "
        }
    }
    
    @IBAction func useVariable(_ sender: UIButton) {
        /* clicking the variable "M" button only puts M in the display
        but doesn't set Operand because the user might want to write-over
        with numbers.  This preps the variable to be used to setOperand
        */
        let variableName = sender.currentTitle!
        display.text = variableName
        variableInDisplay = variableName
        userIsTyping = false
    }
    
    

}

