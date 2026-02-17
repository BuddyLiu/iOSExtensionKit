// Set+Extension.swift
// Foundation Set扩展，提供便捷的操作和方法

import Foundation

public extension Set {
    
    // MARK: - 集合操作
    
    /// 安全的交集操作（返回新集合）
    func intersection(safe other: Set<Element>) -> Set<Element> {
        return self.intersection(other)
    }
    
    /// 安全的并集操作（返回新集合）
    func union(safe other: Set<Element>) -> Set<Element> {
        return self.union(other)
    }
    
    /// 安全的差集操作（返回新集合）
    func subtracting(safe other: Set<Element>) -> Set<Element> {
        return self.subtracting(other)
    }
    
    /// 安全的对称差集操作（返回新集合）
    func symmetricDifference(safe other: Set<Element>) -> Set<Element> {
        return self.symmetricDifference(other)
    }
    
    /// 检查是否包含所有指定元素
    func contains(all elements: [Element]) -> Bool {
        return elements.allSatisfy { self.contains($0) }
    }
    
    /// 检查是否包含任意指定元素
    func contains(any elements: [Element]) -> Bool {
        return elements.contains { self.contains($0) }
    }
    
    /// 过滤后返回新集合
    func filterSet(_ isIncluded: (Element) throws -> Bool) rethrows -> Set<Element> {
        return try Set(self.filter(isIncluded))
    }
    
    /// 映射后返回新集合（自动去重）
    func mapSet<T>(_ transform: (Element) throws -> T) rethrows -> Set<T> where T: Hashable {
        var result = Set<T>()
        for element in self {
            result.insert(try transform(element))
        }
        return result
    }
    
    /// 扁平映射后返回新集合（自动去重）
    func flatMapSet<T>(_ transform: (Element) throws -> Set<T>) rethrows -> Set<T> where T: Hashable {
        var result = Set<T>()
        for element in self {
            let transformed = try transform(element)
            result.formUnion(transformed)
        }
        return result
    }
    
    /// 压缩映射后返回新集合（自动去重）
    func compactMapSet<T>(_ transform: (Element) throws -> T?) rethrows -> Set<T> where T: Hashable {
        var result = Set<T>()
        for element in self {
            if let transformed = try transform(element) {
                result.insert(transformed)
            }
        }
        return result
    }
    
    // MARK: - 元素操作
    
    /// 安全地插入元素（如果存在则忽略）
    @discardableResult
    mutating func insertIfNotExists(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        return self.insert(element)
    }
    
    /// 批量插入元素
    mutating func insert(_ elements: [Element]) {
        for element in elements {
            self.insert(element)
        }
    }
    
    /// 批量插入元素（从另一个集合）
    mutating func insert(_ elements: Set<Element>) {
        self.formUnion(elements)
    }
    
    /// 安全地移除元素（如果存在）
    @discardableResult
    mutating func removeIfExists(_ element: Element) -> Element? {
        return self.remove(element)
    }
    
    /// 批量移除元素
    mutating func remove(_ elements: [Element]) {
        for element in elements {
            self.remove(element)
        }
    }
    
    /// 批量移除元素（从另一个集合）
    mutating func remove(_ elements: Set<Element>) {
        self.subtract(elements)
    }
    
    /// 获取第一个元素（可选）
    var firstElement: Element? {
        return self.first
    }
    
    /// 随机获取一个元素（可选）
    var randomElement: Element? {
        return self.randomElement()
    }
    
    /// 随机获取多个元素
    func randomElements(_ count: Int) -> [Element] {
        guard count > 0 else { return [] }
        let actualCount = Swift.min(count, self.count)
        var result: [Element] = []
        var remaining = Array(self)
        
        for _ in 0..<actualCount {
            if let index = remaining.indices.randomElement() {
                result.append(remaining.remove(at: index))
            }
        }
        
        return result
    }
    
    // MARK: - 集合关系
    
    /// 检查是否与另一个集合不相交
    func disjoint(with other: Set<Element>) -> Bool {
        return self.isDisjoint(with: other)
    }
    
    /// 检查是否为另一个集合的子集
    func subset(of other: Set<Element>) -> Bool {
        return self.isSubset(of: other)
    }
    
