// Dictionary+Extension.swift
// 字典扩展，提供便捷和安全的方法

import Foundation

public extension Dictionary {
    
    // MARK: - 安全访问
    
    /// 安全获取指定键的值，如果键不存在则返回 nil
    /// - Parameter key: 键
    /// - Returns: 值或 nil
    func safeValue(forKey key: Key) -> Value? {
        return self[key]
    }
    
    /// 安全获取指定键的值，如果键不存在则返回默认值
    /// - Parameters:
    ///   - key: 键
    ///   - defaultValue: 默认值
    /// - Returns: 值或默认值
    func value(forKey key: Key, defaultValue: Value) -> Value {
        return self[key] ?? defaultValue
    }
    
    /// 安全获取指定键的值并转换为指定类型
    /// - Parameters:
    ///   - key: 键
    ///   - type: 目标类型
    /// - Returns: 转换后的值或 nil
    func value<T>(forKey key: Key, as type: T.Type) -> T? {
        guard let value = self[key] as? T else { return nil }
        return value
    }
    
    // MARK: - 便捷方法
    
    /// 检查字典是否为空
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// 检查字典是否包含指定键
    /// - Parameter key: 键
    /// - Returns: 是否包含
    func contains(key: Key) -> Bool {
        return self[key] != nil
    }
    
    /// 获取字典的所有键
    var allKeys: [Key] {
        return Array(keys)
    }
    
    /// 获取字典的所有值
    var allValues: [Value] {
        return Array(values)
    }
    
    /// 获取字典中满足条件的第一个键值对
    /// - Parameter predicate: 条件闭包
    /// - Returns: 键值对，如果没有找到则返回 nil
    func first(where predicate: (Key, Value) -> Bool) -> (key: Key, value: Value)? {
        for (key, value) in self {
            if predicate(key, value) {
                return (key, value)
            }
        }
        return nil
    }
    
    /// 获取字典中满足条件的最后一个键值对
    /// - Parameter predicate: 条件闭包
    /// - Returns: 键值对，如果没有找到则返回 nil
    func last(where predicate: (Key, Value) -> Bool) -> (key: Key, value: Value)? {
        var lastMatch: (Key, Value)?
        for (key, value) in self {
            if predicate(key, value) {
                lastMatch = (key, value)
            }
        }
        return lastMatch
    }
    
    // MARK: - 修改方法
    
    /// 安全设置值，如果值为 nil 则移除键
    /// - Parameters:
    ///   - value: 值（可选）
    ///   - key: 键
    mutating func safeSet(_ value: Value?, forKey key: Key) {
        if let value = value {
            self[key] = value
        } else {
            removeValue(forKey: key)
        }
    }
    
    /// 安全合并另一个字典
    /// - Parameters:
    ///   - other: 另一个字典
    ///   - combine: 合并策略闭包
    mutating func safeMerge(_ other: [Key: Value], uniquingKeysWith combine: (Value, Value) -> Value) {
        merge(other, uniquingKeysWith: combine)
    }
    
    /// 安全合并另一个字典（使用默认合并策略：新值覆盖旧值）
    /// - Parameter other: 另一个字典
    mutating func safeMerge(_ other: [Key: Value]) {
        merge(other) { _, new in new }
    }
    
    /// 安全移除多个键
    /// - Parameter keys: 要移除的键数组
    mutating func safeRemove(keys: [Key]) {
        for key in keys {
            removeValue(forKey: key)
        }
    }
    
    /// 安全移除满足条件的所有键值对
    /// - Parameter predicate: 条件闭包
    /// - Returns: 被移除的键值对数量
    @discardableResult
    mutating func safeRemoveAll(where predicate: (Key, Value) -> Bool) -> Int {
        let originalCount = count
        for (key, value) in self {
            if predicate(key, value) {
                removeValue(forKey: key)
            }
        }
        return originalCount - count
    }
    
    /// 过滤字典并返回新字典
    /// - Parameter predicate: 条件闭包
    /// - Returns: 过滤后的字典
    func safeFilter(_ predicate: (Key, Value) -> Bool) -> [Key: Value] {
        return filter(predicate)
    }
    
    /// 原地过滤字典
    /// - Parameter predicate: 条件闭包
    mutating func safeFilterInPlace(_ predicate: (Key, Value) -> Bool) {
        self = filter(predicate)
    }
    
    // MARK: - 映射操作
    
