// Optional+Extension.swift
// Optional扩展，提供便捷和安全的可选值操作方法

import Foundation

public extension Optional {
    
    // MARK: - 属性和检查
    
    /// 检查可选值是否为nil
    var isNil: Bool {
        return self == nil
    }
    
    /// 检查可选值是否为非nil
    var isNotNil: Bool {
        return self != nil
    }
    
    /// 检查可选值是否满足条件
    /// - Parameter predicate: 条件闭包
    /// - Returns: 如果值为nil则返回false，否则返回条件结果
    func satisfies(_ predicate: (Wrapped) -> Bool) -> Bool {
        guard let value = self else { return false }
        return predicate(value)
    }
    
    /// 检查可选值是否不满足条件
    /// - Parameter predicate: 条件闭包
    /// - Returns: 如果值为nil则返回true，否则返回条件取反结果
    func doesNotSatisfy(_ predicate: (Wrapped) -> Bool) -> Bool {
        guard let value = self else { return true }
        return !predicate(value)
    }
    
    // MARK: - 安全解包
    
    /// 安全解包，如果为nil则返回默认值
    /// - Parameter defaultValue: 默认值
    /// - Returns: 解包后的值或默认值
    func or(_ defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? defaultValue()
    }
    
    /// 安全解包，如果为nil则返回另一个可选值
    /// - Parameter other: 另一个可选值
    /// - Returns: 当前值或另一个可选值
    func or(_ other: Optional<Wrapped>) -> Optional<Wrapped> {
        return self ?? other
    }
    
    /// 安全解包，如果为nil则执行闭包并返回其结果
    /// - Parameter closure: 闭包
    /// - Returns: 解包后的值或闭包结果
    func orElse(_ closure: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? closure()
    }
    
