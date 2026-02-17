// NSAttributedString+Extension.swift
// 富文本字符串扩展，提供便捷的富文本创建和操作方法

import Foundation

#if canImport(UIKit)
import UIKit

public extension NSAttributedString {
    
    // MARK: - 属性访问
    
    /// 获取字符串长度（字符数）
    var length: Int {
        return self.string.count
    }
    
    /// 获取基础字符串
    var baseString: String {
        return self.string
    }
    
    /// 获取所有属性范围
    var attributeRanges: [NSRange] {
        var ranges: [NSRange] = []
        var location = 0
        let length = self.length
        
        while location < length {
            var effectiveRange = NSRange(location: 0, length: 0)
            _ = attributes(at: location, effectiveRange: &effectiveRange)
            ranges.append(effectiveRange)
            location = effectiveRange.location + effectiveRange.length
        }
        
        return ranges
    }
    
    // MARK: - 创建方法
    
    /// 创建带有指定属性的富文本字符串
    /// - Parameters:
    ///   - string: 基础字符串
    ///   - attributes: 属性字典
    convenience init(string: String, attributes: [NSAttributedString.Key: Any]? = nil) {
        self.init(string: string, attributes: attributes)
    }
    
    /// 创建带有单一属性的富文本字符串
    /// - Parameters:
    ///   - string: 基础字符串
    ///   - attributeKey: 属性键
    ///   - attributeValue: 属性值
    convenience init(string: String, attributeKey: NSAttributedString.Key, attributeValue: Any) {
        self.init(string: string, attributes: [attributeKey: attributeValue])
    }
    
    // MARK: - 样式创建（便利方法）
    
