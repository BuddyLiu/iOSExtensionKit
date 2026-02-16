// Bool+Extension.swift
// 布尔值扩展，提供便捷的转换和操作方法

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public extension Bool {
    
    // MARK: - 基本转换
    
    /// 转换为整数（true = 1, false = 0）
    var toInt: Int {
        return self ? 1 : 0
    }
    
    /// 转换为字符串
    /// - Parameter localized: 是否使用本地化字符串（true: "true"/"是"，false: "false"/"否"）
    /// - Returns: 字符串表示
    func toString(localized: Bool = false) -> String {
        if localized {
            #if canImport(UIKit)
            return NSLocalizedString(self ? "true" : "false", comment: "")
            #else
            return self ? "true" : "false"
            #endif
        } else {
            return self ? "true" : "false"
        }
    }
    
    /// 转换为YES/NO字符串（Objective-C风格）
    var yesNoString: String {
        return self ? "YES" : "NO"
    }
    
    /// 转换为是/否字符串（中文）
    var chineseString: String {
        return self ? "是" : "否"
    }
    
    // MARK: - 逻辑运算
    
    /// 逻辑与（&&）的便捷方法
    /// - Parameter other: 另一个布尔值
    /// - Returns: 逻辑与结果
    func and(_ other: Bool) -> Bool {
        return self && other
    }
    
    /// 逻辑或（||）的便捷方法
    /// - Parameter other: 另一个布尔值
    /// - Returns: 逻辑或结果
    func or(_ other: Bool) -> Bool {
        return self || other
    }
    
    /// 逻辑异或（XOR）
    /// - Parameter other: 另一个布尔值
    /// - Returns: 逻辑异或结果
    func xor(_ other: Bool) -> Bool {
        return self != other
    }
    
    /// 逻辑非（!）的属性版本
    var not: Bool {
        return !self
    }
    
    /// 逻辑与非（NAND）
    /// - Parameter other: 另一个布尔值
    /// - Returns: 逻辑与非结果
    func nand(_ other: Bool) -> Bool {
        return !(self && other)
    }
    
    /// 逻辑或非（NOR）
    /// - Parameter other: 另一个布尔值
    /// - Returns: 逻辑或非结果
    func nor(_ other: Bool) -> Bool {
        return !(self || other)
    }
    
    // MARK: - 位运算（适用于整数转换后）
    
    /// 位与运算（将布尔值视为0/1后进行位与）
    /// - Parameter other: 另一个布尔值
    /// - Returns: 位与结果（转换为布尔值）
    func bitwiseAnd(_ other: Bool) -> Bool {
        return (self.toInt & other.toInt) != 0
    }
    
    /// 位或运算（将布尔值视为0/1后进行位或）
    /// - Parameter other: 另一个布尔值
    /// - Returns: 位或结果（转换为布尔值）
    func bitwiseOr(_ other: Bool) -> Bool {
        return (self.toInt | other.toInt) != 0
    }
    
    /// 位异或运算（将布尔值视为0/1后进行位异或）
    /// - Parameter other: 另一个布尔值
    /// - Returns: 位异或结果（转换为布尔值）
    func bitwiseXor(_ other: Bool) -> Bool {
        return (self.toInt ^ other.toInt) != 0
    }
    
    /// 位非运算（将布尔值视为0/1后进行位非）
    var bitwiseNot: Bool {
        return (~self.toInt & 1) != 0
    }
    
    // MARK: - 条件操作
    
    /// 根据布尔值选择两个值中的一个
    /// - Parameters:
    ///   - trueValue: 当为true时返回的值
    ///   - falseValue: 当为false时返回的值
    /// - Returns: 选择的值
    func choose<T>(trueValue: T, falseValue: T) -> T {
        return self ? trueValue : falseValue
    }
    
    /// 根据布尔值执行不同的闭包
    /// - Parameters:
    ///   - trueAction: 当为true时执行的闭包
    ///   - falseAction: 当为false时执行的闭包
    /// - Returns: 闭包的返回值
    @discardableResult
    func ifTrue<T>(_ trueAction: () -> T, else falseAction: () -> T) -> T {
        return self ? trueAction() : falseAction()
    }
    
    /// 当为true时执行闭包
    /// - Parameter action: 要执行的闭包
    /// - Returns: 闭包的返回值，如果为false则返回nil
    @discardableResult
    func whenTrue<T>(_ action: () -> T) -> T? {
        guard self else { return nil }
        return action()
    }
    
    /// 当为false时执行闭包
    /// - Parameter action: 要执行的闭包
    /// - Returns: 闭包的返回值，如果为true则返回nil
    @discardableResult
    func whenFalse<T>(_ action: () -> T) -> T? {
        guard !self else { return nil }
        return action()
    }
    
    /// 如果为true，返回给定的值，否则返回nil
    /// - Parameter value: 要返回的值
    /// - Returns: 值或nil
    func then<T>(_ value: T) -> T? {
        return self ? value : nil
    }
    
    /// 如果为true，返回给定的闭包的结果，否则返回nil
    /// - Parameter valueProvider: 提供值的闭包
    /// - Returns: 闭包的结果或nil
    func then<T>(_ valueProvider: () -> T) -> T? {
        return self ? valueProvider() : nil
    }
    
    /// 如果为false，返回给定的值，否则返回nil
    /// - Parameter value: 要返回的值
    /// - Returns: 值或nil
    func otherwise<T>(_ value: T) -> T? {
        return !self ? value : nil
    }
    
    // MARK: - 数值转换
    
    /// 转换为Double（true = 1.0, false = 0.0）
    var toDouble: Double {
        return self ? 1.0 : 0.0
    }
    
    /// 转换为Float（true = 1.0, false = 0.0）
    var toFloat: Float {
        return self ? 1.0 : 0.0
    }
    
    /// 转换为CGFloat（true = 1.0, false = 0.0）
    #if canImport(CoreGraphics)
    var toCGFloat: CGFloat {
        return self ? 1.0 : 0.0
    }
    #endif
    
    /// 转换为NSNumber
    var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
    
    // MARK: - 集合操作
    
    /// 将布尔值转换为可选类型
    /// - Returns: 如果为true则返回空元组，否则返回nil
    var asOptionalVoid: Void? {
        return self ? () : nil
    }
    
    /// 将布尔值转换为Result类型
    /// - Parameters:
    ///   - successValue: 成功时的值
    ///   - error: 失败时的错误
    /// - Returns: Result类型
    func toResult<T, E: Error>(success successValue: T, failure error: E) -> Result<T, E> {
        return self ? .success(successValue) : .failure(error)
    }
    
    /// 将布尔值转换为Result类型（使用闭包）
    /// - Parameters:
    ///   - successProvider: 成功时提供值的闭包
    ///   - errorProvider: 失败时提供错误的闭包
    /// - Returns: Result类型
    func toResult<T, E: Error>(
        success successProvider: () -> T,
        failure errorProvider: () -> E
    ) -> Result<T, E> {
        return self ? .success(successProvider()) : .failure(errorProvider())
    }
    
    // MARK: - 检查与验证
    
    /// 检查布尔值是否与期望值一致
    /// - Parameter expected: 期望的布尔值
    /// - Returns: 是否一致
    func isEqual(to expected: Bool) -> Bool {
        return self == expected
    }
    
    /// 检查布尔值是否与期望值不一致
    /// - Parameter expected: 期望的布尔值
    /// - Returns: 是否不一致
    func isNotEqual(to expected: Bool) -> Bool {
        return self != expected
    }
    
    /// 布尔值的哈希值（兼容Hashable）
    var hashValue: Int {
        return self.toInt
    }
    
    // MARK: - 字符串解析
    
    /// 从字符串解析布尔值
    /// - Parameter string: 要解析的字符串
    /// - Returns: 解析出的布尔值
    static func from(_ string: String) -> Bool {
        let lowercased = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch lowercased {
        case "true", "yes", "y", "1", "on", "enabled", "enable":
            return true
        case "false", "no", "n", "0", "off", "disabled", "disable":
            return false
        default:
            return false
        }
    }
    
    /// 安全地从字符串解析布尔值
    /// - Parameter string: 要解析的字符串
    /// - Returns: 解析出的布尔值，如果无法解析则返回nil
    static func safeFrom(_ string: String) -> Bool? {
        let lowercased = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch lowercased {
        case "true", "yes", "y", "1", "on", "enabled", "enable":
            return true
        case "false", "no", "n", "0", "off", "disabled", "disable":
            return false
        default:
            return nil
        }
    }
    
    // MARK: - 随机生成
    
    /// 随机生成一个布尔值
    /// - Returns: 随机布尔值
    static func random() -> Bool {
        return Int.random(in: 0...1) == 1
    }
    
    /// 以指定概率生成true
    /// - Parameter probability: true的概率（0.0到1.0之间）
    /// - Returns: 根据概率生成的布尔值
    static func random(probability: Double) -> Bool {
        guard probability >= 0.0 && probability <= 1.0 else {
            return false
        }
        return Double.random(in: 0.0..<1.0) < probability
    }
    
    /// 以指定概率生成true
    /// - Parameter percentage: true的百分比（0到100之间）
    /// - Returns: 根据百分比生成的布尔值
    static func random(percentage: Int) -> Bool {
        guard percentage >= 0 && percentage <= 100 else {
            return false
        }
        return Double.random(in: 0.0..<1.0) < Double(percentage) / 100.0
    }
}

