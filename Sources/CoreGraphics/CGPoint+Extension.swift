// CGPoint+Extension.swift
// Core Graphics 点扩展，提供便捷的几何计算和操作方法

import CoreGraphics

public extension CGPoint {
    
    // MARK: - 属性和计算属性
    
    /// 原点的零向量
    static var zero: CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    /// 单位向量（1, 1）
    static var one: CGPoint {
        return CGPoint(x: 1, y: 1)
    }
    
    /// 点的大小（长度），从原点到该点的距离
    var magnitude: CGFloat {
        return sqrt(x * x + y * y)
    }
    
    /// 点的平方大小，避免开方计算
    var magnitudeSquared: CGFloat {
        return x * x + y * y
    }
    
    /// 点的角度（弧度），相对于X轴正方向
    var angle: CGFloat {
        return atan2(y, x)
    }
    
    /// 判断点是否在原点附近（容差范围内）
    var isNearOrigin: Bool {
        return magnitudeSquared < 1e-6
    }
    
    /// 判断点是否有效（非无穷大和非NaN）
    var isValid: Bool {
        return x.isFinite && y.isFinite && !x.isNaN && !y.isNaN
    }
    
    // MARK: - 向量操作
    
    /// 获取单位向量（归一化）
    var normalized: CGPoint {
        let length = magnitude
        guard length > 0 else { return .zero }
        return CGPoint(x: x / length, y: y / length)
    }
    
    /// 归一化向量
    mutating func normalize() {
        let length = magnitude
        guard length > 0 else { return }
        x /= length
        y /= length
    }
    
    /// 限制向量的大小在指定范围内
    /// - Parameter maxLength: 最大长度
    mutating func limit(_ maxLength: CGFloat) {
        let currentLength = magnitude
        guard currentLength > maxLength else { return }
        let scale = maxLength / currentLength
        x *= scale
        y *= scale
    }
    
    /// 获取限制大小后的向量
    /// - Parameter maxLength: 最大长度
    /// - Returns: 限制后的向量
    func limited(_ maxLength: CGFloat) -> CGPoint {
        var result = self
        result.limit(maxLength)
        return result
    }
    
    /// 缩放向量
    /// - Parameter scale: 缩放因子
    mutating func scale(by scale: CGFloat) {
        x *= scale
        y *= scale
    }
    
    /// 获取缩放后的向量
    /// - Parameter scale: 缩放因子
    /// - Returns: 缩放后的向量
    func scaled(by scale: CGFloat) -> CGPoint {
        return CGPoint(x: x * scale, y: y * scale)
    }
    
    /// 旋转向量
    /// - Parameter angle: 旋转角度（弧度）
    mutating func rotate(by angle: CGFloat) {
        let cosA = cos(angle)
        let sinA = sin(angle)
        let newX = x * cosA - y * sinA
        let newY = x * sinA + y * cosA
        x = newX
        y = newY
    }
    
    /// 获取旋转后的向量
    /// - Parameter angle: 旋转角度（弧度）
    /// - Returns: 旋转后的向量
    func rotated(by angle: CGFloat) -> CGPoint {
        var result = self
        result.rotate(by: angle)
        return result
    }
    
    // MARK: - 距离计算
    
    /// 计算到另一个点的距离
    /// - Parameter point: 另一个点
    /// - Returns: 距离
    func distance(to point: CGPoint) -> CGFloat {
        let dx = point.x - x
        let dy = point.y - y
        return sqrt(dx * dx + dy * dy)
    }
    
    /// 计算到另一个点的平方距离，避免开方计算
    /// - Parameter point: 另一个点
    /// - Returns: 平方距离
    func distanceSquared(to point: CGPoint) -> CGFloat {
        let dx = point.x - x
        let dy = point.y - y
        return dx * dx + dy * dy
    }
    
    /// 计算到原点的曼哈顿距离
    var manhattanDistance: CGFloat {
        return abs(x) + abs(y)
    }
    
