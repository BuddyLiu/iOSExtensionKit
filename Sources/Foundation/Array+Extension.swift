// Array+Extension.swift
// 数组扩展，提供便捷和安全的方法

import Foundation

public extension Array {
    
    // MARK: - 安全访问
    
    /// 安全获取指定索引的元素，如果索引越界则返回 nil
    /// - Parameter index: 索引
    /// - Returns: 元素或 nil
    func safeElement(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    /// 安全获取指定索引范围的子数组，如果范围越界则返回 nil
    /// - Parameter range: 索引范围
    /// - Returns: 子数组或 nil
    func safeSubarray(in range: Range<Int>) -> [Element]? {
        guard range.lowerBound >= 0,
              range.upperBound <= count,
              range.lowerBound <= range.upperBound else {
            return nil
        }
        return Array(self[range])
    }
    
    /// 安全获取子数组，从指定索引开始到数组末尾
    /// - Parameter startIndex: 起始索引
    /// - Returns: 子数组
    func safeSuffix(from startIndex: Int) -> [Element] {
        guard startIndex >= 0 && startIndex < count else { return [] }
        return Array(self[startIndex...])
    }
    
    /// 安全获取子数组，从开始到指定索引
    /// - Parameter endIndex: 结束索引（不包含）
    /// - Returns: 子数组
    func safePrefix(upTo endIndex: Int) -> [Element] {
        guard endIndex > 0 && endIndex <= count else { return [] }
        return Array(self[..<endIndex])
    }
    
    // MARK: - 便捷方法
    
    /// 检查数组是否为空
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// 检查数组是否包含至少一个满足条件的元素
    /// - Parameter predicate: 条件闭包
    /// - Returns: 是否包含满足条件的元素
    func contains(where predicate: (Element) -> Bool) -> Bool {
        // 避免递归调用，手动实现contains(where:)
        for element in self {
            if predicate(element) {
                return true
            }
        }
        return false
    }
    
    /// 获取满足条件的第一个元素，同时返回其索引
    /// - Parameter predicate: 条件闭包
    /// - Returns: (索引, 元素) 元组，如果没有找到则返回 nil
    func firstIndexed(where predicate: (Element) -> Bool) -> (index: Int, element: Element)? {
        for (index, element) in enumerated() {
            if predicate(element) {
                return (index, element)
            }
        }
        return nil
    }
    
    /// 获取满足条件的最后一个元素，同时返回其索引
    /// - Parameter predicate: 条件闭包
    /// - Returns: (索引, 元素) 元组，如果没有找到则返回 nil
    func lastIndexed(where predicate: (Element) -> Bool) -> (index: Int, element: Element)? {
        for (index, element) in enumerated().reversed() {
            if predicate(element) {
                return (index, element)
            }
        }
        return nil
    }
    
    /// 按指定条件分组
    /// - Parameter keyForValue: 分组键提取闭包
    /// - Returns: 分组后的字典
    func grouped<Key: Hashable>(by keyForValue: (Element) -> Key) -> [Key: [Element]] {
        var groups: [Key: [Element]] = [:]
        for element in self {
            let key = keyForValue(element)
            groups[key, default: []].append(element)
        }
        return groups
    }
    
    /// 按指定条件排序，同时返回排序后的索引
    /// - Parameter areInIncreasingOrder: 排序条件
    /// - Returns: 排序后的数组和对应的原始索引
    func sortedWithIndices(by areInIncreasingOrder: (Element, Element) -> Bool) -> (sortedArray: [Element], indices: [Int]) {
        let enumerated = self.enumerated().map { (index: $0.offset, element: $0.element) }
        let sorted = enumerated.sorted { areInIncreasingOrder($0.element, $1.element) }
        return (sorted.map { $0.element }, sorted.map { $0.index })
    }
    
    // MARK: - 修改方法
    
    /// 在安全索引位置插入元素，如果索引越界则追加到末尾
    /// - Parameters:
    ///   - element: 要插入的元素
    ///   - index: 插入位置
    mutating func safeInsert(_ element: Element, at index: Int) {
        if index >= 0 && index <= count {
            insert(element, at: index)
        } else {
            append(element)
        }
    }
    
    /// 移除指定索引的元素，如果索引越界则什么都不做
    /// - Parameter index: 要移除的索引
    /// - Returns: 被移除的元素，如果索引越界则返回 nil
    @discardableResult
    mutating func safeRemove(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return remove(at: index)
    }
    
    /// 移除满足条件的第一个元素
    /// - Parameter predicate: 条件闭包
    /// - Returns: 被移除的元素，如果没有找到则返回 nil
    @discardableResult
    mutating func removeFirst(where predicate: (Element) -> Bool) -> Element? {
        guard let index = firstIndex(where: predicate) else { return nil }
        return remove(at: index)
    }
    
    /// 移除满足条件的所有元素
    /// - Parameter predicate: 条件闭包
    /// - Returns: 被移除的元素数量
    @discardableResult
    mutating func removeAll(where predicate: (Element) -> Bool) -> Int {
        let originalCount = count
        // 避免递归调用，手动实现removeAll(where:)
        var indicesToRemove: [Int] = []
        for (index, element) in enumerated() {
            if predicate(element) {
                indicesToRemove.append(index)
            }
        }
        
        // 从后往前移除，避免索引变化问题
        for index in indicesToRemove.reversed() {
            remove(at: index)
        }
        
        return originalCount - count
    }
    
    /// 将元素移动到新的索引位置
    /// - Parameters:
    ///   - fromIndex: 原始索引
    ///   - toIndex: 目标索引
    mutating func moveElement(from fromIndex: Int, to toIndex: Int) {
        guard fromIndex >= 0 && fromIndex < count,
              toIndex >= 0 && toIndex < count,
              fromIndex != toIndex else { return }
        
        let element = remove(at: fromIndex)
        insert(element, at: toIndex)
    }
    
    /// 交换元素，支持安全索引检查
    /// - Parameters:
    ///   - index1: 第一个索引
    ///   - index2: 第二个索引
    mutating func safeSwapAt(_ index1: Int, _ index2: Int) {
        guard index1 >= 0 && index1 < count,
              index2 >= 0 && index2 < count,
              index1 != index2 else { return }
        
        swapAt(index1, index2)
    }
    
    /// 获取并移除第一个元素
    /// - Returns: 第一个元素，如果数组为空则返回 nil
    @discardableResult
    mutating func popFirst() -> Element? {
        guard !isEmpty else { return nil }
        return removeFirst()
    }
    
    // MARK: - 集合操作
    
    /// 数组去重（保持原有顺序）
    /// - Returns: 去重后的数组
    func uniqued() -> [Element] where Element: Hashable {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
    
    /// 数组去重（根据指定条件）
    /// - Parameter by: 去重条件闭包
    /// - Returns: 去重后的数组
    func uniqued<T: Hashable>(by keyForValue: (Element) -> T) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert(keyForValue($0)).inserted }
    }
    
