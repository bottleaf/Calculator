// lecture 34:03
//  calcBrain.swift
//  Calculator
//
//  Created by Andrew on 8/17/17.
//  Copyright © 2017 Andrew Su. All rights reserved.
//

import Foundation

struct CalcBrain {
    
    private var accumulator: Double? //accumulator is unintialized in the beginning
    private var description: String = ""
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
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
        "%": Operation.unaryOperation({$0 / 100}),
        "1/x": Operation.unaryOperation({1 / $0}),
        "ln": Operation.unaryOperation(log),
        "×": Operation.binaryOperation({$0 * $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "=": Operation.equals,
        "C": Operation.clear
    ]
    // ctrl + i = indent
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                description += symbol
            case .unaryOperation(let function):
                if accumulator != nil {
                    description = symbol + "(" + description + ")"
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
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            description = description + String(accumulator!)
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
            description = String(operand)
        }
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    func getDescription() -> String {
        if description == "" {
            return ""
        } else {
            if resultIsPending {
                return description + " ..."
            } else {
                return description + "="
            }
        }
    }

}
