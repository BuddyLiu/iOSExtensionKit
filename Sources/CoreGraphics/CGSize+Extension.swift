// CGSize+Extension.swift
// Core Graphics 尺寸扩展，提供便捷的尺寸计算和操作方法

import CoreGraphics

public extension CGSize {
    
    // MARK: - 属性和计算属性
    
    /// 零尺寸
    static var zero: CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    /// 单位尺寸（1, 1）
    static var one: CGSize {
        return CGSize(width: 1, height: 1)
    }
    
    /// 平方尺寸
    static var square: CGSize {
        return CGSize(width: 1, height: 1)
    }
    
    /// 面积（宽度 × 高度）
    var area: CGFloat {
        return width * height
    }
    
    /// 周长（2 × (宽度 + 高度)）
    var perimeter: CGFloat {
        return 2 * (width + height)
    }
    
    /// 比例（宽度 / 高度）
    var aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }
    
    /// 反向比例（高度 / 宽度）
    var inverseAspectRatio: CGFloat {
        guard width != 0 else { return 0 }
        return height / width
    }
    
    /// 对角线长度（勾股定理）
    var diagonal: CGFloat {
        return sqrt(width * width + height * height)
    }
    
    /// 是否为零尺寸
    var isZero: Bool {
        return width == 0 && height == 0
    }
    
    /// 是否为正方形（宽度和高度相等）
    var isSquare: Bool {
        return width == height
    }
    
    /// 判断尺寸是否有效（非无穷大和非NaN）
    var isValid: Bool {
        return width.isFinite && height.isFinite && !width.isNaN && !height.isNaN
    }
    
    /// 最小维度（宽度和高度中的较小值）
    var minDimension: CGFloat {
        return min(width, height)
    }
    
    /// 最大维度（宽度和高度中的较大值）
    var maxDimension: CGFloat {
        return max(width, height)
    }
    
    // MARK: - 尺寸操作
    
    /// 缩放尺寸
    /// - Parameter scale: 缩放因子
    mutating func scale(by scale: CGFloat) {
        width *= scale
        height *= scale
    }
    
    /// 获取缩放后的尺寸
    /// - Parameter scale: 缩放因子
    /// - Returns: 缩放后的尺寸
    func scaled(by scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
    }
    
    /// 保持比例缩放
    /// - Parameter maxSize: 最大尺寸
    /// - Returns: 按比例缩放后的尺寸
    func scaled(toFit maxSize: CGSize) -> CGSize {
        guard width > 0 && height > 0 else { return self }
        
        let widthRatio = maxSize.width / width
        let heightRatio = maxSize.height / height
        let scale = min(widthRatio, heightRatio)
        
        return CGSize(width: width * scale, height: height * scale)
    }
    
    /// 保持比例填充
    /// - Parameter minSize: 最小尺寸
    /// - Returns: 按比例填充后的尺寸
    func scaled(toFill minSize: CGSize) -> CGSize {
        guard width > 0 && height > 0 else { return self }
        
        let widthRatio = minSize.width / width
        let heightRatio = minSize.height / height
        let scale = max(widthRatio, heightRatio)
        
        return CGSize(width: width * scale, height: height * scale)
    }
    
    /// 调整尺寸，保持比例但限制最大尺寸
    /// - Parameter maxSize: 最大尺寸
    /// - Returns: 调整后的尺寸
    func constrained(to maxSize: CGSize) -> CGSize {
        return CGSize(
            width: min(width, maxSize.width),
            height: min(height, maxSize.height)
        )
    }
    
    /// 扩大尺寸，至少达到最小尺寸
    /// - Parameter minSize: 最小尺寸
    /// - Returns: 扩大后的尺寸
    func expanded(to minSize: CGSize) -> CGSize {
        return CGSize(
            width: max(width, minSize.width),
            height: max(height, minSize.height)
        )
    }
    
    /// 获取指定比例下的尺寸
    /// - Parameter aspectRatio: 比例（宽度/高度）
    /// - Returns: 保持指定比例且不小于当前尺寸的最小尺寸
    func maintainingAspectRatio(_ aspectRatio: CGFloat) -> CGSize {
        guard aspectRatio > 0 else { return self }
        
        if width / height > aspectRatio {
            // 当前比例大于目标比例，调整高度
            return CGSize(width: width, height: width / aspectRatio)
        } else {
            // 当前比例小于目标比例，调整宽度
            return CGSize(width: height * aspectRatio, height: height)
        }
    }
    
    /// 获取指定比例下的尺寸（裁剪方式）
    /// - Parameter aspectRatio: 比例（宽度/高度）
    /// - Returns: 保持指定比例且不大于当前尺寸的最大尺寸
    func croppingToAspectRatio(_ aspectRatio: CGFloat) -> CGSize {
        guard aspectRatio > 0 else { return self }
        
        if width / height > aspectRatio {
            // 当前比例大于目标比例，裁剪宽度
            return CGSize(width: height * aspectRatio, height: height)
        } else {
            // 当前比例小于目标比例，裁剪高度
            return CGSize(width: width, height: width / aspectRatio)
        }
    }
    
    /// 调整尺寸为正方形
    /// - Parameter side: 边长（默认为最大维度）
    /// - Returns: 正方形尺寸
    func squared(side: CGFloat? = nil) -> CGSize {
        let sideLength = side ?? maxDimension
        return CGSize(width: sideLength, height: sideLength)
    }
    
    /// 交换宽度和高度
    mutating func swapDimensions() {
        let temp = width
        width = height
        height = temp
    }
    
    /// 获取交换宽度和高度的尺寸
    /// - Returns: 交换后的尺寸
    func swapped() -> CGSize {
        return CGSize(width: height, height: width)
    }
    
    // MARK: - 边距处理
    
    /// 添加边距
    /// - Parameter padding: 边距（水平、垂直相同）
    /// - Returns: 添加边距后的尺寸
    func insetBy(padding: CGFloat) -> CGSize {
        return CGSize(width: max(0, width - 2 * padding), height: max(0, height - 2 * padding))
    }
    
    /// 添加边距
    /// - Parameters:
    ///   - horizontal: 水平边距
    ///   - vertical: 垂直边距
    /// - Returns: 添加边距后的尺寸
    func insetBy(horizontal: CGFloat, vertical: CGFloat) -> CGSize {
        return CGSize(width: max(0, width - 2 * horizontal), height: max(0, height - 2 * vertical))
    }
    
    /// 添加边距
    /// - Parameters:
    ///   - top: 上边距
    ///   - left: 左边距
    ///   - bottom: 下边距
    ///   - right: 右边距
    /// - Returns: 添加边距后的尺寸
    func insetBy(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGSize {
        return CGSize(
            width: max(0, width - left - right),
            height: max(0, height - top - bottom)
        )
    }
    
    // MARK: - 比较和判断
    
    /// 判断尺寸是否包含另一个尺寸
    /// - Parameter size: 另一个尺寸
    /// - Returns: 是否包含
    func contains(_ size: CGSize) -> Bool {
        return width >= size.width && height >= size.height
    }
    
    /// 判断尺寸是否被另一个尺寸包含
    /// - Parameter size: 另一个尺寸
    /// - Returns: 是否被包含
    func isContained(in size: CGSize) -> Bool {
        return width <= size.width && height <= size.height
    }
    
    /// 判断两个尺寸是否相似（在容差范围内）
    /// - Parameters:
    ///   - size: 另一个尺寸
    ///   - tolerance: 容差值
    /// - Returns: 是否相似
    func isSimilar(to size: CGSize, tolerance: CGFloat = 1e-6) -> Bool {
        return abs(width - size.width) <= tolerance && abs(height - size.height) <= tolerance
    }
    
    /// 判断尺寸是否在指定范围内
    /// - Parameters:
    ///   - minSize: 最小尺寸
    ///   - maxSize: 最大尺寸
    /// - Returns: 是否在范围内
    func isWithin(minSize: CGSize, maxSize: CGSize) -> Bool {
        return width >= minSize.width && height >= minSize.height &&
               width <= maxSize.width && height <= maxSize.height
    }
    
    // MARK: - 运算操作
    
    /// 尺寸相加
    static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    /// 尺寸相减
    static func - (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    /// 尺寸相乘（对应元素相乘）
    static func * (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width * right.width, height: left.height * right.height)
    }
    
    /// 尺寸相乘（标量）
    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width * scalar, height: size.height * scalar)
    }
    
    /// 尺寸相乘（标量）
    static func * (scalar: CGFloat, size: CGSize) -> CGSize {
        return size * scalar
    }
    
    /// 尺寸相除（标量）
    static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        guard scalar != 0 else { return size }
        return CGSize(width: size.width / scalar, height: size.height / scalar)
    }
    
    /// 尺寸取反
    static prefix func - (size: CGSize) -> CGSize {
        return CGSize(width: -size.width, height: -size.height)
    }
    
    // MARK: - 实用方法
    
    /// 创建正方形尺寸
    /// - Parameter side: 边长
    /// - Returns: 正方形尺寸
    static func square(_ side: CGFloat) -> CGSize {
        return CGSize(width: side, height: side)
    }
    
    /// 创建按比例缩放的尺寸
    /// - Parameters:
    ///   - baseSize: 基础尺寸
    ///   - scale: 缩放因子
    /// - Returns: 缩放后的尺寸
    static func scaled(_ baseSize: CGSize, by scale: CGFloat) -> CGSize {
        return baseSize.scaled(by: scale)
    }
    
    /// 获取最佳尺寸来包含一组尺寸
    /// - Parameter sizes: 尺寸数组
    /// - Returns: 包含所有尺寸的最佳尺寸
    static func bestSizeToContain(_ sizes: [CGSize]) -> CGSize {
        guard !sizes.isEmpty else { return .zero }
        
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for size in sizes {
            maxWidth = Swift.max(maxWidth, size.width)
            maxHeight = Swift.max(maxHeight, size.height)
        }
        
        return CGSize(width: maxWidth, height: maxHeight)
    }
    
    /// 获取最佳尺寸来适应一组尺寸
    /// - Parameter sizes: 尺寸数组
    /// - Returns: 适应所有尺寸的最佳尺寸
    static func bestSizeToFit(_ sizes: [CGSize]) -> CGSize {
        guard !sizes.isEmpty else { return .zero }
        
        var minWidth: CGFloat = .greatestFiniteMagnitude
        var minHeight: CGFloat = .greatestFiniteMagnitude
        
        for size in sizes {
            minWidth = Swift.min(minWidth, size.width)
            minHeight = Swift.min(minHeight, size.height)
        }
        
        return CGSize(width: minWidth, height: minHeight)
    }
    
    /// 将点转换为尺寸
    /// - Parameter point: 点
    /// - Returns: 尺寸
    init(_ point: CGPoint) {
        self.init(width: point.x, height: point.y)
    }
    
    /// 将矩形转换为尺寸
    /// - Parameter rect: 矩形
    /// - Returns: 尺寸
    init(_ rect: CGRect) {
        self.init(width: rect.width, height: rect.height)
    }
    
    // MARK: - 常见尺寸
    
    /// 获取设备相关尺寸（仅iOS）
    static var screen: CGSize {
        #if canImport(UIKit)
        return UIScreen.main.bounds.size
        #else
        return .zero
        #endif
    }
    
    /// 获取常见尺寸
    enum Common {
        /// iPhone SE (第二代) 屏幕尺寸
        static let iPhoneSE: CGSize = CGSize(width: 375, height: 667)
        /// iPhone 15 屏幕尺寸
        static let iPhone15: CGSize = CGSize(width: 390, height: 844)
        /// iPhone 15 Pro Max 屏幕尺寸
        static let iPhone15ProMax: CGSize = CGSize(width: 430, height: 932)
        /// iPad Pro 11英寸 屏幕尺寸
        static let iPadPro11: CGSize = CGSize(width: 834, height: 1194)
        /// iPad Pro 12.9英寸 屏幕尺寸
        static let iPadPro12_9: CGSize = CGSize(width: 1024, height: 1366)
        /// 标准A4纸尺寸（72 DPI）
        static let a4Paper: CGSize = CGSize(width: 595, height: 842)
        /// 标准信纸尺寸（72 DPI）
        static let letterPaper: CGSize = CGSize(width: 612, height: 792)
        /// 常见头像尺寸
        static let avatarSmall: CGSize = CGSize(width: 40, height: 40)
        static let avatarMedium: CGSize = CGSize(width: 60, height: 60)
        static let avatarLarge: CGSize = CGSize(width: 100, height: 100)
        /// 常见图标尺寸
        static let iconSmall: CGSize = CGSize(width: 24, height: 24)
        static let iconMedium: CGSize = CGSize(width: 32, height: 32)
        static let iconLarge: CGSize = CGSize(width: 48, height: 48)
        /// 常见按钮尺寸
        static let buttonSmall: CGSize = CGSize(width: 80, height: 36)
        static let buttonMedium: CGSize = CGSize(width: 120, height: 44)
        static let buttonLarge: CGSize = CGSize(width: 200, height: 50)
    }
}

