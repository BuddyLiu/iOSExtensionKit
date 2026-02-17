// UserDefaults+Extension.swift
// UserDefaults扩展，提供类型安全的键值存储

import Foundation

public extension UserDefaults {
    
    // MARK: - 类型安全的键
    
    /// 类型安全的UserDefaults键
    struct Key<Value>: @unchecked Sendable {
        public let name: String
        public let defaultValue: Value
        
        public init(name: String, defaultValue: Value) {
            self.name = name
            self.defaultValue = defaultValue
        }
    }
    
    // MARK: - 通用方法
    
    /// 获取值（类型安全）
    /// - Parameter key: 键
    /// - Returns: 值
    func get<T>(for key: Key<T>) -> T {
        // 使用object(forKey:)检查键是否存在
        guard let value = object(forKey: key.name) else {
            return key.defaultValue
        }
        
        // 特殊处理布尔值：UserDefaults存储布尔值为NSNumber
        if T.self == Bool.self {
            // 确保正确处理存储格式
            if let numberValue = value as? NSNumber {
                return numberValue.boolValue as! T
            } else if let boolValue = value as? Bool {
                return boolValue as! T
            } else {
                // 无法转换，返回默认值
                return key.defaultValue
            }
        }
        
        // 对于其他类型，尝试转换
        if let typedValue = value as? T {
            return typedValue
        }
        
        return key.defaultValue
    }
    
    /// 设置值（类型安全）
    /// - Parameters:
    ///   - value: 值
    ///   - key: 键
    func set<T>(_ value: T, for key: Key<T>) {
        set(value, forKey: key.name)
    }
    
    /// 判断键是否存在
    /// - Parameter key: 键
    /// - Returns: 是否存在
    func has<T>(key: Key<T>) -> Bool {
        return object(forKey: key.name) != nil
    }
    
    /// 移除键值
    /// - Parameter key: 键
    func remove<T>(for key: Key<T>) {
        removeObject(forKey: key.name)
    }
    
    // MARK: - 便捷访问器
    
    /// 获取字符串值
    /// - Parameter key: 键
    /// - Returns: 字符串值
    func string(for key: Key<String>) -> String {
        return get(for: key)
    }
    
    /// 获取整数
    /// - Parameter key: 键
    /// - Returns: 整数值
    func integer(for key: Key<Int>) -> Int {
        return get(for: key)
    }
    
    /// 获取浮点数
    /// - Parameter key: 键
    /// - Returns: 浮点数值
    func double(for key: Key<Double>) -> Double {
        return get(for: key)
    }
    
    /// 获取布尔值
    /// - Parameter key: 键
    /// - Returns: 布尔值
    func bool(for key: Key<Bool>) -> Bool {
        return get(for: key)
    }
    
    /// 获取日期
    /// - Parameter key: 键
    /// - Returns: 日期值
    func date(for key: Key<Date>) -> Date {
        return get(for: key)
    }
    
    /// 获取数据
    /// - Parameter key: 键
    /// - Returns: 数据值
    func data(for key: Key<Data>) -> Data {
        return get(for: key)
    }
    
    /// 获取数组
    /// - Parameter key: 键
    /// - Returns: 数组值
    func array<T>(for key: Key<[T]>) -> [T] {
        return get(for: key)
    }
    
    /// 获取字典
    /// - Parameter key: 键
    /// - Returns: 字典值
    func dictionary<T>(for key: Key<[String: T]>) -> [String: T] {
        return get(for: key)
    }
    
    /// 获取可编码对象
    /// - Parameter key: 键
    /// - Returns: 解码后的对象，如果失败则返回默认值
    func object<T: Codable>(for key: Key<T>) -> T {
        guard let data = data(forKey: key.name) else {
            return key.defaultValue
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("UserDefaults解码失败: \(error)")
            return key.defaultValue
        }
    }
    
    /// 设置可编码对象
    /// - Parameters:
    ///   - object: 可编码对象
    ///   - key: 键
    func set<T: Codable>(_ object: T, for key: Key<T>) {
        do {
            let data = try JSONEncoder().encode(object)
            set(data, forKey: key.name)
        } catch {
            print("UserDefaults编码失败: \(error)")
        }
    }
    
    // MARK: - 原子操作
    
    /// 原子增加整数值
    /// - Parameters:
    ///   - key: 键
    ///   - increment: 增量
    /// - Returns: 增加后的值
    @discardableResult
    func increment(key: Key<Int>, by increment: Int = 1) -> Int {
        let newValue = integer(for: key) + increment
        set(newValue, for: key)
        return newValue
    }
    
    /// 原子增加浮点数值
    /// - Parameters:
    ///   - key: 键
    ///   - increment: 增量
    /// - Returns: 增加后的值
    @discardableResult
    func increment(key: Key<Double>, by increment: Double = 1.0) -> Double {
        let newValue = double(for: key) + increment
        set(newValue, for: key)
        return newValue
    }
    
