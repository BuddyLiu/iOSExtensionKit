# iOSExtensionKit

[![Swift Version](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**iOSExtensionKit** 是一个功能强大的 Swift + SwiftUI + UIKit 扩展库，旨在通过给系统类添加 extension 来增强代码的便捷性、安全性和运行效率，使其足以支撑大部分大型项目的功能开发。

## 特性

### 🚀 核心优势
- **多平台支持**: 支持 iOS 15+, macOS 12+, tvOS 15+, watchOS 8+
- **条件编译**: 智能的平台检测和条件编译
- **类型安全**: 所有扩展都经过严格测试，确保类型安全
- **性能优化**: 高效的实现，避免性能开销
- **中文文档**: 完整的代码注释和文档

### 📦 功能模块

#### 1. Foundation 扩展
- **String 扩展**: 字符串验证、转换、安全操作
- **Date 扩展**: 日期计算、格式化、相对时间

#### 2. UIKit 扩展
- **UIView 扩展**: 便捷的布局、样式、动画方法
- **UIViewController 扩展**: 导航、生命周期管理

#### 3. SwiftUI 扩展
- **View 扩展**: 布局、样式、动画、交互修饰符
- **环境值扩展**: 自定义环境值支持

#### 4. 工具类扩展
- **颜色扩展**: 十六进制颜色、渐变色
- **设备扩展**: 设备信息、屏幕适配
- **网络扩展**: URL请求、JSON处理

## 安装

### Swift Package Manager

在 Xcode 中添加包依赖：
```
https://github.com/your-username/iOSExtensionKit.git
```

或者直接在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/your-username/iOSExtensionKit.git", from: "1.0.0")
]
```

### CocoaPods (计划中)
```ruby
pod 'iOSExtensionKit'
```

## 快速开始

### 导入库

```swift
import iOSExtensionKit
```

### Foundation 扩展示例

```swift
// 字符串操作
let email = "user@example.com"
if email.isValidEmail {
    print("有效的邮箱地址")
}

let str = "hello world"
print(str.capitalizedFirstLetter()) // "Hello world"

// 日期操作
let now = Date()
print(now.chineseDateString) // "2024年02月13日"
print(now.relativeTimeString) // "刚刚"

let tomorrow = now.adding(days: 1)
print(tomorrow.isTomorrow) // true

// 安全转换
let numberStr = "123"
let number = numberStr.toInt() // 123
```

### UIKit 扩展示例

```swift
// 视图布局
let customView = UIView()
view.addSubview(customView)
customView.fillSuperview(edges: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

// 样式设置
customView.roundCorners(radius: 10, corners: [.topLeft, .topRight])
customView.addBorder(width: 1, color: .systemBlue)
customView.addShadow(color: .black, radius: 5, opacity: 0.2)

// 动画
customView.fadeIn(duration: 0.3)
customView.shake(intensity: 20)

// 截图
let image = customView.toImage()
```

### SwiftUI 扩展示例

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, iOSExtensionKit!")
            .frame(size: CGSize(width: 200, height: 50))
            .addRoundedBorder(Color.blue, width: 2, radius: 10)
            .gradientBackground(colors: [.blue, .purple])
            .addPadding(20)
            .onTap {
                print("视图被点击")
            }
            .embedInVStack(alignment: .center, spacing: 20)
    }
}
```

## 高级用法

### 链式调用

```swift
// UIKit 链式调用
let button = UIButton()
    .frame(size: CGSize(width: 100, height: 50))
    .roundCorners(radius: 25)
    .addBorder(width: 2, color: .systemBlue)
    .addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

// SwiftUI 链式调用
Text("提交")
    .font(.title2)
    .foregroundColor(.white)
    .addPadding(12)
    .background(Color.blue)
    .cornerRadius(8)
    .onTap {
        submitForm()
    }
```

### 条件编译

```swift
#if canImport(UIKit)
// UIKit 专用代码
let view = UIView()
view.addShadow()
#endif

#if canImport(SwiftUI)
// SwiftUI 专用代码
struct MyView: View {
    var body: some View {
        Text("SwiftUI View")
    }
}
#endif
```

## 最佳实践

### 1. 安全访问
```swift
// 安全的字符串操作
let str = "Hello"
if let char = str.safeChar(at: 10) {
    print(char)
} else {
    print("索引越界")
}

// 安全的子字符串
if let substring = str.safeSubstring(with: 0..<3) {
    print(substring) // "Hel"
}
```

### 2. 性能优化
```swift
// 批量添加子视图
view.addSubviews(label, button, imageView)

// 批量移除子视图
view.removeSubviews(ofType: UILabel.self)

// 查找特定类型的子视图
let allLabels = view.findSubviews(ofType: UILabel.self)
```

### 3. 响应式设计
```swift
// 设备适配
if UIDevice.current.isIPad {
    // iPad 特定布局
    view.frame = CGRect(x: 0, y: 0, width: 768, height: 1024)
} else {
    // iPhone 布局
    view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
}
```

## API 文档

### 命名空间
```swift
// 主命名空间
iOSExtensionKit.initialize()
print(iOSExtensionKit.version) // "1.0.0"

// 快捷别名
EXK.initialize()
```

### 扩展分类

#### String 扩展
- `isBlank` / `isNotBlank` - 检查空白字符
- `isValidEmail` - 验证邮箱格式
- `isValidChineseMobile` - 验证中国手机号
- `toInt()` / `toDouble()` - 安全类型转换
- `capitalizedFirstLetter()` - 首字母大写

#### Date 扩展
- `year` / `month` / `day` - 日期组件
- `isToday` / `isTomorrow` / `isYesterday` - 日期判断
- `adding(days:)` / `subtracting(days:)` - 日期计算
- `chineseDateString` - 中文日期格式化
- `relativeTimeString` - 相对时间描述

#### UIView 扩展
- `parentViewController` - 获取父控制器
- `addSubviews(_:)` - 批量添加子视图
- `fillSuperview()` - 填充父视图
- `roundCorners()` - 设置圆角
- `addShadow()` - 添加阴影
- `fadeIn()` / `fadeOut()` - 淡入淡出动画
- `shake()` - 震动动画

#### View 扩展 (SwiftUI)
- `frame(size:)` - 设置尺寸
- `square(_:)` - 正方形视图
- `addBorder()` - 添加边框
- `gradientBackground()` - 渐变色背景
- `withDefaultAnimation()` - 默认动画
- `onTap()` - 点击手势
- `embedInVStack()` / `embedInHStack()` - 嵌入容器

## 项目结构

```
iOSExtensionKit/
├── Sources/
│   ├── iOSExtensionKit.swift          # 主入口文件
│   ├── Foundation/
│   │   ├── String+Extension.swift     # 字符串扩展
│   │   └── Date+Extension.swift       # 日期扩展
│   ├── UIKit/
│   │   ├── UIView+Extension.swift     # UIView扩展
│   │   └── UIViewController+Extension.swift
│   ├── SwiftUI/
│   │   ├── View+Extension.swift       # View扩展
│   │   └── Color+Extension.swift      # 颜色扩展
│   └── Utilities/
│       ├── Device+Extension.swift     # 设备扩展
│       └── Color+Extension.swift      # 颜色工具
├── Tests/
│   └── iOSExtensionKitTests/
│       ├── StringExtensionTests.swift
│       └── UIViewExtensionTests.swift
├── Package.swift                      # SPM 配置文件
├── README.md                          # 项目文档
└── LICENSE                           # MIT 许可证
```

## 贡献指南

### 提交问题
如果你发现了 bug 或有功能建议，请提交 issue。

### 提交代码
1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

### 代码规范
- 使用 Swift 6.0 语法
- 遵循 Swift API 设计指南
- 所有公开 API 必须有中文注释
- 添加单元测试

## 许可证

本项目基于 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 支持

- 邮箱: your-email@example.com
- Twitter: [@your-twitter](https://twitter.com/your-twitter)
- GitHub Issues: [问题跟踪](https://github.com/your-username/iOSExtensionKit/issues)

## 致谢

感谢所有贡献者和使用者的支持！

---

⭐️ **如果这个项目对你有帮助，请给我们一个 Star！** ⭐️