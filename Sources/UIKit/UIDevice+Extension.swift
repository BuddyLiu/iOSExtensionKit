// UIDevice+Extension.swift
// UIDevice扩展，提供设备信息和便捷方法

#if canImport(UIKit)
import UIKit

public extension UIDevice {
    
    // MARK: - 设备信息
    
    /// 设备型号名称（如 "iPhone 14 Pro"）
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return deviceIdentifierMapping[identifier] ?? identifier
    }
    
    /// 是否是iPhone
    var isiPhone: Bool {
        return model.lowercased().contains("iphone")
    }
    
    /// 是否是iPad
    var isiPad: Bool {
        return model.lowercased().contains("ipad")
    }
    
    /// 是否是iPod
    var isiPod: Bool {
        return model.lowercased().contains("ipod")
    }
    
    /// 是否是模拟器
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    /// 是否是全面屏设备（有刘海或动态岛）
    var isFullScreenDevice: Bool {
        let fullScreenModels: Set<String> = [
            "iPhone10,3", "iPhone10,6", // iPhone X
            "iPhone11,2", "iPhone11,4", "iPhone11,6", "iPhone11,8", // iPhone XS, XS Max, XR
            "iPhone12,1", "iPhone12,3", "iPhone12,5", "iPhone12,8", // iPhone 11系列
            "iPhone13,1", "iPhone13,2", "iPhone13,3", "iPhone13,4", // iPhone 12系列
            "iPhone14,2", "iPhone14,3", "iPhone14,4", "iPhone14,5", "iPhone14,6", "iPhone14,7", "iPhone14,8", // iPhone 13系列
            "iPhone15,2", "iPhone15,3", "iPhone15,4", "iPhone15,5", // iPhone 14系列
            "iPhone16,1", "iPhone16,2" // iPhone 15系列及以后
        ]
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return fullScreenModels.contains(identifier)
    }
    
    /// 是否有物理Home键
    var hasPhysicalHomeButton: Bool {
        return !isFullScreenDevice
    }
    
    /// 是否是旧设备（性能较差）
    var isOldDevice: Bool {
        let oldModels: Set<String> = [
            "iPhone4,1", "iPhone5,1", "iPhone5,2", "iPhone5,3", "iPhone5,4", // iPhone 4S, iPhone 5系列
            "iPhone6,1", "iPhone6,2", // iPhone 5S
            "iPhone7,1", "iPhone7,2", // iPhone 6系列
            "iPhone8,1", "iPhone8,2", "iPhone8,4", // iPhone 6S系列
            "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4", // iPad 2
            "iPad3,1", "iPad3,2", "iPad3,3", "iPad3,4", "iPad3,5", "iPad3,6", // iPad 3/4
        ]
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return oldModels.contains(identifier)
    }
    
    /// 是否支持面容ID
    var isFaceIDSupported: Bool {
        guard isFullScreenDevice else { return false }
        
        let nonFaceIDModels: Set<String> = [
            "iPhone10,3", "iPhone10,6", // iPhone X
            "iPhone11,2", "iPhone11,4", "iPhone11,6", // iPhone XS, XS Max
            "iPhone12,1", "iPhone12,3", "iPhone12,5", // iPhone 11系列
        ]
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return !nonFaceIDModels.contains(identifier) && isFullScreenDevice
    }
    
    // MARK: - 屏幕信息
    
    /// 屏幕尺寸（英寸）
    var screenSizeInches: Double {
        switch modelName {
        case let name where name.contains("iPhone 4") || name.contains("iPhone 4S"):
            return 3.5
        case let name where name.contains("iPhone 5") || name.contains("iPhone 5S") || name.contains("iPhone SE"):
            return 4.0
        case let name where name.contains("iPhone 6") || name.contains("iPhone 6S") || name.contains("iPhone 7") || name.contains("iPhone 8"):
            return 4.7
        case let name where name.contains("iPhone 6 Plus") || name.contains("iPhone 6S Plus") || name.contains("iPhone 7 Plus") || name.contains("iPhone 8 Plus"):
            return 5.5
        case let name where name.contains("iPhone X") || name.contains("iPhone XS") || name.contains("iPhone 11 Pro"):
            return 5.8
        case let name where name.contains("iPhone XS Max") || name.contains("iPhone 11 Pro Max"):
            return 6.5
        case let name where name.contains("iPhone XR") || name.contains("iPhone 11"):
            return 6.1
        case let name where name.contains("iPhone 12 mini") || name.contains("iPhone 13 mini"):
            return 5.4
        case let name where name.contains("iPhone 12") || name.contains("iPhone 13") || name.contains("iPhone 14"):
            return 6.1
        case let name where name.contains("iPhone 12 Pro Max") || name.contains("iPhone 13 Pro Max") || name.contains("iPhone 14 Pro Max"):
            return 6.7
        case let name where name.contains("iPhone 14 Plus"):
            return 6.7
        case let name where name.contains("iPhone 15"):
            return 6.1 // 简化处理
        case let name where name.contains("iPhone 15 Plus"):
            return 6.7
        case let name where name.contains("iPhone 15 Pro"):
            return 6.1
        case let name where name.contains("iPhone 15 Pro Max"):
            return 6.7
        default:
            return 0.0
        }
    }
    
    /// 屏幕PPI（每英寸像素数）
    var screenPPI: Int {
        switch modelName {
        case let name where name.contains("iPhone 4") || name.contains("iPhone 4S"):
            return 326
        case let name where name.contains("iPhone 5") || name.contains("iPhone 5S") || name.contains("iPhone SE"):
            return 326
        case let name where name.contains("iPhone 6") || name.contains("iPhone 6S") || name.contains("iPhone 7") || name.contains("iPhone 8"):
            return 326
        case let name where name.contains("iPhone 6 Plus") || name.contains("iPhone 6S Plus") || name.contains("iPhone 7 Plus") || name.contains("iPhone 8 Plus"):
            return 401
        case let name where name.contains("iPhone X") || name.contains("iPhone XS") || name.contains("iPhone 11 Pro"):
            return 458
        case let name where name.contains("iPhone XS Max") || name.contains("iPhone 11 Pro Max"):
            return 458
        case let name where name.contains("iPhone XR") || name.contains("iPhone 11"):
            return 326
        case let name where name.contains("iPhone 12 mini") || name.contains("iPhone 13 mini"):
            return 476
        case let name where name.contains("iPhone 12") || name.contains("iPhone 13") || name.contains("iPhone 14"):
            return 460
        case let name where name.contains("iPhone 12 Pro Max") || name.contains("iPhone 13 Pro Max") || name.contains("iPhone 14 Pro Max"):
            return 458
        case let name where name.contains("iPhone 14 Plus"):
            return 458
        default:
            return 326
        }
    }
    
    // MARK: - 系统信息
    
    /// iOS系统版本（字符串）
    var iOSVersion: String {
        return systemVersion
    }
    
    /// iOS主版本号
    var iOSMajorVersion: Int {
        let versionComponents = systemVersion.split(separator: ".")
        guard let majorVersion = versionComponents.first, let intValue = Int(majorVersion) else {
            return 0
        }
        return intValue
    }
    
    /// 是否是iOS 13或更高版本
    var isiOS13OrLater: Bool {
        return iOSMajorVersion >= 13
    }
    
    /// 是否是iOS 14或更高版本
    var isiOS14OrLater: Bool {
        return iOSMajorVersion >= 14
    }
    
    /// 是否是iOS 15或更高版本
    var isiOS15OrLater: Bool {
        return iOSMajorVersion >= 15
    }
    
    /// 是否是iOS 16或更高版本
    var isiOS16OrLater: Bool {
        return iOSMajorVersion >= 16
    }
    
    /// 是否是iOS 17或更高版本
    var isiOS17OrLater: Bool {
        return iOSMajorVersion >= 17
    }
    
    /// 是否是iOS 18或更高版本
    var isiOS18OrLater: Bool {
        return iOSMajorVersion >= 18
    }
    
    /// 设备名称（用户自定义）
    var customName: String {
        return name
    }
    
    /// 设备UUID
    var deviceUUID: String? {
        return identifierForVendor?.uuidString
    }
    
    // MARK: - 电池信息
    
    /// 电池状态
    @available(iOS 3.0, *)
    var batteryStateDescription: String {
        switch batteryState {
        case .unknown:
            return "未知"
        case .unplugged:
            return "未充电"
        case .charging:
            return "充电中"
        case .full:
            return "已充满"
        @unknown default:
            return "未知"
        }
    }
    
    /// 电池电量（0.0 - 1.0）
    @available(iOS 3.0, *)
    var batteryLevelPercentage: Int {
        guard isBatteryMonitoringEnabled else { return -1 }
        return Int(batteryLevel * 100)
    }
    
    /// 是否是低电量模式
    @available(iOS 9.0, *)
    var isLowPowerModeEnabled: Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    // MARK: - 存储信息
    
    /// 设备总存储空间（字节）
    var totalDiskSpace: Int64? {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let space = systemAttributes[.systemSize] as? NSNumber else {
            return nil
        }
        return space.int64Value
    }
    
    /// 设备可用存储空间（字节）
    var freeDiskSpace: Int64? {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let space = systemAttributes[.systemFreeSize] as? NSNumber else {
            return nil
        }
        return space.int64Value
    }
    
    /// 设备已用存储空间（字节）
    var usedDiskSpace: Int64? {
        guard let total = totalDiskSpace, let free = freeDiskSpace else {
            return nil
        }
        return total - free
    }
    
    /// 总存储空间（格式化字符串，如 "64 GB"）
    var formattedTotalDiskSpace: String? {
        guard let total = totalDiskSpace else { return nil }
        return formatBytes(total)
    }
    
    /// 可用存储空间（格式化字符串）
    var formattedFreeDiskSpace: String? {
        guard let free = freeDiskSpace else { return nil }
        return formatBytes(free)
    }
    
    /// 已用存储空间（格式化字符串）
    var formattedUsedDiskSpace: String? {
        guard let used = usedDiskSpace else { return nil }
        return formatBytes(used)
    }
    
    /// 存储空间使用百分比
    var diskUsagePercentage: Double? {
        guard let total = totalDiskSpace, let used = usedDiskSpace, total > 0 else {
            return nil
        }
        return Double(used) / Double(total) * 100.0
    }
    
    /// 是否是低存储空间（小于1GB）
    var isLowStorageSpace: Bool {
        guard let free = freeDiskSpace else { return false }
        return free < 1_073_741_824 // 1 GB
    }
    
    /// 是否是严重低存储空间（小于100MB）
    var isCriticalLowStorageSpace: Bool {
        guard let free = freeDiskSpace else { return false }
        return free < 104_857_600 // 100 MB
    }
    
    // MARK: - 内存信息
    
    /// 设备物理内存（字节）
    var physicalMemory: Int64 {
        return Int64(ProcessInfo.processInfo.physicalMemory)
    }
    
    /// 格式化物理内存（如 "4 GB"）
    var formattedPhysicalMemory: String {
        return formatBytes(Int64(ProcessInfo.processInfo.physicalMemory))
    }
    
    /// 可用内存（近似值，字节）
    var availableMemory: Int64? {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let kerr = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        guard kerr == KERN_SUCCESS else { return nil }
        return Int64(info.resident_size)
    }
    
    /// 格式化可用内存
    var formattedAvailableMemory: String? {
        guard let memory = availableMemory else { return nil }
        return formatBytes(memory)
    }
    
    /// 内存使用百分比
    var memoryUsagePercentage: Double? {
        guard let available = availableMemory else { return nil }
        let total = physicalMemory
        guard total > 0 else { return nil }
        return Double(total - available) / Double(total) * 100.0
    }
    
    /// 是否是高内存使用状态（大于80%）
    var isHighMemoryUsage: Bool {
        guard let percentage = memoryUsagePercentage else { return false }
        return percentage > 80.0
    }
    
    // MARK: - 性能信息
    
    /// 处理器核心数
    var processorCount: Int {
        return ProcessInfo.processInfo.processorCount
    }
    
    /// 活跃处理器核心数
    var activeProcessorCount: Int {
        return ProcessInfo.processInfo.activeProcessorCount
    }
    
    /// 系统运行时间（秒）
    var systemUptime: TimeInterval {
        return ProcessInfo.processInfo.systemUptime
    }
    
    /// 格式化系统运行时间（如 "2天3小时"）
    var formattedSystemUptime: String {
        let uptime = systemUptime
        let days = Int(uptime / 86400)
        let hours = Int((uptime.truncatingRemainder(dividingBy: 86400)) / 3600)
        let minutes = Int((uptime.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if days > 0 {
            return "\(days)天\(hours)小时"
        } else if hours > 0 {
            return "\(hours)小时\(minutes)分钟"
        } else {
            return "\(minutes)分钟"
        }
    }
    
    /// 设备热状态
    @available(iOS 11.0, *)
    var thermalStateDescription: String {
        switch thermalState {
        case .nominal:
            return "正常"
        case .fair:
            return "良好"
        case .serious:
            return "严重"
        case .critical:
            return "临界"
        @unknown default:
            return "未知"
        }
    }
    
    // MARK: - 网络信息
    
    /// 是否支持个人热点
    var isPersonalHotspotSupported: Bool {
        // 这是一个简化的检查，实际可能需要更复杂的检测
        return !isiPod && !isSimulator
    }
    
    /// 是否支持蜂窝网络
    var isCellularSupported: Bool {
        // 这是一个简化的检查
        return isiPhone && !isSimulator
    }
    
    /// 是否支持Wi-Fi
    var isWiFiSupported: Bool {
        return true // 所有iOS设备都支持Wi-Fi
    }
    
    /// 是否支持蓝牙
    var isBluetoothSupported: Bool {
        return true // 所有现代iOS设备都支持蓝牙
    }
    
    /// 是否支持NFC
    var isNFCSupported: Bool {
        // iPhone 7及以后的设备支持NFC
        let nfcModels: Set<String> = [
            "iPhone9,1", "iPhone9,2", "iPhone9,3", "iPhone9,4", // iPhone 7系列
            "iPhone10,1", "iPhone10,2", "iPhone10,3", "iPhone10,4", "iPhone10,5", "iPhone10,6", // iPhone 8系列和X
            // 后续所有iPhone型号
        ]
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return nfcModels.contains(identifier) || identifier.hasPrefix("iPhone11,") || identifier.hasPrefix("iPhone12,") ||
               identifier.hasPrefix("iPhone13,") || identifier.hasPrefix("iPhone14,") || identifier.hasPrefix("iPhone15,") ||
               identifier.hasPrefix("iPhone16,")
    }
    
    // MARK: - 便捷方法
    
    /// 振动设备（如果支持）
    func vibrate() {
        #if os(iOS)
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        #endif
    }
    
    /// 生成设备指纹（用于匿名标识）
    func generateDeviceFingerprint() -> String? {
        var fingerprint = ""
        
        // 添加设备型号
        fingerprint += modelName
        
        // 添加系统版本
        fingerprint += iOSVersion
        
        // 添加设备UUID（如果有）
        if let uuid = deviceUUID {
            fingerprint += uuid
        }
        
        // 生成哈希
        let data = fingerprint.data(using: .utf8)
        return data?.sha256().hexString
    }
    
    /// 检查设备是否满足最低要求
    /// - Parameters:
    ///   - miniOSVersion: 最低iOS版本
    ///   - minMemoryGB: 最低内存（GB）
    ///   - minStorageGB: 最低存储空间（GB）
    /// - Returns: 是否满足要求
    func meetsRequirements(miniOSVersion: String, minMemoryGB: Double, minStorageGB: Double) -> Bool {
        // 检查iOS版本
        let currentVersion = systemVersion
        if currentVersion.compare(miniOSVersion, options: .numeric) == .orderedAscending {
            return false
        }
        
        // 检查内存
        let memoryGB = Double(physicalMemory) / 1_073_741_824.0 // 转换为GB
        if memoryGB < minMemoryGB {
            return false
        }
        
        // 检查存储空间
        guard let totalStorage = totalDiskSpace else { return false }
        let storageGB = Double(totalStorage) / 1_073_741_824.0 // 转换为GB
        if storageGB < minStorageGB {
            return false
        }
        
        return true
    }
    
    /// 获取设备性能等级（1-5，5为最高性能）
    var performanceLevel: Int {
        if isOldDevice {
            return 1
        }
        
        // 这是一个简化的性能评估
        let processorCount = self.processorCount
        
        if processorCount >= 6 {
            return 5 // 高端设备（如 iPhone 13 Pro 及以上）
        } else if processorCount >= 4 {
            return 4 // 中高端设备
        } else if processorCount >= 2 {
            return 3 // 中端设备
        } else {
            return 2 // 低端设备
        }
    }
    
    // MARK: - 私有方法
    
    private func formatBytes(_ bytes: Int64) -> String {
        let units = ["B", "KB", "MB", "GB", "TB", "PB"]
        var size = Double(bytes)
        var unitIndex = 0
        
        while size >= 1024 && unitIndex < units.count - 1 {
            size /= 1024
            unitIndex += 1
        }
        
        return String(format: "%.1f %@", size, units[unitIndex])
    }
    
    // MARK: - 设备标识符映射
    
    private var deviceIdentifierMapping: [String: String] {
        return [
            // iPhone
            "iPhone1,1": "iPhone",
            "iPhone1,2": "iPhone 3G",
            "iPhone2,1": "iPhone 3GS",
            "iPhone3,1": "iPhone 4",
            "iPhone3,2": "iPhone 4",
            "iPhone3,3": "iPhone 4",
            "iPhone4,1": "iPhone 4S",
            "iPhone5,1": "iPhone 5",
            "iPhone5,2": "iPhone 5",
            "iPhone5,3": "iPhone 5c",
            "iPhone5,4": "iPhone 5c",
            "iPhone6,1": "iPhone 5s",
            "iPhone6,2": "iPhone 5s",
            "iPhone7,1": "iPhone 6 Plus",
            "iPhone7,2": "iPhone 6",
            "iPhone8,1": "iPhone 6s",
            "iPhone8,2": "iPhone 6s Plus",
            "iPhone8,4": "iPhone SE (1st generation)",
            "iPhone9,1": "iPhone 7",
            "iPhone9,2": "iPhone 7 Plus",
            "iPhone9,3": "iPhone 7",
            "iPhone9,4": "iPhone 7 Plus",
            "iPhone10,1": "iPhone 8",
            "iPhone10,2": "iPhone 8 Plus",
            "iPhone10,3": "iPhone X",
            "iPhone10,4": "iPhone 8",
            "iPhone10,5": "iPhone 8 Plus",
            "iPhone10,6": "iPhone X",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max",
            "iPhone11,6": "iPhone XS Max",
            "iPhone11,8": "iPhone XR",
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            "iPhone12,8": "iPhone SE (2nd generation)",
            "iPhone13,1": "iPhone 12 mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,4": "iPhone 13 mini",
            "iPhone14,5": "iPhone 13",
            "iPhone14,6": "iPhone SE (3rd generation)",
            "iPhone14,7": "iPhone 14",
            "iPhone14,8": "iPhone 14 Plus",
            "iPhone15,2": "iPhone 14 Pro",
            "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone15,4": "iPhone 15",
            "iPhone15,5": "iPhone 15 Plus",
            "iPhone16,1": "iPhone 15 Pro",
            "iPhone16,2": "iPhone 15 Pro Max",
            
            // iPad
            "iPad1,1": "iPad",
            "iPad2,1": "iPad 2",
            "iPad2,2": "iPad 2",
            "iPad2,3": "iPad 2",
            "iPad2,4": "iPad 2",
            "iPad3,1": "iPad (3rd generation)",
            "iPad3,2": "iPad (3rd generation)",
            "iPad3,3": "iPad (3rd generation)",
            "iPad3,4": "iPad (4th generation)",
            "iPad3,5": "iPad (4th generation)",
            "iPad3,6": "iPad (4th generation)",
            "iPad4,1": "iPad Air",
            "iPad4,2": "iPad Air",
            "iPad4,3": "iPad Air",
            "iPad5,3": "iPad Air 2",
            "iPad5,4": "iPad Air 2",
            "iPad6,7": "iPad Pro (12.9-inch)",
            "iPad6,8": "iPad Pro (12.9-inch)",
            "iPad6,3": "iPad Pro (9.7-inch)",
            "iPad6,4": "iPad Pro (9.7-inch)",
            "iPad7,1": "iPad Pro (12.9-inch, 2nd generation)",
            "iPad7,2": "iPad Pro (12.9-inch, 2nd generation)",
            "iPad7,3": "iPad Pro (10.5-inch)",
            "iPad7,4": "iPad Pro (10.5-inch)",
            
            // iPod
            "iPod1,1": "iPod Touch",
            "iPod2,1": "iPod Touch (2nd generation)",
            "iPod3,1": "iPod Touch (3rd generation)",
            "iPod4,1": "iPod Touch (4th generation)",
            "iPod5,1": "iPod Touch (5th generation)",
            "iPod7,1": "iPod Touch (6th generation)",
            "iPod9,1": "iPod Touch (7th generation)",
            
            // Simulator
            "i386": "Simulator",
            "x86_64": "Simulator",
            "arm64": "Simulator"
        ]
    }
}

// MARK: - Data扩展（用于SHA256计算）

private extension Data {
    func sha256() -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(self.count), &hash)
        }
        return Data(hash)
    }
    
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

// 导入CommonCrypto（需要桥接头文件或Swift Package Manager配置）
#if canImport(CommonCrypto)
import CommonCrypto
#else
// 如果在没有CommonCrypto的环境下，提供一个简单的替代方案
private func CC_SHA256(_ data: UnsafeRawPointer?, _ len: CC_LONG, _ md: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>? {
    // 这是一个空的实现，实际项目中需要导入CommonCrypto
    return nil
}
#endif

#endif