#if canImport(UIKit)
// UIColor+Extension.swift
// UIColor扩展，提供便捷的颜色操作方法

import UIKit

public extension UIColor {
    
    // MARK: - 初始化方法
    
    /// 通过十六进制字符串创建颜色
    /// - Parameters:
    ///   - hex: 十六进制字符串，格式为"#RRGGBB"或"#RRGGBBAA"
    ///   - alpha: 透明度（0.0-1.0），如果十六进制字符串包含透明度，则此参数会被忽略
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 去除 # 前缀
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        // 检查长度
        guard hexString.count == 6 || hexString.count == 8 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        if hexString.count == 6 {
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha
            )
        } else {
            self.init(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0
            )
        }
    }
    
    /// 通过RGB整数值创建颜色
    /// - Parameters:
    ///   - red: 红色分量（0-255）
    ///   - green: 绿色分量（0-255）
    ///   - blue: 蓝色分量（0-255）
    ///   - alpha: 透明度（0.0-1.0）
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
    
    /// 随机颜色
    /// - Parameter alpha: 透明度（0.0-1.0）
    static func random(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: alpha
        )
    }
    
    // MARK: - 属性扩展
    
    /// 颜色的十六进制表示
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * 255),
                Int(green * 255),
                Int(blue * 255)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * 255),
                Int(green * 255),
                Int(blue * 255),
                Int(alpha * 255)
            )
        }
    }
    
    /// 颜色的RGB分量
    var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        return (red, green, blue, alpha)
    }
    
    /// 颜色的亮度（0.0-1.0）
    var brightness: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        guard getRed(&red, green: &green, blue: &blue, alpha: nil) else {
            return 0
        }
        
        // 使用标准亮度计算公式
        return (red * 0.299) + (green * 0.587) + (blue * 0.114)
    }
    
    /// 判断颜色是否是亮色（适合使用深色文字）
    var isLight: Bool {
        return brightness > 0.5
    }
    
    /// 判断颜色是否是暗色（适合使用浅色文字）
    var isDark: Bool {
        return brightness <= 0.5
    }
    
    /// 获取最适合的文本颜色（黑色或白色）
    var textColor: UIColor {
        return isDark ? .white : .black
    }
    
    // MARK: - 颜色操作
    
    /// 调整颜色的亮度
    /// - Parameter factor: 亮度调整因子（-1.0 到 1.0）
    /// - Returns: 调整后的颜色
    func withBrightness(factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        
        let newBrightness = max(0, min(1, brightness + factor))
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    
    /// 调整颜色的饱和度
    /// - Parameter factor: 饱和度调整因子（-1.0 到 1.0）
    /// - Returns: 调整后的颜色
    func withSaturation(factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        
        let newSaturation = max(0, min(1, saturation + factor))
        return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
    }
    
    /// 调整颜色的透明度
    /// - Parameter alpha: 新的透明度（0.0-1.0）
    /// - Returns: 调整后的颜色
    func withAlpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
    /// 获取颜色的互补色
    var complementary: UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        
        // 互补色：色相旋转180度
        let complementaryHue = fmod(hue + 0.5, 1.0)
        return UIColor(hue: complementaryHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// 获取颜色的相似色（同色系不同亮度/饱和度）
    /// - Parameters:
    ///   - brightnessDelta: 亮度变化量
    ///   - saturationDelta: 饱和度变化量
    /// - Returns: 相似色
    func analogous(brightnessDelta: CGFloat = 0, saturationDelta: CGFloat = 0) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        
        let newBrightness = max(0, min(1, brightness + brightnessDelta))
        let newSaturation = max(0, min(1, saturation + saturationDelta))
        
        return UIColor(hue: hue, saturation: newSaturation, brightness: newBrightness, alpha: alpha)
    }
    
    /// 创建渐变色的起点或终点颜色
    /// - Parameter isStart: 是否是渐变起点
    /// - Returns: 调整后的颜色
    func gradientColor(isStart: Bool = true) -> UIColor {
        let factor: CGFloat = isStart ? 0.8 : 1.2
        return withBrightness(factor: factor)
    }
    
    // MARK: - 颜色混合
    
    /// 混合两个颜色
    /// - Parameters:
    ///   - otherColor: 要混合的颜色
    ///   - ratio: 混合比例（0.0-1.0），0.0表示完全使用当前颜色，1.0表示完全使用otherColor
    /// - Returns: 混合后的颜色
    func blend(with otherColor: UIColor, ratio: CGFloat) -> UIColor {
        let clampedRatio = max(0, min(1, ratio))
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        otherColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let r = r1 + (r2 - r1) * clampedRatio
        let g = g1 + (g2 - g1) * clampedRatio
        let b = b1 + (b2 - b1) * clampedRatio
        let a = a1 + (a2 - a1) * clampedRatio
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /// 叠加颜色（类似PS的叠加模式）
    /// - Parameter otherColor: 要叠加的颜色
    /// - Returns: 叠加后的颜色
    func overlay(with otherColor: UIColor) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        otherColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // 叠加模式：如果底层颜色 < 0.5，则叠加 = 2 * 底层 * 上层
        // 否则叠加 = 1 - 2 * (1 - 底层) * (1 - 上层)
        let r = r1 < 0.5 ? 2 * r1 * r2 : 1 - 2 * (1 - r1) * (1 - r2)
        let g = g1 < 0.5 ? 2 * g1 * g2 : 1 - 2 * (1 - g1) * (1 - g2)
        let b = b1 < 0.5 ? 2 * b1 * b2 : 1 - 2 * (1 - b1) * (1 - b2)
        
        return UIColor(red: r, green: g, blue: b, alpha: max(a1, a2))
    }
    
    // MARK: - 预定义颜色
    
    /// 常用的红色系颜色
    static var systemReds: [UIColor] {
        return [
            UIColor(hex: "#FF6B6B")!,    // 亮红色
            UIColor(hex: "#EE5A52")!,    // 标准红色
            UIColor(hex: "#FF0000")!,    // 纯红色
            UIColor(hex: "#C0392B")!,    // 暗红色
            UIColor(hex: "#A93226")!     // 深红色
        ]
    }
    
    /// 常用的蓝色系颜色
    static var systemBlues: [UIColor] {
        return [
            UIColor(hex: "#3498DB")!,    // 亮蓝色
            UIColor(hex: "#2980B9")!,    // 标准蓝色
            UIColor(hex: "#1F618D")!,    // 中蓝色
            UIColor(hex: "#154360")!,    // 深蓝色
            UIColor(hex: "#0D3B66")!     // 海军蓝
        ]
    }
    
    /// 常用的绿色系颜色
    static var systemGreens: [UIColor] {
        return [
            UIColor(hex: "#2ECC71")!,    // 亮绿色
            UIColor(hex: "#27AE60")!,    // 标准绿色
            UIColor(hex: "#229954")!,    // 森林绿
            UIColor(hex: "#196F3D")!,    // 深绿色
            UIColor(hex: "#145A32")!     // 墨绿色
        ]
    }
    
    /// 常用的黄色系颜色
    static var systemYellows: [UIColor] {
        return [
            UIColor(hex: "#F4D03F")!,    // 亮黄色
            UIColor(hex: "#F1C40F")!,    // 标准黄色
            UIColor(hex: "#D4AC0D")!,    // 金色
            UIColor(hex: "#B7950B")!,    // 暗金色
            UIColor(hex: "#9A7D0A")!     // 青铜色
        ]
    }
    
    /// 常用的紫色系颜色
    static var systemPurples: [UIColor] {
        return [
            UIColor(hex: "#9B59B6")!,    // 亮紫色
            UIColor(hex: "#8E44AD")!,    // 标准紫色
            UIColor(hex: "#7D3C98")!,    // 深紫色
            UIColor(hex: "#6C3483")!,    // 紫罗兰
            UIColor(hex: "#5B2C6F")!     // 暗紫色
        ]
    }
    
    /// 常用主题颜色
    static var themeColors: [UIColor] {
        return systemReds + systemBlues + systemGreens + systemYellows + systemPurples
    }
    
    // MARK: - 工具方法
    
    /// 获取颜色的对比度（WCAG标准）
    /// - Parameter otherColor: 对比的颜色
    /// - Returns: 对比度值，大于4.5表示良好对比度
    func contrastRatio(with otherColor: UIColor) -> CGFloat {
        let luminance1 = self.luminance
        let luminance2 = otherColor.luminance
        
        let lighter = max(luminance1, luminance2)
        let darker = min(luminance1, luminance2)
        
        return (lighter + 0.05) / (darker + 0.05)
    }
    
    /// 颜色的相对亮度（WCAG标准）
    private var luminance: CGFloat {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: nil) else {
            return 0
        }
        
        // 将RGB值转换为相对亮度
        let rLinear = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4)
        let gLinear = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4)
        let bLinear = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4)
        
        return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear
    }
    
    /// 检查与另一颜色的对比度是否满足WCAG标准
    /// - Parameters:
    ///   - otherColor: 对比的颜色
    ///   - level: WCAG级别（.AA或.AAA）
    ///   - isLargeText: 是否是大文本
    /// - Returns: 是否满足对比度要求
    func isWcagCompliant(with otherColor: UIColor, level: WCAGLevel = .AA, isLargeText: Bool = false) -> Bool {
        let ratio = contrastRatio(with: otherColor)
        
        switch level {
        case .AA:
            return isLargeText ? ratio >= 3.0 : ratio >= 4.5
        case .AAA:
            return isLargeText ? ratio >= 4.5 : ratio >= 7.0
        }
    }
}