// MARK: - 与CGPoint的交互

public extension CGSize {
    
    /// 将尺寸转换为点
    var asPoint: CGPoint {
        return CGPoint(x: width, y: height)
    }
    
    /// 获取尺寸的中心点（相对于原点）
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
    
    /// 获取尺寸的边界点
    var bounds: (topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        return (
            topLeft: CGPoint(x: 0, y: 0),
            topRight: CGPoint(x: width, y: 0),
            bottomLeft: CGPoint(x: 0, y: height),
            bottomRight: CGPoint(x: width, y: height)
        )
    }
    
    /// 获取矩形（以原点为起点）
    var rect: CGRect {
        return CGRect(origin: .zero, size: self)
    }
    
    /// 获取矩形（以指定点为起点）
    /// - Parameter origin: 起点
    /// - Returns: 矩形
    func rect(origin: CGPoint) -> CGRect {
        return CGRect(origin: origin, size: self)
    }
    
    /// 获取矩形（居中于指定点）
    /// - Parameter center: 中心点
    /// - Returns: 矩形
    func rect(centeredAt center: CGPoint) -> CGRect {
        return CGRect(
            x: center.x - width / 2,
            y: center.y - height / 2,
            width: width,
            height: height
        )
    }
}

// MARK: - 与CGRect的交互

