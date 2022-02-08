//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 혜리 on 2022/01/12.
//

import Foundation
import UIKit

class CalculatorBrain {
    private var accmulator = 0.0
    private var internalProgram = [Any]()
    
    func setOperand(operand: Double) {
        accmulator = operand
        internalProgram.append(operand)
    }
    
    func addUnaryOperation(symbol: String, operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.UnaryOperation(operation)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "x" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accmulator = value
            case .UnaryOperation(let function):
                accmulator = function(accmulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accmulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accmulator = pending!.binaryFunction(pending!.firstOperand, accmulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram as AnyObject
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    func clear() {
        accmulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accmulator
        }
    }
    
}

// 모든 타입은 대문자. ex) CalculatorBrain, Dictionary, Operation, String, Double