/// WCAG对比度级别
public enum WCAGLevel {
    /// AA级：最小对比度要求
    case AA
    /// AAA级：增强对比度要求
    case AAA
}

// MARK: - CAGradientLayer 扩展

public extension CAGradientLayer {
    
    /// 创建水平渐变图层
    /// - Parameters:
    ///   - colors: 渐变颜色数组
    ///   - startPoint: 渐变起点（默认0.0, 0.5）
    ///   - endPoint: 渐变终点（默认1.0, 0.5）
    /// - Returns: 渐变图层
    static func horizontalGradient(colors: [UIColor],
                                   startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5),
                                   endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = colors.enumerated().map { NSNumber(value: Double($0.offset) / Double(colors.count - 1)) }
        return gradient
    }
    
    /// 创建垂直渐变图层
    /// - Parameters:
    ///   - colors: 渐变颜色数组
    ///   - startPoint: 渐变起点（默认0.5, 0.0）
    ///   - endPoint: 渐变终点（默认0.5, 1.0）
    /// - Returns: 渐变图层
    static func verticalGradient(colors: [UIColor],
                                 startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                                 endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = colors.enumerated().map { NSNumber(value: Double($0.offset) / Double(colors.count - 1)) }
        return gradient
    }
    
    /// 创建对角线渐变图层
    /// - Parameters:
    ///   - colors: 渐变颜色数组
    ///   - direction: 对角线方向
    /// - Returns: 渐变图层
    static func diagonalGradient(colors: [UIColor], direction: GradientDirection = .topLeftToBottomRight) -> CAGradientLayer {
        let (startPoint, endPoint) = direction.points
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = colors.enumerated().map { NSNumber(value: Double($0.offset) / Double(colors.count - 1)) }
        return gradient
    }
}

/// 渐变方向
public enum GradientDirection {
    /// 左上到右下
    case topLeftToBottomRight
    /// 左下到右上
    case bottomLeftToTopRight
    /// 右上到左下
    case topRightToBottomLeft
    /// 右下到左上
    case bottomRightToTopLeft
    
    var points: (start: CGPoint, end: CGPoint) {
        switch self {
        case .topLeftToBottomRight:
            return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
        case .bottomLeftToTopRight:
            return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
        case .topRightToBottomLeft:
            return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        case .bottomRightToTopLeft:
            return (CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0))
        }
    }
}

#endif
