// Localization+Extension.swift
// 国际化/本地化扩展，提供便捷的本地化字符串访问、语言切换、格式化等功能

import Foundation

// MARK: - 本地化字符串扩展

public extension String {
    
    /// 获取本地化字符串
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// 获取带注释的本地化字符串
    /// - Parameter comment: 本地化注释
    /// - Returns: 本地化字符串
    func localized(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    /// 获取带参数的本地化字符串
    /// - Parameter arguments: 格式化参数
    /// - Returns: 本地化字符串
    func localized(with arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
    
    /// 从指定的包中获取本地化字符串
    /// - Parameters:
    ///   - bundle: 本地化包
    ///   - tableName: 本地化表名
    /// - Returns: 本地化字符串
    func localized(in bundle: Bundle, tableName: String? = nil) -> String {
        return bundle.localizedString(forKey: self, value: nil, table: tableName)
    }
    
    /// 获取本地化字符串（如果不存在则返回默认值）
    /// - Parameter defaultValue: 默认值
    /// - Returns: 本地化字符串或默认值
    func localizedOrDefault(_ defaultValue: String) -> String {
        let localized = self.localized
        return localized == self ? defaultValue : localized
    }
    
    /// 检查是否有本地化字符串
    var hasLocalization: Bool {
        let localized = self.localized
        return localized != self
    }
    
    /// 获取本地化字符串长度
    var localizedLength: Int {
        return localized.count
    }
    
    /// 安全获取本地化字符串（如果本地化失败则返回原字符串）
    var safeLocalized: String {
        let localized = self.localized
        return localized.isEmpty ? self : localized
    }
}

// MARK: - Bundle本地化扩展

public extension Bundle {
    
    /// 当前应用支持的语言列表
    static var supportedLanguages: [String] {
        guard let preferredLanguages = Bundle.main.localizations else { return [] }
        return preferredLanguages
    }
    
    /// 当前应用的首选语言
    static var preferredLanguage: String {
        return Bundle.main.preferredLocalizations.first ?? "en"
    }
    
    /// 获取指定语言的本地化字符串
    /// - Parameters:
    ///   - key: 本地化键
    ///   - language: 目标语言
    ///   - table: 本地化表名
    /// - Returns: 本地化字符串
    func localizedString(forKey key: String, language: String, table: String? = nil) -> String {
        guard let path = path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return key
        }
        return bundle.localizedString(forKey: key, value: nil, table: table)
    }
    
    /// 获取所有本地化字符串
    /// - Parameter table: 本地化表名
    /// - Returns: 本地化字符串字典
    func allLocalizedStrings(forTable table: String? = nil) -> [String: String] {
        var result: [String: String] = [:]
        
        for language in Bundle.supportedLanguages {
            guard let path = path(forResource: language, ofType: "lproj"),
                  let bundle = Bundle(path: path),
                  let path = bundle.path(forResource: table, ofType: "strings"),
                  let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
                continue
            }
            
            for (key, value) in dictionary {
                if result[key] == nil {
                    result[key] = value
                }
            }
        }
        
        return result
    }
    
    /// 检查是否有指定语言的本地化
    /// - Parameter language: 语言代码
    /// - Returns: 是否有本地化
    func hasLocalization(for language: String) -> Bool {
        return path(forResource: language, ofType: "lproj") != nil
    }
    
    /// 获取指定语言的本地化包
    /// - Parameter language: 语言代码
    /// - Returns: 本地化包
    func bundle(for language: String) -> Bundle? {
        guard let path = path(forResource: language, ofType: "lproj") else { return nil }
        return Bundle(path: path)
    }
}

// MARK: - 语言管理器

/// 语言管理器
public final class LanguageManager: @unchecked Sendable {
    
    public static let shared = LanguageManager()
    
    private let userDefaultsKey = "com.iosexkit.preferredLanguage"
    private let notificationCenter = NotificationCenter.default
    
    /// 当前语言
    public private(set) var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// 支持的语言列表
    public let supportedLanguages: [String]
    
    /// 系统语言
    public var systemLanguage: String {
        return Locale.preferredLanguages.first ?? "en"
    }
    
    /// 是否是RTL语言（从右到左）
    public var isRTL: Bool {
        let rtlLanguages = ["ar", "he", "fa", "ur"]
        return rtlLanguages.contains(currentLanguage)
    }
    
    /// 语言改变通知名称
    public static let languageDidChangeNotification = Notification.Name("com.iosexkit.languageDidChange")
    
    private init() {
        // 从用户偏好设置中读取保存的语言
        if let savedLanguage = UserDefaults.standard.string(forKey: userDefaultsKey),
           Bundle.main.hasLocalization(for: savedLanguage) {
            currentLanguage = savedLanguage
        } else {
            // 使用系统语言或默认英语
            let systemLang = systemLanguage.prefix(2).description
            currentLanguage = Bundle.main.hasLocalization(for: systemLang) ? systemLang : "en"
        }
        
        // 获取支持的语言列表
        supportedLanguages = Bundle.main.localizations.filter { $0 != "Base" }
    }
    
