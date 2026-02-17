// Debug+Extension.swift
// 调试和日志工具扩展，提供便捷的日志记录、调试辅助、断言检查等功能

import Foundation
import os.log
#if canImport(Darwin)
@preconcurrency import Darwin
#endif
#if canImport(UIKit)
import UIKit
#endif

// MARK: - 日志级别

/// 日志级别
public enum LogLevel: Int, CaseIterable, CustomStringConvertible {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    case critical = 5
    
    public var description: String {
        switch self {
        case .verbose: return "VERBOSE"
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        case .critical: return "CRITICAL"
        }
    }
    
    public var symbol: String {
        switch self {
        case .verbose: return "🔍"
        case .debug: return "🐛"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .critical: return "🚨"
        }
    }
    
    public var osLogType: OSLogType {
        switch self {
        case .verbose, .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .critical: return .fault
        }
    }
}

// MARK: - 日志管理器

/// 日志管理器
public final class LogManager: @unchecked Sendable {
    
    public static let shared = LogManager()
    
    private let queue = DispatchQueue(label: "com.iosexkit.log.manager", qos: .utility)
    private var loggers: [String: OSLog] = [:]
    private let lock = NSLock()
    
    /// 当前日志级别
    public var logLevel: LogLevel = .info
    
    /// 是否启用控制台输出
    public var enableConsoleOutput = true
    
    /// 是否启用文件输出
    public var enableFileOutput = false
    
    /// 日志文件路径
    public var logFileURL: URL? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsPath?.appendingPathComponent("logs/ios-extensionkit.log")
    }
    
    /// 是否启用结构化日志（OSLog）
    public var enableStructuredLogging = true
    
    private init() {
        setupLogDirectory()
    }
    
    private func setupLogDirectory() {
        guard let logFileURL = logFileURL else { return }
        let logDirectory = logFileURL.deletingLastPathComponent()
        
        do {
            try FileManager.default.createDirectory(at: logDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create log directory: \(error)")
        }
    }
    
    /// 获取或创建日志记录器
    /// - Parameter subsystem: 子系统标识符
    /// - Returns: 日志记录器
    private func logger(for subsystem: String) -> OSLog {
        lock.lock()
        defer { lock.unlock() }
        
        if let existingLogger = loggers[subsystem] {
            return existingLogger
        }
        
        let newLogger = OSLog(subsystem: subsystem, category: "iOSExtensionKit")
        loggers[subsystem] = newLogger
        return newLogger
    }
    
    /// 记录日志
    /// - Parameters:
    ///   - level: 日志级别
    ///   - message: 日志消息
    ///   - subsystem: 子系统标识符
    ///   - file: 文件名
    ///   - function: 函数名
    ///   - line: 行号
    public func log(level: LogLevel,
                    _ message: String,
                    subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        
        // 检查日志级别
        guard level.rawValue >= logLevel.rawValue else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let timestamp = Date().description
        let formattedMessage = "\(timestamp) \(level.symbol) [\(fileName):\(line)] \(function) - \(message)"
        
        // 控制台输出
        if enableConsoleOutput {
            print(formattedMessage)
        }
        
        // 结构化日志
        if enableStructuredLogging {
            let logger = logger(for: subsystem)
            os_log("%{public}@", log: logger, type: level.osLogType, message)
        }
        
        // 文件输出
        if enableFileOutput, let logFileURL = logFileURL {
            queue.async {
                self.writeToFile(message: formattedMessage, fileURL: logFileURL)
            }
        }
    }
    
    private func writeToFile(message: String, fileURL: URL) {
        let fileManager = FileManager.default
        
        // 添加换行符
        let logMessage = message + "\n"
        
        guard let data = logMessage.data(using: .utf8) else { return }
        
        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                // 追加到现有文件
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } else {
                // 创建新文件
                try data.write(to: fileURL, options: .atomic)
            }
        } catch {
            print("Failed to write log to file: \(error)")
        }
    }
    
    /// 清空日志文件
    public func clearLogFile() {
        guard let logFileURL = logFileURL else { return }
        
        do {
            if FileManager.default.fileExists(atPath: logFileURL.path) {
                try "".write(to: logFileURL, atomically: true, encoding: .utf8)
                log(level: .info, "Log file cleared", subsystem: "com.iosexkit.logger")
            }
        } catch {
            log(level: .error, "Failed to clear log file: \(error)", subsystem: "com.iosexkit.logger")
        }
    }
    
    /// 获取日志文件内容
    /// - Returns: 日志文件内容
    public func getLogFileContent() -> String? {
        guard let logFileURL = logFileURL else { return nil }
        
        do {
            return try String(contentsOf: logFileURL, encoding: .utf8)
        } catch {
            log(level: .error, "Failed to read log file: \(error)", subsystem: "com.iosexkit.logger")
            return nil
        }
    }
    
    /// 导出日志文件
    /// - Returns: 日志文件数据
    public func exportLogFile() -> Data? {
        guard let logFileURL = logFileURL else { return nil }
        
        do {
            return try Data(contentsOf: logFileURL)
        } catch {
            log(level: .error, "Failed to export log file: \(error)", subsystem: "com.iosexkit.logger")
            return nil
        }
    }
    
    /// 设置日志级别
    /// - Parameter level: 日志级别
    public func setLogLevel(_ level: LogLevel) {
        logLevel = level
        log(level: .info, "Log level changed to \(level)", subsystem: "com.iosexkit.logger")
    }
    
    /// 启用调试日志
    public func enableDebugLogging() {
        setLogLevel(.debug)
        enableConsoleOutput = true
        log(level: .info, "Debug logging enabled", subsystem: "com.iosexkit.logger")
    }
    
    /// 禁用所有日志
    public func disableAllLogging() {
        setLogLevel(.critical)
        enableConsoleOutput = false
        log(level: .info, "All logging disabled", subsystem: "com.iosexkit.logger")
    }
}

