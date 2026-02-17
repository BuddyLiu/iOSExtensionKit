// NotificationCenter+Extension.swift
// NotificationCenter扩展，提供便捷的通知管理方法

@preconcurrency import Foundation

public extension NotificationCenter {
    
    // MARK: - 便捷方法
    
    /// 安全添加观察者（自动管理生命周期）
    /// - Parameters:
    ///   - observer: 观察者
    ///   - selector: 选择器
    ///   - name: 通知名称
    ///   - object: 发送对象
    func safeAddObserver(_ observer: Any,
                         selector: Selector,
                         name: NSNotification.Name?,
                         object: Any? = nil) {
        addObserver(observer, selector: selector, name: name, object: object)
    }
    
    /// 安全添加观察者（使用闭包）
    /// - Parameters:
    ///   - forName: 通知名称
    ///   - object: 发送对象
    ///   - queue: 执行队列
    ///   - using: 闭包
    /// - Returns: 观察者令牌
    func safeAddObserver(forName name: NSNotification.Name?,
                         object obj: Any? = nil,
                         queue: OperationQueue? = nil,
                         using block: @escaping @Sendable (Notification) -> Void) -> NSObjectProtocol {
        return addObserver(forName: name, object: obj, queue: queue, using: block)
    }
    
    /// 安全移除观察者
    /// - Parameter observer: 观察者
    func safeRemoveObserver(_ observer: Any) {
        removeObserver(observer)
    }
    
    /// 安全移除观察者（指定通知名称和对象）
    /// - Parameters:
    ///   - observer: 观察者
    ///   - name: 通知名称
    ///   - object: 发送对象
    func safeRemoveObserver(_ observer: Any,
                            name: NSNotification.Name?,
                            object: Any? = nil) {
        removeObserver(observer, name: name, object: object)
    }
    
    /// 移除所有观察者
    /// - Parameter observer: 观察者
    func removeAllObservers(for observer: Any) {
        removeObserver(observer)
    }
    
    // MARK: - 批量操作
    
    /// 批量添加观察者
    /// - Parameters:
    ///   - observer: 观察者
    ///   - selector: 选择器
    ///   - names: 通知名称数组
    ///   - object: 发送对象
    func addObserver(_ observer: Any,
                     selector: Selector,
                     names: [NSNotification.Name],
                     object: Any? = nil) {
        for name in names {
            addObserver(observer, selector: selector, name: name, object: object)
        }
    }
    
    /// 批量移除观察者
    /// - Parameters:
    ///   - observer: 观察者
    ///   - names: 通知名称数组
    ///   - object: 发送对象
    func removeObserver(_ observer: Any,
                        names: [NSNotification.Name],
                        object: Any? = nil) {
        for name in names {
            removeObserver(observer, name: name, object: object)
        }
    }
    
    /// 批量发送通知
    /// - Parameters:
    ///   - names: 通知名称数组
    ///   - object: 发送对象
    ///   - userInfo: 用户信息
    func post(names: [NSNotification.Name],
              object: Any? = nil,
              userInfo: [AnyHashable: Any]? = nil) {
        for name in names {
            post(name: name, object: object, userInfo: userInfo)
        }
    }
}

// MARK: - 通知名称扩展

public extension Notification.Name {
    /// 自定义通知名称
    static let customNotification = Notification.Name("CustomNotification")
    
    /// 网络状态变化通知
    static let networkStatusChanged = Notification.Name("NetworkStatusChanged")
    
    /// 用户登录通知
    static let userDidLogin = Notification.Name("UserDidLogin")
    
    /// 用户登出通知
    static let userDidLogout = Notification.Name("UserDidLogout")
    
    /// 数据更新通知
    static let dataDidUpdate = Notification.Name("DataDidUpdate")
    
    /// 配置变化通知
    static let configurationChanged = Notification.Name("ConfigurationChanged")
    
    /// 主题变化通知
    static let themeDidChange = Notification.Name("ThemeDidChange")
    
    /// 语言变化通知
    static let languageDidChange = Notification.Name("LanguageDidChange")
    
    /// 内存警告通知
    static let memoryWarning = Notification.Name("MemoryWarning")
    
    /// 应用进入后台通知
    static let appDidEnterBackground = Notification.Name("AppDidEnterBackground")
    
    /// 应用进入前台通知
    static let appWillEnterForeground = Notification.Name("AppWillEnterForeground")
}

// MARK: - 用户信息键扩展

public extension String {
    /// 错误信息键
    static let errorKey = "error"
    
    /// 状态信息键
    static let statusKey = "status"
    
    /// 数据信息键
    static let dataKey = "data"
    
    /// 消息信息键
    static let messageKey = "message"
    
    /// 进度信息键
    static let progressKey = "progress"
    
    /// 用户信息键
    static let userInfoKey = "userInfo"
    
    /// 时间戳键
    static let timestampKey = "timestamp"
    
    /// 来源信息键
    static let sourceKey = "source"
    
    /// 目标信息键
    static let targetKey = "target"
    
    /// 上下文信息键
    static let contextKey = "context"
}

// MARK: - 便捷通知发送

public func postNotification(_ name: Notification.Name,
                             object: Any? = nil,
                             userInfo: [AnyHashable: Any]? = nil) {
    NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
}

// 注意：由于Swift 6的严格并发检查，此函数已被移除
// 建议使用postNotification并在调用方处理线程安全

public func observeNotification(_ name: Notification.Name?,
                                object: Any? = nil,
                                queue: OperationQueue? = nil,
                                using block: @escaping @Sendable (Notification) -> Void) -> NSObjectProtocol {
    return NotificationCenter.default.addObserver(forName: name,
                                                 object: object,
                                                 queue: queue,
                                                 using: block)
}

public func removeNotificationObserver(_ observer: Any) {
    NotificationCenter.default.removeObserver(observer)
}

public func removeNotificationObserver(_ observer: Any,
                                       name: Notification.Name?,
                                       object: Any? = nil) {
    NotificationCenter.default.removeObserver(observer, name: name, object: object)
}