// PerformanceOptimizer.swift
// 性能优化工具，提供缓存、懒加载、性能监控等功能

import Foundation

// MARK: - 性能监控

/// 性能监控器
public final class PerformanceMonitor: @unchecked Sendable {
    
    public static let shared = PerformanceMonitor()
    
    private struct Measurement {
        let startTime: CFAbsoluteTime
        let name: String
        let threshold: CFAbsoluteTime?
        
        init(name: String, threshold: CFAbsoluteTime? = nil) {
            self.startTime = CFAbsoluteTimeGetCurrent()
            self.name = name
            self.threshold = threshold
        }
        
        func end() -> CFAbsoluteTime {
            let endTime = CFAbsoluteTimeGetCurrent()
            let duration = endTime - startTime
            return duration
        }
    }
    
    private var measurements: [Measurement] = []
    private let queue = DispatchQueue(label: "com.iosexkit.performance.monitor")
    
    private init() {}
    
    /// 开始性能测量
    /// - Parameters:
    ///   - name: 测量名称
    ///   - threshold: 阈值（秒），超过此值会记录警告
    /// - Returns: 测量标识符
    @discardableResult
    public func startMeasurement(name: String, threshold: CFAbsoluteTime? = 0.1) -> String {
        let measurement = Measurement(name: name, threshold: threshold)
        queue.sync {
            measurements.append(measurement)
        }
        return name
    }
    
    /// 结束性能测量并返回持续时间
    /// - Parameter name: 测量名称
    /// - Returns: 持续时间（秒）
    @discardableResult
    public func endMeasurement(_ name: String) -> CFAbsoluteTime {
        var duration: CFAbsoluteTime = 0
        queue.sync {
            if let index = measurements.firstIndex(where: { $0.name == name }) {
                let measurement = measurements.remove(at: index)
                duration = measurement.end()
                
                if let threshold = measurement.threshold, duration > threshold {
                    print("⚠️ 性能警告：\(name) 耗时 \(String(format: "%.3f", duration))s，超过阈值 \(String(format: "%.3f", threshold))s")
                } else {
                    print("✅ 性能正常：\(name) 耗时 \(String(format: "%.3f", duration))s")
                }
            }
        }
        return duration
    }
    
    /// 批量测量多个操作的性能
    /// - Parameter operations: 操作字典 [名称: 操作]
    public func measureBatch(operations: [String: () -> Void]) {
        let totalStart = CFAbsoluteTimeGetCurrent()
        
        for (name, operation) in operations {
            let start = CFAbsoluteTimeGetCurrent()
            operation()
            let duration = CFAbsoluteTimeGetCurrent() - start
            print("📊 \(name): \(String(format: "%.3f", duration))s")
        }
        
        let totalDuration = CFAbsoluteTimeGetCurrent() - totalStart
        print("📈 总耗时: \(String(format: "%.3f", totalDuration))s")
    }
    
    /// 重置所有测量
    public func reset() {
        queue.sync {
            measurements.removeAll()
        }
    }
}

// MARK: - 内存缓存

/// 内存缓存管理器
public final class MemoryCache<T: AnyObject> {
    
    private let cache = NSCache<NSString, T>()
    
    public init(name: String = "MemoryCache", countLimit: Int = 100, totalCostLimit: Int = 1024 * 1024 * 100) {
        cache.name = name
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }
    
    /// 存储对象
    /// - Parameters:
    ///   - object: 要存储的对象
    ///   - key: 存储键
    ///   - cost: 存储成本
    public func set(_ object: T, forKey key: String, cost: Int = 0) {
        cache.setObject(object, forKey: key as NSString, cost: cost)
    }
    
    /// 获取对象
    /// - Parameter key: 存储键
    /// - Returns: 存储的对象
    public func object(forKey key: String) -> T? {
        return cache.object(forKey: key as NSString)
    }
    
    /// 移除对象
    /// - Parameter key: 存储键
    public func removeObject(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    /// 清空缓存
    public func removeAll() {
        cache.removeAllObjects()
    }
    
    /// 缓存统计
    public var statistics: (count: Int, totalCost: Int) {
        return (cache.countLimit, cache.totalCostLimit)
    }
}

// MARK: - 懒加载包装器

/// 线程安全的懒加载包装器
@propertyWrapper
public final class Lazy<T> {
    
    private var storage: T?
    private let lock = NSLock()
    private let initializer: () -> T
    
    public init(wrappedValue initializer: @escaping @autoclosure () -> T) {
        self.initializer = initializer
    }
    
    public var wrappedValue: T {
        get {
            lock.lock()
            defer { lock.unlock() }
            
            if let storage = storage {
                return storage
            }
            
            let value = initializer()
            storage = value
            return value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            storage = newValue
        }
    }
    
    /// 重置为未初始化状态
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        storage = nil
    }
    
    /// 检查是否已初始化
    public var isInitialized: Bool {
        lock.lock()
        defer { lock.unlock() }
        return storage != nil
    }
}

// MARK: - 性能优化工具

/// 防抖器
public final class Debouncer {
    
    private let interval: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    
    public init(interval: TimeInterval, queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }
    
    /// 触发防抖操作
    /// - Parameter action: 要执行的操作
    public func debounce(_ action: @escaping @Sendable () -> Void) {
        workItem?.cancel()
        
        let newWorkItem = DispatchWorkItem { action() }
        workItem = newWorkItem
        
        queue.asyncAfter(deadline: .now() + interval, execute: newWorkItem)
    }
    
    /// 取消待执行的防抖操作
    public func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}

/// 节流器
public final class Throttler {
    
    private let interval: TimeInterval
    private var lastExecutionTime: TimeInterval = 0
    private let queue: DispatchQueue
    
    public init(interval: TimeInterval, queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }
    
    /// 触发节流操作
    /// - Parameter action: 要执行的操作
    public func throttle(_ action: @escaping @Sendable () -> Void) {
        let now = Date().timeIntervalSince1970
        
        if now - lastExecutionTime >= interval {
            lastExecutionTime = now
            queue.async {
                action()
            }
        }
    }
    
    /// 重置节流器
    public func reset() {
        lastExecutionTime = 0
    }
}

// MARK: - 性能监控扩展

/// 性能测量宏
public func measure<T>(_ name: String = "操作", threshold: TimeInterval? = 0.1, _ operation: () -> T) -> T {
    let startTime = CFAbsoluteTimeGetCurrent()
    let result = operation()
    let duration = CFAbsoluteTimeGetCurrent() - startTime
    
    if let threshold = threshold, duration > threshold {
        print("⚠️ 性能警告：\(name) 耗时 \(String(format: "%.3f", duration))s，超过阈值 \(String(format: "%.3f", threshold))s")
    }
    
    return result
}