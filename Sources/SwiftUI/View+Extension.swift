// View+Extension.swift
// SwiftUI视图扩展，提供便捷的修饰符和工具方法

#if canImport(SwiftUI)
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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
    
    /// 设置固定大小
    /// - Parameter size: 固定大小
    func fixedSize(_ size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
            .fixedSize()
    }
    
    /// 设置固定宽度
    /// - Parameter width: 固定宽度
    func fixedWidth(_ width: CGFloat) -> some View {
        self.frame(width: width)
            .fixedSize(horizontal: true, vertical: false)
    }
    
    /// 设置固定高度
    /// - Parameter height: 固定高度
    func fixedHeight(_ height: CGFloat) -> some View {
        self.frame(height: height)
            .fixedSize(horizontal: false, vertical: true)
    }
    
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
    
    /// 设置上边距
    /// - Parameter padding: 边距值
    func topPadding(_ padding: CGFloat) -> some View {
        self.padding(.top, padding)
    }
    
    /// 设置下边距
    /// - Parameter padding: 边距值
    func bottomPadding(_ padding: CGFloat) -> some View {
        self.padding(.bottom, padding)
    }
    
    /// 设置左边距
    /// - Parameter padding: 边距值
    func leadingPadding(_ padding: CGFloat) -> some View {
        self.padding(.leading, padding)
    }
    
    /// 设置右边距
    /// - Parameter padding: 边距值
    func trailingPadding(_ padding: CGFloat) -> some View {
        self.padding(.trailing, padding)
    }
    
    /// 设置忽略安全区域
    /// - Parameter edges: 要忽略的边
    func ignoreSafeArea(_ edges: Edge.Set = .all) -> some View {
        self.ignoresSafeArea(.all, edges: edges)
    }
    
    /// 设置安全区域边距
    /// - Parameter edges: 安全区域边
    func safeAreaPadding(_ edges: Edge.Set = .all) -> some View {
        return self.padding(edges)
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
    
    /// 添加圆角
    /// - Parameter radius: 圆角半径
    func cornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
    
    /// 添加圆形裁剪
    func circleClip() -> some View {
        self.clipShape(Circle())
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
    
    /// 设置径向渐变背景
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - center: 中心点
    ///   - startRadius: 起始半径
    ///   - endRadius: 结束半径
    func radialGradientBackground(colors: [Color], center: UnitPoint = .center, startRadius: CGFloat = 0, endRadius: CGFloat = 100) -> some View {
        self.background(
            RadialGradient(
                gradient: Gradient(colors: colors),
                center: center,
                startRadius: startRadius,
                endRadius: endRadius
            )
        )
    }
    
    /// 设置背景颜色
    /// - Parameter color: 背景颜色
    func backgroundColor(_ color: Color) -> some View {
        self.background(color)
    }
    
    /// 设置前景颜色
    /// - Parameter color: 前景颜色
    func setForegroundColor(_ color: Color) -> some View {
        return self.foregroundColor(color)
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
    
    /// 设置透明度
    /// - Parameter opacity: 透明度值
    func setOpacity(_ opacity: Double) -> some View {
        return self.opacity(opacity)
    }
    
    /// 设置亮度
    /// - Parameter amount: 亮度值
    func setBrightness(_ amount: Double) -> some View {
        return self.brightness(amount)
    }
    
    /// 设置对比度
    /// - Parameter amount: 对比度值
    func setContrast(_ amount: Double) -> some View {
        return self.contrast(amount)
    }
    
    /// 设置饱和度
    /// - Parameter amount: 饱和度值
    func setSaturation(_ amount: Double) -> some View {
        return self.saturation(amount)
    }
    
    /// 设置模糊效果
    /// - Parameter radius: 模糊半径
    func setBlur(radius: CGFloat) -> some View {
        return self.blur(radius: radius)
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
    
    #if os(macOS)
    /// 添加半透明模糊背景（macOS）
    /// - Parameter material: 材质类型
    func blurredBackground(material: NSVisualEffectView.Material = .fullScreenUI) -> some View {
        self.background(
            VisualEffectView(material: material)
        )
    }
    #endif
    
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
    
    /// 应用缓入动画
    /// - Parameters:
    ///   - value: 观察值
    ///   - duration: 动画时长
    func withEaseInAnimation<T>(value: T, duration: Double = 0.3) -> some View where T: Equatable {
        self.animation(.easeIn(duration: duration), value: value)
    }
    
    /// 应用缓出动画
    /// - Parameters:
    ///   - value: 观察值
    ///   - duration: 动画时长
    func withEaseOutAnimation<T>(value: T, duration: Double = 0.3) -> some View where T: Equatable {
        self.animation(.easeOut(duration: duration), value: value)
    }
    
    /// 应用缓入缓出动画
    /// - Parameters:
    ///   - value: 观察值
    ///   - duration: 动画时长
    func withEaseInOutAnimation<T>(value: T, duration: Double = 0.3) -> some View where T: Equatable {
        self.animation(.easeInOut(duration: duration), value: value)
    }
    
    /// 应用线性动画
    /// - Parameters:
    ///   - value: 观察值
    ///   - duration: 动画时长
    func withLinearAnimation<T>(value: T, duration: Double = 0.3) -> some View where T: Equatable {
        self.animation(.linear(duration: duration), value: value)
    }
    
    /// 添加转场动画
    /// - Parameters:
    ///   - transition: 转场类型
    ///   - value: 观察值
    func withTransition<T>(_ transition: AnyTransition, value: T) -> some View where T: Equatable {
        self.transition(transition)
            .animation(.default, value: value)
    }
    
    /// 添加淡入淡出转场
    /// - Parameter value: 观察值
    func withFadeTransition<T>(value: T) -> some View where T: Equatable {
        self.withTransition(.opacity, value: value)
    }
    
    /// 添加滑动转场
    /// - Parameters:
    ///   - edge: 滑动方向
    ///   - value: 观察值
    func withSlideTransition<T>(edge: Edge = .trailing, value: T) -> some View where T: Equatable {
        self.withTransition(.slide, value: value)
    }
    
    /// 添加缩放转场
    /// - Parameter value: 观察值
    func withScaleTransition<T>(value: T) -> some View where T: Equatable {
        self.withTransition(.scale, value: value)
    }
    
    // MARK: - 交互扩展
    
    /// 添加点击手势
    /// - Parameters:
    ///   - action: 点击动作
    func onTap(perform action: @escaping () -> Void) -> some View {
        self.onTapGesture(perform: action)
    }
    
    /// 添加点击手势（带计数）
    /// - Parameters:
    ///   - count: 点击次数
    ///   - action: 点击动作
    func onTap(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        self.onTapGesture(count: count, perform: action)
    }
    
    /// 添加长按手势
    /// - Parameters:
    ///   - duration: 长按时长
    ///   - action: 长按动作
    func onLongPress(minimumDuration: Double = 0.5, perform action: @escaping () -> Void) -> some View {
        self.onLongPressGesture(minimumDuration: minimumDuration, perform: action)
    }
    
    /// 添加长按手势（带最大距离）
    /// - Parameters:
    ///   - minimumDuration: 最小持续时间
    ///   - maximumDistance: 最大移动距离
    ///   - action: 长按动作
    func onLongPress(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10, perform action: @escaping () -> Void) -> some View {
        self.onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: action)
    }
    
    /// 禁用用户交互
    /// - Parameter disabled: 是否禁用
    func userInteraction(_ disabled: Bool) -> some View {
        self.disabled(disabled)
    }
    
    /// 启用用户交互
    func enableUserInteraction() -> some View {
        self.disabled(false)
    }
    
    /// 添加悬停效果
    /// - Parameter action: 悬停回调
    func withHoverEffect(perform action: @escaping (Bool) -> Void) -> some View {
        return self.onHover(perform: action)
    }
    
    /// 添加拖动手势
    /// - Parameter action: 拖动回调
    func onDrag(perform action: @escaping (DragGesture.Value) -> Void) -> some View {
        self.gesture(
            DragGesture()
                .onChanged(action)
        )
    }
    
    /// 添加拖动手势（带结束回调）
    /// - Parameters:
    ///   - onChanged: 拖动变化回调
    ///   - onEnded: 拖动结束回调
    func onDrag(onChanged: @escaping (DragGesture.Value) -> Void, onEnded: @escaping (DragGesture.Value) -> Void) -> some View {
        self.gesture(
            DragGesture()
                .onChanged(onChanged)
                .onEnded(onEnded)
        )
    }
    
    /// 添加缩放手势
    /// - Parameter action: 缩放回调
    func onMagnify(perform action: @escaping (MagnificationGesture.Value) -> Void) -> some View {
        self.gesture(
            MagnificationGesture()
                .onChanged(action)
        )
    }
    
    /// 添加旋转手势
    /// - Parameter action: 旋转回调
    func onRotate(perform action: @escaping (RotationGesture.Value) -> Void) -> some View {
        self.gesture(
            RotationGesture()
                .onChanged(action)
        )
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
    
    /// 隐藏条件控制
    /// - Parameter condition: 隐藏条件
    func hideIf(_ condition: Bool) -> some View {
        self.showIf(!condition)
    }
    
    /// 嵌入到 NavigationView 中
    @available(iOS, deprecated: 16.0, message: "Use NavigationStack instead")
    func embedInNavigation() -> some View {
        NavigationView {
            self
        }
    }
    
    /// 嵌入到 NavigationStack 中
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func embedInNavigationStack() -> some View {
        NavigationStack {
            self
        }
    }
    
    /// 嵌入到 NavigationSplitView 中
    @available(iOS 16.0, macOS 13.0, *)
    func embedInNavigationSplitView() -> some View {
        NavigationSplitView {
            self
        } detail: {
            EmptyView()
        }
    }
    
    /// 嵌入到 ScrollView 中
    func embedInScroll() -> some View {
        ScrollView {
            self
        }
    }
    
    /// 嵌入到垂直滚动视图中
    func embedInVerticalScroll() -> some View {
        ScrollView(.vertical) {
            self
        }
    }
    
    /// 嵌入到水平滚动视图中
    func embedInHorizontalScroll() -> some View {
        ScrollView(.horizontal) {
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
    
    /// 嵌入到 LazyVStack 中
    func embedInLazyVStack(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil) -> some View {
        LazyVStack(alignment: alignment, spacing: spacing) {
            self
        }
    }
    
    /// 嵌入到 LazyHStack 中
    func embedInLazyHStack(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) -> some View {
        LazyHStack(alignment: alignment, spacing: spacing) {
            self
        }
    }
    
    /// 嵌入到 LazyVGrid 中
    func embedInLazyVGrid(columns: [GridItem], spacing: CGFloat? = nil) -> some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            self
        }
    }
    
    /// 嵌入到 LazyHGrid 中
    func embedInLazyHGrid(rows: [GridItem], spacing: CGFloat? = nil) -> some View {
        LazyHGrid(rows: rows, spacing: spacing) {
            self
        }
    }
    
    /// 嵌入到 Form 中
    func embedInForm() -> some View {
        Form {
            self
        }
    }
    
    /// 嵌入到 List 中
    func embedInList() -> some View {
        List {
            self
        }
    }
    
    /// 嵌入到 Group 中
    func embedInGroup() -> some View {
        Group {
            self
        }
    }
    
    /// 嵌入到 Section 中
    func embedInSection(header: some View = EmptyView(), footer: some View = EmptyView()) -> some View {
        Section(header: header, footer: footer) {
            self
        }
    }
    
    /// 设置标识符
    /// - Parameter id: 标识符
    func identified(by id: String) -> some View {
        self.id(id)
    }
    
    /// 设置标识符（使用哈希值）
    func identified(by id: some Hashable) -> some View {
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
    
    /// 设置提示文本
    /// - Parameter hint: 提示文本
    func hint(_ hint: String) -> some View {
        self.accessibilityHint(hint)
    }
    
    /// 设置值文本
    /// - Parameter value: 值文本
    func valueDescription(_ value: String) -> some View {
        self.accessibilityValue(value)
    }
    
    /// 设置为可访问性元素
    /// - Parameter isElement: 是否为可访问性元素
    func accessibilityElement(_ isElement: Bool = true) -> some View {
        self.accessibilityElement(children: isElement ? .contain : .ignore)
    }
    
    /// 设置排序优先级
    /// - Parameter priority: 排序优先级
    func sortPriority(_ priority: Double) -> some View {
        self.layoutPriority(priority)
    }
    
    /// 设置对齐方式
    /// - Parameter alignment: 对齐方式
    func alignment(_ alignment: Alignment) -> some View {
        self.frame(alignment: alignment)
    }
    
    /// 转换为 AnyView
    var anyView: AnyView {
        AnyView(self)
    }
    
    // MARK: - 预览扩展
    
    /// 设置预览设备
    /// - Parameter device: 设备名称
    func setPreviewDevice(_ device: PreviewDevice) -> some View {
        return self.previewDevice(device)
    }
    
    /// 设置预览显示名称
    /// - Parameter name: 显示名称
    func setPreviewDisplayName(_ name: String) -> some View {
        return self.previewDisplayName(name)
    }
    
    /// 添加预览布局
    /// - Parameter layout: 布局类型
    func setPreviewLayout(_ layout: PreviewLayout) -> some View {
        return self.previewLayout(layout)
    }
    
    /// 添加设备预览
    /// - Parameter devices: 设备名称数组
    func previewDevices(_ devices: [String]) -> some View {
        return ForEach(devices, id: \.self) { device in
            self.previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
    
    /// 添加暗色模式预览
    func previewDarkMode() -> some View {
        return self.preferredColorScheme(.dark)
    }
    
    /// 添加亮色模式预览
    func previewLightMode() -> some View {
        return self.preferredColorScheme(.light)
    }
    
    /// 添加动态类型预览
    /// - Parameter sizeCategory: 动态类型大小
    func previewDynamicType(_ sizeCategory: ContentSizeCategory) -> some View {
        return self.environment(\.sizeCategory, sizeCategory)
    }
    
    // MARK: - 状态管理
    
    /// 绑定到状态
    /// - Parameters:
    ///   - state: 状态值
    ///   - setter: 状态设置器
    func bind<T: Equatable>(to state: T, setter: @escaping (T) -> Void) -> some View {
        self.onChange(of: state) { newValue in
            setter(newValue)
        }
    }
    
    /// 监听状态变化
    /// - Parameters:
    ///   - value: 监听的数值
    ///   - action: 变化回调
    func observeChange<T: Equatable>(of value: T, perform action: @escaping (T) -> Void) -> some View {
        return self.onChange(of: value, perform: action)
    }
    
    /// 设置环境值
    /// - Parameters:
    ///   - keyPath: 环境键路径
    ///   - value: 环境值
    func setEnvironment<T>(_ keyPath: WritableKeyPath<EnvironmentValues, T>, _ value: T) -> some View {
        return self.environment(keyPath, value)
    }
    
    // MARK: - 性能优化
    
    /// 应用绘制组优化
    func applyDrawingGroup() -> some View {
        return self.drawingGroup()
    }
    
    /// 应用合成模式优化
    /// - Parameter blendMode: 混合模式
    func applyBlendMode(_ blendMode: BlendMode) -> some View {
        return self.blendMode(blendMode)
    }
    
    /// 应用合成操作优化
    /// - Parameter compositingGroup: 是否使用合成组
    func applyCompositingGroup(_ compositingGroup: Bool = true) -> some View {
        return self.compositingGroup()
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

#if os(macOS)
/// 视觉效果视图（macOS）
private struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.state = .active
        view.blendingMode = .behindWindow
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
    }
}
#endif

#endif
