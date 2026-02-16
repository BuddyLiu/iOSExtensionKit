// CGRect+Extension.swift
// Core Graphics 矩形扩展，提供便捷的几何计算和操作

import CoreGraphics

/// 跨平台的边距结构（类似于 UIEdgeInsets）
public struct EdgeInsets {
    public var top: CGFloat
    public var left: CGFloat
    public var bottom: CGFloat
    public var right: CGFloat
    
    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    public init(all: CGFloat) {
        self.top = all
        self.left = all
        self.bottom = all
        self.right = all
    }
    
    public var horizontal: CGFloat {
        return left + right
    }
    
    public var vertical: CGFloat {
        return top + bottom
    }
}

/// 点之间的距离计算辅助函数
private func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
    let dx = point2.x - point1.x
    let dy = point2.y - point1.y
    return sqrt(dx * dx + dy * dy)
}

public extension CGRect {
    
    // MARK: - 属性和计算属性
    
    /// 矩形的中心点
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    /// 矩形的左上角
    var topLeft: CGPoint {
        return origin
    }
    
    /// 矩形的右上角
    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }
    
    /// 矩形的左下角
    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }
    
    /// 矩形的右下角
    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    
    /// 矩形的顶部中心点
    var topCenter: CGPoint {
        return CGPoint(x: midX, y: minY)
    }
    
    /// 矩形的底部中心点
    var bottomCenter: CGPoint {
        return CGPoint(x: midX, y: maxY)
    }
    
    /// 矩形的左侧中心点
    var leftCenter: CGPoint {
        return CGPoint(x: minX, y: midY)
    }
    
    /// 矩形的右侧中心点
    var rightCenter: CGPoint {
        return CGPoint(x: maxX, y: midY)
    }
    
    /// 矩形的面积
    var area: CGFloat {
        return width * height
    }
    
    /// 检查矩形是否有效（非负宽高）
    var isValid: Bool {
        return width >= 0 && height >= 0
    }
    
    /// 检查矩形是否是正方形
    var isSquare: Bool {
        return abs(width - height) < CGFloat.ulpOfOne
    }
    
    /// 检查矩形是否为空
    var isEmpty: Bool {
        return width <= 0 || height <= 0
    }
    
    /// 矩形的缩放因子（基于原始大小的比例）
    var aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }
    
    // MARK: - 变换方法
    
    /// 将矩形缩放到指定大小
    /// - Parameter size: 目标大小
    /// - Returns: 缩放后的矩形（保持中心点不变）
    func scaled(to size: CGSize) -> CGRect {
        let scaleX = size.width / width
        let scaleY = size.height / height
        return CGRect(
            x: origin.x,
            y: origin.y,
            width: width * scaleX,
            height: height * scaleY
        )
    }
    
    /// 按比例缩放矩形
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的矩形（保持中心点不变）
    func scaled(by scale: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x,
            y: origin.y,
            width: width * scale,
            height: height * scale
        )
    }
    
    /// 移动矩形到指定点
    /// - Parameter point: 新的原点
    /// - Returns: 移动后的矩形
    func moved(to point: CGPoint) -> CGRect {
        return CGRect(origin: point, size: size)
    }
    
    /// 移动矩形
    /// - Parameter offset: 偏移量
    /// - Returns: 移动后的矩形
    func moved(by offset: CGPoint) -> CGRect {
        return CGRect(origin: CGPoint(x: origin.x + offset.x, y: origin.y + offset.y), size: size)
    }
    
    /// 调整矩形大小
    /// - Parameter size: 新的尺寸
    /// - Returns: 调整后的矩形（保持原点不变）
    func resized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    /// 调整矩形大小
    /// - Parameters:
    ///   - width: 新的宽度
    ///   - height: 新的高度
    /// - Returns: 调整后的矩形（保持原点不变）
    func resized(width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(origin: origin, size: CGSize(width: width, height: height))
    }
    
    /// 保持中心点不变，调整矩形大小
    /// - Parameter size: 新的尺寸
    /// - Returns: 调整后的矩形
    func resizedKeepingCenter(to size: CGSize) -> CGRect {
        let dx = (size.width - width) / 2
        let dy = (size.height - height) / 2
        return CGRect(
            x: origin.x - dx,
            y: origin.y - dy,
            width: size.width,
            height: size.height
        )
    }
    
    /// 设置矩形的中心点
    /// - Parameter point: 新的中心点
    /// - Returns: 调整后的矩形
    func withCenter(_ point: CGPoint) -> CGRect {
        return CGRect(
            x: point.x - width / 2,
            y: point.y - height / 2,
            width: width,
            height: height
        )
    }
    
    // MARK: - 边距和内边距
    
    /// 向内缩小矩形（添加内边距）
    /// - Parameter insets: 内边距值
    /// - Returns: 缩小后的矩形
    func inset(by insets: EdgeInsets) -> CGRect {
        return CGRect(
            x: origin.x + insets.left,
            y: origin.y + insets.top,
            width: width - insets.left - insets.right,
            height: height - insets.top - insets.bottom
        )
    }
    
    /// 向内缩小矩形（统一值）
    /// - Parameter value: 统一内边距
    /// - Returns: 缩小后的矩形
    func inset(by value: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x + value,
            y: origin.y + value,
            width: width - value * 2,
            height: height - value * 2
        )
    }
    
    /// 向外扩大矩形（添加外边距）
    /// - Parameter value: 外边距值
    /// - Returns: 扩大后的矩形
    func outset(by value: CGFloat) -> CGRect {
        return inset(by: -value)
    }
    
    /// 获取矩形内的安全区域（防止负数尺寸）
    var safeRect: CGRect {
        let safeOrigin = CGPoint(x: max(0, origin.x), y: max(0, origin.y))
        let safeWidth = max(0, width)
        let safeHeight = max(0, height)
        return CGRect(origin: safeOrigin, size: CGSize(width: safeWidth, height: safeHeight))
    }
    
    // MARK: - 对齐和布局
    
    /// 在另一个矩形内居中
    /// - Parameter rect: 容器矩形
    /// - Returns: 居中的矩形
    func centered(in rect: CGRect) -> CGRect {
        let x = rect.origin.x + (rect.width - width) / 2
        let y = rect.origin.y + (rect.height - height) / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    /// 在另一个矩形内水平居中
    /// - Parameter rect: 容器矩形
    /// - Returns: 水平居中的矩形
    func centeredHorizontally(in rect: CGRect) -> CGRect {
        let x = rect.origin.x + (rect.width - width) / 2
        return CGRect(x: x, y: origin.y, width: width, height: height)
    }
    
    /// 在另一个矩形内垂直居中
    /// - Parameter rect: 容器矩形
    /// - Returns: 垂直居中的矩形
    func centeredVertically(in rect: CGRect) -> CGRect {
        let y = rect.origin.y + (rect.height - height) / 2
        return CGRect(x: origin.x, y: y, width: width, height: height)
    }
    
    /// 对齐到另一个矩形的顶部
    /// - Parameter rect: 参考矩形
    /// - Returns: 对齐后的矩形
    func alignedTop(to rect: CGRect, spacing: CGFloat = 0) -> CGRect {
        return CGRect(x: origin.x, y: rect.minY - height - spacing, width: width, height: height)
    }
    
    /// 对齐到另一个矩形的底部
    /// - Parameter rect: 参考矩形
    /// - Returns: 对齐后的矩形
    func alignedBottom(to rect: CGRect, spacing: CGFloat = 0) -> CGRect {
        return CGRect(x: origin.x, y: rect.maxY + spacing, width: width, height: height)
    }
    
    /// 对齐到另一个矩形的左侧
    /// - Parameter rect: 参考矩形
    /// - Returns: 对齐后的矩形
    func alignedLeft(to rect: CGRect, spacing: CGFloat = 0) -> CGRect {
        return CGRect(x: rect.minX - width - spacing, y: origin.y, width: width, height: height)
    }
    
    /// 对齐到另一个矩形的右侧
    /// - Parameter rect: 参考矩形
    /// - Returns: 对齐后的矩形
    func alignedRight(to rect: CGRect, spacing: CGFloat = 0) -> CGRect {
        return CGRect(x: rect.maxX + spacing, y: origin.y, width: width, height: height)
    }
    
    /// 将矩形放置在另一个矩形的内部
    /// - Parameters:
    ///   - rect: 容器矩形
    ///   - horizontalAlignment: 水平对齐方式
    ///   - verticalAlignment: 垂直对齐方式
    /// - Returns: 放置后的矩形
    func placed(in rect: CGRect, horizontalAlignment: HorizontalAlignment = .center, verticalAlignment: VerticalAlignment = .center) -> CGRect {
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        switch horizontalAlignment {
        case .left:
            x = rect.minX
        case .center:
            x = rect.minX + (rect.width - width) / 2
        case .right:
            x = rect.maxX - width
        }
        
        switch verticalAlignment {
        case .top:
            y = rect.minY
        case .center:
            y = rect.minY + (rect.height - height) / 2
        case .bottom:
            y = rect.maxY - height
        }
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // MARK: - 几何计算
    
    /// 计算两个矩形的交集，如果没有交集则返回 nil
    /// - Parameter rect: 另一个矩形
    /// - Returns: 交集矩形，如果没有交集则返回 nil
    func intersected(with rect: CGRect) -> CGRect? {
        let intersected = self.intersection(rect)
        return intersected.isNull ? nil : intersected
    }
    
    /// 计算两个矩形的并集
    /// - Parameter rect: 另一个矩形
    /// - Returns: 并集矩形
    func united(with rect: CGRect) -> CGRect {
        return self.union(rect)
    }
    
    /// 检查是否完全包含另一个矩形
    /// - Parameter rect: 要检查的矩形
    /// - Returns: 是否完全包含
    func fullyContains(_ rect: CGRect) -> Bool {
        return self.contains(rect)
    }
    
    /// 检查是否与另一个矩形相交
    /// - Parameter rect: 要检查的矩形
    /// - Returns: 是否相交
    func intersects(with rect: CGRect) -> Bool {
        return self.intersects(rect)
    }
    
    /// 计算两点之间的距离（矩形中心到另一点）
    /// - Parameter point: 另一个点
    /// - Returns: 距离
    func distance(to point: CGPoint) -> CGFloat {
        return distanceBetween(center, point)
    }
    
    /// 计算两个矩形之间的距离
    /// - Parameter rect: 另一个矩形
    /// - Returns: 距离
    func distance(to rect: CGRect) -> CGFloat {
        return distanceBetween(center, rect.center)
    }
    
    /// 获取矩形的缩放因子以适应另一个矩形
    /// - Parameter rect: 目标矩形
    /// - Returns: 缩放因子
    func scaleFactor(toFit rect: CGRect) -> CGFloat {
        let widthScale = rect.width / width
        let heightScale = rect.height / height
        return Swift.min(widthScale, heightScale)
    }
    
    /// 获取矩形的缩放因子以填充另一个矩形
    /// - Parameter rect: 目标矩形
    /// - Returns: 缩放因子
    func scaleFactor(toFill rect: CGRect) -> CGFloat {
        let widthScale = rect.width / width
        let heightScale = rect.height / height
        return Swift.max(widthScale, heightScale)
    }
    
    // MARK: - 分割和网格
    
    /// 将矩形水平分割为多个部分
    /// - Parameters:
    ///   - count: 分割数量
    ///   - spacing: 间距
    /// - Returns: 分割后的矩形数组
    func splitHorizontally(count: Int, spacing: CGFloat = 0) -> [CGRect] {
        guard count > 0 else { return [] }
        
        let totalSpacing = CGFloat(count - 1) * spacing
        let itemWidth = (width - totalSpacing) / CGFloat(count)
        
        var rects: [CGRect] = []
        for i in 0..<count {
            let x = origin.x + CGFloat(i) * (itemWidth + spacing)
            let rect = CGRect(x: x, y: origin.y, width: itemWidth, height: height)
            rects.append(rect)
        }
        
        return rects
    }
    
    /// 将矩形垂直分割为多个部分
    /// - Parameters:
    ///   - count: 分割数量
    ///   - spacing: 间距
    /// - Returns: 分割后的矩形数组
    func splitVertically(count: Int, spacing: CGFloat = 0) -> [CGRect] {
        guard count > 0 else { return [] }
        
        let totalSpacing = CGFloat(count - 1) * spacing
        let itemHeight = (height - totalSpacing) / CGFloat(count)
        
        var rects: [CGRect] = []
        for i in 0..<count {
            let y = origin.y + CGFloat(i) * (itemHeight + spacing)
            let rect = CGRect(x: origin.x, y: y, width: width, height: itemHeight)
            rects.append(rect)
        }
        
        return rects
    }
    
    /// 将矩形分割为网格
    /// - Parameters:
    ///   - rows: 行数
    ///   - columns: 列数
    ///   - rowSpacing: 行间距
    ///   - columnSpacing: 列间距
    /// - Returns: 网格矩形数组
    func splitGrid(rows: Int, columns: Int, rowSpacing: CGFloat = 0, columnSpacing: CGFloat = 0) -> [[CGRect]] {
        guard rows > 0 && columns > 0 else { return [] }
        
        let totalRowSpacing = CGFloat(rows - 1) * rowSpacing
        let totalColumnSpacing = CGFloat(columns - 1) * columnSpacing
        
        let cellWidth = (width - totalColumnSpacing) / CGFloat(columns)
        let cellHeight = (height - totalRowSpacing) / CGFloat(rows)
        
        var grid: [[CGRect]] = []
        for row in 0..<rows {
            var rowRects: [CGRect] = []
            for col in 0..<columns {
                let x = origin.x + CGFloat(col) * (cellWidth + columnSpacing)
                let y = origin.y + CGFloat(row) * (cellHeight + rowSpacing)
                let rect = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
                rowRects.append(rect)
            }
            grid.append(rowRects)
        }
        
        return grid
    }
    
    // MARK: - 工厂方法
    
    /// 创建以指定点为中心的矩形
    /// - Parameters:
    ///   - center: 中心点
    ///   - size: 尺寸
    /// - Returns: 矩形
    static func centered(at center: CGPoint, size: CGSize) -> CGRect {
        return CGRect(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }
    
    /// 创建覆盖多个点的边界矩形
    /// - Parameter points: 点数组
    /// - Returns: 边界矩形
    static func boundingRect(for points: [CGPoint]) -> CGRect? {
        guard !points.isEmpty else { return nil }
        
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude
        
        for point in points {
            minX = Swift.min(minX, point.x)
            minY = Swift.min(minY, point.y)
            maxX = Swift.max(maxX, point.x)
            maxY = Swift.max(maxY, point.y)
        }
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}

// MARK: - 对齐枚举

/// 水平对齐方式
public enum HorizontalAlignment {
    case left
    case center
    case right
}

/// 垂直对齐方式
public enum VerticalAlignment {
    case top
    case center
    case bottom
}

// MARK: - CGRect 数组扩展

public extension Array where Element == CGRect {
    
    /// 计算数组中所有矩形的并集
    var union: CGRect? {
        guard let firstRect = first else { return nil }
        
        var result = firstRect
        for rect in dropFirst() {
            result = result.union(rect)
        }
        return result
    }
    
    /// 计算数组中所有矩形的边界矩形
    var boundingRect: CGRect? {
        guard !isEmpty else { return nil }
        
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude
        
        for rect in self {
            minX = Swift.min(minX, rect.minX)
            minY = Swift.min(minY, rect.minY)
            maxX = Swift.max(maxX, rect.maxX)
            maxY = Swift.max(maxY, rect.maxY)
        }
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}