    /// 检查是否为另一个集合的真子集
    func strictSubset(of other: Set<Element>) -> Bool {
        return self.isSubset(of: other) && self.count < other.count
    }
    
    /// 检查是否为另一个集合的超集
    func superset(of other: Set<Element>) -> Bool {
        return self.isSuperset(of: other)
    }
    
    /// 检查是否为另一个集合的真超集
    func strictSuperset(of other: Set<Element>) -> Bool {
        return self.isSuperset(of: other) && self.count > other.count
    }
    
    /// 检查两个集合是否相等
    func isEqual(to other: Set<Element>) -> Bool {
        return self == other
    }
    
    // MARK: - 转换方法
    
    /// 转换为数组
    var toArray: [Element] {
        return Array(self)
    }
    
    /// 转换为排序后的数组
    func toSortedArray(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element] {
        return try Array(self).sorted(by: areInIncreasingOrder)
    }
    
    /// 转换为排序后的数组（当元素可比较时）
    func toSortedArray() -> [Element] where Element: Comparable {
        return Array(self).sorted()
    }
    
    /// 转换为字典（使用指定的键值转换器）
    func toDictionary<Key, Value>(
        keyTransform: (Element) throws -> Key,
        valueTransform: (Element) throws -> Value
    ) rethrows -> [Key: Value] where Key: Hashable {
        var dictionary: [Key: Value] = [:]
        for element in self {
            let key = try keyTransform(element)
            let value = try valueTransform(element)
            dictionary[key] = value
        }
        return dictionary
    }
    
    /// 分组（按指定的键转换器）
    func grouped<Key>(by keyForValue: (Element) throws -> Key) rethrows -> [Key: [Element]] where Key: Hashable {
        var groups: [Key: [Element]] = [:]
        for element in self {
            let key = try keyForValue(element)
            groups[key, default: []].append(element)
        }
        return groups
    }
    
    // MARK: - 实用方法
    
    /// 清空集合
    mutating func removeAllElements() {
        self.removeAll()
    }
    
    /// 保持与另一个集合的交集
    mutating func keepIntersection(with other: Set<Element>) {
        self.formIntersection(other)
    }
    
    /// 保持与另一个集合的并集
    mutating func keepUnion(with other: Set<Element>) {
        self.formUnion(other)
    }
    
    /// 保持与另一个集合的差集
    mutating func keepSubtracting(_ other: Set<Element>) {
        self.subtract(other)
    }
    
    /// 保持与另一个集合的对称差集
    mutating func keepSymmetricDifference(with other: Set<Element>) {
        self.formSymmetricDifference(other)
    }
    
    /// 更新集合（保留满足条件的元素）
    mutating func keep(where condition: (Element) throws -> Bool) rethrows {
        let elementsToRemove = try self.filter { try !condition($0) }
        self.subtract(elementsToRemove)
    }
    
    /// 分区集合（根据条件分为两个集合）
    func partitioned(by condition: (Element) throws -> Bool) rethrows -> (matching: Set<Element>, notMatching: Set<Element>) {
        var matching = Set<Element>()
        var notMatching = Set<Element>()
        
        for element in self {
            if try condition(element) {
                matching.insert(element)
            } else {
                notMatching.insert(element)
            }
        }
        
        return (matching, notMatching)
    }
    
    /// 检查所有元素是否满足条件
    func allSatisfyCondition(_ condition: (Element) throws -> Bool) rethrows -> Bool {
        return try self.allSatisfy(condition)
    }
    
    /// 检查是否有任意元素满足条件
    func anySatisfyCondition(_ condition: (Element) throws -> Bool) rethrows -> Bool {
        return try self.contains { try condition($0) }
    }
    
    /// 检查是否没有元素满足条件
    func noneSatisfyCondition(_ condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !self.contains { try condition($0) }
    }
    
    // MARK: - 统计方法
    
