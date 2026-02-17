// DispatchQueue+Extension.swift
// DispatchQueue扩展，提供便捷的并发操作方法

@preconcurrency import Foundation

public extension DispatchQueue {
    
    // MARK: - 线程安全访问
    
    /// 安全地异步执行任务（避免捕获非Sendable类型的警告）
    /// - Parameter work: 要执行的工作项
    func safeAsync(execute work: @escaping @Sendable () -> Void) {
        async(execute: work)
    }
    
    /// 安全地异步执行任务，带有延迟
    /// - Parameters:
    ///   - deadline: 延迟时间
    ///   - work: 要执行的工作项
    func safeAsyncAfter(deadline: DispatchTime, execute work: @escaping @Sendable () -> Void) {
        asyncAfter(deadline: deadline, execute: work)
    }
    
    /// 安全地异步执行任务，带有时间间隔
    /// - Parameters:
    ///   - interval: 时间间隔（秒）
    ///   - work: 要执行的工作项
    func safeAsyncAfter(interval: TimeInterval, execute work: @escaping @Sendable () -> Void) {
        asyncAfter(deadline: .now() + interval, execute: work)
    }
    
    // MARK: - 同步执行（线程安全）
    
    /// 安全地同步执行任务
    /// - Parameter work: 要执行的工作项
    /// - Returns: 工作项的返回值
    func safeSync<T>(execute work: @Sendable () throws -> T) rethrows -> T {
        return try sync(execute: work)
    }
    
    /// 安全地同步执行任务（不返回结果）
    /// - Parameter work: 要执行的工作项
    func safeSync(execute work: @Sendable () throws -> Void) rethrows {
        try sync(execute: work)
    }
    
    // MARK: - 屏障操作
    
    /// 安全地异步屏障操作
    /// - Parameter work: 要执行的工作项
    func safeAsyncBarrier(execute work: @escaping @Sendable () -> Void) {
        async(group: nil, qos: .unspecified, flags: .barrier, execute: work)
    }
    
    /// 安全地同步屏障操作
    /// - Parameter work: 要执行的工作项
    /// - Returns: 工作项的返回值
    func safeSyncBarrier<T>(execute work: @Sendable () throws -> T) rethrows -> T {
        return try sync(flags: .barrier, execute: work)
    }
    
    // MARK: - 便捷全局队列访问
    
    /// 获取主队列（线程安全）
    static var safeMain: DispatchQueue {
        return main
    }
    
    /// 获取全局后台队列（指定服务质量）
    /// - Parameter qos: 服务质量
    /// - Returns: 全局队列
    static func safeGlobal(qos: DispatchQoS.QoSClass = .default) -> DispatchQueue {
        return global(qos: qos)
    }
    
    // MARK: - 延迟执行
    
    /// 在主队列上延迟执行
    /// - Parameters:
    ///   - interval: 延迟时间（秒）
    ///   - work: 要执行的工作项
    static func safeMainAsyncAfter(interval: TimeInterval, execute work: @escaping @Sendable () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: work)
    }
    
    /// 在后台队列上延迟执行
    /// - Parameters:
    ///   - interval: 延迟时间（秒）
    ///   - qos: 服务质量
    ///   - work: 要执行的工作项
    static func safeGlobalAsyncAfter(interval: TimeInterval, qos: DispatchQoS.QoSClass = .default, execute work: @escaping @Sendable () -> Void) {
        DispatchQueue.global(qos: qos).asyncAfter(deadline: .now() + interval, execute: work)
    }
    
    // MARK: - 批量任务执行
    
    /// 并发执行多个任务
    /// - Parameters:
    ///   - count: 任务数量
    ///   - qos: 服务质量
    ///   - work: 任务生成器，接受索引参数
    static func concurrentPerformSafe(count: Int, qos: DispatchQoS = .default, execute work: @Sendable (Int) -> Void) {
        DispatchQueue.concurrentPerformSafe(iterations: count, execute: work)
    }
    
    /// 安全版本的concurrentPerform（避免并发警告）
    /// - Parameters:
    ///   - iterations: 迭代次数
    ///   - execute: 执行闭包
    static func concurrentPerformSafe(iterations: Int, execute work: @Sendable (Int) -> Void) {
        DispatchQueue.concurrentPerform(iterations: iterations, execute: work)
    }
    
    // MARK: - 任务组
    
    /// 异步执行任务组
    /// - Parameters:
    ///   - tasks: 任务数组
    ///   - qos: 服务质量
    ///   - completion: 所有任务完成后的回调
    static func asyncGroup(tasks: [@Sendable () -> Void], qos: DispatchQoS = .default, completion: (@Sendable () -> Void)? = nil) {
        let group = DispatchGroup()
        
        for task in tasks {
            DispatchQueue.global(qos: qos.qosClass).async(group: group) {
                task()
            }
        }
        
        if let completion = completion {
            group.notify(queue: .main, execute: completion)
        }
    }
}

// MARK: - 异步任务包装器