// MARK: - 全局函数

/// 从字符串创建布尔值
/// - Parameter string: 字符串
/// - Returns: 布尔值
public func bool(from string: String) -> Bool {
    return Bool.from(string)
}

/// 安全地从字符串创建布尔值
/// - Parameter string: 字符串
/// - Returns: 布尔值，如果无法解析则返回nil
public func safeBool(from string: String) -> Bool? {
    return Bool.safeFrom(string)
}

// MARK: - 自定义运算符（可选）

infix operator &&= : AssignmentPrecedence

/// 逻辑与赋值运算符
/// - Parameters:
///   - lhs: 要赋值的布尔值
///   - rhs: 另一个布尔值
public func &&= (lhs: inout Bool, rhs: Bool) {
    lhs = lhs && rhs
}

infix operator ||= : AssignmentPrecedence

/// 逻辑或赋值运算符
/// - Parameters:
///   - lhs: 要赋值的布尔值
///   - rhs: 另一个布尔值
public func ||= (lhs: inout Bool, rhs: Bool) {
    lhs = lhs || rhs
}

infix operator ^= : AssignmentPrecedence

/// 逻辑异或赋值运算符
/// - Parameters:
///   - lhs: 要赋值的布尔值
///   - rhs: 另一个布尔值
public func ^= (lhs: inout Bool, rhs: Bool) {
    lhs = lhs != rhs
}