    /// 映射字典的键
    /// - Parameter transform: 转换闭包
    /// - Returns: 新字典
    func mapKeys<T: Hashable>(_ transform: (Key) -> T) -> [T: Value] {
        var result: [T: Value] = [:]
        for (key, value) in self {
            result[transform(key)] = value
        }
        return result
    }
    
    /// 映射字典的值
    /// - Parameter transform: 转换闭包
    /// - Returns: 新字典
    func mapValues<T>(_ transform: (Value) -> T) -> [Key: T] {
        // 避免递归调用，使用标准库的mapValues
        var result: [Key: T] = [:]
        for (key, value) in self {
            result[key] = transform(value)
        }
        return result
    }
    
    /// 映射字典的键和值
    /// - Parameter transform: 转换闭包
    /// - Returns: 新字典
    func mapKeysAndValues<T: Hashable, U>(_ transform: (Key, Value) -> (T, U)) -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (newKey, newValue) = transform(key, value)
            result[newKey] = newValue
        }
        return result
    }
    
    /// 紧凑映射字典的值
    /// - Parameter transform: 转换闭包
    /// - Returns: 新字典
    func compactMapValues<T>(_ transform: (Value) -> T?) -> [Key: T] {
        // 避免递归调用，手动实现compactMapValues
        var result: [Key: T] = [:]
        for (key, value) in self {
            if let transformed = transform(value) {
                result[key] = transformed
            }
        }
        return result
    }
    
    // MARK: - 分组操作
    
    /// 将字典按值分组
    /// - Parameter keyForValue: 分组键提取闭包
    /// - Returns: 分组后的字典
    func grouped<T: Hashable>(by keyForValue: (Value) -> T) -> [T: [Key: Value]] {
        var groups: [T: [Key: Value]] = [:]
        for (key, value) in self {
            let groupKey = keyForValue(value)
            groups[groupKey, default: [:]][key] = value
        }
        return groups
    }
    
    /// 将字典按键分组
    /// - Parameter keyForKey: 分组键提取闭包
    /// - Returns: 分组后的字典
    func groupedByKey<T: Hashable>(_ keyForKey: (Key) -> T) -> [T: [Key: Value]] {
        var groups: [T: [Key: Value]] = [:]
        for (key, value) in self {
            let groupKey = keyForKey(key)
            groups[groupKey, default: [:]][key] = value
        }
        return groups
    }
    
    // MARK: - 排序操作
    
    /// 按键排序
    /// - Parameter areInIncreasingOrder: 排序条件
    /// - Returns: 排序后的键值对数组
    func sortedByKey(by areInIncreasingOrder: (Key, Key) -> Bool) -> [(key: Key, value: Value)] {
        return sorted { areInIncreasingOrder($0.key, $1.key) }
    }
    
    /// 按值排序
    /// - Parameter areInIncreasingOrder: 排序条件
    /// - Returns: 排序后的键值对数组
    func sortedByValue(by areInIncreasingOrder: (Value, Value) -> Bool) -> [(key: Key, value: Value)] {
        return sorted { areInIncreasingOrder($0.value, $1.value) }
    }
    
    /// 按键排序（升序）
    /// - Returns: 排序后的键值对数组
    func sortedByKey() -> [(key: Key, value: Value)] where Key: Comparable {
        return sorted { $0.key < $1.key }
    }
    
    /// 按值排序（升序）
    /// - Returns: 排序后的键值对数组
    func sortedByValue() -> [(key: Key, value: Value)] where Value: Comparable {
        return sorted { $0.value < $1.value }
    }
    
    // MARK: - 批量操作
    
    /// 批量设置值
    /// - Parameter dictionary: 键值对数组
    mutating func setValues(_ dictionary: [(Key, Value)]) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
    /// 批量设置值
    /// - Parameter dictionary: 键值对字典
    mutating func setValues(_ dictionary: [Key: Value]) {
        merge(dictionary) { _, new in new }
    }
    
    /// 批量获取值
    /// - Parameter keys: 键数组
    /// - Returns: 键值对字典
    func values(for keys: [Key]) -> [Key: Value] {
        var result: [Key: Value] = [:]
        for key in keys {
            if let value = self[key] {
                result[key] = value
            }
        }
        return result
    }
    
    /// 批量移除值
    /// - Parameter keys: 键数组
    mutating func removeValues(for keys: [Key]) {
        for key in keys {
            removeValue(forKey: key)
        }
    }
    
    // MARK: - 转换操作
    
    /// 将字典转换为数组
    /// - Returns: 键值对数组
    func toArray() -> [(key: Key, value: Value)] {
        return Array(self)
    }
    
    /// 将字典转换为集合（仅键）
    /// - Returns: 键的集合
    func toKeySet() -> Set<Key> where Key: Hashable {
        return Set(keys)
    }
    
    /// 将字典转换为集合（仅值）
    /// - Returns: 值的集合
    func toValueSet() -> Set<Value> where Value: Hashable {
        return Set(values)
    }
    
    /// 将字典转换为JSON字符串
    /// - Returns: JSON字符串，如果转换失败则返回 nil
    func toJSONString() -> String? where Key == String, Value: Encodable {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    /// 从JSON字符串创建字典
    /// - Parameter jsonString: JSON字符串
    /// - Returns: 字典，如果解析失败则返回 nil
    static func fromJSONString(_ jsonString: String) -> [String: Value]? where Key == String, Value: Decodable {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        do {
            return try JSONDecoder().decode([String: Value].self, from: jsonData)
        } catch {
            return nil
        }
    }
    
    // MARK: - 深度操作
    
    /// 深度合并另一个字典
    /// - Parameters:
    ///   - other: 另一个字典
    ///   - combine: 合并策略闭包
    /// - Returns: 合并后的字典
    func deepMerge(_ other: [Key: Value], uniquingKeysWith combine: (Value, Value) -> Value) -> [Key: Value] {
        var result = self
        for (key, otherValue) in other {
            if let existingValue = result[key] {
                // 如果两个值都是字典，递归合并
                if let existingDict = existingValue as? [Key: Value],
                   let otherDict = otherValue as? [Key: Value] {
                    result[key] = existingDict.deepMerge(otherDict, uniquingKeysWith: combine) as? Value
                } else {
                    result[key] = combine(existingValue, otherValue)
                }
            } else {
                result[key] = otherValue
            }
        }
        return result
    }
    
    /// 深度映射字典的值
    /// - Parameter transform: 转换闭包
    /// - Returns: 映射后的字典
    func deepMapValues<T>(_ transform: (Value) -> T) -> [Key: T] where Value: Any {
        var result: [Key: T] = [:]
        for (key, value) in self {
            // 如果是嵌套字典，递归处理
            if let dictValue = value as? [Key: Value] {
                result[key] = dictValue.deepMapValues(transform) as? T
            } else {
                result[key] = transform(value)
            }
        }
        return result
    }
}