    /// 计算到另一个点的曼哈顿距离
    /// - Parameter point: 另一个点
    /// - Returns: 曼哈顿距离
    func manhattanDistance(to point: CGPoint) -> CGFloat {
        return abs(point.x - x) + abs(point.y - y)
    }
    
    /// 计算两个点之间的中间点
    /// - Parameter point: 另一个点
    /// - Returns: 中间点
    func midpoint(with point: CGPoint) -> CGPoint {
        return CGPoint(x: (x + point.x) * 0.5, y: (y + point.y) * 0.5)
    }
    
    /// 计算两点之间的线性插值
    /// - Parameters:
    ///   - point: 另一个点
    ///   - t: 插值因子（0.0 到 1.0）
    /// - Returns: 插值点
    func lerp(to point: CGPoint, t: CGFloat) -> CGPoint {
        return CGPoint(
            x: x + (point.x - x) * t,
            y: y + (point.y - y) * t
        )
    }
    
    // MARK: - 几何关系
    
    /// 判断点是否在矩形内
    /// - Parameter rect: 矩形
    /// - Returns: 是否在矩形内
    func isInside(_ rect: CGRect) -> Bool {
        return rect.contains(self)
    }
    
    /// 判断点是否在圆形内
    /// - Parameters:
    ///   - center: 圆心
    ///   - radius: 半径
    /// - Returns: 是否在圆形内
    func isInsideCircle(center: CGPoint, radius: CGFloat) -> Bool {
        return distanceSquared(to: center) <= radius * radius
    }
    
    /// 获取点在矩形内的投影（如果点在矩形外，则投影到最近的边上）
    /// - Parameter rect: 矩形
    /// - Returns: 投影点
    func clamped(to rect: CGRect) -> CGPoint {
        return CGPoint(
            x: max(rect.minX, min(rect.maxX, x)),
            y: max(rect.minY, min(rect.maxY, y))
        )
    }
    
    /// 获取点到矩形最近的点
    /// - Parameter rect: 矩形
    /// - Returns: 最近的点
    func nearestPoint(to rect: CGRect) -> CGPoint {
        if rect.contains(self) {
            return self
        }
        
        let clampedX = max(rect.minX, min(rect.maxX, x))
        let clampedY = max(rect.minY, min(rect.maxY, y))
        
        return CGPoint(x: clampedX, y: clampedY)
    }
    
    /// 判断点是否在直线上（容差范围内）
    /// - Parameters:
    ///   - start: 直线起点
    ///   - end: 直线终点
    ///   - tolerance: 容差
    /// - Returns: 是否在直线上
    func isOnLine(from start: CGPoint, to end: CGPoint, tolerance: CGFloat = 1e-6) -> Bool {
        // 使用点到直线距离公式
        let dx = end.x - start.x
        let dy = end.y - start.y
        
        guard dx != 0 || dy != 0 else {
            // 起点和终点重合
            return distance(to: start) <= tolerance
        }
        
        // 点到直线的距离公式
        let numerator = abs(dy * x - dx * y + end.x * start.y - end.y * start.x)
        let denominator = sqrt(dx * dx + dy * dy)
        let distance = numerator / denominator
        
        return distance <= tolerance
    }
    
    // MARK: - 向量运算
    
    /// 向量点积
    /// - Parameter point: 另一个点
    /// - Returns: 点积结果
    func dot(_ point: CGPoint) -> CGFloat {
        return x * point.x + y * point.y
    }
    
    /// 向量叉积（2D叉积实际上是标量）
    /// - Parameter point: 另一个点
    /// - Returns: 叉积结果
    func cross(_ point: CGPoint) -> CGFloat {
        return x * point.y - y * point.x
    }
    