    /// 创建带有字体样式的富文本字符串
    /// - Parameters:
    ///   - string: 基础字符串
    ///   - font: 字体
    ///   - textColor: 文字颜色（可选）
    static func styled(string: String, font: UIFont, textColor: UIColor? = nil) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    /// 创建带有段落样式的富文本字符串
    /// - Parameters:
    ///   - string: 基础字符串
    ///   - alignment: 文本对齐方式
    ///   - lineSpacing: 行间距
    static func styled(string: String, alignment: NSTextAlignment, lineSpacing: CGFloat = 0) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle])
    }
    
    /// 创建链接样式的富文本字符串
    /// - Parameters:
    ///   - string: 基础字符串
    ///   - url: 链接URL
    ///   - textColor: 文字颜色（默认为蓝色）
    static func link(string: String, url: URL, textColor: UIColor = .systemBlue) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: url
        ]
        
        attributes[.font] = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: - 属性操作
    
    /// 安全获取指定位置的属性
    /// - Parameter location: 位置索引
    /// - Returns: 属性字典（如果位置有效）
    func safeAttributes(at location: Int) -> [NSAttributedString.Key: Any]? {
        guard location >= 0 && location < length else {
            return nil
        }
        return attributes(at: location, effectiveRange: nil)
    }
    
    /// 安全获取指定范围内的属性
    /// - Parameter range: 范围
    /// - Returns: 属性字典数组（如果范围有效）
    func safeAttributes(in range: NSRange) -> [[NSAttributedString.Key: Any]]? {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return nil
        }
        
        var attributesList: [[NSAttributedString.Key: Any]] = []
        var location = range.location
        let endLocation = range.location + range.length
        
        while location < endLocation {
            var effectiveRange = NSRange(location: 0, length: 0)
            let attributes = self.attributes(at: location, effectiveRange: &effectiveRange)
            attributesList.append(attributes)
            location = effectiveRange.location + effectiveRange.length
        }
        
        return attributesList
    }
    
    /// 获取指定属性键的值
    /// - Parameters:
    ///   - attributeKey: 属性键
    ///   - location: 位置索引
    ///   - defaultValue: 默认值（当属性不存在时返回）
    /// - Returns: 属性值
    func value<T>(forAttribute attributeKey: NSAttributedString.Key, at location: Int, defaultValue: T) -> T {
        guard let attributes = safeAttributes(at: location),
              let value = attributes[attributeKey] as? T else {
            return defaultValue
        }
        return value
    }
    
    // MARK: - 样式检查
    
    /// 检查是否包含指定属性
    /// - Parameter attributeKey: 属性键
    /// - Returns: 是否包含该属性
    func containsAttribute(_ attributeKey: NSAttributedString.Key) -> Bool {
        var found = false
        enumerateAttribute(attributeKey, in: NSRange(location: 0, length: length)) { value, _, stop in
            if value != nil {
                found = true
                stop.pointee = true
            }
        }
        return found
    }
    
    /// 检查指定位置是否包含指定属性
    /// - Parameters:
    ///   - attributeKey: 属性键
    ///   - location: 位置索引
    /// - Returns: 是否包含该属性
    func containsAttribute(_ attributeKey: NSAttributedString.Key, at location: Int) -> Bool {
        guard let attributes = safeAttributes(at: location) else {
            return false
        }
        return attributes[attributeKey] != nil
    }
    
    // MARK: - 富文本操作
    
    /// 附加另一个富文本字符串
    /// - Parameter other: 要附加的富文本字符串
    /// - Returns: 新的富文本字符串
    func appending(_ other: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        result.append(other)
        return NSAttributedString(attributedString: result)
    }
    
    /// 插入富文本字符串到指定位置
    /// - Parameters:
    ///   - other: 要插入的富文本字符串
    ///   - location: 插入位置
    /// - Returns: 新的富文本字符串（如果位置有效）
    func inserting(_ other: NSAttributedString, at location: Int) -> NSAttributedString? {
        guard location >= 0 && location <= length else {
            return nil
        }
        
        let result = NSMutableAttributedString(attributedString: self)
        result.insert(other, at: location)
        return NSAttributedString(attributedString: result)
    }
    
    /// 删除指定范围的字符
    /// - Parameter range: 要删除的范围
    /// - Returns: 新的富文本字符串（如果范围有效）
    func deletingCharacters(in range: NSRange) -> NSAttributedString? {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return nil
        }
        
        let result = NSMutableAttributedString(attributedString: self)
        result.deleteCharacters(in: range)
        return NSAttributedString(attributedString: result)
    }
    
    /// 替换指定范围的字符
    /// - Parameters:
    ///   - range: 要替换的范围
    ///   - other: 替换的富文本字符串
    /// - Returns: 新的富文本字符串（如果范围有效）
    func replacingCharacters(in range: NSRange, with other: NSAttributedString) -> NSAttributedString? {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return nil
        }
        
        let result = NSMutableAttributedString(attributedString: self)
        result.replaceCharacters(in: range, with: other)
        return NSAttributedString(attributedString: result)
    }
    
    /// 获取子富文本字符串
    /// - Parameter range: 范围
    /// - Returns: 子富文本字符串（如果范围有效）
    func substring(with range: NSRange) -> NSAttributedString? {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return nil
        }
        
        return attributedSubstring(from: range)
    }
    
    // MARK: - 样式修改
    
    /// 为整个字符串添加属性
    /// - Parameters:
    ///   - attributeKey: 属性键
    ///   - attributeValue: 属性值
    /// - Returns: 新的富文本字符串
    func addingAttribute(_ attributeKey: NSAttributedString.Key, value: Any) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        result.addAttribute(attributeKey, value: value, range: NSRange(location: 0, length: length))
        return NSAttributedString(attributedString: result)
    }
    
    /// 为指定范围添加属性
    /// - Parameters:
    ///   - attributeKey: 属性键
    ///   - attributeValue: 属性值
    ///   - range: 范围
    /// - Returns: 新的富文本字符串（如果范围有效）
    func addingAttribute(_ attributeKey: NSAttributedString.Key, value: Any, range: NSRange) -> NSAttributedString? {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return nil
        }
        
        let result = NSMutableAttributedString(attributedString: self)
        result.addAttribute(attributeKey, value: value, range: range)
        return NSAttributedString(attributedString: result)
    }
    
    /// 移除整个字符串的指定属性
    /// - Parameter attributeKey: 属性键
    /// - Returns: 新的富文本字符串
    func removingAttribute(_ attributeKey: NSAttributedString.Key) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        result.removeAttribute(attributeKey, range: NSRange(location: 0, length: length))
        return NSAttributedString(attributedString: result)
    }
    
    /// 移除指定范围的属性
    /// - Parameters:
    ///   - attributeKey: 属性键
    ///   - range: 范围
    /// - Returns: 新的富文本字符串（如果范围有效）
    func removingAttribute(_ attributeKey: NSAttributedString.Key, range: NSRange) -> NSAttributedString? {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return nil
        }
        
        let result = NSMutableAttributedString(attributedString: self)
        result.removeAttribute(attributeKey, range: range)
        return NSAttributedString(attributedString: result)
    }
    
    // MARK: - 常见样式设置
    
    /// 设置字体
    /// - Parameter font: 字体
    /// - Returns: 新的富文本字符串
    func withFont(_ font: UIFont) -> NSAttributedString {
        return addingAttribute(.font, value: font)
    }
    
    /// 设置文字颜色
    /// - Parameter color: 颜色
    /// - Returns: 新的富文本字符串
    func withTextColor(_ color: UIColor) -> NSAttributedString {
        return addingAttribute(.foregroundColor, value: color)
    }
    
    /// 设置背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: 新的富文本字符串
    func withBackgroundColor(_ color: UIColor) -> NSAttributedString {
        return addingAttribute(.backgroundColor, value: color)
    }
    
    /// 设置下划线样式
    /// - Parameters:
    ///   - style: 下划线样式
    ///   - color: 下划线颜色（可选）
    /// - Returns: 新的富文本字符串
    func withUnderline(style: NSUnderlineStyle = .single, color: UIColor? = nil) -> NSAttributedString {
        var result = addingAttribute(.underlineStyle, value: style.rawValue)
        if let color = color {
            result = result.addingAttribute(.underlineColor, value: color)
        }
        return result
    }
    
    /// 设置删除线样式
    /// - Parameters:
    ///   - style: 删除线样式
    ///   - color: 删除线颜色（可选）
    /// - Returns: 新的富文本字符串
    func withStrikethrough(style: NSUnderlineStyle = .single, color: UIColor? = nil) -> NSAttributedString {
        var result = addingAttribute(.strikethroughStyle, value: style.rawValue)
        if let color = color {
            result = result.addingAttribute(.strikethroughColor, value: color)
        }
        return result
    }
    
    /// 设置字间距
    /// - Parameter spacing: 字间距（以磅为单位）
    /// - Returns: 新的富文本字符串
    func withKern(_ spacing: CGFloat) -> NSAttributedString {
        return addingAttribute(.kern, value: spacing)
    }
    
    /// 设置段落样式
    /// - Parameter paragraphStyle: 段落样式
    /// - Returns: 新的富文本字符串
    func withParagraphStyle(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        return addingAttribute(.paragraphStyle, value: paragraphStyle)
    }
    
    /// 设置链接
    /// - Parameter url: 链接URL
    /// - Returns: 新的富文本字符串
    func withLink(_ url: URL) -> NSAttributedString {
        return addingAttribute(.link, value: url)
    }
    
    // MARK: - 实用工具
    
    /// 转换为HTML格式字符串
    /// - Returns: HTML字符串
    func toHTML() -> String? {
        let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html
        ]
        
        do {
            let htmlData = try data(from: NSRange(location: 0, length: length), 
                                    documentAttributes: documentAttributes)
            return String(data: htmlData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    /// 从HTML字符串创建富文本
    /// - Parameters:
    ///   - html: HTML字符串
    ///   - options: HTML解析选项
    /// - Returns: 富文本字符串
    static func fromHTML(_ html: String, options: [NSAttributedString.DocumentReadingOptionKey: Any]? = nil) -> NSAttributedString? {
        guard let htmlData = html.data(using: .utf8) else {
            return nil
        }
        
        let defaultOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            return try NSAttributedString(data: htmlData, 
                                          options: options ?? defaultOptions, 
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    /// 获取字符串的大小（根据指定约束）
    /// - Parameters:
    ///   - maxWidth: 最大宽度
    ///   - maxHeight: 最大高度
    /// - Returns: 字符串大小
    func size(maxWidth: CGFloat = .greatestFiniteMagnitude, maxHeight: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let constraintRect = CGSize(width: maxWidth, height: maxHeight)
        let boundingBox = boundingRect(with: constraintRect, 
                                       options: .usesLineFragmentOrigin, 
                                       context: nil)
        return CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }
}

// MARK: - NSMutableAttributedString 扩展

public extension NSMutableAttributedString {
    
    /// 安全设置属性
    /// - Parameters:
    ///   - attributeKey: 属性键
    ///   - attributeValue: 属性值
    ///   - range: 范围
    /// - Returns: 是否设置成功
    @discardableResult
    func safeSetAttribute(_ attributeKey: NSAttributedString.Key, value: Any, range: NSRange) -> Bool {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return false
        }
        
        addAttribute(attributeKey, value: value, range: range)
        return true
    }
    
    /// 安全移除属性
    /// - Parameters:
    ///   - attributeKey: 属性键
    ///   - range: 范围
    /// - Returns: 是否移除成功
    @discardableResult
    func safeRemoveAttribute(_ attributeKey: NSAttributedString.Key, range: NSRange) -> Bool {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return false
        }
        
        removeAttribute(attributeKey, range: range)
        return true
    }
    
    /// 安全插入富文本字符串
    /// - Parameters:
    ///   - attrString: 富文本字符串
    ///   - location: 插入位置
    /// - Returns: 是否插入成功
    @discardableResult
    func safeInsert(_ attrString: NSAttributedString, at location: Int) -> Bool {
        guard location >= 0 && location <= length else {
            return false
        }
        
        insert(attrString, at: location)
        return true
    }
    
    /// 安全删除字符
    /// - Parameter range: 要删除的范围
    /// - Returns: 是否删除成功
    @discardableResult
    func safeDeleteCharacters(in range: NSRange) -> Bool {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return false
        }
        
        deleteCharacters(in: range)
        return true
    }
    
    /// 安全替换字符
    /// - Parameters:
    ///   - range: 要替换的范围
    ///   - attrString: 替换的富文本字符串
    /// - Returns: 是否替换成功
    @discardableResult
    func safeReplaceCharacters(in range: NSRange, with attrString: NSAttributedString) -> Bool {
        guard range.location >= 0 && range.length >= 0 && range.location + range.length <= length else {
            return false
        }
        
        replaceCharacters(in: range, with: attrString)
        return true
    }
}

