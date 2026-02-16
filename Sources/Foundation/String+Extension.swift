// String+Extension.swift
// 字符串扩展，提供便捷和安全的方法

import Foundation

public extension String {
    
    // MARK: - 属性扩展
    
    /// 检查字符串是否为空或仅包含空白字符
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// 检查字符串是否不为空且包含非空白字符
    var isNotBlank: Bool {
        return !isBlank
    }
    
    /// 安全获取字符串的长度
    var safeLength: Int {
        return count
    }
    
    /// 获取移除两端空白后的字符串
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - 便捷方法
    
    /// 安全获取指定索引的字符，如果索引越界则返回 nil
    /// - Parameter index: 字符索引
    /// - Returns: 字符或 nil
    func safeChar(at index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// 安全获取子字符串，如果范围越界则返回 nil
    /// - Parameters:
    ///   - start: 开始索引（包含）
    ///   - end: 结束索引（不包含）
    /// - Returns: 子字符串或 nil
    func safeSubstring(from start: Int, to end: Int) -> String? {
        // 检查范围是否有效
        guard start >= 0, end >= start, end <= count else {
            return nil
        }
        
        // 如果范围为空，返回空字符串
        if start == end {
            return ""
        }
        
        let startIndex = self.index(startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: end - start)
        return String(self[startIndex..<endIndex])
    }
    
    /// 安全获取前缀
    /// - Parameter length: 前缀长度
    /// - Returns: 前缀字符串
    func safePrefix(_ length: Int) -> String {
        guard length > 0 && length <= count else { return self }
        return String(prefix(length))
    }
    
    /// 安全获取后缀
    /// - Parameter length: 后缀长度
    /// - Returns: 后缀字符串
    func safeSuffix(_ length: Int) -> String {
        guard length > 0 && length <= count else { return self }
        return String(suffix(length))
    }
    
    /// 检查字符串是否以指定前缀开头（不区分大小写）
    /// - Parameter prefix: 前缀
    /// - Returns: 是否以该前缀开头
    func hasCaseInsensitivePrefix(_ prefix: String) -> Bool {
        return lowercased().hasPrefix(prefix.lowercased())
    }
    
    /// 检查字符串是否以指定后缀结尾（不区分大小写）
    /// - Parameter suffix: 后缀
    /// - Returns: 是否以该后缀结尾
    func hasCaseInsensitiveSuffix(_ suffix: String) -> Bool {
        return lowercased().hasSuffix(suffix.lowercased())
    }
    
    /// 转换为首字母大写
    /// - Returns: 首字母大写的字符串
    func capitalizedFirstLetter() -> String {
        guard let firstChar = first else { return self }
        return String(firstChar).uppercased() + dropFirst()
    }
    
    // MARK: - 验证方法
    
    /// 验证是否是有效的电子邮件地址
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    /// 验证是否是有效的手机号码（中国）
    var isValidChineseMobile: Bool {
        let mobileRegEx = "^1[3-9]\\d{9}$"
        let mobilePredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
        return mobilePredicate.evaluate(with: self)
    }
    
    /// 验证是否是有效的身份证号码（中国）
    var isValidChineseID: Bool {
        let idRegEx = "^[1-9]\\d{5}(18|19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$"
        let idPredicate = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        return idPredicate.evaluate(with: self)
    }
    
    // MARK: - 转换方法
    
    /// 转换为整数，如果转换失败则返回默认值
    /// - Parameter defaultValue: 默认值
    /// - Returns: 整数
    func toInt(defaultValue: Int = 0) -> Int {
        return Int(self) ?? defaultValue
    }
    
    /// 转换为浮点数，如果转换失败则返回默认值
    /// - Parameter defaultValue: 默认值
    /// - Returns: 浮点数
    func toDouble(defaultValue: Double = 0.0) -> Double {
        return Double(self) ?? defaultValue
    }
    
    /// 转换为布尔值
    /// - Returns: 布尔值
    func toBool() -> Bool {
        let lowercased = self.lowercased()
        return lowercased == "true" || lowercased == "1" || lowercased == "yes" || lowercased == "y"
    }
    
    /// 转换为 URL，如果转换失败则返回 nil
    var toURL: URL? {
        return URL(string: self)
    }
    
    /// 转换为安全的 URL，自动添加协议前缀
    var toSafeURL: URL? {
        // 空字符串或空白字符串不是有效的URL
        if isBlank {
            return nil
        }
        
        var urlString = self.trimmed
        if !hasPrefix("http://") && !hasPrefix("https://") {
            urlString = "https://" + urlString
        }
        return URL(string: urlString)
    }
}