/// 异步任务包装器，简化异步操作
public struct AsyncTask {
    
    /// 异步执行任务并返回结果
    /// - Parameters:
    ///   - qos: 服务质量
    ///   - work: 异步工作项
    /// - Returns: 任务结果
    @discardableResult
    public static func run<T: Sendable>(
        qos: DispatchQoS.QoSClass = .default,
        _ work: @escaping @Sendable () throws -> T
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: qos).async {
                do {
                    let result = try work()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// 在主线程上执行任务
    /// - Parameter work: 要执行的工作项
    public static func onMain(_ work: @escaping @Sendable () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
    
    /// 在主线程上执行任务并等待结果
    /// - Parameter work: 要执行的工作项
    /// - Returns: 任务结果
    @discardableResult
    public static func onMain<T: Sendable>(_ work: @escaping @Sendable () throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            if Thread.isMainThread {
                do {
                    let result = try work()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            } else {
                DispatchQueue.main.async {
                    do {
                        let result = try work()
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    /// 延迟执行任务
    /// - Parameters:
    ///   - interval: 延迟时间（秒）
    ///   - qos: 服务质量
    ///   - work: 要执行的工作项
    public static func delayed(
        interval: TimeInterval,
        qos: DispatchQoS.QoSClass = .default,
        _ work: @escaping @Sendable () -> Void
    ) {
        DispatchQueue.global(qos: qos).asyncAfter(deadline: .now() + interval, execute: work)
    }
}

// MARK: - 全局便捷函数

/// 在主线程上安全执行任务
/// - Parameter work: 要执行的工作项
public func onMainThread(_ work: @escaping @Sendable () -> Void) {
    AsyncTask.onMain(work)
}

/// 在主线程上安全执行任务并返回值
/// - Parameter work: 要执行的工作项
/// - Returns: 任务结果
@discardableResult
public func onMainThread<T: Sendable>(_ work: @escaping @Sendable () throws -> T) async throws -> T {
    return try await AsyncTask.onMain(work)
}

/// 在后台线程上执行任务
/// - Parameters:
    ///   - qos: 服务质量
    ///   - work: 要执行的工作项
public func onBackgroundThread(
    qos: DispatchQoS.QoSClass = .default,
    _ work: @escaping @Sendable () -> Void
) {
    DispatchQueue.global(qos: qos).async(execute: work)
}

/// 在后台线程上执行任务并返回值
/// - Parameters:
///   - qos: 服务质量
///   - work: 要执行的工作项
/// - Returns: 任务结果
@discardableResult
public func onBackgroundThread<T: Sendable>(
    qos: DispatchQoS.QoSClass = .default,
    _ work: @escaping @Sendable () throws -> T
) async throws -> T {
    return try await AsyncTask.run(qos: qos, work)
}

// MARK: - 互斥锁工具

/// 线程安全的包装器
public final class ThreadSafe<Value: Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var _value: Value
    
    /// 初始化线程安全包装器
    /// - Parameter value: 初始值
    public init(_ value: Value) {
        self._value = value
    }
    
    /// 线程安全地访问值
    public var value: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
    
    /// 线程安全地修改值
    /// - Parameter transform: 转换函数
    public func mutate(_ transform: (inout Value) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        transform(&_value)
    }
    
    /// 线程安全地获取并设置新值
    /// - Parameter newValue: 新值
    /// - Returns: 旧值
    @discardableResult
    public func getAndSet(_ newValue: Value) -> Value {
        lock.lock()
        defer { lock.unlock() }
        let oldValue = _value
        _value = newValue
        return oldValue
    }
}

// MARK: - 信号量包装器（安全版本）

/// 线程安全的信号量包装器
public struct SafeSemaphore: @unchecked Sendable {
    private let semaphore: DispatchSemaphore
    
    /// 初始化信号量
    /// - Parameter value: 初始值
    public init(value: Int = 0) {
        self.semaphore = DispatchSemaphore(value: value)
    }
    
    /// 等待信号量
    /// - Parameter timeout: 超时时间（默认永远等待）
    /// - Returns: 等待结果
    @discardableResult
    public func wait(timeout: DispatchTime = .distantFuture) -> DispatchTimeoutResult {
        return semaphore.wait(timeout: timeout)
    }
    
    /// 发送信号
    public func signal() {
        semaphore.signal()
    }
}

// MARK: - 示例用法

/*
 示例用法：
 
 1. 安全异步执行：
    DispatchQueue.main.safeAsync {
        updateUI()
    }
 
 2. 延迟执行：
    DispatchQueue.safeMainAsyncAfter(interval: 1.0) {
        showMessage()
    }
 
 3. 线程安全访问：
    let safeCounter = ThreadSafe(0)
    safeCounter.mutate { $0 += 1 }
    print(safeCounter.value)
 
 4. 异步任务包装器：
    let result = await AsyncTask.run {
        performHeavyComputation()
    }
 
 5. 主线程执行：
    await onMainThread {
        updateUI()
    }
 */