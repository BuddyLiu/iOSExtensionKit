// PerformanceTimer.swift
// 性能计时器和分析工具 - 简化版本，避免并发问题

import Foundation

/// 性能测量级别
public enum PerformanceLevel {
    /// 调试级别（用于开发调试）
    case debug
    /// 发布级别（用于生产环境）
    case release
    /// 性能关键路径
    case critical
}

/// 性能计时器，用于测量代码执行时间
public struct PerformanceTimer {
    
    // MARK: - 内部状态
    
    private let startTime: CFAbsoluteTime
    private let name: String
    private let level: PerformanceLevel
    private var shouldLog: Bool = true
    
    // MARK: - 初始化
    
    /// 创建一个性能计时器
    /// - Parameters:
    ///   - name: 计时器名称
    ///   - level: 性能级别
    ///   - shouldLog: 是否记录日志
    public init(name: String, level: PerformanceLevel = .debug, shouldLog: Bool = true) {
        self.name = name
        self.level = level
        self.shouldLog = shouldLog
        self.startTime = CFAbsoluteTimeGetCurrent()
    }
    
    // MARK: - 计时方法
    
    /// 停止计时并返回执行时间（秒）
    /// - Returns: 执行时间（秒）
    @discardableResult
    public func stop() -> TimeInterval {
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsed = endTime - startTime
        
        if shouldLog {
            logMeasurement(duration: elapsed)
        }
        
        return elapsed
    }
    
    /// 停止计时并输出结果
    /// - Parameter message: 自定义消息
    @discardableResult
    public func stop(withMessage message: String? = nil) -> TimeInterval {
        let elapsed = stop()
        
        if let message = message, shouldLog {
            print("⏱️ [\(name)] \(message) - \(String(format: "%.4f", elapsed))s")
        }
        
        return elapsed
    }
    
    // MARK: - 日志记录
    
    private func logMeasurement(duration: TimeInterval) {
        let timeString = String(format: "%.4f", duration)
        
        switch level {
        case .debug:
            print("🔍 [PERF-DEBUG] \(name): \(timeString)s")
        case .release:
            print("📊 [PERF-RELEASE] \(name): \(timeString)s")
        case .critical:
            print("🚨 [PERF-CRITICAL] \(name): \(timeString)s")
        }
    }
    
    // MARK: - 静态方法
    
    /// 快速测量代码块执行时间
    /// - Parameters:
    ///   - name: 测量名称
    ///   - level: 性能级别
    ///   - block: 要测量的代码块
    /// - Returns: 执行时间（秒）
    @discardableResult
    public static func measure<T>(
        name: String,
        level: PerformanceLevel = .debug,
        _ block: () throws -> T
    ) rethrows -> (T, TimeInterval) {
        let timer = PerformanceTimer(name: name, level: level)
        let result = try block()
        let elapsed = timer.stop()
        return (result, elapsed)
    }
    
    /// 快速测量代码块执行时间并输出结果
    /// - Parameters:
    ///   - name: 测量名称
    ///   - level: 性能级别
    ///   - message: 输出消息
    ///   - block: 要测量的代码块
    /// - Returns: 代码块的返回值
    @discardableResult
    public static func measureAndLog<T>(
        name: String,
        level: PerformanceLevel = .debug,
        message: String? = nil,
        _ block: () throws -> T
    ) rethrows -> T {
        let timer = PerformanceTimer(name: name, level: level)
        let result = try block()
        timer.stop(withMessage: message)
        return result
    }
    
    /// 异步测量代码块执行时间
    /// - Parameters:
    ///   - name: 测量名称
    ///   - level: 性能级别
    ///   - block: 要测量的异步代码块
    /// - Returns: 执行时间（秒）
    @discardableResult
    public static func measureAsync<T>(
        name: String,
        level: PerformanceLevel = .debug,
        _ block: () async throws -> T
    ) async rethrows -> (T, TimeInterval) {
        let timer = PerformanceTimer(name: name, level: level)
        let result = try await block()
        let elapsed = timer.stop()
        return (result, elapsed)
    }
}

// MARK: - 便捷全局函数

/// 快速测量函数（全局方法）
/// - Parameters:
///   - name: 测量名称
///   - level: 性能级别
///   - block: 要测量的代码块
/// - Returns: 代码块的返回值
@discardableResult
public func measurePerformance<T>(
    name: String,
    level: PerformanceLevel = .debug,
    _ block: () throws -> T
) rethrows -> T {
    return try PerformanceTimer.measureAndLog(name: name, level: level, block)
}