    /// 安全解包，如果为nil则抛出错误
    /// - Parameter error: 要抛出的错误
    /// - Returns: 解包后的值
    /// - Throws: 如果值为nil则抛出指定错误
    func orThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw error()
        }
        return value
    }
    
    /// 安全解包，如果为nil则抛出默认错误
    /// - Parameter message: 错误信息
    /// - Returns: 解包后的值
    /// - Throws: OptionalError.valueIsNil
    func unwrapOrThrow(message: String = "值不能为nil") throws -> Wrapped {
        guard let value = self else {
            throw OptionalError.valueIsNil(message)
        }
        return value
    }
    
    /// 安全解包，如果为nil则返回nil结果
    /// - Parameter transform: 转换闭包
    /// - Returns: 转换后的可选值
    func flatMap<T>(_ transform: (Wrapped) -> T?) -> T? {
        return self.flatMap(transform)
    }
    
    // MARK: - 转换和映射
    
    /// 映射可选值，如果为nil则返回默认值
    /// - Parameters:
    ///   - transform: 转换闭包
    ///   - defaultValue: 默认值
    /// - Returns: 转换后的值或默认值
    func mapOrDefault<T>(_ transform: (Wrapped) -> T, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self else { return defaultValue() }
        return transform(value)
    }
    
    /// 映射可选值，如果为nil则返回nil
    /// - Parameter transform: 转换闭包
    /// - Returns: 转换后的可选值
    func map<T>(_ transform: (Wrapped) -> T) -> T? {
        return self.map(transform)
    }
    
    /// 尝试映射可选值，如果转换失败则返回nil
    /// - Parameter transform: 可能抛出错误的转换闭包
    /// - Returns: 转换后的可选值
    func tryMap<T>(_ transform: (Wrapped) throws -> T) -> T? {
        guard let value = self else { return nil }
        return try? transform(value)
    }
    
    /// 尝试映射可选值，如果转换失败则返回默认值
    /// - Parameters:
    ///   - transform: 可能抛出错误的转换闭包
    ///   - defaultValue: 默认值
    /// - Returns: 转换后的值或默认值
    func tryMapOrDefault<T>(_ transform: (Wrapped) throws -> T, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self else { return defaultValue() }
        return (try? transform(value)) ?? defaultValue()
    }
    
    /// 将可选值转换为数组
    /// - Returns: 如果值为nil则返回空数组，否则返回包含该值的数组
    func toArray() -> [Wrapped] {
        guard let value = self else { return [] }
        return [value]
    }
    
    /// 将可选值转换为Result
    /// - Parameter error: 错误（当值为nil时）
    /// - Returns: 成功包含值或失败包含错误
    func toResult<E: Error>(error: @autoclosure () -> E) -> Result<Wrapped, E> {
        guard let value = self else {
            return .failure(error())
        }
        return .success(value)
    }
    
    /// 将可选值转换为Result，使用默认错误
    /// - Parameter message: 错误信息
    /// - Returns: 成功包含值或失败包含OptionalError
    func toResult(message: String = "值不能为nil") -> Result<Wrapped, OptionalError> {
        guard let value = self else {
            return .failure(.valueIsNil(message))
        }
        return .success(value)
    }
    
    // MARK: - 过滤
    
    /// 过滤可选值
    /// - Parameter predicate: 条件闭包
    /// - Returns: 如果值满足条件则返回该值，否则返回nil
    func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self, predicate(value) else { return nil }
        return value
    }
    
    /// 排除满足条件的值
    /// - Parameter predicate: 条件闭包
    /// - Returns: 如果值不满足条件则返回该值，否则返回nil
    func exclude(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self, !predicate(value) else { return nil }
        return value
    }
    
    /// 如果值为nil或满足条件则返回nil
    /// - Parameter predicate: 条件闭包
    /// - Returns: 可选值
    func drop(if predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self, !predicate(value) else { return nil }
        return value
    }
    
    // MARK: - 副作用操作
    
    /// 如果值不为nil则执行闭包
    /// - Parameter action: 要执行的闭包
    /// - Returns: 原始可选值（用于链式调用）
    @discardableResult
    func ifPresent(_ action: (Wrapped) -> Void) -> Optional<Wrapped> {
        if let value = self {
            action(value)
        }
        return self
    }
    
    /// 如果值为nil则执行闭包
    /// - Parameter action: 要执行的闭包
    /// - Returns: 原始可选值（用于链式调用）
    @discardableResult
    func ifAbsent(_ action: () -> Void) -> Optional<Wrapped> {
        if self == nil {
            action()
        }
        return self
    }
    
    /// 根据值是否存在执行不同的闭包
    /// - Parameters:
    ///   - ifPresent: 值存在时执行的闭包
    ///   - ifAbsent: 值为nil时执行的闭包
    func match(ifPresent: (Wrapped) -> Void, ifAbsent: () -> Void) {
        if let value = self {
            ifPresent(value)
        } else {
            ifAbsent()
        }
    }
    
    /// 根据值是否存在返回不同的结果
    /// - Parameters:
    ///   - ifPresent: 值存在时执行的闭包
    ///   - ifAbsent: 值为nil时执行的闭包
    /// - Returns: 闭包的执行结果
    func match<T>(ifPresent: (Wrapped) -> T, ifAbsent: () -> T) -> T {
        if let value = self {
            return ifPresent(value)
        } else {
            return ifAbsent()
        }
    }
    
    // MARK: - 链式操作
    
    /// 链式映射，支持可选的转换结果
    /// - Parameter transform: 转换闭包
    /// - Returns: 转换后的可选值
    func andThen<T>(_ transform: (Wrapped) -> T?) -> T? {
        return self.flatMap(transform)
    }
    
    /// 链式操作，如果值存在则应用转换
    /// - Parameter transform: 转换闭包
    /// - Returns: 转换后的可选值
    func then<T>(_ transform: (Wrapped) -> T) -> T? {
        return self.map(transform)
    }
    
    /// 链式操作，如果值存在则应用可能失败的转换
    /// - Parameter transform: 可能抛出错误的转换闭包
    /// - Returns: 转换后的可选值
    func tryThen<T>(_ transform: (Wrapped) throws -> T) -> T? {
        guard let value = self else { return nil }
        return try? transform(value)
    }
    
    /// 合并两个可选值
    /// - Parameter other: 另一个可选值
    /// - Returns: 如果两个值都存在则返回元组，否则返回nil
    func zip<T>(with other: T?) -> (Wrapped, T)? {
        guard let value = self, let otherValue = other else { return nil }
        return (value, otherValue)
    }
    
    /// 合并三个可选值
    /// - Parameters:
    ///   - second: 第二个可选值
    ///   - third: 第三个可选值
    /// - Returns: 如果三个值都存在则返回元组，否则返回nil
    func zip<T, U>(with second: T?, and third: U?) -> (Wrapped, T, U)? {
        guard let value = self, let secondValue = second, let thirdValue = third else { return nil }
        return (value, secondValue, thirdValue)
    }
    
    // MARK: - 实用方法
    
    /// 将可选值作为可选项返回（主要用于API兼容性）
    var asOptional: Optional<Wrapped> {
        return self
    }
    
    /// 将可选值转换为字符串描述
    /// - Parameter defaultValue: 默认描述
    /// - Returns: 值的描述或默认描述
    func description(defaultValue: String = "nil") -> String {
        guard let value = self else { return defaultValue }
        return String(describing: value)
    }
    
    /// 将可选值转换为调试描述
    /// - Parameter defaultValue: 默认描述
    /// - Returns: 值的调试描述或默认描述
    func debugDescription(defaultValue: String = "nil") -> String {
        guard let value = self else { return defaultValue }
        return String(reflecting: value)
    }
    
    /// 比较两个可选值是否相等
    /// - Parameter other: 另一个可选值
    /// - Returns: 是否相等
    func isEqual(to other: Optional<Wrapped>) -> Bool where Wrapped: Equatable {
        switch (self, other) {
        case (.none, .none):
            return true
        case (.some(let left), .some(let right)):
            return left == right
        default:
            return false
        }
    }
    
    /// 比较两个可选值是否相等（使用自定义比较器）
    /// - Parameters:
    ///   - other: 另一个可选值
    ///   - comparator: 比较闭包
    /// - Returns: 是否相等
    func isEqual(to other: Optional<Wrapped>, comparator: (Wrapped, Wrapped) -> Bool) -> Bool {
        switch (self, other) {
        case (.none, .none):
            return true
        case (.some(let left), .some(let right)):
            return comparator(left, right)
        default:
            return false
        }
    }
}