    /// 获取数组的交集（保持原有顺序）
    /// - Parameter other: 另一个数组
    /// - Returns: 交集数组
    func intersection(_ other: [Element]) -> [Element] where Element: Hashable {
        let set = Set(other)
        return filter { set.contains($0) }
    }
    
    /// 获取数组的并集（保持原有顺序，不重复）
    /// - Parameter other: 另一个数组
    /// - Returns: 并集数组
    func union(_ other: [Element]) -> [Element] where Element: Hashable {
        return (self + other).uniqued()
    }
    
    /// 获取数组的差集（存在于当前数组但不存在于另一个数组中的元素）
    /// - Parameter other: 另一个数组
    /// - Returns: 差集数组
    func difference(_ other: [Element]) -> [Element] where Element: Hashable {
        let set = Set(other)
        return filter { !set.contains($0) }
    }
    
    // MARK: - 批量操作
    
    /// 批量更新元素
    /// - Parameter transform: 转换闭包
    mutating func updateEach(_ transform: (inout Element) -> Void) {
        for index in indices {
            transform(&self[index])
        }
    }
    
    /// 批量过滤元素（原地操作）
    /// - Parameter predicate: 条件闭包
    mutating func filterInPlace(_ predicate: (Element) -> Bool) {
        self = filter(predicate)
    }
    
    /// 批量映射元素（原地操作）
    /// - Parameter transform: 转换闭包
    mutating func mapInPlace(_ transform: (Element) -> Element) {
        self = map(transform)
    }
    
    /// 将数组分割成指定大小的块
    /// - Parameter chunkSize: 每块的大小
    /// - Returns: 分割后的数组块
    func chunked(into chunkSize: Int) -> [[Element]] {
        guard chunkSize > 0 else { return [] }
        
        return stride(from: 0, to: count, by: chunkSize).map { startIndex in
            let endIndex = Swift.min(startIndex + chunkSize, count)
            return Array(self[startIndex..<endIndex])
        }
    }
    
    /// 将数组分割成指定数量的块（尽可能均匀）
    /// - Parameter numberOfChunks: 块的数量
    /// - Returns: 分割后的数组块
    func split(into numberOfChunks: Int) -> [[Element]] {
        guard numberOfChunks > 0 else { return [] }
        
        let chunkSize = count / numberOfChunks
        let remainder = count % numberOfChunks
        
        var result: [[Element]] = []
        var startIndex = 0
        
        for i in 0..<numberOfChunks {
            let endIndex = startIndex + chunkSize + (i < remainder ? 1 : 0)
            result.append(Array(self[startIndex..<endIndex]))
            startIndex = endIndex
        }
        
        return result
    }
    
