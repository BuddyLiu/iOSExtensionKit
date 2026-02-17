//
//  AppDelegate.swift
//  iOSExtensionKitDemo
//
//  示例应用程序的主应用委托
//

import UIKit
import iOSExtensionKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// 应用程序的主窗口
    var window: UIWindow?

    /// 应用程序启动完成后的回调
    ///
    /// - Parameters:
    ///   - application: 应用程序实例
    ///   - launchOptions: 启动选项字典
    /// - Returns: 如果应用程序成功处理启动，返回true
    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 初始化iOSExtensionKit框架
        iOSExtensionKit.initialize()
        print("🎯 iOSExtensionKitDemo 启动")
        
        // 检查框架兼容性
        if iOSExtensionKit.isCompatible() {
            print("✅ iOSExtensionKit 兼容当前平台")
        } else {
            print("⚠️ iOSExtensionKit 可能不完全兼容当前平台")
        }
        
        // 创建主窗口
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 设置根视图控制器
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = navigationController
        
        // 配置窗口外观
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        
        // 配置导航栏外观
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = .white
        
        return true
    }
    
    /// 应用程序即将进入前台时的回调
    ///
    /// - Parameter application: 应用程序实例
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("📱 应用程序即将进入前台")
    }
    
    /// 应用程序进入后台时的回调
    ///
    /// - Parameter application: 应用程序实例
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("📱 应用程序已进入后台")
    }
    
    /// 应用程序内存警告时的回调
    ///
    /// - Parameter application: 应用程序实例
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("⚠️ 应用程序收到内存警告")
    }
}