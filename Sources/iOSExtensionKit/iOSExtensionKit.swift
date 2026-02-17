// iOSExtensionKit.swift
// iOSExtensionKit框架的主入口点
//
// 提供统一的命名空间和便捷的API访问方式。

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(Combine)
import Combine
#endif

// 重新导出所有子模块
@_exported import iOSExtensionKit_Foundation
@_exported import iOSExtensionKit_UIKit
@_exported import iOSExtensionKit_SwiftUI
@_exported import iOSExtensionKit_CoreGraphics
@_exported import iOSExtensionKit_Combine
@_exported import iOSExtensionKit_Utilities
@_exported import iOSExtensionKit_Security

/// iOSExtensionKit 是一个功能强大的 Swift + SwiftUI + UIKit 扩展库。
///
/// 通过给系统类添加 extension 来增强代码的便捷性、安全性和运行效率，使其足以支撑大部分大型项目的功能开发。
///
/// 主要特性：
/// - 多平台支持：iOS 15+, macOS 12+, tvOS 15+, watchOS 8+
/// - 类型安全：所有扩展都经过严格测试，确保类型安全
/// - 性能优化：高效的实现，避免性能开销
/// - 并发安全：支持 Swift 6 并发模型，避免数据竞争
/// - 中文文档：完整的代码注释和文档
///
/// 使用示例：
/// ```
/// import iOSExtensionKit
///
/// let email = "user@example.com"
/// if email.isValidEmail {
///     print("有效的邮箱地址")
/// }
/// ```
public enum iOSExtensionKit {
    
    /// 框架版本号
    ///
    /// 遵循语义化版本规范：主版本.次版本.修订版本
    public static let version = "1.0.0"
    
    /// 框架名称
    public static let name = "iOSExtensionKit"
    
    /// 框架开发者
    public static let author = "BuddyLiu"
    
    /// 框架主页URL
    public static let homepageURL = "https://github.com/BuddyLiu/iOSExtensionKit"
    
    /// 初始化框架（可选设置）
    ///
    /// 在应用启动时调用此方法可以初始化框架的配置。
    ///
    /// - Note: 此方法目前只输出初始化信息，未来可能会添加配置选项。
    public static func initialize() {
        // 框架初始化（如果需要）
        print("🎉 \(name) v\(version) 已初始化")
        print("📚 文档：\(homepageURL)")
    }
    
    /// 检查框架兼容性
    ///
    /// 验证当前平台是否支持框架的所有特性。
    ///
    /// - Returns: 如果框架在当前平台上完全兼容，则返回 `true`
    public static func isCompatible() -> Bool {
        #if os(iOS)
        return true
        #elseif os(macOS)
        return true
        #elseif os(tvOS)
        return true
        #elseif os(watchOS)
        return true
        #else
        return false
        #endif
    }
}

/// 为更方便访问而创建的快捷别名
///
/// 使用 `EXK` 作为 `iOSExtensionKit` 的简短别名。
///
/// 示例：
/// ```
/// EXK.initialize()
/// print(EXK.version)
/// ```
public typealias EXK = iOSExtensionKit
