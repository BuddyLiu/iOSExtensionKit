// View+Extension.swift
// SwiftUI视图扩展，提供便捷的修饰符和工具方法

#if canImport(SwiftUI)
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public extension View {
    
    // MARK: - 布局扩展
    
    /// 设置视图的框架大小
    /// - Parameter size: 大小
    func frame(size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
    
    /// 设置视图为正方形
    /// - Parameter length: 边长
    func square(_ length: CGFloat) -> some View {
        self.frame(width: length, height: length)
    }
    
    /// 设置最小尺寸
    /// - Parameter size: 最小尺寸
    func minFrame(_ size: CGSize) -> some View {
        self.frame(minWidth: size.width, minHeight: size.height)
    }
    
    /// 设置最大尺寸
    /// - Parameter size: 最大尺寸
    func maxFrame(_ size: CGSize) -> some View {
        self.frame(maxWidth: size.width, maxHeight: size.height)
    }
    
    /// 设置理想尺寸
    /// - Parameter size: 理想尺寸
    func idealFrame(_ size: CGSize) -> some View {
        self.frame(idealWidth: size.width, idealHeight: size.height)
    }
    
    /// 填充可用空间
    func fill() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// 水平填充可用空间
    func hFill() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    /// 垂直填充可用空间
    func vFill() -> some View {
        self.frame(maxHeight: .infinity)
    }
    
    // MARK: - 样式扩展
    
    /// 添加边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    func addBorder(_ color: Color, width: CGFloat = 1) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(color, lineWidth: width)
        )
    }
    
    /// 添加圆角边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    ///   - radius: 圆角半径
    func addRoundedBorder(_ color: Color, width: CGFloat = 1, radius: CGFloat = 8) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: width)
        )
    }
    
    /// 添加阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - radius: 阴影半径
    ///   - x: X轴偏移
    ///   - y: Y轴偏移
    func addShadow(color: Color = .black, radius: CGFloat = 3, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        self.shadow(color: color, radius: radius, x: x, y: y)
    }
    
    /// 设置渐变色背景
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - startPoint: 起始点
    ///   - endPoint: 结束点
    func gradientBackground(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> some View {
        self.background(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
    }
    
    /// 设置背景图片
    /// - Parameters:
    ///   - image: 图片名称
    ///   - contentMode: 内容模式
    func backgroundImage(_ image: String, contentMode: ContentMode = .fill) -> some View {
        self.background(
            Image(image)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        )
    }
    
    #if os(iOS)
    /// 添加半透明模糊背景
    /// - Parameters:
    ///   - style: 模糊样式
    ///   - intensity: 强度
    func blurredBackground(style: UIBlurEffect.Style = .systemMaterial, intensity: CGFloat = 1.0) -> some View {
        self.background(
            BlurView(style: style, intensity: intensity)
        )
    }
    #endif
    
    // MARK: - 边距扩展
    
    /// 设置统一的边距
    /// - Parameter padding: 边距值
    func addPadding(_ padding: CGFloat) -> some View {
        self.padding(.all, padding)
    }
    
    /// 设置水平边距
    /// - Parameter padding: 边距值
    func hPadding(_ padding: CGFloat) -> some View {
        self.padding(.horizontal, padding)
    }
    
    /// 设置垂直边距
    /// - Parameter padding: 边距值
    func vPadding(_ padding: CGFloat) -> some View {
        self.padding(.vertical, padding)
    }
    
    /// 设置忽略安全区域
    /// - Parameter edges: 要忽略的边
    func ignoreSafeArea(_ edges: Edge.Set = .all) -> some View {
        self.ignoresSafeArea(.all, edges: edges)
    }
    
    // MARK: - 动画扩展
    
    /// 应用默认动画
    /// - Parameter value: 观察值
    func withDefaultAnimation<T>(value: T) -> some View where T: Equatable {
        self.animation(.default, value: value)
    }
    
    /// 应用弹性动画
    /// - Parameters:
    ///   - value: 观察值
    ///   - duration: 动画时长
    ///   - bounce: 弹性强度
    func withSpringAnimation<T>(value: T, duration: Double = 0.5, bounce: Double = 0.3) -> some View where T: Equatable {
        self.animation(.spring(duration: duration, bounce: bounce), value: value)
    }
    
    // MARK: - 交互扩展
    
    /// 添加点击手势
    /// - Parameters:
    ///   - action: 点击动作
    func onTap(perform action: @escaping () -> Void) -> some View {
        self.onTapGesture(perform: action)
    }
    
    /// 添加长按手势
    /// - Parameters:
    ///   - duration: 长按时长
    ///   - action: 长按动作
    func onLongPress(minimumDuration: Double = 0.5, perform action: @escaping () -> Void) -> some View {
        self.onLongPressGesture(minimumDuration: minimumDuration, perform: action)
    }
    
    /// 禁用用户交互
    /// - Parameter disabled: 是否禁用
    func userInteraction(_ disabled: Bool) -> some View {
        self.disabled(disabled)
    }
    
    // MARK: - 工具方法
    
    /// 隐藏视图
    /// - Parameter hidden: 是否隐藏
    func hidden(_ hidden: Bool) -> some View {
        self.opacity(hidden ? 0 : 1)
    }
    
    /// 显示条件控制
    /// - Parameter condition: 显示条件
    func showIf(_ condition: Bool) -> some View {
        Group {
            if condition {
                self
            }
        }
    }
    
    /// 嵌入到 NavigationView 中
    @available(iOS, deprecated: 16.0, message: "Use NavigationStack instead")
    func embedInNavigation() -> some View {
        NavigationView {
            self
        }
    }
    
    /// 嵌入到 ScrollView 中
    func embedInScroll() -> some View {
        ScrollView {
            self
        }
    }
    
    /// 嵌入到 VStack 中
    func embedInVStack(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil) -> some View {
        VStack(alignment: alignment, spacing: spacing) {
            self
        }
    }
    
    /// 嵌入到 HStack 中
    func embedInHStack(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) -> some View {
        HStack(alignment: alignment, spacing: spacing) {
            self
        }
    }
    
    /// 嵌入到 ZStack 中
    func embedInZStack(alignment: Alignment = .center) -> some View {
        ZStack(alignment: alignment) {
            self
        }
    }
    
    /// 设置标识符
    /// - Parameter id: 标识符
    func identified(by id: String) -> some View {
        self.id(id)
    }
    
    /// 设置可访问性标识符
    /// - Parameter identifier: 标识符
    func accessibilityIdentifier(_ identifier: String) -> some View {
        self.accessibilityIdentifier(identifier)
    }
    
    /// 设置标签
    /// - Parameter label: 标签文本
    func labeled(_ label: String) -> some View {
        self.accessibilityLabel(label)
    }
    
    /// 转换为 AnyView
    var anyView: AnyView {
        AnyView(self)
    }
}

// MARK: - 辅助视图

#if os(iOS)
/// 模糊视图
private struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    var intensity: CGFloat
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // 更新视图
    }
}
#endif

#endif
