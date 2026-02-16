// Double+Extension.swift
// 双精度浮点数扩展，提供便捷的数学、转换和格式化方法

import Foundation

public extension Double {
    
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
    var isFinite: Bool {
        return self.isFinite
    }
    
    /// 检查是否为无限数
    var isInfinite: Bool {
        return self.isInfinite
    }
    
    /// 检查是否为NaN（非数字）
    var isNaN: Bool {
        return self.isNaN
    }
    
    /// 检查是否为正常数（既不是NaN也不是无限数）
    var isNormal: Bool {
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
    var absoluteValue: Double {
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
    
    /// 向下取整（返回Double）
    var floored: Double {
        return self.rounded(.down)
    }
    
    /// 向上取整（返回Double）
    var ceiled: Double {
        return self.rounded(.up)
    }
    
    /// 四舍五入（返回Double）
    var roundedValue: Double {
        return self.rounded()
    }
    
    /// 检查是否在指定范围内（包含边界）
    /// - Parameter range: 范围
    /// - Returns: 是否在范围内
    func isIn(_ range: ClosedRange<Double>) -> Bool {
        return range.contains(self)
    }
    
    /// 检查是否在指定范围内（不包含边界）
    /// - Parameter range: 范围
    /// - Returns: 是否在范围内
    func isIn(_ range: Range<Double>) -> Bool {
        return range.contains(self)
    }
    
    /// 限制在指定范围内
    /// - Parameter range: 范围
    /// - Returns: 限制后的值
    func clamped(to range: ClosedRange<Double>) -> Double {
        return Swift.max(range.lowerBound, Swift.min(range.upperBound, self))
    }
    
    /// 限制在指定范围内
    /// - Parameter range: 范围
    /// - Returns: 限制后的值
    func clamped(to range: Range<Double>) -> Double {
        let lowerBound = Swift.max(range.lowerBound, self)
        return Swift.min(range.upperBound, lowerBound)
    }
    
    // MARK: - 数字转换
    
    /// 转换为Int
    var intValue: Int {
        return Int(self)
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
    
    /// 转换为货币格式字符串
    /// - Parameters:
    ///   - locale: 区域设置
    ///   - currencyCode: 货币代码（如：USD、CNY）
    ///   - fractionDigits: 小数位数
    /// - Returns: 货币格式字符串
    func formattedAsCurrency(locale: Locale = .current, currencyCode: String? = nil, fractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
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
    func formattedAsPercent(locale: Locale = .current, fractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self / 100.0))
    }
    
    /// 转换为科学计数法字符串
    /// - Parameters:
    ///   - locale: 区域设置
    ///   - fractionDigits: 小数位数
    /// - Returns: 科学计数法字符串
    func formattedAsScientific(locale: Locale = .current, fractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self))
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
        return self / 1024
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
    /// - Returns: 随机浮点数
    static func random(in range: ClosedRange<Double>) -> Double {
        return Double.random(in: range)
    }
    
    /// 生成随机数（不包含最大值）
    /// - Parameters:
    ///   - min: 最小值
    ///   - max: 最大值（不包含）
    /// - Returns: 随机浮点数
    static func random(in range: Range<Double>) -> Double {
        return Double.random(in: range)
    }
    
    /// 生成随机数（从0到指定值，不包含最大值）
    /// - Parameter upperBound: 最大值（不包含）
    /// - Returns: 随机浮点数
    static func random(upTo upperBound: Double) -> Double {
        return Double.random(in: 0..<upperBound)
    }
    
    // MARK: - 角度相关
    
    /// 转换为弧度
    var radians: Double {
        return self * .pi / 180.0
    }
    
    /// 转换为角度
    var degrees: Double {
        return self * 180.0 / .pi
    }
    
    /// 正弦值
    var sinValue: Double {
        return sin(self)
    }
    
    /// 余弦值
    var cosValue: Double {
        return cos(self)
    }
    
    /// 正切值
    var tanValue: Double {
        return tan(self)
    }
    
    /// 反正弦值（返回弧度）
    var asinValue: Double {
        return asin(self)
    }
    
    /// 反余弦值（返回弧度）
    var acosValue: Double {
        return acos(self)
    }
    
    /// 反正切值（返回弧度）
    var atanValue: Double {
        return atan(self)
    }
    
    // MARK: - 字符串格式化
    
    /// 转换为带千位分隔符的字符串
    /// - Parameter fractionDigits: 小数位数
    /// - Returns: 带千位分隔符的字符串
    func withThousandsSeparator(fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? stringValue
    }
    
    /// 转换为百分比字符串（带百分号）
    /// - Parameter fractionDigits: 小数位数
    /// - Returns: 百分比字符串
    func asPercentage(fractionDigits: Int = 1) -> String {
        return String(format: "%.\(fractionDigits)f%%", self * 100)
    }
    
    /// 转换为分数字符串（如：1/2）
    /// - Parameter maxDenominator: 最大分母
    /// - Returns: 分数字符串
    func asFraction(maxDenominator: Int = 100) -> String? {
        guard self >= 0 && self <= 1 else { return nil }
        
        var bestNumerator = 0
        var bestDenominator = 1
        var bestError = Double.infinity
        
        for denominator in 1...maxDenominator {
            let numerator = Int((self * Double(denominator)).rounded())
            let error = abs(Double(numerator) / Double(denominator) - self)

            if error < bestError {
                bestError = error
                bestNumerator = numerator
                bestDenominator = denominator
            }
        }
        
        return "\(bestNumerator)/\(bestDenominator)"
    }
    
    // MARK: - 数学函数
    
    /// 计算平方
    var squared: Double {
        return self * self
    }
    
    /// 计算立方
    var cubed: Double {
        return self * self * self
    }
    
    /// 计算平方根
    var squareRoot: Double {
        return sqrt(self)
    }
    
    /// 计算立方根
    var cubeRoot: Double {
        return cbrt(self)
    }
    
    /// 计算幂运算
    /// - Parameter exponent: 指数
    /// - Returns: 幂运算结果
    func power(_ exponent: Double) -> Double {
        return pow(self, exponent)
    }
    
    /// 计算指数函数（e的x次幂）
    var expValue: Double {
        return exp(self)
    }
    
    /// 计算自然对数
    var lnValue: Double {
        return log(self)
    }
    
    /// 计算常用对数（以10为底）
    var log10Value: Double {
        return log10(self)
    }
    
    /// 计算绝对值平方
    var magnitudeSquared: Double {
        return self * self
    }
    
    /// 计算倒数
    var reciprocal: Double? {
        guard self != 0 else { return nil }
        return 1.0 / self
    }
    
    /// 计算百分比（相对于另一个值）
    /// - Parameter of: 基准值
    /// - Returns: 百分比
    func percentage(of value: Double) -> Double {
        guard value != 0 else { return 0 }
        return (self / value) * 100
    }
    
    // MARK: - 统计相关
    
    /// 检查是否为有效百分比（0-100之间）
    var isValidPercentage: Bool {
        return self >= 0 && self <= 100
    }
    
    /// 将百分比转换为小数
    var asDecimal: Double {
        return self / 100.0
    }
    
    /// 将小数转换为百分比
    var asPercent: Double {
        return self * 100.0
    }
    
    // MARK: - 精度处理
    
    /// 保留指定小数位数
    /// - Parameter places: 小数位数
    /// - Returns: 保留小数后的值
    func rounded(toPlaces places: Int) -> Double {
        guard places >= 0 else { return self }
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// 向上取整到指定小数位数
    /// - Parameter places: 小数位数
    /// - Returns: 取整后的值
    func ceiled(toPlaces places: Int) -> Double {
        guard places >= 0 else { return self }
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.up) / divisor
    }
    
    /// 向下取整到指定小数位数
    /// - Parameter places: 小数位数
    /// - Returns: 取整后的值
    func floored(toPlaces places: Int) -> Double {
        guard places >= 0 else { return self }
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.down) / divisor
    }
    
