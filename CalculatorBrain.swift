//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Steven Dao on 5/25/16.
//  Copyright © 2016 Hoang Dao. All rights reserved.
//

import Foundation

func factorial(op1: Double) -> Double {
    if op1 <= 1 {
        return 1
    }
    return op1 * factorial(op1 - 1)
}

class CalculatorBrain
{
    private var accumulator = 0.0
    
    var description = ""
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0}),
        "√" : Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "sinh": Operation.UnaryOperation(sinh),
        "cosh": Operation.UnaryOperation(cosh),
        "tan": Operation.UnaryOperation(tan),
        "tanh": Operation.UnaryOperation(tanh),
        "1/x" : Operation.UnaryOperation({ 1 / $0 }),
        "ln" : Operation.UnaryOperation(log),
        "log" : Operation.UnaryOperation(log10),
        "x!" : Operation.UnaryOperation(factorial),
        "10^x" : Operation.UnaryOperation({ pow( 10, $0 ) }),
        "e^x" : Operation.UnaryOperation({ pow( M_E, $0 ) }),
        "x^2" : Operation.UnaryOperation({ pow( $0, 2 ) }),
        "x^3" : Operation.UnaryOperation({ pow( $0, 3 ) }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "=" : Operation.Equals,
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 })
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)-> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}