    /// 原子切换布尔值
    /// - Parameter key: 键
    /// - Returns: 切换后的值
    @discardableResult
    func toggle(key: Key<Bool>) -> Bool {
        // 特殊处理：键不存在时，默认值为false，所以第一次切换应该是true
        let currentValue = bool(for: key)
        
        let newValue = !currentValue
        
        // 直接使用UserDefaults的set方法，确保存储
        set(newValue, forKey: key.name)
        synchronize()
        
        return newValue
    }
    
    // MARK: - 批量操作
    
    /// 批量设置值
    /// - Parameter dictionary: 键值字典
    func setValues(_ dictionary: [String: Any]) {
        for (key, value) in dictionary {
            set(value, forKey: key)
        }
        synchronize()
    }
    
    /// 批量获取值
    /// - Parameter keys: 键数组
    /// - Returns: 键值字典
    func getValues(for keys: [String]) -> [String: Any] {
        var result: [String: Any] = [:]
        for key in keys {
            if let value = object(forKey: key) {
                result[key] = value
            }
        }
        return result
    }
    
    /// 批量移除值
    /// - Parameter keys: 键数组
    func removeValues(for keys: [String]) {
        for key in keys {
            removeObject(forKey: key)
        }
        synchronize()
    }
    
    /// 移除所有用户数据
    /// - Parameter except: 需要保留的键数组
    func removeAll(except: [String] = []) {
        let allKeys = Array(dictionaryRepresentation().keys)
        let keysToRemove = allKeys.filter { !except.contains($0) }
        removeValues(for: keysToRemove)
    }
    
    // MARK: - 安全操作
    
    /// 安全获取值（可选）
    /// - Parameter key: 键
    /// - Returns: 可选值
    func safeGet<T>(for key: Key<T>) -> T? {
        return object(forKey: key.name) as? T
    }
    
    /// 安全设置值（当值存在时才设置）
    /// - Parameters:
    ///   - value: 值
    ///   - key: 键
    /// - Returns: 是否设置了值
    @discardableResult
    func safeSet<T>(_ value: T, for key: Key<T>) -> Bool {
        if object(forKey: key.name) != nil {
            set(value, for: key)
            return true
        }
        return false
    }
    
    /// 获取或设置默认值
    /// - Parameters:
    ///   - key: 键
    ///   - defaultValue: 默认值（当键不存在时使用）
    /// - Returns: 值
    func getOrSet<T>(for key: Key<T>, defaultValue: T) -> T {
        if has(key: key) {
            return get(for: key)
        } else {
            set(defaultValue, for: key)
            return defaultValue
        }
    }
    
    // MARK: - 观察者模式
    
    // 注意：由于 Swift 并发安全限制，观察者功能暂时不可用
    // 用户可以直接使用 NotificationCenter 监听 UserDefaults.didChangeNotification
    
    /*
    /// 监听UserDefaults变化
    /// - Parameters:
    ///   - key: 要监听的键
    ///   - handler: 变化处理闭包
    /// - Returns: 观察者，需要手动保留引用
    func observe<T>(key: Key<T>, handler: @escaping (T, T?) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: self,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            let oldValue = self.safeGet(for: key)
            let newValue = self.get(for: key)
            handler(newValue, oldValue)
        }
    }
    
    /// 监听指定键的UserDefaults变化
    /// - Parameters:
    ///   - keyName: 键名
    ///   - handler: 变化处理闭包
    /// - Returns: 观察者，需要手动保留引用
    func observeKey(_ keyName: String, handler: @escaping (Any?, Any?) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: self,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            let oldValue = self.object(forKey: keyName)
            let newValue = self.object(forKey: keyName)
            handler(newValue, oldValue)
        }
    }
    */
}

// MARK: - 全局便捷方法

public extension UserDefaults {
    
    /// 标准UserDefaults单例
    static var standardDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    /// 应用程序组UserDefaults
    /// - Parameter appGroup: 应用程序组标识符
    /// - Returns: UserDefaults实例，如果失败则返回标准UserDefaults
    static func appGroupDefaults(appGroup: String) -> UserDefaults {
        guard let defaults = UserDefaults(suiteName: appGroup) else {
            print("无法创建应用程序组UserDefaults: \(appGroup)")
            return UserDefaults.standard
        }
        return defaults
    }
    
    /// 临时UserDefaults（用于测试）
    static var temporaryDefaults: UserDefaults {
        return UserDefaults(suiteName: "temp_test_\(UUID().uuidString)") ?? UserDefaults.standard
    }
    
