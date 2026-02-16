// Float+Extension.swift
// 单精度浮点数扩展，提供便捷的数学、转换和格式化方法

import Foundation

public extension Float {
    
    // MARK: - 数学运算
    
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
    
    /// 检查是否为有限数
    var isFiniteNumber: Bool {
        return self.isFinite
    }
    
    /// 检查是否为无限数
    var isInfiniteNumber: Bool {
        return self.isInfinite
    }
    
    /// 检查是否为NaN（非数字）
    var isNaNValue: Bool {
        return self.isNaN
    }
    
    /// 检查是否为正常数（既不是NaN也不是无限数）
    var isNormalNumber: Bool {
        return self.isNormal
    }
    
    /// 检查是否为非正数
    var isNotPositive: Bool {
        return self <= 0
    }
    
    /// 检查是否为非负数
    var isNotNegative: Bool {
        return self >= 0
    }
    
    /// 绝对值
    var absoluteValue: Float {
        return abs(self)
    }
    
    /// 符号值（1表示正数，-1表示负数，0表示零）
    var sign: Int {
        if self > 0 { return 1 }
        else if self < 0 { return -1 }
        else { return 0 }
    }
    
    /// 向下取整
    var floor: Int {
        return Int(self.rounded(.down))
    }
    
    /// 向上取整
    var ceil: Int {
        return Int(self.rounded(.up))
    }
    
    /// 四舍五入取整
    var round: Int {
        return Int(self.rounded())
    }
    
    /// 向下取整（返回Float）
    var floored: Float {
        return self.rounded(.down)
    }
    
    /// 向上取整（返回Float）
    var ceiled: Float {
        return self.rounded(.up)
    }
    
    /// 四舍五入（返回Float）
    var roundedValue: Float {
        return self.rounded()
    }
    
    /// 检查是否在指定范围内（包含边界）
    /// - Parameter range: 范围
    /// - Returns: 是否在范围内
    func isIn(_ range: ClosedRange<Float>) -> Bool {
        return range.contains(self)
    }
    
    /// 检查是否在指定范围内（不包含边界）
    /// - Parameter range: 范围
    /// - Returns: 是否在范围内
    func isIn(_ range: Range<Float>) -> Bool {
        return range.contains(self)
    }
    
    /// 限制在指定范围内
    /// - Parameter range: 范围
    /// - Returns: 限制后的值
    func clamped(to range: ClosedRange<Float>) -> Float {
        return Swift.max(range.lowerBound, Swift.min(range.upperBound, self))
    }
    
    /// 限制在指定范围内
    /// - Parameter range: 范围
    /// - Returns: 限制后的值
    func clamped(to range: Range<Float>) -> Float {
        let lowerBound = Swift.max(range.lowerBound, self)
        return Swift.min(range.upperBound, lowerBound)
    }
    
    // MARK: - 数字转换
    
    /// 转换为Int
    var intValue: Int {
        return Int(self)
    }
    
