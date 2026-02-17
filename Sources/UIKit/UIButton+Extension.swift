// UIButton+Extension.swift
// UIKit按钮扩展，提供便捷的按钮配置和操作方法

#if canImport(UIKit)
import UIKit

public extension UIButton {
    
    // MARK: - 便捷属性设置
    
    /// 设置按钮标题
    /// - Parameter title: 标题
    /// - Parameter state: 按钮状态（默认为.normal）
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func title(_ title: String?, for state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        return self
    }
    
    /// 设置按钮标题颜色
    /// - Parameters:
    ///   - color: 颜色
    ///   - state: 按钮状态（默认为.normal）
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    /// 设置按钮标题阴影颜色
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - state: 按钮状态（默认为.normal）
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func titleShadowColor(_ color: UIColor?, for state: UIControl.State = .normal) -> Self {
        setTitleShadowColor(color, for: state)
        return self
    }
    
    /// 设置按钮图片
    /// - Parameters:
    ///   - image: 图片
    ///   - state: 按钮状态（默认为.normal）
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }
    
    /// 设置按钮背景图片
    /// - Parameters:
    ///   - image: 背景图片
    ///   - state: 按钮状态（默认为.normal）
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
    
    /// 设置按钮字体
    /// - Parameter font: 字体
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }
    
    /// 设置系统字体大小
    /// - Parameters:
    ///   - size: 字体大小
    ///   - weight: 字体粗细（默认为.regular）
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func systemFont(size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        titleLabel?.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    /// 设置内容对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func contentAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        contentHorizontalAlignment = alignment
        return self
    }
    
    /// 设置内容边距
    /// - Parameters:
    ///   - top: 上边距
    ///   - left: 左边距
    ///   - bottom: 下边距
    ///   - right: 右边距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func contentInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        contentEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    /// 设置标题边距
    /// - Parameters:
    ///   - top: 上边距
    ///   - left: 左边距
    ///   - bottom: 下边距
    ///   - right: 右边距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func titleInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        titleEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    /// 设置图片边距
    /// - Parameters:
    ///   - top: 上边距
    ///   - left: 左边距
    ///   - bottom: 下边距
    ///   - right: 右边距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func imageInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        imageEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    /// 设置按钮是否启用
    /// - Parameter enabled: 是否启用
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func enabled(_ enabled: Bool) -> Self {
        isEnabled = enabled
        return self
    }
    
    /// 设置按钮是否被选中
    /// - Parameter selected: 是否被选中
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func selected(_ selected: Bool) -> Self {
        isSelected = selected
        return self
    }
    
    /// 设置按钮是否高亮
    /// - Parameter highlighted: 是否高亮
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func highlighted(_ highlighted: Bool) -> Self {
        isHighlighted = highlighted
        return self
    }
    
    /// 设置按钮是否显示触摸时的高亮效果
    /// - Parameter showsTouch: 是否显示触摸高亮
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func showsTouchWhenHighlighted(_ showsTouch: Bool) -> Self {
        showsTouchWhenHighlighted = showsTouch
        return self
    }
    
    /// 设置按钮的 tint 颜色
    /// - Parameter color: tint 颜色
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    /// 设置按钮类型
    /// - Parameter type: 按钮类型
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func buttonType(_ type: UIButton.ButtonType) -> Self {
        // 注意：按钮类型在创建后不能更改，此方法仅用于文档目的
        return self
    }
    
    // MARK: - 样式设置
    
    /// 添加边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func addBorder(color: UIColor, width: CGFloat = 1) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        return self
    }
    
    /// 添加圆角
    /// - Parameter radius: 圆角半径
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func roundCorners(radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    /// 添加阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移
    ///   - radius: 阴影半径
    ///   - opacity: 阴影不透明度
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func addShadow(color: UIColor = .black,
                   offset: CGSize = CGSize(width: 0, height: 2),
                   radius: CGFloat = 4,
                   opacity: Float = 0.2) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        return self
    }
    
    /// 设置按钮背景颜色
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - forState: 按钮状态
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func backgroundColor(_ color: UIColor, forState state: UIControl.State) -> Self {
        // 为特定状态设置背景颜色
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(colorImage, for: state)
        return self
    }
    
    /// 设置渐变背景
    /// - Parameters:
    ///   - colors: 渐变色数组
    ///   - startPoint: 渐变起点（归一化坐标）
    ///   - endPoint: 渐变终点（归一化坐标）
    ///   - forState: 按钮状态
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func gradientBackground(colors: [UIColor],
                           startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
                           endPoint: CGPoint = CGPoint(x: 0.5, y: 1),
                           forState state: UIControl.State) -> Self {
        let gradientImage = UIImage.gradientImage(
            colors: colors,
            size: bounds.size,
            startPoint: startPoint,
            endPoint: endPoint
        )
        setBackgroundImage(gradientImage, for: state)
        return self
    }
    
    // MARK: - 图片和标题布局
    
    /// 设置图片在标题左侧（默认布局）
    /// - Parameter spacing: 图片和标题之间的间距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func imageLeft(spacing: CGFloat = 8) -> Self {
        semanticContentAttribute = .forceLeftToRight
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
        return self
    }
    
    /// 设置图片在标题右侧
    /// - Parameter spacing: 图片和标题之间的间距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func imageRight(spacing: CGFloat = 8) -> Self {
        semanticContentAttribute = .forceRightToLeft
        imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing + spacing/2, bottom: 0, right: -spacing/2)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing + spacing/2)
        return self
    }
    
    /// 设置图片在标题上方
    /// - Parameter spacing: 图片和标题之间的间距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func imageTop(spacing: CGFloat = 8) -> Self {
        guard let imageSize = imageView?.image?.size,
              let titleSize = titleLabel?.intrinsicContentSize else {
            return self
        }
        
        imageEdgeInsets = UIEdgeInsets(
            top: -titleSize.height - spacing/2,
            left: (bounds.width - imageSize.width) / 2,
            bottom: 0,
            right: 0
        )
        
        titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -imageSize.height - spacing/2,
            right: 0
        )
        
        contentEdgeInsets = UIEdgeInsets(
            top: spacing/2,
            left: 0,
            bottom: spacing/2,
            right: 0
        )
        
        return self
    }
    
    /// 设置图片在标题下方
    /// - Parameter spacing: 图片和标题之间的间距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func imageBottom(spacing: CGFloat = 8) -> Self {
        guard let imageSize = imageView?.image?.size,
              let titleSize = titleLabel?.intrinsicContentSize else {
            return self
        }
        
        imageEdgeInsets = UIEdgeInsets(
            top: titleSize.height + spacing/2,
            left: (bounds.width - imageSize.width) / 2,
            bottom: 0,
            right: 0
        )
        
        titleEdgeInsets = UIEdgeInsets(
            top: -imageSize.height - spacing/2,
            left: -imageSize.width,
            bottom: 0,
            right: 0
        )
        
        contentEdgeInsets = UIEdgeInsets(
            top: spacing/2,
            left: 0,
            bottom: spacing/2,
            right: 0
        )
        
        return self
    }
    
    /// 设置按钮为纯图标按钮
    /// - Parameter padding: 内边距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func iconOnly(padding: CGFloat = 8) -> Self {
        setTitle(nil, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return self
    }
    
    /// 设置按钮为圆形图标按钮
    /// - Parameter padding: 内边距
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func circularIcon(padding: CGFloat = 8) -> Self {
        iconOnly(padding: padding)
        let minSide = min(bounds.width, bounds.height)
        roundCorners(radius: minSide / 2)
        return self
    }
    
    // MARK: - 事件处理
    
    /// 添加点击事件回调
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 动作选择器
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func onTap(target: Any?, action: Selector) -> Self {
        addTarget(target, action: action, for: .touchUpInside)
        return self
    }
    
    /// 添加点击事件闭包回调
    /// - Parameter handler: 点击事件处理闭包
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func onTap(_ handler: @escaping () -> Void) -> Self {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        objc_setAssociatedObject(self, &AssociatedKeys.tapHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
    
    /// 添加长按事件回调
    /// - Parameter handler: 长按事件处理闭包
    /// - Returns: 按钮本身，支持链式调用
    @discardableResult
    func onLongPress(_ handler: @escaping () -> Void) -> Self {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        addGestureRecognizer(recognizer)
        objc_setAssociatedObject(self, &AssociatedKeys.longPressHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
    
    /// 禁用点击事件一段时间
    /// - Parameter seconds: 禁用的秒数
    func disableTemporarily(for seconds: TimeInterval) {
        isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            self?.isEnabled = true
        }
    }
    
    // MARK: - 私有处理方法和关联对象键
    
    private struct AssociatedKeys {
        static var tapHandler = "tapHandler"
        static var longPressHandler = "longPressHandler"
    }
    
    @objc private func handleTap() {
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.tapHandler) as? () -> Void {
            handler()
        }
    }
    
    @objc private func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.longPressHandler) as? () -> Void {
            handler()
        }
    }
    
    // MARK: - 按钮状态管理
    
    /// 切换按钮的选中状态
    func toggleSelection() {
        isSelected = !isSelected
    }
    
    /// 启用按钮
    func enable() {
        isEnabled = true
    }
    
    /// 禁用按钮
    func disable() {
        isEnabled = false
    }
    
    /// 高亮按钮
    func highlight() {
        isHighlighted = true
    }
    
    /// 取消高亮按钮
    func unhighlight() {
        isHighlighted = false
    }
    
    /// 检查按钮是否处于活动状态（启用且未高亮）
    var isActive: Bool {
        return isEnabled && !isHighlighted
    }
    
    /// 获取按钮当前标题
    var currentTitleText: String {
        return title(for: .normal) ?? ""
    }
    
    /// 获取按钮当前标题颜色
    var currentTitleColor: UIColor? {
        return titleColor(for: .normal)
    }
    
    /// 获取按钮当前图片
    var currentImage: UIImage? {
        return image(for: .normal)
    }
    
    // MARK: - 工厂方法
    
    /// 创建系统样式按钮
    /// - Parameters:
    ///   - systemImageName: 系统图片名称
    ///   - tintColor: 按钮颜色
    /// - Returns: 配置好的按钮
    @available(iOS 13.0, *)
    static func systemButton(systemImageName: String, tintColor: UIColor = .systemBlue) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemImageName), for: .normal)
        button.tintColor = tintColor
        return button
    }
    
    /// 创建主要操作按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - backgroundColor: 背景颜色
    /// - Returns: 配置好的按钮
    static func primaryButton(title: String, backgroundColor: UIColor = .systemBlue) -> UIButton {
        return UIButton(type: .system)
            .title(title)
            .systemFont(size: 17, weight: .semibold)
            .titleColor(.white, for: .normal)
            .backgroundColor(backgroundColor, forState: .normal)
            .roundCorners(radius: 8)
            .contentInsets(top: 12, left: 24, bottom: 12, right: 24)
    }
    
    /// 创建次要操作按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - borderColor: 边框颜色
    /// - Returns: 配置好的按钮
    static func secondaryButton(title: String, borderColor: UIColor = .systemBlue) -> UIButton {
        return UIButton(type: .system)
            .title(title)
            .systemFont(size: 17, weight: .semibold)
            .titleColor(borderColor, for: .normal)
            .addBorder(color: borderColor, width: 1)
            .roundCorners(radius: 8)
            .contentInsets(top: 12, left: 24, bottom: 12, right: 24)
    }
    
    /// 创建文本按钮
    /// - Parameter title: 按钮标题
    /// - Returns: 配置好的按钮
    static func textButton(title: String) -> UIButton {
        return UIButton(type: .system)
            .title(title)
            .systemFont(size: 17, weight: .semibold)
            .titleColor(.systemBlue, for: .normal)
    }
    
    /// 创建图标按钮
    /// - Parameters:
    ///   - image: 图标图片
    ///   - tintColor: 图标颜色
    /// - Returns: 配置好的按钮
    static func iconButton(image: UIImage, tintColor: UIColor = .systemBlue) -> UIButton {
        return UIButton(type: .system)
            .image(image.withRenderingMode(.alwaysTemplate))
            .tintColor(tintColor)
            .iconOnly(padding: 8)
    }
    
    /// 创建圆形图标按钮
    /// - Parameters:
    ///   - image: 图标图片
    ///   - backgroundColor: 背景颜色
    ///   - tintColor: 图标颜色
    /// - Returns: 配置好的按钮
    static func circularIconButton(image: UIImage, backgroundColor: UIColor = .systemBlue, tintColor: UIColor = .white) -> UIButton {
        let button = UIButton(type: .system)
            .image(image.withRenderingMode(.alwaysTemplate))
            .tintColor(tintColor)
            .iconOnly(padding: 12)
            .backgroundColor(backgroundColor, forState: .normal)
        
        // 需要在布局完成后设置圆角
        DispatchQueue.main.async {
            let minSide = min(button.bounds.width, button.bounds.height)
            button.roundCorners(radius: minSide / 2)
        }
        
        return button
    }
    
    /// 创建带图标的文本按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - image: 图标图片
    ///   - imagePosition: 图标位置
    /// - Returns: 配置好的按钮
    static func iconTextButton(title: String, image: UIImage, imagePosition: ImagePosition = .left) -> UIButton {
        let button = UIButton(type: .system)
            .title(title)
            .image(image)
            .systemFont(size: 16, weight: .medium)
        
        switch imagePosition {
        case .left:
            button.imageLeft()
        case .right:
            button.imageRight()
        case .top:
            button.imageTop()
        case .bottom:
            button.imageBottom()
        }
        
        return button
    }
    
    // MARK: - 枚举定义
    
    /// 图标位置枚举
    enum ImagePosition {
        case left
        case right
        case top
        case bottom
    }
    
    /// 按钮样式枚举
    enum ButtonStyle {
        case primary
        case secondary
        case text
        case icon
        case circularIcon
    }
}

