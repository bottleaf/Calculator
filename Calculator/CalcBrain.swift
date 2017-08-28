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
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "cos" : Operation.unaryOperation(cos),
        "√" : Operation.unaryOperation(sqrt),
        "+/-": Operation.unaryOperation({-$0}),
            //long way => {(op1: Double) -> Double in return -op1}
        "×": Operation.binaryOperation({$0 * $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "=": Operation.equals
    ]
    // ctrl + i = indent
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation { //switch does not fall through
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
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
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