    /// 检查两个浮点数是否近似相等
    /// - Parameters:
    ///   - other: 另一个浮点数
    ///   - tolerance: 容差
    /// - Returns: 是否近似相等
    func isApproximatelyEqual(to other: Double, tolerance: Double = 0.000001) -> Bool {
        return abs(self - other) <= tolerance
    }
    
    // MARK: - 实用方法
    
    /// 线性插值
    /// - Parameters:
    ///   - to: 目标值
    ///   - t: 插值因子（0-1之间）
    /// - Returns: 插值结果
    func lerp(to: Double, t: Double) -> Double {
        let clampedT = max(0, min(1, t))
        return self + (to - self) * clampedT
    }
    
    /// 反向线性插值
    /// - Parameters:
    ///   - value: 插值后的值
    ///   - to: 目标值
    /// - Returns: 插值因子
    func inverseLerp(value: Double, to: Double) -> Double {
        guard self != to else { return 0 }
        return (value - self) / (to - self)
    }
    
    /// 映射到新范围
    /// - Parameters:
    ///   - fromRange: 原始范围
    ///   - toRange: 目标范围
    /// - Returns: 映射后的值
    func map(fromRange: ClosedRange<Double>, toRange: ClosedRange<Double>) -> Double {
        let t = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return toRange.lowerBound + t * (toRange.upperBound - toRange.lowerBound)
    }
    
    /// 计算两点之间的距离
    /// - Parameters:
    ///   - x2: 第二个点的x坐标
    ///   - y2: 第二个点的y坐标
    /// - Returns: 距离
    func distance(to x2: Double, _ y2: Double) -> Double {
        let x1 = self
        let y1 = self
        return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
    }
    