    // MARK: - 随机操作
    
    /// 随机获取一个元素
    /// - Returns: 随机元素，如果数组为空则返回 nil
    func randomElement() -> Element? {
        // 避免递归调用，手动实现randomElement
        guard !isEmpty else { return nil }
        let randomIndex = Int.random(in: 0..<count)
        return self[randomIndex]
    }
    
    /// 随机打乱数组（Fisher-Yates洗牌算法）
    /// - Returns: 打乱后的数组
    func shuffled() -> [Element] {
        var result = self
        result.shuffle()
        return result
    }
    
    /// 随机获取指定数量的元素（不重复）
    /// - Parameter count: 要获取的元素数量
    /// - Returns: 随机元素数组
    func randomElements(count: Int) -> [Element] where Element: Hashable {
        guard count > 0 else { return [] }
        let actualCount = Swift.min(count, self.count)
        return Array(Set(self).shuffled().prefix(actualCount))
    }
    
    /// 随机获取指定数量的元素（可能重复）
    /// - Parameter count: 要获取的元素数量
    /// - Returns: 随机元素数组
    func randomElementsWithReplacement(count: Int) -> [Element] {
        guard count > 0 && !isEmpty else { return [] }
        return (0..<count).map { _ in randomElement()! }
    }
    
    // MARK: - 性能优化方法
    
    /// 并行映射（适用于计算密集型的映射操作）
    /// - Parameter transform: 转换闭包
    /// - Returns: 映射后的数组
    func parallelMap<T>(_ transform: @escaping (Element) -> T) -> [T] {
        // 简化版本：使用串行映射，避免并发复杂性
        return map(transform)
    }
    
    /// 并行过滤（适用于计算密集型的过滤操作）
    /// - Parameter predicate: 条件闭包
    /// - Returns: 过滤后的数组
    func parallelFilter(_ predicate: @escaping (Element) -> Bool) -> [Element] {
        // 简化版本：使用串行过滤，避免并发复杂性
        return filter(predicate)
    }
    
    // MARK: - 统计方法
    
    /// 统计满足条件的元素数量
    /// - Parameter predicate: 条件闭包
    /// - Returns: 满足条件的元素数量
    func count(where predicate: (Element) -> Bool) -> Int {
        return reduce(0) { count, element in
            predicate(element) ? count + 1 : count
        }
    }
    
    /// 计算数值型数组的总和
    /// - Returns: 总和
    func sum() -> Element where Element: Numeric {
        return reduce(0, +)
    }
    
    /// 计算数值型数组的平均值
    /// - Returns: 平均值
    func average() -> Double where Element: BinaryInteger {
        guard !isEmpty else { return 0 }
        return Double(sum()) / Double(count)
    }
    
    /// 计算数值型数组的平均值
    /// - Returns: 平均值
    func average() -> Double where Element: BinaryFloatingPoint {
        guard !isEmpty else { return 0 }
        return Double(sum()) / Double(count)
    }
    
    /// 获取数值型数组的最小值
    /// - Returns: 最小值
    func minValue() -> Element? where Element: Comparable {
        guard !isEmpty else { return nil }
        var currentMin = self[0]
        for element in self.dropFirst() {
            if element < currentMin {
                currentMin = element
            }
        }
        return currentMin
    }
    
    /// 获取数值型数组的最大值
    /// - Returns: 最大值
    func maxValue() -> Element? where Element: Comparable {
        guard !isEmpty else { return nil }
        var currentMax = self[0]
        for element in self.dropFirst() {
            if element > currentMax {
                currentMax = element
            }
        }
        return currentMax
    }
    
    // MARK: - 便捷转换
    
    /// 将数组转换为字典，使用指定闭包生成键
    /// - Parameter keyForValue: 键生成闭包
    /// - Returns: 字典
    func toDictionary<Key: Hashable>(keyedBy keyForValue: (Element) -> Key) -> [Key: Element] {
        var dictionary: [Key: Element] = [:]
        for element in self {
            dictionary[keyForValue(element)] = element
        }
        return dictionary
    }
    
    /// 将数组转换为字典，使用指定闭包生成键和值
    /// - Parameters:
    ///   - keyForValue: 键生成闭包
    ///   - valueForValue: 值生成闭包
    /// - Returns: 字典
    func toDictionary<Key: Hashable, Value>(
        keyedBy keyForValue: (Element) -> Key,
        valuedBy valueForValue: (Element) -> Value
    ) -> [Key: Value] {
        var dictionary: [Key: Value] = [:]
        for element in self {
            dictionary[keyForValue(element)] = valueForValue(element)
        }
        return dictionary
    }
    