/// 快速测量异步函数（全局方法）
/// - Parameters:
///   - name: 测量名称
///   - level: 性能级别
///   - block: 要测量的异步代码块
/// - Returns: 代码块的返回值
@discardableResult
public func measurePerformanceAsync<T>(
    name: String,
    level: PerformanceLevel = .debug,
    _ block: () async throws -> T
) async rethrows -> T {
    let (result, elapsed) = try await PerformanceTimer.measureAsync(name: name, level: level, block)
    let timeString = String(format: "%.4f", elapsed)
    print("⏱️ [\(name)] Async operation completed in \(timeString)s")
    return result
}

// MARK: - 线程安全的结果包装器

private final class ResultWrapper<Value>: @unchecked Sendable {
    var value: Value?
    
    init() {}
}

// MARK: - DispatchQueue 扩展（简化版本）

public extension DispatchQueue {
    
    /// 在指定队列上测量代码块执行时间（简化版本）
    /// - Parameters:
    ///   - name: 测量名称
    ///   - level: 性能级别
    ///   - qos: 服务质量
    ///   - block: 要测量的代码块
    /// - Returns: 执行时间（秒）
    @discardableResult
    static func measureOnQueue<T>(
        name: String,
        level: PerformanceLevel = .debug,
        qos: DispatchQoS = .default,
        _ block: @escaping @Sendable () -> T
    ) -> (T, TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // 使用线程安全的包装器存储结果
        let wrapper = ResultWrapper<T>()
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global(qos: qos.qosClass).async {
            wrapper.value = block()
            semaphore.signal()
        }
        
        semaphore.wait()
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsed = endTime - startTime
        
        // 记录日志
        let timeString = String(format: "%.4f", elapsed)
        switch level {
        case .debug:
            print("🔍 [PERF-DEBUG] \(name) (queue): \(timeString)s")
        case .release:
            print("📊 [PERF-RELEASE] \(name) (queue): \(timeString)s")
        case .critical:
            print("🚨 [PERF-CRITICAL] \(name) (queue): \(timeString)s")
        }
        
        // 安全解包
        if let unwrappedResult = wrapper.value {
            return (unwrappedResult, elapsed)
        } else {
            fatalError("Block did not return a value")
        }
    }
}

// MARK: - 简单的内存使用监控（安全版本）

/// 内存使用监控工具
public struct MemoryMonitor {
    
    /// 获取当前应用内存使用情况（格式化字符串）- 简化版本
    /// - Returns: 格式化后的内存使用字符串
    public static func formattedMemoryUsage() -> String {
        // 使用更安全的方法获取内存信息
        #if canImport(UIKit)
        let usageInBytes = report_memory()
        return formatBytes(usageInBytes)
        #else
        return "Memory monitoring not available"
        #endif
    }
    
    /// 格式化字节数
    /// - Parameter bytes: 字节数
    /// - Returns: 格式化字符串
    private static func formatBytes(_ bytes: UInt64) -> String {
        if bytes < 1024 {
            return "\(bytes) B"
        } else if bytes < 1024 * 1024 {
            return String(format: "%.2f KB", Double(bytes) / 1024.0)
        } else if bytes < 1024 * 1024 * 1024 {
            return String(format: "%.2f MB", Double(bytes) / (1024.0 * 1024.0))
        } else {
            return String(format: "%.2f GB", Double(bytes) / (1024.0 * 1024.0 * 1024.0))
        }
    }
}

// MARK: - 平台特定的内存报告函数

#if canImport(UIKit)
import UIKit

/// 报告当前内存使用情况
/// - Returns: 内存使用字节数
private func report_memory() -> UInt64 {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
    
    let kerr = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
        }
    }
    
    if kerr == KERN_SUCCESS {
        return UInt64(info.resident_size)
    } else {
        // 备用方法：使用更安全的系统 API
        return UInt64(ProcessInfo.processInfo.physicalMemory / 1024 / 1024) * 1024 * 1024
    }
}
#endif

// MARK: - 使用示例

/*
 示例用法：
 
 1. 基本用法：
    let timer = PerformanceTimer(name: "数据库查询", level: .debug)
    let result = performDatabaseQuery()
    let elapsed = timer.stop()
 
 2. 快速测量：
    let (result, time) = PerformanceTimer.measure(name: "网络请求") {
        performNetworkRequest()
    }
 
 3. 异步测量：
    let (result, time) = await PerformanceTimer.measureAsync(name: "异步操作") {
        try await performAsyncOperation()
    }
 
 4. 全局函数：
    let result = measurePerformance(name: "复杂计算") {
        performComplexCalculation()
    }
 
 5. 队列测量：
    let (result, time) = DispatchQueue.measureOnQueue(name: "后台处理", qos: .userInitiated) {
        performBackgroundProcessing()
    }
 */