// MARK: - UIButton 链式样式设置

public extension UIButton {
    
    /// 链式设置主要按钮样式
    /// - Parameters:
    ///   - backgroundColor: 背景颜色
    ///   - cornerRadius: 圆角半径
    /// - Returns: 按钮本身
    func styledAsPrimary(backgroundColor: UIColor = .systemBlue, cornerRadius: CGFloat = 8) -> Self {
        return self
            .titleColor(.white, for: .normal)
            .backgroundColor(backgroundColor, forState: .normal)
            .roundCorners(radius: cornerRadius)
            .systemFont(size: 17, weight: .semibold)
    }
    
    /// 链式设置次要按钮样式
    /// - Parameters:
    ///   - borderColor: 边框颜色
    ///   - cornerRadius: 圆角半径
    /// - Returns: 按钮本身
    func styledAsSecondary(borderColor: UIColor = .systemBlue, cornerRadius: CGFloat = 8) -> Self {
        return self
            .titleColor(borderColor, for: .normal)
            .addBorder(color: borderColor, width: 1)
            .roundCorners(radius: cornerRadius)
            .systemFont(size: 17, weight: .semibold)
    }
    
    /// 链式设置文本按钮样式
    /// - Parameter textColor: 文本颜色
    /// - Returns: 按钮本身
    func styledAsText(textColor: UIColor = .systemBlue) -> Self {
        return self
            .titleColor(textColor, for: .normal)
            .systemFont(size: 17, weight: .semibold)
    }
    
    /// 链式设置图标按钮样式
    /// - Parameters:
    ///   - tintColor: 图标颜色
    ///   - padding: 内边距
    /// - Returns: 按钮本身
    func styledAsIcon(tintColor: UIColor = .systemBlue, padding: CGFloat = 8) -> Self {
        return self
            .tintColor(tintColor)
            .iconOnly(padding: padding)
    }
    
    /// 链式设置圆形图标按钮样式
    /// - Parameters:
    ///   - backgroundColor: 背景颜色
    ///   - tintColor: 图标颜色
    ///   - padding: 内边距
    /// - Returns: 按钮本身
    func styledAsCircularIcon(backgroundColor: UIColor = .systemBlue, tintColor: UIColor = .white, padding: CGFloat = 12) -> Self {
        return self
            .tintColor(tintColor)
            .iconOnly(padding: padding)
            .backgroundColor(backgroundColor, forState: .normal)
    }
}

#endif