public extension CGSize {
    
    /// 将矩形转换为尺寸
    static func size(of rect: CGRect) -> CGSize {
        return rect.size
    }
    
    /// 创建包含指定点的最小尺寸
    /// - Parameter point: 点
    /// - Returns: 包含点的最小尺寸
    static func containing(_ point: CGPoint) -> CGSize {
        return CGSize(width: abs(point.x), height: abs(point.y))
    }
    
    /// 创建包含多个点的最小尺寸
    /// - Parameter points: 点数组
    /// - Returns: 包含所有点的最小尺寸
    static func containing(_ points: [CGPoint]) -> CGSize {
        guard !points.isEmpty else { return .zero }
        
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude
        
        for point in points {
            minX = min(minX, point.x)
            minY = min(minY, point.y)
            maxX = max(maxX, point.x)
            maxY = max(maxY, point.y)
        }
        
        return CGSize(width: maxX - minX, height: maxY - minY)
    }
}

// MARK: - CGSize 数组扩展

public extension Array where Element == CGSize {
    
    /// 计算尺寸数组的总面积
    var totalArea: CGFloat {
        return reduce(0) { $0 + $1.area }
    }
    
    /// 计算尺寸数组的平均尺寸
    var averageSize: CGSize? {
        guard !isEmpty else { return nil }
        
        var totalWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        
        for size in self {
            totalWidth += size.width
            totalHeight += size.height
        }
        
        let count = CGFloat(self.count)
        return CGSize(width: totalWidth / count, height: totalHeight / count)
    }
    
