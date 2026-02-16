// Int+Extension.swift
// 整数扩展，提供便捷的数学、转换和格式化方法

import Foundation

public extension Int {
    
    // MARK: - 数学运算
    
    /// 检查是否为偶数
    var isEven: Bool {
        return self % 2 == 0
    }
    
    /// 检查是否为奇数
    var isOdd: Bool {
        return self % 2 != 0
    }
    
    /// 检查是否为正数
    var isPositive: Bool {
        return self > 0
    }
    
    /// 检查是否为负数
    var isNegative: Bool {
        return self < 0
    }
    
    /// 检查是否为零
    var isZero: Bool {
        return self == 0
    }
    
    /// 绝对值
    var absoluteValue: Int {
        return abs(self)
    }
    
    /// 符号值（1表示正数，-1表示负数，0表示零）
    var sign: Int {
        if self > 0 { return 1 }
        else if self < 0 { return -1 }
        else { return 0 }
    }
    
    /// 阶乘（仅对非负整数有效）
    var factorial: Int? {
        guard self >= 0 else { return nil }
        if self == 0 { return 1 }
        return (1...self).reduce(1, *)
    }
    
    /// 检查是否为质数
    var isPrime: Bool {
        if self <= 1 { return false }
        if self <= 3 { return true }
        if self % 2 == 0 || self % 3 == 0 { return false }
        
        var i = 5
        while i * i <= self {
            if self % i == 0 || self % (i + 2) == 0 {
                return false
            }
            i += 6
        }
        return true
    }
    
    /// 检查是否在指定范围内（包含边界）
    /// - Parameter range: 范围
    /// - Returns: 是否在范围内
    func isIn(_ range: ClosedRange<Int>) -> Bool {
        return range.contains(self)
    }
    
    /// 检查是否在指定范围内（不包含边界）
    /// - Parameter range: 范围
    /// - Returns: 是否在范围内
    func isIn(_ range: Range<Int>) -> Bool {
        return range.contains(self)
    }
    
    /// 限制在指定范围内
    /// - Parameter range: 范围
    /// - Returns: 限制后的值
    func clamped(to range: ClosedRange<Int>) -> Int {
        return Swift.max(range.lowerBound, Swift.min(range.upperBound, self))
    }
    
    /// 限制在指定范围内
    /// - Parameter range: 范围
    /// - Returns: 限制后的值
    func clamped(to range: Range<Int>) -> Int {
        let lowerBound = Swift.max(range.lowerBound, self)
        return Swift.min(range.upperBound - 1, lowerBound)
    }
    
    // MARK: - 数字转换
    
    /// 转换为Double
    var doubleValue: Double {
        return Double(self)
    }
    
    /// 转换为Float
    var floatValue: Float {
        return Float(self)
    }
    
    /// 转换为CGFloat
    var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
    
    /// 转换为字符串
    var stringValue: String {
        return String(self)
    }
    
    /// 转换为布尔值（0为false，非0为true）
    var boolValue: Bool {
        return self != 0
    }
    