// MARK: - 可选错误

public enum OptionalError: Error, LocalizedError {
    case valueIsNil(String)
    
    public var errorDescription: String? {
        switch self {
        case .valueIsNil(let message):
            return message
        }
    }
}

// MARK: - 可选值集合扩展

public extension Collection where Element: OptionalValueType {
    
    /// 过滤掉nil值
    var compactedValues: [Element.WrappedValue] {
        return compactMap { $0.optionalValue }
    }
    
    /// 检查是否包含nil值
    var containsNil: Bool {
        return contains { $0.optionalValue == nil }
    }
    
    /// 检查是否只包含nil值
    var containsOnlyNil: Bool {
        return allSatisfy { $0.optionalValue == nil }
    }
    
    /// 获取第一个非nil值
    var firstNonNil: Element.WrappedValue? {
        return first(where: { $0.optionalValue != nil })?.optionalValue
    }
    
    /// 获取最后一个非nil值
    var lastNonNil: Element.WrappedValue? {
        return reversed().first(where: { $0.optionalValue != nil })?.optionalValue
    }
    
    /// 统计非nil值的数量
    var nonNilCount: Int {
        return count { $0.optionalValue != nil }
    }
    
    /// 统计nil值的数量
    var nilCount: Int {
        return count { $0.optionalValue == nil }
    }
    