    /// 向量加法
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    /// 向量减法
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    /// 向量乘法（标量）
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    /// 向量乘法（标量）
    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        return point * scalar
    }
    
    /// 向量除法（标量）
    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        guard scalar != 0 else { return point }
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }
    
    /// 向量取反
    static prefix func - (point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    // MARK: - 实用方法
    
    /// 创建极坐标点
    /// - Parameters:
    ///   - radius: 半径
    ///   - angle: 角度（弧度）
    /// - Returns: 极坐标点
    static func polar(radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: radius * cos(angle), y: radius * sin(angle))
    }
    
    /// 获取点与水平轴的夹角
    /// - Parameter point: 另一个点
    /// - Returns: 夹角（弧度）
    func angle(to point: CGPoint) -> CGFloat {
        return atan2(point.y - y, point.x - x)
    }
    
    /// 反射点（相对于另一个点）
    /// - Parameter center: 反射中心
    /// - Returns: 反射点
    func reflected(across center: CGPoint) -> CGPoint {
        return CGPoint(
            x: 2 * center.x - x,
            y: 2 * center.y - y
        )
    }
    
    /// 绕另一个点旋转
    /// - Parameters:
    ///   - center: 旋转中心
    ///   - angle: 旋转角度（弧度）
    /// - Returns: 旋转后的点
    func rotated(around center: CGPoint, by angle: CGFloat) -> CGPoint {
        let translated = self - center
        let rotated = translated.rotated(by: angle)
        return rotated + center
    }
    
    /// 绕另一个点缩放
    /// - Parameters:
    ///   - center: 缩放中心
    ///   - scale: 缩放因子
    /// - Returns: 缩放后的点
    func scaled(around center: CGPoint, by scale: CGFloat) -> CGPoint {
        let translated = self - center
        let scaled = translated.scaled(by: scale)
        return scaled + center
    }
    
    /// 判断三个点是否共线
    /// - Parameters:
    ///   - p1: 第一个点
    ///   - p2: 第二个点
    ///   - tolerance: 容差
    /// - Returns: 是否共线
    func isCollinear(with p1: CGPoint, and p2: CGPoint, tolerance: CGFloat = 1e-6) -> Bool {
        // 使用三角形面积为零的判断
        let area = abs((p1.x - x) * (p2.y - y) - (p1.y - y) * (p2.x - x))
        return area <= tolerance
    }
    
    /// 获取点到直线的最短距离
    /// - Parameters:
    ///   - lineStart: 直线起点
    ///   - lineEnd: 直线终点
    /// - Returns: 最短距离
    func distanceToLine(from lineStart: CGPoint, to lineEnd: CGPoint) -> CGFloat {
        let dx = lineEnd.x - lineStart.x
        let dy = lineEnd.y - lineStart.y
        
        guard dx != 0 || dy != 0 else {
            // 起点和终点重合
            return distance(to: lineStart)
        }
        
        let numerator = abs(dy * x - dx * y + lineEnd.x * lineStart.y - lineEnd.y * lineStart.x)
        let denominator = sqrt(dx * dx + dy * dy)
        
        return numerator / denominator
    }
    
    /// 获取点到线段的最短距离
    /// - Parameters:
    ///   - segmentStart: 线段起点
    ///   - segmentEnd: 线段终点
    /// - Returns: 最短距离
    func distanceToSegment(from segmentStart: CGPoint, to segmentEnd: CGPoint) -> CGFloat {
        let lineLengthSquared = segmentStart.distanceSquared(to: segmentEnd)
        
        if lineLengthSquared == 0 {
            // 线段退化为点
            return distance(to: segmentStart)
        }
        
        // 计算投影参数 t
        let t = max(0, min(1, ((x - segmentStart.x) * (segmentEnd.x - segmentStart.x) +
                              (y - segmentStart.y) * (segmentEnd.y - segmentStart.y)) / lineLengthSquared))
        
        // 计算投影点
        let projection = CGPoint(
            x: segmentStart.x + t * (segmentEnd.x - segmentStart.x),
            y: segmentStart.y + t * (segmentEnd.y - segmentStart.y)
        )
        
        return distance(to: projection)
    }
}

// MARK: - CGPoint 数组扩展