    /// 切换语言
    /// - Parameter language: 目标语言代码
    /// - Returns: 是否切换成功
    @discardableResult
    public func switchLanguage(to language: String) -> Bool {
        guard supportedLanguages.contains(language) else { return false }
        guard currentLanguage != language else { return true }
        
        currentLanguage = language
        applyLanguage()
        return true
    }
    
    /// 切换到系统语言
    /// - Returns: 是否切换成功
    @discardableResult
    public func switchToSystemLanguage() -> Bool {
        let systemLang = systemLanguage.prefix(2).description
        return switchLanguage(to: systemLang)
    }
    
    /// 重置为默认语言（英语）
    /// - Returns: 是否重置成功
    @discardableResult
    public func resetToDefault() -> Bool {
        return switchLanguage(to: "en")
    }
    
    /// 应用当前语言设置
    private func applyLanguage() {
        // 这里可以添加更多语言切换后的处理逻辑
        // 例如：重新加载界面、更新文本等
        
        notificationCenter.post(name: LanguageManager.languageDidChangeNotification, object: nil)
    }
    
    /// 获取语言的本地化名称
    /// - Parameter languageCode: 语言代码
    /// - Returns: 语言的本地化名称
    public func localizedName(for languageCode: String) -> String {
        let locale = Locale(identifier: currentLanguage)
        return locale.localizedString(forIdentifier: languageCode) ?? languageCode
    }
    
    /// 获取当前语言的本地化名称
    public var currentLanguageName: String {
        return localizedName(for: currentLanguage)
    }
    
    /// 检查语言是否支持
    /// - Parameter language: 语言代码
    /// - Returns: 是否支持
    public func isLanguageSupported(_ language: String) -> Bool {
        return supportedLanguages.contains(language)
    }
    
    /// 获取语言列表（包含名称和代码）
    public var languageList: [(code: String, name: String)] {
        return supportedLanguages.map { (code: $0, name: localizedName(for: $0)) }
    }
    
    /// 获取按名称排序的语言列表
    public var sortedLanguageList: [(code: String, name: String)] {
        return languageList.sorted { $0.name < $1.name }
    }
}

// MARK: - 日期和时间本地化扩展

public extension Date {
    
    /// 获取本地化的日期字符串
    /// - Parameter dateStyle: 日期样式
    /// - Returns: 本地化日期字符串
    func localizedString(dateStyle: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage)
        return formatter.string(from: self)
    }
    
    /// 获取本地化的时间字符串
    /// - Parameter timeStyle: 时间样式
    /// - Returns: 本地化时间字符串
    func localizedString(timeStyle: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = timeStyle
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage)
        return formatter.string(from: self)
    }
    
    /// 获取本地化的日期和时间字符串
    /// - Parameters:
    ///   - dateStyle: 日期样式
    ///   - timeStyle: 时间样式
    /// - Returns: 本地化日期时间字符串
    func localizedString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage)
        return formatter.string(from: self)
    }
    
    /// 获取本地化的相对时间字符串（例如："刚刚"、"5分钟前"）
    var localizedRelativeTime: String {
        let components = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = components.year, year > 0 {
            return String(format: "%d年前".localized, year)
        } else if let month = components.month, month > 0 {
            return String(format: "%d个月前".localized, month)
        } else if let week = components.weekOfYear, week > 0 {
            return String(format: "%d周前".localized, week)
        } else if let day = components.day, day > 0 {
            return String(format: "%d天前".localized, day)
        } else if let hour = components.hour, hour > 0 {
            return String(format: "%d小时前".localized, hour)
        } else if let minute = components.minute, minute > 0 {
            return String(format: "%d分钟前".localized, minute)
        } else if let second = components.second, second > 30 {
            return String(format: "%d秒前".localized, second)
        } else {
            return "刚刚".localized
        }
    }
    
    /// 获取本地化的简短相对时间字符串
    var localizedShortRelativeTime: String {
        let components = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: self, to: Date())
        
        if let year = components.year, year > 0 {
            return String(format: "%dy".localized, year)
        } else if let month = components.month, month > 0 {
            return String(format: "%dM".localized, month)
        } else if let week = components.weekOfYear, week > 0 {
            return String(format: "%dw".localized, week)
        } else if let day = components.day, day > 0 {
            return String(format: "%dd".localized, day)
        } else if let hour = components.hour, hour > 0 {
            return String(format: "%dh".localized, hour)
        } else if let minute = components.minute, minute > 0 {
            return String(format: "%dm".localized, minute)
        } else {
            return "now".localized
        }
    }
}

// MARK: - 数字格式化本地化扩展

public extension Numeric {
    