    /// 转换为带格式的字符串（如：1,000,000）
    /// - Parameter locale: 区域设置
    /// - Returns: 格式化后的字符串
    func formatted(locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: self)) ?? stringValue
    }
    
    /// 转换为货币格式字符串
    /// - Parameters:
    ///   - locale: 区域设置
    ///   - currencyCode: 货币代码（如：USD、CNY）
    /// - Returns: 货币格式字符串
    func formattedAsCurrency(locale: Locale = .current, currencyCode: String? = nil) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        if let currencyCode = currencyCode {
            formatter.currencyCode = currencyCode
        }
        return formatter.string(from: NSNumber(value: self))
    }
    
    /// 转换为百分比格式字符串
    /// - Parameters:
    ///   - locale: 区域设置
    ///   - fractionDigits: 小数位数
    /// - Returns: 百分比格式字符串
    func formattedAsPercent(locale: Locale = .current, fractionDigits: Int = 0) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self.doubleValue / 100.0))
    }
    
    // MARK: - 时间相关
    
    /// 转换为秒（用于时间间隔）
    var seconds: TimeInterval {
        return TimeInterval(self)
    }
    
    /// 转换为分钟（用于时间间隔）
    var minutes: TimeInterval {
        return TimeInterval(self) * 60
    }
    
    /// 转换为小时（用于时间间隔）
    var hours: TimeInterval {
        return TimeInterval(self) * 3600
    }
    
    /// 转换为天（用于时间间隔）
    var days: TimeInterval {
        return TimeInterval(self) * 86400
    }
    
    /// 转换为毫秒（用于时间间隔）
    var milliseconds: TimeInterval {
        return TimeInterval(self) / 1000
    }
    
    /// 转换为微秒（用于时间间隔）
    var microseconds: TimeInterval {
        return TimeInterval(self) / 1_000_000
    }
    
    /// 转换为纳秒（用于时间间隔）
    var nanoseconds: TimeInterval {
        return TimeInterval(self) / 1_000_000_000
    }
    
    // MARK: - 字节大小相关
    
    /// 转换为字节大小（用于存储容量）
    var bytes: Int64 {
        return Int64(self)
    }
    
    /// 转换为千字节（KB）
    var kilobytes: Double {
        return Double(self) / 1024
    }
    
    /// 转换为兆字节（MB）
    var megabytes: Double {
        return kilobytes / 1024
    }
    
    /// 转换为吉字节（GB）
    var gigabytes: Double {
        return megabytes / 1024
    }
    
    /// 转换为太字节（TB）
    var terabytes: Double {
        return gigabytes / 1024
    }
    
    /// 格式化字节大小（智能选择单位）
    /// - Returns: 格式化后的字符串（如：1.2 MB）
    func formattedBytes() -> String {
        let byteCount = Int64(self)
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        return formatter.string(fromByteCount: byteCount)
    }
    
    // MARK: - 随机数生成
    
    /// 生成随机数（包含边界）
    /// - Parameters:
    ///   - min: 最小值
    ///   - max: 最大值
    /// - Returns: 随机整数
    static func random(in range: ClosedRange<Int>) -> Int {
        return Int.random(in: range)
    }
    
    /// 生成随机数（不包含最大值）
    /// - Parameters:
    ///   - min: 最小值
    ///   - max: 最大值（不包含）
    /// - Returns: 随机整数
    static func random(in range: Range<Int>) -> Int {
        return Int.random(in: range)
    }
    
    /// 生成随机数（从0到指定值，不包含最大值）
    /// - Parameter upperBound: 最大值（不包含）
    /// - Returns: 随机整数
    static func random(upTo upperBound: Int) -> Int {
        return Int.random(in: 0..<upperBound)
    }
    
    // MARK: - 位运算
    
    /// 检查指定位是否为1
    /// - Parameter position: 位位置（从0开始）
    /// - Returns: 指定位是否为1
    func bitIsSet(at position: Int) -> Bool {
        guard position >= 0 else { return false }
        return (self & (1 << position)) != 0
    }
    
    /// 设置指定位为1
    /// - Parameter position: 位位置（从0开始）
    /// - Returns: 设置后的值
    func withBitSet(at position: Int) -> Int {
        guard position >= 0 else { return self }
        return self | (1 << position)
    }
    
    /// 清除指定位（设置为0）
    /// - Parameter position: 位位置（从0开始）
    /// - Returns: 清除后的值
    func withBitCleared(at position: Int) -> Int {
        guard position >= 0 else { return self }
        return self & ~(1 << position)
    }
    
    /// 切换指定位的值
    /// - Parameter position: 位位置（从0开始）
    /// - Returns: 切换后的值
    func withBitToggled(at position: Int) -> Int {
        guard position >= 0 else { return self }
        return self ^ (1 << position)
    }
    
    /// 获取二进制字符串表示
    /// - Returns: 二进制字符串（如：1010）
    var binaryString: String {
        return String(self, radix: 2)
    }
    
    /// 获取八进制字符串表示
    /// - Returns: 八进制字符串
    var octalString: String {
        return String(self, radix: 8)
    }
    
    /// 获取十六进制字符串表示
    /// - Returns: 十六进制字符串
    var hexadecimalString: String {
        return String(self, radix: 16)
    }
    
    /// 获取十六进制字符串表示（带前缀0x）
    /// - Returns: 十六进制字符串
    var hexadecimalStringWithPrefix: String {
        return "0x" + hexadecimalString.uppercased()
    }
    
    /// 设置位数
    /// - Parameter numberOfBits: 位数（如：8、16、32、64）
    /// - Returns: 限制在指定位数范围内的值
    func masked(to numberOfBits: Int) -> Int {
        guard numberOfBits > 0 else { return 0 }
        let mask = (1 << numberOfBits) - 1
        return self & mask
    }
    
    // MARK: - 字符串格式化
    
    /// 转换为带千位分隔符的字符串
    /// - Returns: 带千位分隔符的字符串
    func withThousandsSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? stringValue
    }
    
    /// 转换为中文数字字符串
    /// - Returns: 中文数字字符串
    var chineseNumberString: String {
        if self == 0 { return "零" }
        
        let digits = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        let units = ["", "十", "百", "千", "万", "十", "百", "千", "亿"]
        
        var number = self
        var result = ""
        var unitIndex = 0
        var lastWasZero = true
        
        while number > 0 {
            let digit = number % 10
            if digit == 0 {
                if !lastWasZero && unitIndex != 0 && unitIndex != 4 && unitIndex != 8 {
                    result = "零" + result
                }
                lastWasZero = true
            } else {
                let unit = units[unitIndex]
                result = digits[digit] + unit + result
                lastWasZero = false
            }
            number /= 10
            unitIndex += 1
        }
        
        // 处理特殊情况：十开头的数字如"十二"而不是"一十二"
        if result.hasPrefix("一十") {
            result = String(result.dropFirst())
        }
        
        return result
    }
    
    /// 转换为罗马数字字符串
    /// - Returns: 罗马数字字符串
    var romanNumeralString: String? {
        guard self > 0 && self < 4000 else { return nil }
        
        let values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        let symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        var number = self
        var result = ""
        
        for i in 0..<values.count {
            while number >= values[i] {
                number -= values[i]
                result += symbols[i]
            }
        }
        
        return result
    }
    
    // MARK: - 数学函数
    
    /// 计算平方
    var squared: Int {
        return self * self
    }
    
    /// 计算立方
    var cubed: Int {
        return self * self * self
    }
    
    /// 计算平方根（返回Double）
    var squareRoot: Double {
        return sqrt(Double(self))
    }
    
    /// 计算幂运算
    /// - Parameter exponent: 指数
    /// - Returns: 幂运算结果
    func power(_ exponent: Int) -> Int {
        guard exponent >= 0 else { return 0 }
        var result = 1
        for _ in 0..<exponent {
            result *= self
        }
        return result
    }
    
    /// 计算最大公约数（GCD）
    /// - Parameter other: 另一个整数
    /// - Returns: 最大公约数
    func gcd(with other: Int) -> Int {
        var a = self.absoluteValue
        var b = other.absoluteValue
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        return a
    }
    
    /// 计算最小公倍数（LCM）
    /// - Parameter other: 另一个整数
    /// - Returns: 最小公倍数
    func lcm(with other: Int) -> Int {
        guard self != 0 && other != 0 else { return 0 }
        return (self.absoluteValue * other.absoluteValue) / gcd(with: other)
    }
    
    // MARK: - 数组生成
    
    /// 生成从0到当前值的数组（不包含当前值）
    /// - Returns: 数组
    var rangeArray: [Int] {
        guard self > 0 else { return [] }
        return Array(0..<self)
    }
    
    /// 生成从0到当前值的数组（包含当前值）
    /// - Returns: 数组
    var closedRangeArray: [Int] {
        guard self >= 0 else { return [] }
        return Array(0...self)
    }
    
    /// 重复指定次数的闭包
    /// - Parameter body: 要重复执行的闭包
    func times(_ body: () -> Void) {
        for _ in 0..<self {
            body()
        }
    }
    
    /// 重复指定次数并传递索引的闭包
    /// - Parameter body: 要重复执行的闭包，接收当前索引
    func times(_ body: (Int) -> Void) {
        for i in 0..<self {
            body(i)
        }
    }
    
    // MARK: - 实用方法
    
    /// 检查是否为2的幂
    var isPowerOfTwo: Bool {
        guard self > 0 else { return false }
        return (self & (self - 1)) == 0
    }
    
    /// 获取下一个2的幂（向上取整）
    var nextPowerOfTwo: Int {
        guard self > 0 else { return 1 }
        var value = self - 1
        value |= value >> 1
        value |= value >> 2
        value |= value >> 4
        value |= value >> 8
        value |= value >> 16
        return value + 1
    }
    
    /// 四舍五入到最接近的10的倍数
    var roundedToNearestTen: Int {
        return ((self + 5) / 10) * 10
    }
    
    /// 四舍五入到最接近的100的倍数
    var roundedToNearestHundred: Int {
        return ((self + 50) / 100) * 100
    }
    
    /// 四舍五入到最接近的1000的倍数
    var roundedToNearestThousand: Int {
        return ((self + 500) / 1000) * 1000
    }
    
    /// 获取数字的长度（位数）
    var digitCount: Int {
        guard self != 0 else { return 1 }
        return Int(log10(Double(abs(self)))) + 1
    }
    
    /// 获取各个位上的数字
    var digits: [Int] {
        var number = abs(self)
        var result: [Int] = []
        
        repeat {
            result.insert(number % 10, at: 0)
            number /= 10
        } while number > 0
        
        return result
    }
    
    /// 反转数字（如：123 -> 321）
    var reversed: Int {
        var number = abs(self)
        var result = 0
        
        while number > 0 {
            result = result * 10 + number % 10
            number /= 10
        }
        
        return self < 0 ? -result : result
    }
    
    /// 检查是否为回文数
    var isPalindrome: Bool {
        return self == reversed
    }
}