// MARK: - 便捷日志函数

/// 记录详细日志
public func logVerbose(_ message: String,
                       subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line) {
    LogManager.shared.log(level: .verbose, message, subsystem: subsystem, file: file, function: function, line: line)
}

/// 记录调试日志
public func logDebug(_ message: String,
                     subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
    LogManager.shared.log(level: .debug, message, subsystem: subsystem, file: file, function: function, line: line)
}

/// 记录信息日志
public func logInfo(_ message: String,
                    subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
    LogManager.shared.log(level: .info, message, subsystem: subsystem, file: file, function: function, line: line)
}

/// 记录警告日志
public func logWarning(_ message: String,
                       subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line) {
    LogManager.shared.log(level: .warning, message, subsystem: subsystem, file: file, function: function, line: line)
}

/// 记录错误日志
public func logError(_ message: String,
                     subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
    LogManager.shared.log(level: .error, message, subsystem: subsystem, file: file, function: function, line: line)
}

/// 记录严重错误日志
public func logCritical(_ message: String,
                        subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
    LogManager.shared.log(level: .critical, message, subsystem: subsystem, file: file, function: function, line: line)
}

// MARK: - 调试辅助工具

/// 调试断言（仅在调试模式下有效）
public func debugAssert(_ condition: @autoclosure () -> Bool,
                        _ message: String = "",
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
    #if DEBUG
    if !condition() {
        let fileName = (file as NSString).lastPathComponent
        let assertionMessage = "Assertion failed in \(fileName):\(line) \(function) - \(message)"
        logCritical(assertionMessage, subsystem: "com.iosexkit.debug", file: file, function: function, line: line)
        assertionFailure(assertionMessage)
    }
    #endif
}

/// 调试前提条件检查
public func debugPrecondition(_ condition: @autoclosure () -> Bool,
                              _ message: String = "",
                              file: String = #file,
                              function: String = #function,
                              line: Int = #line) {
    #if DEBUG
    if !condition() {
        let fileName = (file as NSString).lastPathComponent
        let preconditionMessage = "Precondition failed in \(fileName):\(line) \(function) - \(message)"
        logCritical(preconditionMessage, subsystem: "com.iosexkit.debug", file: file, function: function, line: line)
        preconditionFailure(preconditionMessage)
    }
    #endif
}

/// 安全执行代码块并记录错误
public func safeExecute<T>(_ block: () throws -> T,
                           defaultValue: T? = nil,
                           errorMessage: String = "",
                           file: String = #file,
                           function: String = #function,
                           line: Int = #line) -> T? {
    do {
        return try block()
    } catch {
        let fileName = (file as NSString).lastPathComponent
        let message = errorMessage.isEmpty ? "Error in \(fileName):\(line) \(function)" : errorMessage
        logError("\(message): \(error)", subsystem: "com.iosexkit.safe", file: file, function: function, line: line)
        return defaultValue
    }
}

/// 测量代码执行时间
public func measureExecutionTime<T>(_ name: String = "Execution",
                                    _ block: () throws -> T,
                                    file: String = #file,
                                    function: String = #function,
                                    line: Int = #line) rethrows -> T {
    let startTime = CFAbsoluteTimeGetCurrent()
    defer {
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        logDebug("\(name) took \(String(format: "%.3f", duration)) seconds", subsystem: "com.iosexkit.performance", file: file, function: function, line: line)
    }
    return try block()
}