    /// 获取本地化的数字字符串
    /// - Parameters:
    ///   - style: 数字样式
    ///   - fractionDigits: 小数位数
    /// - Returns: 本地化数字字符串
    func localizedString(style: NumberFormatter.Style = .decimal, fractionDigits: Int? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage)
        
        if let fractionDigits = fractionDigits {
            formatter.minimumFractionDigits = fractionDigits
            formatter.maximumFractionDigits = fractionDigits
        }
        
        return formatter.string(from: self as! NSNumber) ?? "\(self)"
    }
    
    /// 获取本地化的货币字符串
    /// - Parameter currencyCode: 货币代码
    /// - Returns: 本地化货币字符串
    func localizedCurrencyString(currencyCode: String = "CNY") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage)
        return formatter.string(from: self as! NSNumber) ?? "\(self)"
    }
    
    /// 获取本地化的百分比字符串
    /// - Parameter fractionDigits: 小数位数
    /// - Returns: 本地化百分比字符串
    func localizedPercentString(fractionDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage)
        return formatter.string(from: self as! NSNumber) ?? "\(self)"
    }
}

// MARK: - 文件大小本地化扩展

public extension Int64 {
    
    /// 获取本地化的文件大小字符串
    var localizedFileSize: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = true
        formatter.allowedUnits = .useAll
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage)
        return formatter.string(fromByteCount: self)
    }
    
    /// 获取本地化的内存大小字符串
    var localizedMemorySize: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .memory
        formatter.includesUnit = true
        formatter.isAdaptive = true
        formatter.allowedUnits = .useAll
        formatter.locale = Locale(identifier: LanguageManager.shared.currentLanguage)
        return formatter.string(fromByteCount: self)
    }
}

// MARK: - 便捷本地化宏

/// 快速本地化字符串宏
public func L(_ key: String, comment: String = "") -> String {
    return key.localized(comment: comment)
}

/// 带参数的本地化字符串宏
public func L(_ key: String, _ arguments: CVarArg...) -> String {
    return String(format: key.localized, arguments: arguments)
}

/// 检查本地化是否可用
public func isLocalizationAvailable(for key: String) -> Bool {
    return key.hasLocalization
}

// MARK: - 本地化调试工具

/// 本地化调试器
public final class LocalizationDebugger {
    
    public static let shared = LocalizationDebugger()
    
    private var missingKeys: Set<String> = []
    private var unusedKeys: Set<String> = []
    private let lock = NSLock()
    
    private init() {}
    
    /// 记录未找到的本地化键
    /// - Parameter key: 本地化键
    public func recordMissingKey(_ key: String) {
        lock.lock()
        missingKeys.insert(key)
        lock.unlock()
    }
    
    /// 记录未使用的本地化键
    /// - Parameter key: 本地化键
    public func recordUnusedKey(_ key: String) {
        lock.lock()
        unusedKeys.insert(key)
        lock.unlock()
    }
    
    /// 获取所有未找到的本地化键
    public var allMissingKeys: [String] {
        lock.lock()
        let keys = Array(missingKeys)
        lock.unlock()
        return keys
    }
    
    /// 获取所有未使用的本地化键
    public var allUnusedKeys: [String] {
        lock.lock()
        let keys = Array(unusedKeys)
        lock.unlock()
        return keys
    }
    
    /// 检查是否有缺失的本地化键
    public var hasMissingKeys: Bool {
        lock.lock()
        let hasMissing = !missingKeys.isEmpty
        lock.unlock()
        return hasMissing
    }
    
    /// 检查是否有未使用的本地化键
    public var hasUnusedKeys: Bool {
        lock.lock()
        let hasUnused = !unusedKeys.isEmpty
        lock.unlock()
        return hasUnused
    }
    
    /// 生成本地化报告
    public func generateReport() -> String {
        lock.lock()
        let missing = missingKeys
        let unused = unusedKeys
        lock.unlock()
        
        var report = "📊 本地化报告\n"
        report += "=============\n"
        report += "缺失的本地化键: \(missing.count)个\n"
        if !missing.isEmpty {
            report += "  - " + missing.sorted().joined(separator: "\n  - ") + "\n"
        }
        
        report += "未使用的本地化键: \(unused.count)个\n"
        if !unused.isEmpty {
            report += "  - " + unused.sorted().joined(separator: "\n  - ") + "\n"
        }
        
        return report
    }
    
    /// 重置调试器
    public func reset() {
        lock.lock()
        missingKeys.removeAll()
        unusedKeys.removeAll()
        lock.unlock()
    }
}

// MARK: - 本地化字符串安全检查

public extension String {
    
    /// 安全的本地化字符串（如果找不到则记录并返回键）
    var safeDebugLocalized: String {
        let localized = self.localized
        if localized == self {
            LocalizationDebugger.shared.recordMissingKey(self)
        }
        return localized
    }
    
    /// 标记为已使用的本地化键
    func markAsUsed() {
        LocalizationDebugger.shared.recordUnusedKey(self)
    }
}