    /// 获取最大尺寸
    var maxSize: CGSize? {
        guard !isEmpty else { return nil }
        
        var result = self[0]
        for size in self.dropFirst() {
            result = CGSize(
                width: Swift.max(result.width, size.width),
                height: Swift.max(result.height, size.height)
            )
        }
        return result
    }
    
    /// 获取最小尺寸
    var minSize: CGSize? {
        guard !isEmpty else { return nil }
        
        var result = self[0]
        for size in self.dropFirst() {
            result = CGSize(
                width: Swift.min(result.width, size.width),
                height: Swift.min(result.height, size.height)
            )
        }
        return result
    }
    
    /// 筛选出正方形尺寸
    var squares: [CGSize] {
        return filter { $0.isSquare }
    }
    
    /// 筛选出符合条件的尺寸
    /// - Parameter predicate: 筛选条件
    /// - Returns: 符合条件的尺寸数组
    func filtered(by predicate: (CGSize) -> Bool) -> [CGSize] {
        return filter(predicate)
    }
    
    /// 映射尺寸数组
    /// - Parameter transform: 转换函数
    /// - Returns: 转换后的尺寸数组
    func mapSizes(_ transform: (CGSize) -> CGSize) -> [CGSize] {
        return map(transform)
    }
    
    /// 按比例缩放所有尺寸
    /// - Parameter scale: 缩放因子
    /// - Returns: 缩放后的尺寸数组
    func scaled(by scale: CGFloat) -> [CGSize] {
        return map { $0.scaled(by: scale) }
    }
    
    /// 按条件分组
    /// - Parameter condition: 分组条件
    /// - Returns: 分组后的字典
    func grouped(by condition: (CGSize) -> Bool) -> [Bool: [CGSize]] {
        var result: [Bool: [CGSize]] = [:]
        for size in self {
            let key = condition(size)
            result[key, default: []].append(size)
        }
        return result
    }
}