    /// 生成等差数列
    /// - Parameters:
    ///   - to: 终点值
    ///   - count: 元素数量（包含起点和终点）
    /// - Returns: 等差数列数组
    func arithmeticProgression(to: Double, count: Int) -> [Double] {
        guard count >= 2 else { return [self] }
        var result: [Double] = []
        let step = (to - self) / Double(count - 1)
        for i in 0..<count {
            result.append(self + Double(i) * step)
        }
        return result
    }
    
    // MARK: - 物理常数（近似值）
    
    /// 圆周率
    static var pi: Double {
        return Double.pi
    }
    
    /// 自然常数e
    static var e: Double {
        return M_E
    }
    
    /// 黄金分割率
    static var goldenRatio: Double {
        return 1.618033988749895
    }
    
    /// 光速（米/秒）
    static var speedOfLight: Double {
        return 299792458
    }
    
    /// 重力加速度（米/秒²）
    static var gravity: Double {
        return 9.80665
    }
}

// MARK: - 可比较扩展

public extension Double {
    
    /// 检查是否大于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否大于
    func isGreater(than other: Double) -> Bool {
        return self > other
    }
    
    /// 检查是否小于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否小于
    func isLess(than other: Double) -> Bool {
        return self < other
    }
    
    /// 检查是否大于或等于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否大于或等于
    func isGreaterOrEqual(to other: Double) -> Bool {
        return self >= other
    }
    
    /// 检查是否小于或等于另一个值
    /// - Parameter other: 另一个值
    /// - Returns: 是否小于或等于
    func isLessOrEqual(to other: Double) -> Bool {
        return self <= other
    }
    
    /// 检查是否在指定范围内（包含边界）
    /// - Parameter min: 最小值
    /// - Parameter max: 最大值
    /// - Returns: 是否在范围内
    func isBetween(_ min: Double, and max: Double) -> Bool {
        return self >= min && self <= max
    }
}

// MARK: - 序列扩展

public extension Sequence where Element == Double {
    
    /// 计算序列的总和
    /// - Returns: 总和
    func sum() -> Double {
        return reduce(0, +)
    }
    
    /// 计算序列的平均值
    /// - Returns: 平均值
    func average() -> Double {
        var count = 0
        var sum: Double = 0
        for element in self {
            sum += element
            count += 1
        }
        return count == 0 ? 0 : sum / Double(count)
    }
    
    /// 获取序列中的最大值
    /// - Returns: 最大值
    func maxValue() -> Double? {
        return self.max()
    }
    
    /// 获取序列中的最小值
    /// - Returns: 最小值
    func minValue() -> Double? {
        return self.min()
    }
    
    /// 计算序列的乘积
    /// - Returns: 乘积
    func product() -> Double {
        return reduce(1, *)
    }
}

// MARK: - 数组扩展

public extension Array where Element == Double {
    
    /// 计算中位数
    /// - Returns: 中位数
    var median: Double? {
        guard !isEmpty else { return nil }
        let sorted = self.sorted()
        let middle = sorted.count / 2
        if sorted.count % 2 == 0 {
            return (sorted[middle - 1] + sorted[middle]) / 2.0
        } else {
            return sorted[middle]
        }
    }
    
    /// 计算众数（出现频率最高的值）
    /// - Parameter tolerance: 容差
    /// - Returns: 众数数组
    func mode(tolerance: Double = 0.000001) -> [Double] {
        guard !isEmpty else { return [] }
        
        var groups: [[Double]] = []
        let sorted = self.sorted()
        
        var currentGroup: [Double] = []
        for value in sorted {
            if currentGroup.isEmpty || abs(value - currentGroup[0]) <= tolerance {
                currentGroup.append(value)
            } else {
                groups.append(currentGroup)
                currentGroup = [value]
            }
        }
        if !currentGroup.isEmpty {
            groups.append(currentGroup)
        }
        
        let maxCount = groups.map { $0.count }.max() ?? 0
        return groups.filter { $0.count == maxCount }.compactMap { $0.first }
    }
    
    /// 计算方差
    /// - Returns: 方差
    var variance: Double? {
        guard count > 1 else { return nil }
        let mean = average()
        let sumOfSquaredDifferences = reduce(0.0) { $0 + pow($1 - mean, 2) }
        return sumOfSquaredDifferences / Double(count - 1)
    }
    
    /// 计算标准差
    /// - Returns: 标准差
    var standardDeviation: Double? {
        return variance.map { sqrt($0) }
    }
    
    /// 归一化到0-1范围
    /// - Returns: 归一化后的数组
    var normalized: [Double] {
        guard let min = min(), let max = max(), min != max else {
            return Array(repeating: 0, count: count)
        }
        return map { ($0 - min) / (max - min) }
    }
    
    /// 标准化（均值为0，标准差为1）
    /// - Returns: 标准化后的数组
    var standardized: [Double]? {
        guard let stdDev = standardDeviation, stdDev != 0 else { return nil }
        let mean = average()
        return map { ($0 - mean) / stdDev }
    }
}