// MARK: - 可比较扩展

public extension Int {
    
    /// 检查是否大于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否大于
    func isGreater(than other: Int) -> Bool {
        return self > other
    }
    
    /// 检查是否小于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否小于
    func isLess(than other: Int) -> Bool {
        return self < other
    }
    
    /// 检查是否大于或等于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否大于或等于
    func isGreaterOrEqual(to other: Int) -> Bool {
        return self >= other
    }
    
    /// 检查是否小于或等于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否小于或等于
    func isLessOrEqual(to other: Int) -> Bool {
        return self <= other
    }
}

// MARK: - 序列扩展

public extension Sequence where Element == Int {
    
    /// 计算序列的总和
    /// - Returns: 总和
    func sum() -> Int {
        return reduce(0, +)
    }
    
    /// 计算序列的平均值
    /// - Returns: 平均值
    func average() -> Double {
        guard let count = self as? [Int] else { return 0 }
        return count.isEmpty ? 0 : Double(sum()) / Double(count.count)
    }
    
    /// 获取序列中的最大值
    /// - Returns: 最大值
    func maxValue() -> Int? {
        return self.max()
    }
    
    /// 获取序列中的最小值
    /// - Returns: 最小值
    func minValue() -> Int? {
        return self.min()
    }
    
    /// 计算序列的乘积
    /// - Returns: 乘积
    func product() -> Int {
        return reduce(1, *)
    }
}