// MARK: - 字符串键字典扩展

public extension Dictionary where Key == String {
    
    /// 获取字符串值
    /// - Parameter key: 键
    /// - Returns: 字符串值，如果类型不匹配则返回 nil
    func string(forKey key: String) -> String? {
        return self[key] as? String
    }
    
    /// 获取整数
    /// - Parameter key: 键
    /// - Returns: 整数值，如果类型不匹配则返回 nil
    func integer(forKey key: String) -> Int? {
        return self[key] as? Int
    }
    
    /// 获取浮点数
    /// - Parameter key: 键
    /// - Returns: 浮点数值，如果类型不匹配则返回 nil
    func double(forKey key: String) -> Double? {
        return self[key] as? Double
    }
    
    /// 获取布尔值
    /// - Parameter key: 键
    /// - Returns: 布尔值，如果类型不匹配则返回 nil
    func bool(forKey key: String) -> Bool? {
        return self[key] as? Bool
    }
    
    /// 获取数组
    /// - Parameter key: 键
    /// - Returns: 数组值，如果类型不匹配则返回 nil
    func array<T>(forKey key: String) -> [T]? {
        return self[key] as? [T]
    }
    
    /// 获取字典
    /// - Parameter key: 键
    /// - Returns: 字典值，如果类型不匹配则返回 nil
    func dictionary<T>(forKey key: String) -> [String: T]? {
        return self[key] as? [String: T]
    }
    
    /// 获取日期
    /// - Parameter key: 键
    /// - Returns: 日期值，如果类型不匹配则返回 nil
    func date(forKey key: String) -> Date? {
        if let timestamp = self[key] as? TimeInterval {
            return Date(timeIntervalSince1970: timestamp)
        } else if let dateString = self[key] as? String {
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: dateString)
        }
        return nil
    }
}

// MARK: - 可编码值字典扩展

public extension Dictionary where Key == String, Value: Codable {
    
