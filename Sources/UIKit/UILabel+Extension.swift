// UILabel+Extension.swift
// UILabel扩展，提供便捷的文本样式和布局方法

#if canImport(UIKit)
import UIKit

public extension UILabel {
    
    // MARK: - 便捷初始化
    
    /// 便捷创建标签
    /// - Parameters:
    ///   - text: 文本内容
    ///   - font: 字体
    ///   - textColor: 文本颜色
    ///   - alignment: 对齐方式
    ///   - lines: 行数
    convenience init(text: String? = nil,
                     font: UIFont? = nil,
                     textColor: UIColor? = nil,
                     alignment: NSTextAlignment = .natural,
                     lines: Int = 1) {
        self.init()
        self.text = text
        if let font = font {
            self.font = font
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
        self.textAlignment = alignment
        self.numberOfLines = lines
        self.adjustsFontSizeToFitWidth = lines == 1
    }
    
    /// 创建属性字符串标签
    /// - Parameter attributedText: 属性文本
    convenience init(attributedText: NSAttributedString?) {
        self.init()
        self.attributedText = attributedText
    }
    
    /// 创建自适应大小标签
    /// - Parameter text: 文本内容
    convenience init(fittingText text: String) {
        self.init()
        self.text = text
        self.sizeToFit()
    }
    
    // MARK: - 文本样式
    
    /// 设置字体大小和粗细
    /// - Parameters:
    ///   - size: 字体大小
    ///   - weight: 字体粗细
    func setFont(size: CGFloat, weight: UIFont.Weight = .regular) {
        font = UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    /// 设置粗体字体
    /// - Parameter size: 字体大小
    func setBoldFont(size: CGFloat) {
        font = UIFont.boldSystemFont(ofSize: size)
    }
    
    /// 设置斜体字体
    /// - Parameter size: 字体大小
    @available(iOS 13.0, *)
    func setItalicFont(size: CGFloat) {
        font = UIFont.italicSystemFont(ofSize: size)
    }
    
    /// 设置等宽字体
    /// - Parameters:
    ///   - size: 字体大小
    ///   - weight: 字体粗细
    func setMonospacedFont(size: CGFloat, weight: UIFont.Weight = .regular) {
        font = UIFont.monospacedSystemFont(ofSize: size, weight: weight)
    }
    
    /// 设置系统字体
    /// - Parameters:
    ///   - style: 文本样式
    ///   - weight: 字体粗细
    @available(iOS 11.0, *)
    func setSystemFont(style: UIFont.TextStyle, weight: UIFont.Weight? = nil) {
        if let weight = weight {
            font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: style).pointSize, weight: weight)
        } else {
            font = UIFont.preferredFont(forTextStyle: style)
        }
    }
    
    /// 设置文本颜色
    /// - Parameter color: 文本颜色
    func setTextColor(_ color: UIColor) {
        textColor = color
    }
    
    /// 设置文本对齐方式
    /// - Parameter alignment: 对齐方式
    func setAlignment(_ alignment: NSTextAlignment) {
        textAlignment = alignment
    }
    
    /// 设置行数
    /// - Parameter lines: 行数（0表示无限制）
    func setNumberOfLines(_ lines: Int) {
        numberOflines = lines
    }
    
    /// 启用自动缩小字体
    /// - Parameter minimumScaleFactor: 最小缩放比例
    func enableAutoShrink(minimumScaleFactor: CGFloat = 0.5) {
        adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = minimumScaleFactor
    }
    
    /// 禁用自动缩小字体
    func disableAutoShrink() {
        adjustsFontSizeToFitWidth = false
    }
    