    /// 将数组转换为集合
    /// - Returns: 集合
    func toSet() -> Set<Element> where Element: Hashable {
        return Set(self)
    }
}

// MARK: - 可选元素数组扩展

public extension Array where Element: OptionalType {
    
    /// 过滤掉 nil 值
    /// - Returns: 非 nil 值的数组
    func compacted() -> [Element.Wrapped] {
        return compactMap { $0.value }
    }
    
    /// 检查数组是否包含 nil 值
    var containsNil: Bool {
        return contains { $0.value == nil }
    }
    
    /// 检查数组是否只包含 nil 值
    var containsOnlyNil: Bool {
        return allSatisfy { $0.value == nil }
    }
    
    /// 获取第一个非 nil 值
    var firstNonNil: Element.Wrapped? {
        return first { $0.value != nil }?.value
    }
    
    /// 获取最后一个非 nil 值
    var lastNonNil: Element.Wrapped? {
        return last { $0.value != nil }?.value
    }
}

// MARK: - 可选类型协议

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

// MARK: - Equatable 元素数组扩展

public extension Array where Element: Equatable {
    
    /// 移除所有指定的元素
    /// - Parameter element: 要移除的元素
    mutating func removeAll(_ element: Element) {
        removeAll { $0 == element }
    }
    
    /// 检查数组是否包含所有指定的元素
    /// - Parameter elements: 要检查的元素数组
    /// - Returns: 是否包含所有元素
    func containsAll(_ elements: [Element]) -> Bool {
        // 对于Equatable类型，使用数组方法而不是Set
        for element in elements {
            if !contains(element) {
                return false
            }
        }
        return true
    }
    
    /// 检查数组是否包含任何指定的元素
    /// - Parameter elements: 要检查的元素数组
    /// - Returns: 是否包含任何元素
    func containsAny(_ elements: [Element]) -> Bool {
        // 对于Equatable类型，使用数组方法而不是Set
        for element in elements {
            if contains(element) {
                return true
            }
        }
        return false
    }
    
    /// 移除重复元素（保持原有顺序）
    mutating func removeDuplicates() where Element: Hashable {
        self = uniqued()
    }
}

// MARK: - Comparable 元素数组扩展

public extension Array where Element: Comparable {
    
    /// 检查数组是否已排序（升序）
    var isSorted: Bool {
        for i in 1..<count {
            if self[i] < self[i-1] {
                return false
            }
        }
        return true
    }
    
    /// 检查数组是否已排序（降序）
    var isSortedDescending: Bool {
        for i in 1..<count {
            if self[i] > self[i-1] {
                return false
            }
        }
        return true
    }
    
    /// 获取数组的中位数
    var median: Element? {
        guard !isEmpty else { return nil }
        let sorted = self.sorted()
        let middle = sorted.count / 2
        if sorted.count % 2 == 0 {
            return sorted[middle]
        } else {
            return sorted[middle]
        }
    }
}

// MARK: - 数值型元素数组扩展

public extension Array where Element: Numeric {
    
    /// 计算数组的乘积
    var product: Element {
        return reduce(1, *)
    }
}

// MARK: - 字符串数组扩展

public extension Array where Element == String {
    
    /// 将字符串数组连接成一个字符串，使用指定的分隔符
    /// - Parameter separator: 分隔符
    /// - Returns: 连接后的字符串
    func joinedString(separator: String = "") -> String {
        // 调用标准库的joined方法
        return self.joined(separator: separator)
    }
    
    /// 将字符串数组连接成一个字符串，每个元素在单独一行
    /// - Returns: 连接后的字符串
    func joinedWithNewlines() -> String {
        return joinedString(separator: "\n")
    }
    
    /// 过滤掉空字符串
    /// - Returns: 非空字符串数组
    func nonEmpty() -> [String] {
        return filter { !$0.isEmpty }
    }
    
    /// 过滤掉空白字符串
    /// - Returns: 非空白字符串数组
    func nonBlank() -> [String] {
        return filter { !$0.isBlank }
    }
    
    /// 将每个字符串首字母大写
    /// - Returns: 首字母大写的字符串数组
    func capitalizedFirstLetters() -> [String] {
        return map { $0.capitalizedFirstLetter() }
    }
    
    /// 将每个字符串转换为小写
    /// - Returns: 小写字符串数组
    func lowercased() -> [String] {
        return map { $0.lowercased() }
    }
    
    /// 将每个字符串转换为大写
    /// - Returns: 大写字符串数组
    func uppercased() -> [String] {
        return map { $0.uppercased() }
    }
    
    /// 将每个字符串去除两端空白
    /// - Returns: 去除空白后的字符串数组
    func trimmed() -> [String] {
        return map { $0.trimmed }
    }
}