    /// 将字典转换为JSON数据
    /// - Returns: JSON数据，如果转换失败则返回 nil
    func toJSONData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
    
    /// 将字典写入JSON文件
    /// - Parameter fileURL: 文件URL
    /// - Returns: 是否写入成功
    @discardableResult
    func write(to fileURL: URL) -> Bool {
        guard let jsonData = toJSONData() else { return false }
        do {
            try jsonData.write(to: fileURL)
            return true
        } catch {
            return false
        }
    }
    
    /// 从JSON文件读取字典
    /// - Parameter fileURL: 文件URL
    /// - Returns: 字典，如果读取失败则返回 nil
    static func read(from fileURL: URL) -> [String: Value]? {
        do {
            let jsonData = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([String: Value].self, from: jsonData)
        } catch {
            return nil
        }
    }
}

// MARK: - 可哈希值字典扩展

public extension Dictionary where Value: Hashable {
    
    /// 反转字典（值作为键，键作为值）
    /// - Returns: 反转后的字典
    func inverted() -> [Value: Key] where Key: Hashable {
        var invertedDict: [Value: Key] = [:]
        for (key, value) in self {
            invertedDict[value] = key
        }
        return invertedDict
    }
    
    /// 获取值的频率统计
    /// - Returns: 值频率字典
    func valueFrequency() -> [Value: Int] {
        var frequency: [Value: Int] = [:]
        for value in values {
            frequency[value, default: 0] += 1
        }
        return frequency
    }
}

// MARK: - 数值值字典扩展

public extension Dictionary where Value: Numeric {
    
    /// 计算所有值的总和
    /// - Returns: 总和
    func sum() -> Value {
        return values.reduce(0, +)
    }
    
    /// 计算所有值的平均值
    /// - Returns: 平均值
    func average() -> Double where Value: BinaryInteger {
        guard !isEmpty else { return 0 }
        return Double(sum()) / Double(count)
    }
    
    /// 计算所有值的平均值
    /// - Returns: 平均值
    func average() -> Double where Value: BinaryFloatingPoint {
        guard !isEmpty else { return 0 }
        return Double(sum()) / Double(count)
    }
    
    /// 获取最小值
    /// - Returns: 最小值
    func min() -> Value? where Value: Comparable {
        return values.min()
    }
    
    /// 获取最大值
    /// - Returns: 最大值
    func max() -> Value? where Value: Comparable {
        return values.max()
    }
}

// MARK: - 实用扩展

public extension Dictionary {
    
    /// 检查字典是否包含所有指定键
    /// - Parameter keys: 键数组
    /// - Returns: 是否包含所有键
    func containsAll(keys: [Key]) -> Bool {
        for key in keys {
            if self[key] == nil {
                return false
            }
        }
        return true
    }
    
    /// 检查字典是否包含任何指定键
    /// - Parameter keys: 键数组
    /// - Returns: 是否包含任何键
    func containsAny(keys: [Key]) -> Bool {
        for key in keys {
            if self[key] != nil {
                return true
            }
        }
        return false
    }
    
    /// 获取字典的子字典
    /// - Parameter keys: 键数组
    /// - Returns: 子字典
    func subdictionary(for keys: [Key]) -> [Key: Value] {
        var result: [Key: Value] = [:]
        for key in keys {
            if let value = self[key] {
                result[key] = value
            }
        }
        return result
    }
    
    /// 获取字典的补集（不包含指定键的部分）
    /// - Parameter keys: 要排除的键数组
    /// - Returns: 补集字典
    func complement(for keys: [Key]) -> [Key: Value] {
        var result = self
        for key in keys {
            result.removeValue(forKey: key)
        }
        return result
    }
    
    /// 随机获取一个键值对
    /// - Returns: 随机键值对，如果字典为空则返回 nil
    func randomElement() -> (key: Key, value: Value)? {
        // 避免递归调用，手动实现randomElement
        guard !isEmpty else { return nil }
        let randomIndex = Int.random(in: 0..<count)
        for (index, (key, value)) in enumerated() {
            if index == randomIndex {
                return (key, value)
            }
        }
        return nil
    }
    
    /// 随机获取一个键
    /// - Returns: 随机键，如果字典为空则返回 nil
    func randomKey() -> Key? {
        return keys.randomElement()
    }
    
    /// 随机获取一个值
    /// - Returns: 随机值，如果字典为空则返回 nil
    func randomValue() -> Value? {
        return values.randomElement()
    }
}