// MARK: - Bool扩展的便捷属性

public extension Bool {
    
    /// 检查是否为true
    var isTrue: Bool {
        return self
    }
    
    /// 检查是否为false
    var isFalse: Bool {
        return !self
    }
    
    /// 反转为相反的布尔值
    var toggled: Bool {
        return !self
    }
    
    /// 切换布尔值（返回切换后的新值）
    @discardableResult
    mutating func toggle() -> Bool {
        self = !self
        return self
    }
}

// MARK: - 可选项布尔扩展

public extension Optional where Wrapped == Bool {
    
    /// 安全地获取布尔值，如果为nil则返回默认值
    /// - Parameter defaultValue: 默认值
    /// - Returns: 布尔值
    func value(or defaultValue: Bool = false) -> Bool {
        return self ?? defaultValue
    }
    
    /// 检查可选项是否为true（非nil且为true）
    var isTrue: Bool {
        return self == true
    }
    
    /// 检查可选项是否为false（非nil且为false）
    var isFalse: Bool {
        return self == false
    }
    
    /// 检查可选项是否为nil或false
    var isNilOrFalse: Bool {
        return self == nil || self == false
    }
    
    /// 检查可选项是否为nil或true
    var isNilOrTrue: Bool {
        return self == nil || self == true
    }
}

// MARK: - 布尔数组扩展

public extension Array where Element == Bool {
    
    /// 检查数组中是否所有值都为true
    var allTrue: Bool {
        return allSatisfy { $0 }
    }
    
    /// 检查数组中是否所有值都为false
    var allFalse: Bool {
        return allSatisfy { !$0 }
    }
    
    /// 统计true的数量
    var trueCount: Int {
        return count { $0 }
    }
    
    /// 统计false的数量
    var falseCount: Int {
        return count { !$0 }
    }
    
    /// 逻辑与（所有值的与运算）
    var logicalAnd: Bool {
        guard !isEmpty else { return true }
        return reduce(true) { $0 && $1 }
    }
    
    /// 逻辑或（所有值的或运算）
    var logicalOr: Bool {
        guard !isEmpty else { return false }
        return reduce(false) { $0 || $1 }
    }
    
    /// 逻辑异或（所有值的异或运算）
    var logicalXor: Bool {
        guard !isEmpty else { return false }
        return reduce(false) { $0 != $1 }
    }
}

// MARK: - 使用示例
/*
 示例用法：
 
 1. 基本转换：
    let isEnabled = true
    print(isEnabled.toInt)        // 1
    print(isEnabled.toString())   // "true"
    print(isEnabled.yesNoString)  // "YES"
    print(isEnabled.chineseString) // "是"
 
 2. 逻辑运算：
    let a = true, b = false
    print(a.and(b))    // false
    print(a.or(b))     // true
    print(a.xor(b))    // true
    print(a.not)       // false
 
 3. 条件操作：
    let condition = true
    let result = condition.choose(trueValue: "成功", falseValue: "失败") // "成功"
    let value = condition.then(42) // Optional(42)
    condition.whenTrue { print("条件为真") } // 会执行打印
 
 4. 字符串解析：
    let bool1 = Bool.from("yes")   // true
    let bool2 = Bool.from("0")     // false
    let bool3 = Bool.safeFrom("maybe") // nil
 
 5. 随机生成：
    let randomBool = Bool.random()
    let weightedBool = Bool.random(probability: 0.7) // 70%概率为true
 */