// MARK: - 调试信息收集

/// 调试信息收集器
public final class DebugInfoCollector: @unchecked Sendable {
    
    public static let shared = DebugInfoCollector()
    
    private var collectedInfo: [String: Any] = [:]
    private let lock = NSLock()
    
    private init() {
        collectSystemInfo()
    }
    
    /// 收集系统信息
    private func collectSystemInfo() {
        let processInfo = ProcessInfo.processInfo
        
        lock.lock()
        
        #if canImport(UIKit)
        let device = UIDevice.current
        collectedInfo["systemName"] = device.systemName
        collectedInfo["systemVersion"] = device.systemVersion
        collectedInfo["deviceModel"] = device.model
        collectedInfo["deviceName"] = device.name
        #else
        collectedInfo["systemName"] = ProcessInfo.processInfo.operatingSystemVersionString
        collectedInfo["systemVersion"] = "Unknown"
        collectedInfo["deviceModel"] = "Unknown"
        collectedInfo["deviceName"] = ProcessInfo.processInfo.hostName
        #endif
        
        collectedInfo["processorCount"] = processInfo.processorCount
        collectedInfo["physicalMemory"] = processInfo.physicalMemory
        collectedInfo["systemUptime"] = processInfo.systemUptime
        collectedInfo["isLowPowerModeEnabled"] = processInfo.isLowPowerModeEnabled
        collectedInfo["isMacCatalystApp"] = processInfo.isMacCatalystApp
        collectedInfo["isiOSAppOnMac"] = processInfo.isiOSAppOnMac
        lock.unlock()
    }
    
    /// 添加调试信息
    /// - Parameters:
    ///   - value: 信息值
    ///   - key: 信息键
    public func addInfo(_ value: Any, forKey key: String) {
        lock.lock()
        collectedInfo[key] = value
        lock.unlock()
    }
    
    /// 获取调试信息
    /// - Parameter key: 信息键
    /// - Returns: 信息值
    public func getInfo(forKey key: String) -> Any? {
        lock.lock()
        let value = collectedInfo[key]
        lock.unlock()
        return value
    }
    
    /// 获取所有调试信息
    /// - Returns: 调试信息字典
    public func getAllInfo() -> [String: Any] {
        lock.lock()
        let info = collectedInfo
        lock.unlock()
        return info
    }
    
    /// 生成本机调试信息报告
    /// - Returns: 调试信息报告字符串
    public func generateDebugReport() -> String {
        let info = getAllInfo()
        var report = "📱 iOSExtensionKit 调试报告\n"
        report += "=====================\n"
        report += "生成时间: \(Date())\n\n"
        
        for (key, value) in info.sorted(by: { $0.key < $1.key }) {
            report += "\(key): \(value)\n"
        }
        
        return report
    }
    
    /// 导出调试报告到文件
    /// - Returns: 是否导出成功
    @discardableResult
    public func exportDebugReport() -> Bool {
        let report = generateDebugReport()
        let timestamp = Date().timeIntervalSince1970
        let fileName = "debug-report-\(Int(timestamp)).txt"
        
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try report.write(to: fileURL, atomically: true, encoding: .utf8)
            logInfo("Debug report exported to: \(fileURL.path)", subsystem: "com.iosexkit.debug")
            return true
        } catch {
            logError("Failed to export debug report: \(error)", subsystem: "com.iosexkit.debug")
            return false
        }
    }
    
    /// 清空收集的调试信息
    public func clear() {
        lock.lock()
        collectedInfo.removeAll()
        lock.unlock()
        collectSystemInfo() // 重新收集系统信息
    }
}

// MARK: - 内存调试工具

/// 内存使用监控器
public final class MemoryMonitor: @unchecked Sendable {
    
    public static let shared = MemoryMonitor()
    
    private var memoryUsageHistory: [TimeInterval: UInt64] = [:]
    private let maxHistoryCount = 100
    private let lock = NSLock()
    
    private init() {}
    