    /// 转换为Double
    var doubleValue: Double {
        return Double(self)
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
    
    /// 转换为带格式的字符串（如：1,000,000.00）
    /// - Parameters:
    ///   - locale: 区域设置
    ///   - fractionDigits: 小数位数
    /// - Returns: 格式化后的字符串
    func formatted(locale: Locale = .current, fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? stringValue
    }
    
    /// 转换为百分比格式字符串
    /// - Parameters:
    ///   - locale: 区域设置
    ///   - fractionDigits: 小数位数
    /// - Returns: 百分比格式字符串
    func formattedAsPercent(locale: Locale = .current, fractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self.doubleValue / 100.0))
    }
    
    // MARK: - 随机数生成
    
    /// 生成随机数（包含边界）
    /// - Parameters:
    ///   - min: 最小值
    ///   - max: 最大值
    /// - Returns: 随机浮点数
    static func random(in range: ClosedRange<Float>) -> Float {
        // 使用系统随机数生成器，避免递归调用
        var generator = SystemRandomNumberGenerator()
        return Float.random(in: range, using: &generator)
    }
    
    /// 生成随机数（不包含最大值）
    /// - Parameters:
    ///   - min: 最小值
    ///   - max: 最大值（不包含）
    /// - Returns: 随机浮点数
    static func random(in range: Range<Float>) -> Float {
        // 使用系统随机数生成器，避免递归调用
        var generator = SystemRandomNumberGenerator()
        return Float.random(in: range, using: &generator)
    }
    
    /// 生成随机数（从0到指定值，不包含最大值）
    /// - Parameter upperBound: 最大值（不包含）
    /// - Returns: 随机浮点数
    static func random(upTo upperBound: Float) -> Float {
        return Float.random(in: 0..<upperBound)
    }
    
    // MARK: - 角度相关
    
    /// 转换为弧度
    var radians: Float {
        return self * .pi / 180.0
    }
    
    /// 转换为角度
    var degrees: Float {
        return self * 180.0 / .pi
    }
    
    /// 正弦值
    var sinValue: Float {
        return sin(self)
    }
    
    /// 余弦值
    var cosValue: Float {
        return cos(self)
    }
    
    /// 正切值
    var tanValue: Float {
        return tan(self)
    }
    
    // MARK: - 数学函数
    
    /// 计算平方
    var squared: Float {
        return self * self
    }
    
    /// 计算立方
    var cubed: Float {
        return self * self * self
    }
    
    /// 计算平方根
    var squareRoot: Float {
        return sqrt(self)
    }
    
    /// 计算幂运算
    /// - Parameter exponent: 指数
    /// - Returns: 幂运算结果
    func power(_ exponent: Float) -> Float {
        return pow(self, exponent)
    }
    
    /// 计算指数函数（e的x次幂）
    var expValue: Float {
        return exp(self)
    }
    
    /// 计算自然对数
    var lnValue: Float {
        return log(self)
    }
    
    /// 计算常用对数（以10为底）
    var log10Value: Float {
        return log10(self)
    }
    
    /// 计算绝对值平方
    var magnitudeSquared: Float {
        return self * self
    }
    
    /// 计算倒数
    var reciprocal: Float? {
        guard self != 0 else { return nil }
        return 1.0 / self
    }
    
    // MARK: - 精度处理
    
    /// 保留指定小数位数
    /// - Parameter places: 小数位数
    /// - Returns: 保留小数后的值
    func rounded(toPlaces places: Int) -> Float {
        guard places >= 0 else { return self }
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// 检查两个浮点数是否近似相等
    /// - Parameters:
    ///   - other: 另一个浮点数
    ///   - tolerance: 容差
    /// - Returns: 是否近似相等
    func isApproximatelyEqual(to other: Float, tolerance: Float = 0.000001) -> Bool {
        return abs(self - other) <= tolerance
    }
    
    // MARK: - 实用方法
    
    /// 线性插值
    /// - Parameters:
    ///   - to: 目标值
    ///   - t: 插值因子（0-1之间）
    /// - Returns: 插值结果
    func lerp(to: Float, t: Float) -> Float {
        let clampedT = max(0, min(1, t))
        return self + (to - self) * clampedT
    }
}

// MARK: - 可比较扩展

public extension Float {
    
    /// 检查是否大于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否大于
    func isGreater(than other: Float) -> Bool {
        return self > other
    }
    
    /// 检查是否小于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否小于
    func isLess(than other: Float) -> Bool {
        return self < other
    }
    
    /// 检查是否大于或等于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否大于或等于
    func isGreaterOrEqual(to other: Float) -> Bool {
        return self >= other
    }
    
    /// 检查是否小于或等于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否小于或等于
    func isLessOrEqual(to other: Float) -> Bool {
        return self <= other
    }
    
    /// 检查是否在指定范围内（包含边界）
    /// - Parameter min: 最小值
    /// - Parameter max: 最大值
    /// - Returns: 是否在范围内
    func isBetween(_ min: Float, and max: Float) -> Bool {
        return self >= min && self <= max
    }
}

// MARK: - 序列扩展

public extension Sequence where Element == Float {
    
    /// 计算序列的总和
    /// - Returns: 总和
    func sum() -> Float {
        return reduce(0, +)
    }
    
    /// 计算序列的平均值
    /// - Returns: 平均值
    func average() -> Float {
        var count = 0
        var sum: Float = 0
        for element in self {
            sum += element
            count += 1
        }
        return count == 0 ? 0 : sum / Float(count)
    }
    
    /// 获取序列中的最大值
    /// - Returns: 最大值
    func maxValue() -> Float? {
        return self.max()
    }
    
    /// 获取序列中的最小值
    /// - Returns: 最小值
    func minValue() -> Float? {
        return self.min()
    }
    
    /// 计算序列的乘积
    /// - Returns: 乘积
    func product() -> Float {
        return reduce(1, *)
    }
}

// MARK: - 数组扩展

public extension Array where Element == Float {
    
    /// 计算中位数
    /// - Returns: 中位数
    var median: Float? {
        guard !isEmpty else { return nil }
        let sorted = self.sorted()
        let middle = sorted.count / 2
        if sorted.count % 2 == 0 {
            return (sorted[middle - 1] + sorted[middle]) / 2.0
        } else {
            return sorted[middle]
        }
    }
    
    /// 计算标准差
    /// - Returns: 标准差
    var standardDeviation: Float? {
        guard count > 1 else { return nil }
        let mean = self.reduce(0.0, +) / Float(count)
        let sumOfSquaredDifferences = self.reduce(0.0) { $0 + ($1 - mean) * ($1 - mean) }
        let variance = sumOfSquaredDifferences / Float(count - 1)
        return sqrtf(variance)
    }
}