public extension Array where Element == CGPoint {
    
    /// 计算点集的边界矩形
    var boundingRect: CGRect? {
        guard !isEmpty else { return nil }
        
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude
        
        for point in self {
            minX = Swift.min(minX, point.x)
            minY = Swift.min(minY, point.y)
            maxX = Swift.max(maxX, point.x)
            maxY = Swift.max(maxY, point.y)
        }
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    /// 计算点集的中心点
    var center: CGPoint? {
        guard !isEmpty else { return nil }
        
        var sumX: CGFloat = 0
        var sumY: CGFloat = 0
        
        for point in self {
            sumX += point.x
            sumY += point.y
        }
        
        let count = CGFloat(self.count)
        return CGPoint(x: sumX / count, y: sumY / count)
    }
    
    /// 计算点集的总路径长度
    var pathLength: CGFloat {
        guard count > 1 else { return 0 }
        
        var length: CGFloat = 0
        for i in 1..<count {
            length += self[i-1].distance(to: self[i])
        }
        return length
    }
    
    /// 在点集中查找最近的点
    /// - Parameter point: 参考点
    /// - Returns: 最近点的索引和距离
    func nearestPoint(to point: CGPoint) -> (index: Int, distance: CGFloat)? {
        guard !isEmpty else { return nil }
        
        var nearestIndex = 0
        var minDistance = self[0].distance(to: point)
        
        for i in 1..<count {
            let distance = self[i].distance(to: point)
            if distance < minDistance {
                minDistance = distance
                nearestIndex = i
            }
        }
        
        return (nearestIndex, minDistance)
    }
    
    /// 对点集进行平滑处理（移动平均）
    /// - Parameter windowSize: 窗口大小
    /// - Returns: 平滑后的点集
    func smoothed(windowSize: Int = 3) -> [CGPoint] {
        guard count >= windowSize else { return self }
        
        var result: [CGPoint] = []
        
        for i in 0..<count {
            let start = max(0, i - windowSize / 2)
            let end = min(count - 1, i + windowSize / 2)
            
            var sumX: CGFloat = 0
            var sumY: CGFloat = 0
            let windowCount = end - start + 1
            
            for j in start...end {
                sumX += self[j].x
                sumY += self[j].y
            }
            
            result.append(CGPoint(x: sumX / CGFloat(windowCount), y: sumY / CGFloat(windowCount)))
        }
        
        return result
    }
}

// MARK: - 与CGSize的交互

public extension CGPoint {
    
    /// 将点转换为大小
    var asSize: CGSize {
        return CGSize(width: x, height: y)
    }
    
    /// 从大小创建点
    /// - Parameter size: 大小
    init(_ size: CGSize) {
        self.init(x: size.width, y: size.height)
    }
}

// MARK: - 与CGRect的交互

public extension CGPoint {
    
    /// 从矩形创建点（矩形的原点）
    /// - Parameter rect: 矩形
    init(_ rect: CGRect) {
        self.init(x: rect.origin.x, y: rect.origin.y)
    }
    
    /// 获取点在矩形内的相对位置（归一化坐标）
    /// - Parameter rect: 矩形
    /// - Returns: 相对位置（0到1之间）
    func relativePosition(in rect: CGRect) -> CGPoint {
        guard rect.width > 0 && rect.height > 0 else {
            return CGPoint(x: 0.5, y: 0.5)
        }
        
        return CGPoint(
            x: (x - rect.minX) / rect.width,
            y: (y - rect.minY) / rect.height
        )
    }
    
    /// 从相对位置获取绝对位置
    /// - Parameters:
    ///   - relativePosition: 相对位置（0到1之间）
    ///   - rect: 矩形
    /// - Returns: 绝对位置
    static func fromRelativePosition(_ relativePosition: CGPoint, in rect: CGRect) -> CGPoint {
        return CGPoint(
            x: rect.minX + relativePosition.x * rect.width,
            y: rect.minY + relativePosition.y * rect.height
        )
    }
}