    /// 统计满足条件的元素数量
    /// - Parameter predicate: 条件闭包
    /// - Returns: 满足条件的元素数量
    func count(where predicate: (Element.WrappedValue) -> Bool) -> Int {
        var count = 0
        for element in self {
            if let value = element.optionalValue, predicate(value) {
                count += 1
            }
        }
        return count
    }
    
    /// 统计满足条件的元素数量（辅助方法）
    private func count(where condition: (Element) -> Bool) -> Int {
        var result = 0
        for element in self {
            if condition(element) {
                result += 1
            }
        }
        return result
    }
}

// MARK: - 可选值类型协议

public protocol OptionalValueType {
    associatedtype WrappedValue
    var optionalValue: WrappedValue? { get }
}

extension Optional: OptionalValueType {
    public typealias WrappedValue = Wrapped
    public var optionalValue: Wrapped? {
        return self
    }
}

// MARK: - 全局函数

/// 创建可选值（语法糖）
public func some<T>(_ value: T) -> T? {
    return value
}

/// 创建nil值（语法糖）
public func none<T>() -> T? {
    return nil
}

/// 安全解包多个可选值
public func unwrap<T1, T2>(
    _ value1: T1?,
    _ value2: T2?,
    orThrow error: @autoclosure () -> Error = OptionalError.valueIsNil("一个或多个必需值为nil")
) throws -> (T1, T2) {
    guard let v1 = value1, let v2 = value2 else {
        throw error()
    }
    return (v1, v2)
}

/// 安全解包多个可选值
public func unwrap<T1, T2, T3>(
    _ value1: T1?,
    _ value2: T2?,
    _ value3: T3?,
    orThrow error: @autoclosure () -> Error = OptionalError.valueIsNil("一个或多个必需值为nil")
) throws -> (T1, T2, T3) {
    guard let v1 = value1, let v2 = value2, let v3 = value3 else {
        throw error()
    }
    return (v1, v2, v3)
}

/// 安全解包多个可选值
public func unwrap<T1, T2, T3, T4>(
    _ value1: T1?,
    _ value2: T2?,
    _ value3: T3?,
    _ value4: T4?,
    orThrow error: @autoclosure () -> Error = OptionalError.valueIsNil("一个或多个必需值为nil")
) throws -> (T1, T2, T3, T4) {
    guard let v1 = value1, let v2 = value2, let v3 = value3, let v4 = value4 else {
        throw error()
    }
    return (v1, v2, v3, v4)
}

/// 链式解包多个可选值
public func chain<T, U>(
    _ value: T?,
    _ transform: (T) -> U?
) -> U? {
    return value.flatMap(transform)
}

/// 链式解包多个可选值
public func chain<T, U, V>(
    _ value: T?,
    _ transform1: (T) -> U?,
    _ transform2: (U) -> V?
) -> V? {
    return value.flatMap(transform1).flatMap(transform2)
}

// MARK: - 自定义运算符

/// 可选值合并运算符（?? 的替代，更简洁）
infix operator ??? : NilCoalescingPrecedence

public func ??? <T>(lhs: T?, rhs: @autoclosure () -> T) -> T {
    return lhs ?? rhs()
}

/// 可选值映射运算符
infix operator <^> : ApplicativePrecedence

public func <^> <T, U>(transform: (T) -> U, value: T?) -> U? {
    return value.map(transform)
}

/// 可选值链式映射运算符
infix operator >>- : MonadPrecedence

public func >>- <T, U>(value: T?, transform: (T) -> U?) -> U? {
    return value.flatMap(transform)
}

/// 可选值应用运算符
infix operator <*> : ApplicativePrecedence

public func <*> <T, U>(transform: ((T) -> U)?, value: T?) -> U? {
    return transform.flatMap { f in value.map { f($0) } }
}

// MARK: - 优先级组定义

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

precedencegroup MonadPrecedence {
    associativity: left
    higherThan: ApplicativePrecedence
}