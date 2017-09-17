// lecture 34:03
//  calcBrain.swift
//  Calculator
//
//  Created by Andrew on 8/17/17.
//  Copyright © 2017 Andrew Su. All rights reserved.
//

import Foundation

struct CalcBrain {
    private var evaluationQueue = [EvaluationStep]()
        //TODO: add unique String functions for unaryOperations that displays operation properly not just func(operand)
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    private enum EvaluationStep {
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
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        evaluationQueue.append(EvaluationStep.number(operand))
    }
    
    mutating func setOperand(variableName: String) {
        evaluationQueue.append(EvaluationStep.variable(variableName))
    }
    
    mutating func performOperation(representedBy symbol: String) {
        evaluationQueue.append(EvaluationStep.operationSymbol(symbol))
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool, description: String){
        var accumulator: Double?
        var description = ""
        var lastOperandDescription = ""
        //This variable is used for unaryOperations on second operand of pending binaryOperations
        var pendingBinaryOperation: PendingBinaryOperation?
        var resultIsPending: Bool {
            return pendingBinaryOperation != nil
        }
        var formattedDescription: String {
            if description == "" {
                return " "
            } else {
                if resultIsPending {
                    return description + lastOperandDescription + "..."
                } else {
                    return description + "="
                }
            }
        }
        
        func doubleToString(_ numToConvert: Double) -> String {
            return ((floor(numToConvert) == numToConvert) ? String(Int(numToConvert)) : String(numToConvert))
        }

        func setOperand(operand: Double) {
            if !resultIsPending {
                description = doubleToString(operand)
            } else {
                lastOperandDescription = doubleToString(operand)
            }
            accumulator = operand
        }
        
        func setOperand(_ variableName: String) {
            if !resultIsPending {
                description = variableName
            } else {
                lastOperandDescription = variableName
            }
            if (variables == nil || variables![variableName] == nil) {
                accumulator = 0
            } else {
                accumulator = variables![variableName]
            }
        }
        
        func performPendingBinaryOperation() {
            if pendingBinaryOperation != nil && accumulator != nil {
                description = description + lastOperandDescription
                lastOperandDescription = ""
                accumulator = pendingBinaryOperation!.perform(with: accumulator!)
                pendingBinaryOperation = nil
                
            }
        }
        
        func performOperation(representedBy symbol: String) {
            if let operation = operations[symbol] {
                switch operation {
                case .constant(let value):
                    if resultIsPending {
                        lastOperandDescription = symbol
                    } else {
                        description = symbol
                    }
                    accumulator = value
                case .unaryOperation(let function):
                    if accumulator != nil {
                        if resultIsPending {
                            lastOperandDescription = symbol + "(" + lastOperandDescription + ")"
                        } else {
                            description = symbol + "(" + description + ")"
                        }
                        accumulator = function(accumulator!)
                    }
                //TODO: check precedence of previous binary function to properly display description (e.g. 5 + 5 * 3 -> (5 + 5) * 3
                case .binaryOperation(let function):
                    if resultIsPending {
                        performPendingBinaryOperation()
                    }
                    if accumulator != nil {
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                        description += symbol
                        accumulator = nil
                    }
                case .equals:
                    performPendingBinaryOperation()
                case .clear:
                    pendingBinaryOperation = nil
                    accumulator = 0
                    description = ""
                    lastOperandDescription = ""
                }
            }
        }
        
        //evaluate body iterates thorugh evaluationQueue
        for evaluationStep in evaluationQueue {
            switch evaluationStep {
            case .number(let constant):
                if !resultIsPending {
                    description = doubleToString(constant)
                }
                setOperand(operand: constant) //implement setOperand(double)
            case .variable(let variableName):
                setOperand(variableName)
            case .operationSymbol(let symbol):
                performOperation(representedBy: symbol)
            }
        }

        return (accumulator, resultIsPending, formattedDescription)
    }
    
    var result: Double? {
        return evaluate().result
    }
    
    var resultIsPending: Bool {
        return evaluate().isPending
    }
    
    func getDescription() -> String {
        return evaluate().description
    }
    
}

