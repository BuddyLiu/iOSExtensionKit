// UITextField+Extension.swift
// UIKit文本字段扩展，提供便捷的文本字段配置和操作方法

#if canImport(UIKit)
import UIKit

public extension UITextField {
    
    // MARK: - 便捷属性设置
    
    /// 设置占位符文本
    /// - Parameter text: 占位符文本
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func placeholder(_ text: String?) -> Self {
        placeholder = text
        return self
    }
    
    /// 设置占位符文本颜色
    /// - Parameter color: 颜色
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func placeholderColor(_ color: UIColor) -> Self {
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: color]
            )
        }
        return self
    }
    
    /// 设置文本颜色
    /// - Parameter color: 颜色
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }
    
    /// 设置字体
    /// - Parameter font: 字体
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    /// 设置系统字体大小
    /// - Parameters:
    ///   - size: 字体大小
    ///   - weight: 字体粗细
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func systemFont(size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    /// 设置对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    /// 设置边框样式
    /// - Parameter style: 边框样式
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        borderStyle = style
        return self
    }
    
    /// 设置清除按钮模式
    /// - Parameter mode: 清除按钮模式
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        clearButtonMode = mode
        return self
    }
    
    /// 设置键盘类型
    /// - Parameter type: 键盘类型
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        keyboardType = type
        return self
    }
    
    /// 设置返回键类型
    /// - Parameter type: 返回键类型
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        returnKeyType = type
        return self
    }
    
    /// 设置自动大写类型
    /// - Parameter type: 自动大写类型
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> Self {
        autocapitalizationType = type
        return self
    }
    
    /// 设置自动纠正类型
    /// - Parameter type: 自动纠正类型
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func autocorrectionType(_ type: UITextAutocorrectionType) -> Self {
        autocorrectionType = type
        return self
    }
    
    /// 设置是否安全输入
    /// - Parameter isSecure: 是否安全输入
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func isSecureTextEntry(_ isSecure: Bool) -> Self {
        isSecureTextEntry = isSecure
        return self
    }
    
    /// 设置左侧视图
    /// - Parameter view: 左侧视图
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func leftView(_ view: UIView?) -> Self {
        leftView = view
        return self
    }
    
    /// 设置左侧视图模式
    /// - Parameter mode: 左侧视图模式
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func leftViewMode(_ mode: UITextField.ViewMode) -> Self {
        leftViewMode = mode
        return self
    }
    
    /// 设置右侧视图
    /// - Parameter view: 右侧视图
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func rightView(_ view: UIView?) -> Self {
        rightView = view
        return self
    }
    
    /// 设置右侧视图模式
    /// - Parameter mode: 右侧视图模式
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func rightViewMode(_ mode: UITextField.ViewMode) -> Self {
        rightViewMode = mode
        return self
    }
    
    // MARK: - 文本操作
    
    /// 清空文本
    func clearText() {
        text = ""
    }
    
    /// 安全获取文本（如果文本为nil则返回空字符串）
    var safeText: String {
        return text ?? ""
    }
    
    /// 安全获取修剪后的文本（去除两端空白字符）
    var trimmedText: String {
        return safeText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 检查文本是否为空（忽略空白字符）
    var isTextEmpty: Bool {
        return trimmedText.isEmpty
    }
    
    /// 检查文本是否非空（忽略空白字符）
    var isTextNotEmpty: Bool {
        return !isTextEmpty
    }
    
    /// 获取文本长度（忽略空白字符）
    var textLength: Int {
        return trimmedText.count
    }
    
    /// 设置文本并触发编辑事件
    /// - Parameter text: 文本
    func setTextWithEvent(_ text: String?) {
        self.text = text
        sendActions(for: .editingChanged)
    }
    
    /// 在文本末尾追加字符串
    /// - Parameter string: 要追加的字符串
    func appendText(_ string: String) {
        text = safeText + string
        sendActions(for: .editingChanged)
    }
    
    /// 在文本开头插入字符串
    /// - Parameter string: 要插入的字符串
    func prependText(_ string: String) {
        text = string + safeText
        sendActions(for: .editingChanged)
    }
    
    // MARK: - 输入验证
    
    /// 验证文本是否为有效邮箱地址
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: trimmedText)
    }
    
    /// 验证文本是否为有效手机号（中国）
    var isValidChineseMobile: Bool {
        let mobileRegex = "^1[3-9]\\d{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return predicate.evaluate(with: trimmedText)
    }
    
    /// 验证文本是否为有效身份证号（中国）
    var isValidChineseID: Bool {
        let idRegex = "^[1-9]\\d{5}(18|19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return predicate.evaluate(with: trimmedText)
    }
    
    /// 验证文本是否仅包含数字
    var isNumeric: Bool {
        let numericRegex = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numericRegex)
        return predicate.evaluate(with: trimmedText)
    }
    
    /// 验证文本是否仅包含字母
    var isAlphabetic: Bool {
        let alphabeticRegex = "^[A-Za-z]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", alphabeticRegex)
        return predicate.evaluate(with: trimmedText)
    }
    
    /// 验证文本是否仅包含字母和数字
    var isAlphanumeric: Bool {
        let alphanumericRegex = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", alphanumericRegex)
        return predicate.evaluate(with: trimmedText)
    }
    
    /// 验证文本长度是否在指定范围内
    /// - Parameters:
    ///   - minLength: 最小长度
    ///   - maxLength: 最大长度
    /// - Returns: 是否在范围内
    func isValidLength(min: Int = 0, max: Int = Int.max) -> Bool {
        let length = textLength
        return length >= min && length <= max
    }
    
    // MARK: - 样式设置
    
    /// 添加边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func addBorder(color: UIColor, width: CGFloat = 1) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        return self
    }
    
    /// 添加圆角
    /// - Parameter radius: 圆角半径
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func roundCorners(radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    /// 设置内边距
    /// - Parameter padding: 内边距
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func padding(_ padding: CGFloat) -> Self {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
        return self
    }
    
    /// 设置左侧内边距
    /// - Parameter padding: 左侧内边距
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func leftPadding(_ padding: CGFloat) -> Self {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
        return self
    }
    
    /// 设置右侧内边距
    /// - Parameter padding: 右侧内边距
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func rightPadding(_ padding: CGFloat) -> Self {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        rightView = paddingView
        rightViewMode = .always
        return self
    }
    
    /// 设置图标作为左侧视图
    /// - Parameters:
    ///   - image: 图标
    ///   - tintColor: 图标颜色
    ///   - padding: 图标与文本的间距
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func leftIcon(_ image: UIImage?, tintColor: UIColor? = nil, padding: CGFloat = 8) -> Self {
        guard let image = image else { return self }
        
        let iconView = UIImageView(image: image)
        if let tintColor = tintColor {
            iconView.tintColor = tintColor
        }
        iconView.contentMode = .center
        iconView.frame = CGRect(x: 0, y: 0, width: image.size.width + padding * 2, height: frame.height)
        
        leftView = iconView
        leftViewMode = .always
        return self
    }
    
    /// 设置图标作为右侧视图
    /// - Parameters:
    ///   - image: 图标
    ///   - tintColor: 图标颜色
    ///   - padding: 图标与文本的间距
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func rightIcon(_ image: UIImage?, tintColor: UIColor? = nil, padding: CGFloat = 8) -> Self {
        guard let image = image else { return self }
        
        let iconView = UIImageView(image: image)
        if let tintColor = tintColor {
            iconView.tintColor = tintColor
        }
        iconView.contentMode = .center
        iconView.frame = CGRect(x: 0, y: 0, width: image.size.width + padding * 2, height: frame.height)
        
        rightView = iconView
        rightViewMode = .always
        return self
    }
    
    /// 设置按钮作为右侧视图
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - target: 目标对象
    ///   - action: 动作选择器
    /// - Returns: 文本字段本身，支持链式调用
    @discardableResult
    func rightButton(title: String, target: Any?, action: Selector) -> Self {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        
        let buttonWidth = button.frame.width + 16
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: frame.height)
        
        rightView = button
        rightViewMode = .always
        return self
    }
    
    // MARK: - 事件处理
    
    /// 添加编辑变化回调
    /// - Parameter handler: 回调闭包
    @discardableResult
    func onEditingChanged(_ handler: @escaping (String) -> Void) -> Self {
        addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        objc_setAssociatedObject(self, &AssociatedKeys.editingChangedHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
    
    /// 添加编辑开始回调
    /// - Parameter handler: 回调闭包
    @discardableResult
    func onEditingDidBegin(_ handler: @escaping () -> Void) -> Self {
        addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
        objc_setAssociatedObject(self, &AssociatedKeys.editingDidBeginHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
    
    /// 添加编辑结束回调
    /// - Parameter handler: 回调闭包
    @discardableResult
    func onEditingDidEnd(_ handler: @escaping () -> Void) -> Self {
        addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
        objc_setAssociatedObject(self, &AssociatedKeys.editingDidEndHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
    
    /// 添加返回键回调
    /// - Parameter handler: 回调闭包
    @discardableResult
    func onReturn(_ handler: @escaping () -> Bool) -> Self {
        addTarget(self, action: #selector(handleReturn), for: .editingDidEndOnExit)
        objc_setAssociatedObject(self, &AssociatedKeys.returnHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
    
    /// 添加文本变化限制
    /// - Parameters:
    ///   - maxLength: 最大长度
    ///   - handler: 超出限制时的回调（可选）
    @discardableResult
    func limitTextLength(maxLength: Int, onExceed: ((String) -> Void)? = nil) -> Self {
        addTarget(self, action: #selector(handleTextLimit), for: .editingChanged)
        objc_setAssociatedObject(self, &AssociatedKeys.maxLength, maxLength, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let onExceed = onExceed {
            objc_setAssociatedObject(self, &AssociatedKeys.exceedHandler, onExceed, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return self
    }
    
    // MARK: - 私有处理方法和关联对象键
    
    private struct AssociatedKeys {
        static var editingChangedHandler = "editingChangedHandler"
        static var editingDidBeginHandler = "editingDidBeginHandler"
        static var editingDidEndHandler = "editingDidEndHandler"
        static var returnHandler = "returnHandler"
        static var maxLength = "maxLength"
        static var exceedHandler = "exceedHandler"
    }
    
    @objc private func handleEditingChanged() {
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.editingChangedHandler) as? (String) -> Void {
            handler(safeText)
        }
    }
    
    @objc private func handleEditingDidBegin() {
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.editingDidBeginHandler) as? () -> Void {
            handler()
        }
    }
    
    @objc private func handleEditingDidEnd() {
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.editingDidEndHandler) as? () -> Void {
            handler()
        }
    }
    
    @objc private func handleReturn() {
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.returnHandler) as? () -> Bool {
            _ = handler()
        }
    }
    
    @objc private func handleTextLimit() {
        guard let maxLength = objc_getAssociatedObject(self, &AssociatedKeys.maxLength) as? Int else { return }
        
        guard let text = text, text.count > maxLength else { return }
        
        let index = text.index(text.startIndex, offsetBy: maxLength)
        self.text = String(text[..<index])
        
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.exceedHandler) as? (String) -> Void {
            handler(text)
        }
    }
    
    // MARK: - 实用方法
    
    /// 成为第一响应者并显示键盘
    func showKeyboard() {
        becomeFirstResponder()
    }
    
    /// 放弃第一响应者并隐藏键盘
    func hideKeyboard() {
        resignFirstResponder()
    }
    
    /// 检查是否正在编辑（是否为第一响应者）
    var isEditingText: Bool {
        return isFirstResponder
    }
    
    /// 设置文本选择范围
    /// - Parameter range: 选择范围
    func selectText(in range: NSRange) {
        guard let startPosition = position(from: beginningOfDocument, offset: range.location),
              let endPosition = position(from: startPosition, offset: range.length),
              let textRange = textRange(from: startPosition, to: endPosition) else {
            return
        }
        
        selectedTextRange = textRange
    }
    
    /// 选择所有文本
    func selectAllText() {
        selectedTextRange = textRange(from: beginningOfDocument, to: endOfDocument)
    }
    
    /// 获取当前选择范围
    var selectedRange: NSRange? {
        guard let selectedRange = selectedTextRange else { return nil }
        
        let location = offset(from: beginningOfDocument, to: selectedRange.start)
        let length = offset(from: selectedRange.start, to: selectedRange.end)
        
        return NSRange(location: location, length: length)
    }
    
    /// 在光标位置插入文本
    /// - Parameter text: 要插入的文本
    func insertTextAtCursor(_ text: String) {
        guard let selectedRange = selectedTextRange else { return }
        replace(selectedRange, withText: text)
    }
    
    // MARK: - 工厂方法
    
    /// 创建邮箱输入框
    /// - Parameters:
    ///   - placeholder: 占位符
    ///   - keyboardType: 键盘类型（默认为.emailAddress）
    /// - Returns: 配置好的邮箱输入框
    static func emailField(placeholder: String = "请输入邮箱", keyboardType: UIKeyboardType = .emailAddress) -> UITextField {
        return UITextField()
            .placeholder(placeholder)
            .keyboardType(keyboardType)
            .autocapitalizationType(.none)
            .autocorrectionType(.no)
    }
    
    /// 创建密码输入框
    /// - Parameter placeholder: 占位符
    /// - Returns: 配置好的密码输入框
    static func passwordField(placeholder: String = "请输入密码") -> UITextField {
        return UITextField()
            .placeholder(placeholder)
            .isSecureTextEntry(true)
            .autocapitalizationType(.none)
            .autocorrectionType(.no)
    }
    
    /// 创建手机号输入框
    /// - Parameter placeholder: 占位符
    /// - Returns: 配置好的手机号输入框
    static func phoneField(placeholder: String = "请输入手机号") -> UITextField {
        return UITextField()
            .placeholder(placeholder)
            .keyboardType(.phonePad)
    }
    
    /// 创建数字输入框
    /// - Parameters:
    ///   - placeholder: 占位符
    ///   - keyboardType: 键盘类型（默认为.decimalPad）
    /// - Returns: 配置好的数字输入框
    static func numberField(placeholder: String = "请输入数字", keyboardType: UIKeyboardType = .decimalPad) -> UITextField {
        return UITextField()
            .placeholder(placeholder)
            .keyboardType(keyboardType)
    }
    
    /// 创建搜索框
    /// - Parameter placeholder: 占位符
    /// - Returns: 配置好的搜索框
    static func searchField(placeholder: String = "搜索") -> UITextField {
        let searchIcon = UIImage(systemName: "magnifyingglass") ?? UIImage()
        return UITextField()
            .placeholder(placeholder)
            .leftIcon(searchIcon, tintColor: .lightGray)
            .roundCorners(radius: 8)
            .addBorder(color: .lightGray)
            .leftPadding(8)
    }
}

// MARK: - UITextField 链式调用示例

public extension UITextField {
    
    /// 链式设置样式为圆角边框
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    /// - Returns: 文本字段本身
    func styledAsRoundedBorder(cornerRadius: CGFloat = 8, borderColor: UIColor = .lightGray, borderWidth: CGFloat = 1) -> Self {
        return self
            .roundCorners(radius: cornerRadius)
            .addBorder(color: borderColor, width: borderWidth)
            .leftPadding(8)
    }
    
    /// 链式设置样式为下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - height: 下划线高度
    /// - Returns: 文本字段本身
    func styledAsUnderline(color: UIColor = .lightGray, height: CGFloat = 1) -> Self {
        borderStyle = .none
        
        let underline = UIView()
        underline.backgroundColor = color
        addSubview(underline)
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: height)
        ])
        
        return self
    }
}

#endif