// MARK: - 字符串扩展，添加富文本支持

public extension String {
    
    /// 转换为富文本字符串
    var toAttributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    /// 创建带有字体样式的富文本字符串
    /// - Parameters:
    ///   - font: 字体
    ///   - textColor: 文字颜色（可选）
    /// - Returns: 富文本字符串
    func toAttributedString(font: UIFont, textColor: UIColor? = nil) -> NSAttributedString {
        return NSAttributedString.styled(string: self, font: font, textColor: textColor)
    }
    
    /// 创建链接样式的富文本字符串
    /// - Parameters:
    ///   - url: 链接URL
    ///   - textColor: 文字颜色（默认为蓝色）
    /// - Returns: 富文本字符串
    func toLinkAttributedString(url: URL, textColor: UIColor = .systemBlue) -> NSAttributedString {
        return NSAttributedString.link(string: self, url: url, textColor: textColor)
    }
    
    /// 创建带有段落样式的富文本字符串
    /// - Parameters:
    ///   - alignment: 文本对齐方式
    ///   - lineSpacing: 行间距
    /// - Returns: 富文本字符串
    func toAttributedString(alignment: NSTextAlignment, lineSpacing: CGFloat = 0) -> NSAttributedString {
        return NSAttributedString.styled(string: self, alignment: alignment, lineSpacing: lineSpacing)
    }
    
    /// 从HTML字符串创建富文本
    /// - Parameter options: HTML解析选项
    /// - Returns: 富文本字符串
    func toAttributedStringFromHTML(options: [NSAttributedString.DocumentReadingOptionKey: Any]? = nil) -> NSAttributedString? {
        return NSAttributedString.fromHTML(self, options: options)
    }
}

#endif