    /// 重置标准UserDefaults（移除所有值）
    static func resetStandardDefaults() {
        let domain = Bundle.main.bundleIdentifier ?? "com.yourapp"
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

// MARK: - 便捷键定义

public extension UserDefaults {
    
    // 示例键定义（实际使用时可以根据需要添加）
    
    /// 首次启动标志
    static let isFirstLaunchKey = Key<Bool>(name: "isFirstLaunch", defaultValue: true)
    
    /// 用户ID
    static let userIdKey = Key<String>(name: "userId", defaultValue: "")
    
    /// 用户令牌
    static let userTokenKey = Key<String>(name: "userToken", defaultValue: "")
    
    /// 上次登录时间
    static let lastLoginDateKey = Key<Date>(name: "lastLoginDate", defaultValue: Date.distantPast)
    
    /// 应用版本
    static let appVersionKey = Key<String>(name: "appVersion", defaultValue: "")
    
    /// 语言设置
    static let languageKey = Key<String>(name: "language", defaultValue: "zh-Hans")
    
    /// 主题设置
    static let themeKey = Key<String>(name: "theme", defaultValue: "light")
    
    /// 通知设置
    static let notificationsEnabledKey = Key<Bool>(name: "notificationsEnabled", defaultValue: true)
    
    /// 启动次数
    static let launchCountKey = Key<Int>(name: "launchCount", defaultValue: 0)
    
    /// 上次版本检查时间
    static let lastVersionCheckDateKey = Key<Date>(name: "lastVersionCheckDate", defaultValue: Date.distantPast)
}

// MARK: - 应用设置封装

public extension UserDefaults {
    
    /// 获取应用设置
    struct AppSettings {
        private let defaults: UserDefaults
        
        public init(defaults: UserDefaults = .standard) {
            self.defaults = defaults
        }
        
        /// 是否是首次启动
        public var isFirstLaunch: Bool {
            get { defaults.get(for: UserDefaults.isFirstLaunchKey) }
            set { defaults.set(newValue, for: UserDefaults.isFirstLaunchKey) }
        }
        
        /// 用户ID
        public var userId: String {
            get { defaults.get(for: UserDefaults.userIdKey) }
            set { defaults.set(newValue, for: UserDefaults.userIdKey) }
        }
        
        /// 用户令牌
        public var userToken: String {
            get { defaults.get(for: UserDefaults.userTokenKey) }
            set { defaults.set(newValue, for: UserDefaults.userTokenKey) }
        }
        
        /// 上次登录时间
        public var lastLoginDate: Date {
            get { defaults.get(for: UserDefaults.lastLoginDateKey) }
            set { defaults.set(newValue, for: UserDefaults.lastLoginDateKey) }
        }
        
        /// 应用版本
        public var appVersion: String {
            get { defaults.get(for: UserDefaults.appVersionKey) }
            set { defaults.set(newValue, for: UserDefaults.appVersionKey) }
        }
        
        /// 语言设置
        public var language: String {
            get { defaults.get(for: UserDefaults.languageKey) }
            set { defaults.set(newValue, for: UserDefaults.languageKey) }
        }
        
        /// 主题设置
        public var theme: String {
            get { defaults.get(for: UserDefaults.themeKey) }
            set { defaults.set(newValue, for: UserDefaults.themeKey) }
        }
        
        /// 通知设置
        public var notificationsEnabled: Bool {
            get { defaults.get(for: UserDefaults.notificationsEnabledKey) }
            set { defaults.set(newValue, for: UserDefaults.notificationsEnabledKey) }
        }
        
        /// 启动次数
        public var launchCount: Int {
            get { defaults.get(for: UserDefaults.launchCountKey) }
            set { defaults.set(newValue, for: UserDefaults.launchCountKey) }
        }
        
        /// 上次版本检查时间
        public var lastVersionCheckDate: Date {
            get { defaults.get(for: UserDefaults.lastVersionCheckDateKey) }
            set { defaults.set(newValue, for: UserDefaults.lastVersionCheckDateKey) }
        }
        
        /// 记录应用启动
        public mutating func recordAppLaunch() {
            launchCount = launchCount + 1
            if isFirstLaunch {
                isFirstLaunch = false
            }
        }
        
        /// 记录登录
        /// - Parameters:
        ///   - userId: 用户ID
        ///   - token: 用户令牌
        public mutating func recordLogin(userId: String, token: String) {
            self.userId = userId
            self.userToken = token
            self.lastLoginDate = Date()
        }
        
        /// 记录登出
        public mutating func recordLogout() {
            userToken = ""
        }
        
        /// 清除所有用户数据
        public mutating func clearUserData() {
            userId = ""
            userToken = ""
        }
        
        /// 清除所有设置（保留首次启动标志）
        public mutating func clearAllSettings() {
            let firstLaunch = isFirstLaunch
            defaults.removeAll(except: ["isFirstLaunch"])
            isFirstLaunch = firstLaunch
        }
    }
    
    /// 应用设置实例
    static var appSettings: AppSettings {
        return AppSettings(defaults: .standard)
    }
}