// MARK: - 数组扩展

public extension Array where Element == Int {
    
    /// 计算中位数
    /// - Returns: 中位数
    var median: Double? {
        guard !isEmpty else { return nil }
        let sorted = self.sorted()
        let middle = sorted.count / 2
        if sorted.count % 2 == 0 {
            return Double(sorted[middle - 1] + sorted[middle]) / 2.0
        } else {
            return Double(sorted[middle])
        }
    }
    
    /// 计算众数（出现频率最高的值）
    /// - Returns: 众数数组
    var mode: [Int] {
        var frequency: [Int: Int] = [:]
        for value in self {
            frequency[value, default: 0] += 1
        }
        
        guard let maxFrequency = frequency.values.max() else { return [] }
        return frequency.compactMap { $0.value == maxFrequency ? $0.key : nil }
    }
    
    /// 计算方差
    /// - Returns: 方差
    var variance: Double? {
        guard count > 1 else { return nil }
        let mean = average()
        let sumOfSquaredDifferences = reduce(0.0) { $0 + pow(Double($1) - mean, 2) }
        return sumOfSquaredDifferences / Double(count - 1)
    }
    
    /// 计算标准差
    /// - Returns: 标准差
    var standardDeviation: Double? {
        return variance.map { sqrt($0) }
    }
}