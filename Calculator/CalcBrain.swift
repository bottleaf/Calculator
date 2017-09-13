// lecture 34:03
//  calcBrain.swift
//  Calculator
//
//  Created by Andrew on 8/17/17.
//  Copyright © 2017 Andrew Su. All rights reserved.
//

import Foundation

struct CalcBrain {
    private var description: String = ""
    private var secondOperandAlreadyShown = false;
    private var evaluationQueue = [EvaluationSteps]()
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    private enum EvaluationSteps {
        case number(Double)
        case variable(String)
        case operationSymbol(String)
    }
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "sin" : Operation.unaryOperation(sin),
        "cos" : Operation.unaryOperation(cos),
        "tan" : Operation.unaryOperation(tan),
        "√" : Operation.unaryOperation(sqrt),
        "+/-": Operation.unaryOperation({-$0}),
            //long way => {(op1: Double) -> Double in return -op1}
        "%": Operation.unaryOperation({$0 * 100}),
        "1/x": Operation.unaryOperation({1 / $0}),
        "ln": Operation.unaryOperation(log),
        "×": Operation.binaryOperation(*),
        "+": Operation.binaryOperation(+),
        "-": Operation.binaryOperation(-),
        "÷": Operation.binaryOperation(/),
        "=": Operation.equals,
        "C": Operation.clear
    ]
    // ctrl + i = indent
    //performOperation changes the state of CalcBrain by calling the associaed function and updating accumulator.
    //all these statements should go into evaluate
    mutating func performOperation(representedBy symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                description += symbol
                if resultIsPending {
                    secondOperandAlreadyShown = true
                }
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    if resultIsPending {
                        description += symbol + "(" + doubleToString(accumulator!) + ")"
                        secondOperandAlreadyShown = true;
                    } else {
                        description = symbol + "(" + description + ")"
                    }
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    description = description + symbol
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                pendingBinaryOperation = nil
                accumulator = 0
                description = ""
                secondOperandAlreadyShown = false
            }
        }

        
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if secondOperandAlreadyShown {
                secondOperandAlreadyShown = false
            } else {
                description = description + doubleToString(accumulator!)
            }
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        if !resultIsPending {
            description = doubleToString(operand)
        }
        accumulator = operand
    }
    
    //TODO:Implement setOperand
    mutating func setOperand(variableName: String) {
    }
    
    //TODO:Implement evaluate
    //evaluate can access everything, even a "cache" of accumulated value and description
    func evaluate(using variables: Dictionary<String,Double>? = nil) ->
        (result: Double?, isPending: Bool, description: String){
            var accumulator: Double?
            func performOperation(representedBy symbol: String) {}
            for evaluationStep in evaluationQueue {
                switch evaluationStep {
                case .number(let constant):
                    setOperand(constant)
                }
            }
                           }
            return (nil, true, "")
    }
    
    var result: Double? {
            return accumulator
    }
    
    var resultIsPending: Bool {
            return pendingBinaryOperation != nil
    }
    
    func getDescription() -> String {
        if description == "" {
            return " "
        } else {
            if resultIsPending {
                return description + " ..."
            } else {
                return description + "="
            }
        }
    }
    
    func doubleToString(_ numToConvert: Double) -> String {
        return ((floor(numToConvert) == numToConvert) ? String(Int(numToConvert)) : String(numToConvert))
    }

}