    /// 获取当前内存使用量
    nonisolated(unsafe) public var currentMemoryUsage: UInt64? {
        #if canImport(Darwin)
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let task = mach_task_self_
        let kerr = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(task, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        guard kerr == KERN_SUCCESS else { return nil }
        return taskInfo.resident_size
        #else
        return nil // 非 Darwin 平台不支持
        #endif
    }
    
    /// 获取内存使用量（MB）
    public var currentMemoryUsageMB: Double? {
        guard let bytes = currentMemoryUsage else { return nil }
        return Double(bytes) / 1024.0 / 1024.0
    }
    
    /// 记录当前内存使用量
    public func recordMemoryUsage() {
        guard let usage = currentMemoryUsage else { return }
        let timestamp = Date().timeIntervalSince1970
        
        lock.lock()
        memoryUsageHistory[timestamp] = usage
        
        // 限制历史记录数量
        if memoryUsageHistory.count > maxHistoryCount {
            let oldestKey = memoryUsageHistory.keys.min()
            if let key = oldestKey {
                memoryUsageHistory.removeValue(forKey: key)
            }
        }
        lock.unlock()
    }
    
    /// 获取内存使用历史
    public func getMemoryUsageHistory() -> [(time: TimeInterval, usage: UInt64)] {
        lock.lock()
        let history = memoryUsageHistory.sorted { $0.key < $1.key }
        lock.unlock()
        return history.map { (time: $0.key, usage: $0.value) }
    }
    
    /// 获取内存使用峰值
    public var peakMemoryUsage: UInt64? {
        lock.lock()
        let peak = memoryUsageHistory.values.max()
        lock.unlock()
        return peak
    }
    
    /// 获取平均内存使用量
    public var averageMemoryUsage: UInt64? {
        lock.lock()
        let values = memoryUsageHistory.values
        guard !values.isEmpty else {
            lock.unlock()
            return nil
        }
        let average = values.reduce(0, +) / UInt64(values.count)
        lock.unlock()
        return average
    }
    
    /// 清空内存使用历史
    public func clearHistory() {
        lock.lock()
        memoryUsageHistory.removeAll()
        lock.unlock()
    }
    
    /// 检查内存使用是否过高
    /// - Parameter thresholdMB: 阈值（MB）
    /// - Returns: 是否超过阈值
    public func isMemoryUsageHigh(thresholdMB: Double = 500) -> Bool {
        guard let usageMB = currentMemoryUsageMB else { return false }
        return usageMB > thresholdMB
    }
    
    /// 打印内存使用报告
    public func printMemoryReport() {
        guard let currentMB = currentMemoryUsageMB,
              let averageBytes = averageMemoryUsage,
              let peakBytes = peakMemoryUsage else {
            logWarning("Unable to generate memory report", subsystem: "com.iosexkit.memory")
            return
        }
        
        let averageMB = Double(averageBytes) / 1024.0 / 1024.0
        let peakMB = Double(peakBytes) / 1024.0 / 1024.0
        
        let report = """
        📊 内存使用报告
        =============
        当前使用: \(String(format: "%.2f", currentMB)) MB
        平均使用: \(String(format: "%.2f", averageMB)) MB
        峰值使用: \(String(format: "%.2f", peakMB)) MB
        历史记录: \(memoryUsageHistory.count) 个
        """
        
        logInfo(report, subsystem: "com.iosexkit.memory")
    }
}

// MARK: - 性能调试扩展

public extension PerformanceMonitor {
    
    /// 记录性能测量到日志
    func logMeasurement(_ name: String, threshold: CFAbsoluteTime? = 0.1) -> String {
        let identifier = startMeasurement(name: name, threshold: threshold)
        return identifier
    }
    
    /// 结束性能测量并记录到日志
    @discardableResult
    func endLogMeasurement(_ identifier: String) -> CFAbsoluteTime {
        let duration = endMeasurement(identifier)
        return duration
    }
}

// MARK: - 便捷调试宏

/// 调试日志宏（仅在调试模式下有效）
#if DEBUG
public func DLog(_ message: String,
                 subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                 file: String = #file,
                 function: String = #function,
                 line: Int = #line) {
    logDebug(message, subsystem: subsystem, file: file, function: function, line: line)
}

/// 调试断言宏
public func DAssert(_ condition: @autoclosure () -> Bool,
                    _ message: String = "",
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
    debugAssert(condition(), message, file: file, function: function, line: line)
}

/// 调试测量宏
public func DMeasure<T>(_ name: String = "Execution",
                        _ block: () throws -> T,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) rethrows -> T {
    return try measureExecutionTime(name, block, file: file, function: function, line: line)
}
#else
public func DLog(_ message: String,
                 subsystem: String = Bundle.main.bundleIdentifier ?? "com.iosexkit",
                 file: String = #file,
                 function: String = #function,
                 line: Int = #line) {
    // Release模式下不执行任何操作
}

public func DAssert(_ condition: @autoclosure () -> Bool,
                    _ message: String = "",
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
    // Release模式下不执行任何操作
}

public func DMeasure<T>(_ name: String = "Execution",
                        _ block: () throws -> T,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) rethrows -> T {
    return try block()
}
#endif