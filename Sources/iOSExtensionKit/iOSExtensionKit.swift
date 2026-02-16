// iOSExtensionKit.swift
// iOSExtensionKit框架的主入口点

@_exported import Foundation
@_exported import SwiftUI

#if canImport(UIKit)
@_exported import UIKit
#endif

#if canImport(AppKit)
@_exported import AppKit
#endif

#if canImport(Combine)
@_exported import Combine
#endif

// 重新导出所有子模块
@_exported import iOSExtensionKit_Foundation
@_exported import iOSExtensionKit_UIKit
@_exported import iOSExtensionKit_SwiftUI
@_exported import iOSExtensionKit_CoreGraphics
@_exported import iOSExtensionKit_Combine

/// iOSExtensionKit的主要命名空间
public enum iOSExtensionKit {
    /// 框架版本
    public static let version = "1.0.0"
    
    /// 框架名称
    public static let name = "iOSExtensionKit"
    
    /// 初始化框架（可选设置）
    public static func initialize() {
        // 框架初始化（如果需要）
        print("\(name) v\(version) 已初始化")
    }
}

// 为更方便访问而重新导出常用扩展
public typealias EXK = iOSExtensionKit