    /// 设置行间距
    /// - Parameter spacing: 行间距
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text = text, !text.isEmpty else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = textAlignment
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: font as Any,
                .foregroundColor: textColor as Any
            ]
        )
        
        attributedText = attributedString
    }
    
    /// 设置字间距
    /// - Parameter spacing: 字间距
    func setCharacterSpacing(_ spacing: CGFloat) {
        guard let text = text, !text.isEmpty else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .kern,
            value: spacing,
            range: NSRange(location: 0, length: text.count)
        )
        
        attributedText = attributedString
    }
    
    /// 设置文本阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移
    ///   - radius: 阴影半径
    func setTextShadow(color: UIColor = .black, offset: CGSize = CGSize(width: 0, height: 1), radius: CGFloat = 0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = 1.0
    }
    
    /// 移除文本阴影
    func removeTextShadow() {
        layer.shadowColor = nil
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
    }
    
    // MARK: - 富文本处理
    
    /// 设置属性文本
    /// - Parameters:
    ///   - string: 文本字符串
    ///   - attributes: 属性字典
    func setAttributedText(_ string: String, attributes: [NSAttributedString.Key: Any]) {
        attributedText = NSAttributedString(string: string, attributes: attributes)
    }
    
    /// 添加属性到指定范围
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - range: 范围
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], range: NSRange) {
        guard let currentAttributedText = attributedText else {
            // 如果没有属性文本，先创建
            guard let text = text else { return }
            let mutableAttributedString = NSMutableAttributedString(string: text)
            mutableAttributedString.addAttributes(attributes, range: range)
            attributedText = mutableAttributedString
            return
        }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: currentAttributedText)
        mutableAttributedString.addAttributes(attributes, range: range)
        attributedText = mutableAttributedString
    }
    
    /// 高亮部分文本
    /// - Parameters:
    ///   - substring: 要高亮的子字符串
    ///   - color: 高亮颜色
    ///   - font: 高亮字体（可选）
    func highlightSubstring(_ substring: String, color: UIColor, font: UIFont? = nil) {
        guard let text = text, let range = text.range(of: substring) else { return }
        
        let nsRange = NSRange(range, in: text)
        var attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        
        if let font = font {
            attributes[.font] = font
        }
        
        addAttributes(attributes, range: nsRange)
    }
    
    /// 设置文本为超链接样式
    /// - Parameters:
    ///   - color: 链接颜色
    ///   - underlined: 是否添加下划线
    func setLinkStyle(color: UIColor = .systemBlue, underlined: Bool = true) {
        var attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        
        if underlined {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        guard let text = text else { return }
        setAttributedText(text, attributes: attributes)
    }
    
    /// 设置文本为删除线样式
    /// - Parameter color: 删除线颜色
    func setStrikethroughStyle(color: UIColor = .gray) {
        guard let text = text else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: color,
            .foregroundColor: color
        ]
        
        setAttributedText(text, attributes: attributes)
    }
    
    /// 设置文本为下划线样式
    /// - Parameter color: 下划线颜色
    func setUnderlineStyle(color: UIColor = .black) {
        guard let text = text else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: color
        ]
        
        setAttributedText(text, attributes: attributes)
    }
    
    // MARK: - 布局和尺寸
    
    /// 计算文本所需的高度
    /// - Parameter width: 可用宽度
    /// - Returns: 所需高度
    func requiredHeight(forWidth width: CGFloat) -> CGFloat {
        guard let text = text, !text.isEmpty else { return 0 }
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil
        )
        
        return ceil(boundingBox.height)
    }
    
    /// 计算文本所需的宽度
    /// - Parameter height: 可用高度
    /// - Returns: 所需宽度
    func requiredWidth(forHeight height: CGFloat) -> CGFloat {
        guard let text = text, !text.isEmpty else { return 0 }
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil
        )
        
        return ceil(boundingBox.width)
    }
    
    /// 获取文本的边界框
    var textBounds: CGRect {
        guard let text = text, !text.isEmpty else { return .zero }
        
        let size = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil
        )
        
        return boundingBox
    }
    
    /// 自适应标签大小（保持文本可见）
    func sizeToFitText() {
        guard let text = text, !text.isEmpty else { return }
        
        let maxSize = CGSize(width: .greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil
        )
        
        frame.size = CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }
    
    /// 自适应标签宽度（保持高度不变）
    func sizeToFitWidth() {
        guard let text = text, !text.isEmpty else { return }
        
        let height = frame.height
        let boundingBox = text.boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: height),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil
        )
        
        frame.size.width = ceil(boundingBox.width)
    }
    
    /// 自适应标签高度（保持宽度不变）
    func sizeToFitHeight() {
        guard let text = text, !text.isEmpty else { return }
        
        let width = frame.width
        let boundingBox = text.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil
        )
        
        frame.size.height = ceil(boundingBox.height)
    }
    
    /// 检查文本是否被截断
    var isTextTruncated: Bool {
        guard let text = text, !text.isEmpty else { return false }
        
        let textSize = text.boundingRect(
            with: CGSize(width: bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil
        ).size
        
        return textSize.height > bounds.height
    }
    
    /// 获取可见文本
    var visibleText: String? {
        guard let text = text, !text.isEmpty else { return nil }
        
        if !isTextTruncated {
            return text
        }
        
        // 查找可见文本
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: bounds.size)
        let textStorage = NSTextStorage(string: text)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        return layoutManager.attributedSubstring(from: glyphRange).string
    }
    
    // MARK: - 动画效果
    
    /// 淡入文本
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func fadeInText(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /// 淡出文本
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func fadeOutText(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    /// 打字机动画效果
    /// - Parameters:
    ///   - text: 要显示的文本
    ///   - characterDelay: 每个字符的延迟时间
    ///   - completion: 完成回调
    func typewriterEffect(text: String, characterDelay: TimeInterval = 0.05, completion: (() -> Void)? = nil) {
        self.text = ""
        var characterIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: characterDelay, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if characterIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: characterIndex)
                self.text?.append(text[index])
                characterIndex += 1
            } else {
                timer.invalidate()
                completion?()
            }
        }
    }
    
    /// 闪烁动画效果
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - repeatCount: 重复次数（0表示无限）
    func blinkAnimation(duration: TimeInterval = 0.5, repeatCount: Float = .infinity) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = repeatCount
        
        layer.add(animation, forKey: "blink")
    }
    
    /// 停止闪烁动画
    func stopBlinkAnimation() {
        layer.removeAnimation(forKey: "blink")
    }
    
    // MARK: - 工具方法
    
    /// 复制文本到剪贴板
    func copyToClipboard() {
        guard let text = text, !text.isEmpty else { return }
        UIPasteboard.general.string = text
    }
    
    /// 清空文本
    func clear() {
        text = nil
        attributedText = nil
    }
    
    /// 检查文本是否为空
    var isEmpty: Bool {
        guard let text = text else { return true }
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// 获取文本长度
    var textLength: Int {
        return text?.count ?? 0
    }
    
    /// 安全设置文本（防止崩溃）
    /// - Parameter text: 文本内容
    func safeSetText(_ text: String?) {
        self.text = text
    }
    
    /// 安全设置属性文本（防止崩溃）
    /// - Parameter attributedText: 属性文本
    func safeSetAttributedText(_ attributedText: NSAttributedString?) {
        self.attributedText = attributedText
    }
}

// MARK: - UILabel 工厂方法

public extension UILabel {
    
    /// 创建标题标签
    static func createTitleLabel(text: String? = nil) -> UILabel {
        let label = UILabel(text: text)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }
    
    /// 创建副标题标签
    static func createSubtitleLabel(text: String? = nil) -> UILabel {
        let label = UILabel(text: text)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }
    
    /// 创建正文标签
    static func createBodyLabel(text: String? = nil) -> UILabel {
        let label = UILabel(text: text)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }
    
    /// 创建小字体标签
    static func createCaptionLabel(text: String? = nil) -> UILabel {
        let label = UILabel(text: text)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }
    
    /// 创建链接样式标签
    static func createLinkLabel(text: String? = nil) -> UILabel {
        let label = UILabel(text: text)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
        return label
    }
    
    /// 创建错误信息标签
    static func createErrorLabel(text: String? = nil) -> UILabel {
        let label = UILabel(text: text)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemRed
        label.numberOfLines = 0
        return label
    }
    
    /// 创建成功信息标签
    static func createSuccessLabel(text: String? = nil) -> UILabel {
        let label = UILabel(text: text)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGreen
        label.numberOfLines = 0
        return label
    }
}

#endif