    /// 计算满足条件的元素数量
    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(condition).count
    }
    
    /// 获取满足条件的元素数量占比
    func proportion(where condition: (Element) throws -> Bool) rethrows -> Double {
        guard !self.isEmpty else { return 0 }
        let matchingCount = try self.count(where: condition)
        return Double(matchingCount) / Double(self.count)
    }
    
    /// 获取满足条件的元素占比（百分比）
    func percentage(where condition: (Element) throws -> Bool) rethrows -> Double {
        return try proportion(where: condition) * 100
    }
    
    // MARK: - 功能方法
    
    /// 遍历并执行操作
    func forEachElement(_ body: (Element) throws -> Void) rethrows {
        try self.forEach(body)
    }
    
    /// 带索引的遍历
    func forEachIndexed(_ body: (Int, Element) throws -> Void) rethrows {
        var index = 0
        for element in self {
            try body(index, element)
            index += 1
        }
    }
    
    /// 带中断的遍历
    func forEachWhile(_ body: (Element) throws -> Bool) rethrows {
        for element in self {
            if try !body(element) {
                break
            }
        }
    }
    
    /// 累加操作
    func reduceElements<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
        return try self.reduce(initialResult, nextPartialResult)
    }
    
    /// 累加操作（使用第一个元素作为初始值）
    func reduceElements(_ nextPartialResult: (Element, Element) throws -> Element) rethrows -> Element? {
        guard let first = self.first else { return nil }
        return try self.dropFirst().reduce(first, nextPartialResult)
    }
}

// MARK: - 可比较元素扩展

public extension Set where Element: Comparable {
    
    /// 获取最小元素
    var minElement: Element? {
        return self.min()
    }
    
    /// 获取最大元素
    var maxElement: Element? {
        return self.max()
    }
    
    /// 获取最小和最大元素
    var minAndMax: (min: Element, max: Element)? {
        guard let min = self.min(), let max = self.max() else { return nil }
        return (min, max)
    }
    
    /// 检查是否所有元素都在指定范围内
    func allElements(in range: ClosedRange<Element>) -> Bool {
        return self.allSatisfy { range.contains($0) }
    }
    
    /// 检查是否所有元素都在指定范围内
    func allElements(in range: Range<Element>) -> Bool {
        return self.allSatisfy { range.contains($0) }
    }
}

// MARK: - 数值元素扩展

public extension Set where Element: Numeric {
    
    /// 计算所有元素的和
    var sum: Element {
        return self.reduce(0, +)
    }
    
    /// 计算所有元素的乘积
    var product: Element {
        guard !self.isEmpty else { return 1 }
        return self.reduce(1, *)
    }
    
    /// 计算平均值（当元素可转换为浮点数时）
    func average<T: FloatingPoint>() -> T? where Element: BinaryInteger {
        guard !self.isEmpty else { return nil }
        let total: T = self.reduce(T(0)) { $0 + T($1) }
        return total / T(self.count)
    }
    
    /// 计算平均值（当元素已经是浮点数时）
    func average() -> Element? where Element: FloatingPoint {
        guard !self.isEmpty else { return nil }
        return self.sum / Element(self.count)
    }
}

// MARK: - 哈希元素扩展

public extension Set where Element: Hashable {
    
    /// 创建包含单个元素的集合
    static func single(_ element: Element) -> Set<Element> {
        return [element]
    }
    
    /// 创建包含多个元素的集合
    static func of(_ elements: Element...) -> Set<Element> {
        return Set(elements)
    }
    
    /// 创建包含多个元素的集合
    static func of(_ elements: [Element]) -> Set<Element> {
        return Set(elements)
    }
}

// MARK: - 便捷初始化方法

public extension Set {
    
    /// 从可选的元素创建集合（忽略nil值）
    init?(optionalElements: [Element?]) {
        let compacted = optionalElements.compactMap { $0 }
        guard !compacted.isEmpty else { return nil }
        self = Set(compacted)
    }
    
    /// 从序列创建集合（带转换器）
    init<S: Sequence>(_ sequence: S, transform: (S.Element) throws -> Element) rethrows {
        self = try Set(sequence.map(transform))
    }
    
    /// 从序列创建集合（带可选转换器，忽略nil值）
    init<S: Sequence>(_ sequence: S, compactTransform: (S.Element) throws -> Element?) rethrows {
        self = try Set(sequence.compactMap(compactTransform))
    }
}