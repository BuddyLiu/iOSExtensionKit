//
//  AppDelegate.swift
//  macOSExtensionKitDemo
//
//  macOS示例应用程序的主应用委托
//

import Cocoa
import iOSExtensionKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    /// 应用程序的主窗口
    var window: NSWindow!

    /// 应用程序启动完成后的回调
    ///
    /// - Parameter notification: 通知对象
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 初始化iOSExtensionKit框架
        iOSExtensionKit.initialize()
        print("🎯 macOSExtensionKitDemo 启动")
        
        // 检查框架兼容性
        if iOSExtensionKit.isCompatible() {
            print("✅ iOSExtensionKit 兼容 macOS 平台")
        } else {
            print("⚠️ iOSExtensionKit 可能不完全兼容 macOS 平台")
        }
        
        // 创建主窗口
        createMainWindow()
        
        // 配置窗口外观
        configureWindowAppearance()
    }
    
    /// 创建主窗口
    private func createMainWindow() {
        // 计算窗口尺寸
        let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
        let windowSize = CGSize(width: min(1000, screenSize.width * 0.8), 
                                height: min(800, screenSize.height * 0.8))
        
        // 创建窗口
        window = NSWindow(
            contentRect: NSRect(origin: .zero, size: windowSize),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // 设置窗口属性
        window.title = "iOSExtensionKit macOS Demo"
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        // 设置内容视图控制器
        let mainViewController = MainViewController()
        window.contentViewController = mainViewController
    }
    
    /// 配置窗口外观
    private func configureWindowAppearance() {
        // 配置窗口工具栏
        window.toolbar = NSToolbar(identifier: "MainToolbar")
        window.toolbar?.displayMode = .iconOnly
        window.toolbar?.showsBaselineSeparator = true
        
        // 配置窗口背景色
        window.backgroundColor = NSColor.windowBackgroundColor
        
        // 配置窗口标题
        window.titlebarAppearsTransparent = false
        window.titleVisibility = .visible
    }
    
    /// 应用程序即将终止时的回调
    ///
    /// - Parameter notification: 通知对象
    func applicationWillTerminate(_ notification: Notification) {
        print("📱 应用程序即将终止")
    }
    
    /// 应用程序变为活动状态时的回调
    ///
    /// - Parameter notification: 通知对象
    func applicationDidBecomeActive(_ notification: Notification) {
        print("📱 应用程序变为活动状态")
    }
    
    /// 应用程序变为非活动状态时的回调
    ///
    /// - Parameter notification: 通知对象
    func applicationDidResignActive(_ notification: Notification) {
        print("📱 应用程序变为非活动状态")
    }
    
    /// 应用程序是否应该终止
    ///
    /// - Parameter sender: 应用程序实例
    /// - Returns: 如果应用程序应该终止，返回true
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        print("⚠️ 应用程序收到终止请求")
        return .terminateNow
    }
    
    /// 应用程序是否应该打开指定文件
    ///
    /// - Parameters:
    ///   - sender: 应用程序实例
    ///   - filename: 文件名
    /// - Returns: 如果应用程序可以打开文件，返回true
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        print("📄 应用程序尝试打开文件: \(filename)")
        return false
    }
}