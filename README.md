# iOSExtensionKit

[![Swift Version](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**iOSExtensionKit** 是一个功能强大的 Swift + SwiftUI + UIKit 扩展库，旨在通过给系统类添加 extension 来增强代码的便捷性、安全性和运行效率，使其足以支撑大部分大型项目的功能开发。由BuddyLiu维护，致力于为iOS/macOS开发者提供高质量的扩展工具。

## 特性

### 🚀 核心优势
- **多平台支持**: 支持 iOS 15+, macOS 12+, tvOS 15+, watchOS 8+
- **条件编译**: 智能的平台检测和条件编译
- **类型安全**: 所有扩展都经过严格测试，确保类型安全
- **性能优化**: 高效的实现，避免性能开销
- **并发安全**: 支持 Swift 6 并发模型，避免数据竞争
- **中文文档**: 完整的代码注释和文档

### 📦 功能模块

#### 1. Foundation 扩展
- **String 扩展**: 字符串验证、转换、安全操作、字符处理
- **Date 扩展**: 日期计算、格式化、相对时间、时区处理
- **Array 扩展**: 集合操作、安全访问、过滤映射
- **Dictionary 扩展**: 字典合并、安全取值、键值操作
- **Set 扩展**: 集合操作、安全交集并集差集、元素统计
- **Int/Double/Float 扩展**: 数值格式化、转换、数学计算
- **Bool 扩展**: 布尔值操作、逻辑运算
- **URL 扩展**: URL构建、参数处理、安全访问
- **Data 扩展**: 数据转换、加密、压缩、编码
- **Optional 扩展**: 安全解包、链式操作、错误处理、空值检查

#### 2. UIKit 扩展
- **UIView 扩展**: 便捷的布局、样式、动画方法
- **UIViewController 扩展**: 导航、生命周期管理
- **UIColor 扩展**: 十六进制颜色、渐变色、颜色混合

#### 3. SwiftUI 扩展
- **View 扩展**: 布局、样式、动画、交互修饰符
- **环境值扩展**: 自定义环境值支持

#### 4. Combine 扩展
- **Publisher 扩展**: 便捷操作符、错误处理、调试工具
- **Subject 扩展**: 值更新、绑定操作
- **Cancellable 扩展**: 存储管理、生命周期控制

#### 5. CoreGraphics 扩展
- **CGPoint 扩展**: 点向量运算、距离计算、几何关系
- **CGSize 扩展**: 尺寸计算、比例缩放、边距处理
- **CGRect 扩展**: 几何计算、布局辅助

#### 6. 安全扩展 
- **字符串安全**: 数据加密、哈希计算、输入验证、敏感信息隐藏
- **数据安全**: AES加密、Base64编码、安全随机数生成
- **密钥链管理**: 安全的本地数据存储
- **安全配置检查**: 越狱检测、调试检测、SSL验证检查
- **安全工具**: 时序攻击防护、安全比较、安全延迟

#### 7. 调试和日志工具 
- **日志管理器**: 多级别日志记录（详细/调试/信息/警告/错误/严重）
- **结构化日志**: 支持OSLog结构化日志
- **日志文件输出**: 支持日志文件存储和导出
- **调试辅助工具**: 安全断言、性能测量、错误处理
- **调试信息收集**: 系统信息收集、内存监控、性能监控
- **调试宏**: 仅在调试模式下有效的便捷宏

#### 8. 国际化/本地化扩展 
- **本地化字符串**: 便捷的本地化字符串访问和格式化
- **语言管理器**: 动态语言切换、RTL支持
- **本地化格式化**: 日期、数字、货币、文件大小的本地化显示
- **本地化调试**: 本地化键使用情况跟踪和报告
- **安全本地化**: 防止本地化缺失导致的应用崩溃

#### 9. 工具类扩展
- **设备扩展**: 设备信息、屏幕适配
- **网络扩展**: URL请求、JSON处理
- **性能计时器**: 代码性能分析
- **文件管理**: 文件操作扩展
- **性能优化器**: 缓存管理、内存优化、性能监控

## 安装

### Swift Package Manager

在 Xcode 中添加包依赖：
```
https://github.com/BuddyLiu/iOSExtensionKit.git
```

或者直接在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/BuddyLiu/iOSExtensionKit.git", from: "1.0.0")
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

#### Set 扩展
- `intersection(safe:)` / `union(safe:)` - 安全的集合操作
- `subtracting(safe:)` / `symmetricDifference(safe:)` - 安全的集合差集和对称差集
- `contains(all:)` / `contains(any:)` - 检查包含所有或任意元素
- `filterSet()` / `mapSet()` / `compactMapSet()` - 集合过滤映射
- `disjoint()` / `subset()` / `superset()` - 集合关系检查
- `strictSubset()` / `strictSuperset()` - 真子集/真超集检查
- `toArray` / `toSortedArray()` - 转换为数组
- `grouped(by:)` / `toDictionary()` - 集合分组和字典转换
- `partitioned(by:)` - 集合分区
- `count(where:)` / `proportion(where:)` / `percentage(where:)` - 元素统计
- `sum` / `product` / `average()` - 数值计算（数值元素）
- `minElement` / `maxElement` / `minAndMax` - 最小/最大元素（可比较元素）

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
│   ├── Foundation/                    # Foundation扩展
│   │   ├── String+Extension.swift     # 字符串扩展
│   │   ├── Date+Extension.swift       # 日期扩展
│   │   ├── Array+Extension.swift      # 数组扩展
│   │   ├── Dictionary+Extension.swift # 字典扩展
│   │   ├── Set+Extension.swift        # 集合扩展
│   │   ├── Int+Extension.swift        # 整数扩展
│   │   ├── Double+Extension.swift     # 双精度扩展
│   │   ├── Float+Extension.swift      # 浮点数扩展
│   │   ├── Bool+Extension.swift       # 布尔值扩展
│   │   ├── URL+Extension.swift        # URL扩展
│   │   ├── Data+Extension.swift       # 数据扩展
│   │   ├── Optional+Extension.swift   # 可选值扩展
│   │   ├── PerformanceTimer.swift     # 性能计时器
│   │   ├── FileManager+Extension.swift # 文件管理扩展
│   │   ├── UserDefaults+Extension.swift # 用户偏好扩展
│   │   ├── NotificationCenter+Extension.swift # 通知中心扩展
│   │   └── DispatchQueue+Extension.swift # 队列扩展
│   ├── UIKit/                         # UIKit扩展
│   │   ├── UIView+Extension.swift     # UIView扩展
│   │   ├── UIViewController+Extension.swift # 视图控制器扩展
│   │   ├── UIColor+Extension.swift    # 颜色扩展
│   │   ├── UILabel+Extension.swift    # 标签扩展
│   │   └── UIDevice+Extension.swift   # 设备信息扩展
│   ├── SwiftUI/                       # SwiftUI扩展
│   │   ├── View+Extension.swift       # View扩展
│   │   └── Text+Extension.swift       # Text扩展
│   ├── CoreGraphics/                  # CoreGraphics扩展
│   │   ├── CGPoint+Extension.swift    # 点扩展
│   │   ├── CGSize+Extension.swift     # 尺寸扩展
│   │   └── CGRect+Extension.swift     # 矩形扩展
│   ├── Combine/                       # Combine扩展
│   │   └── Publisher+Extension.swift  # 发布者扩展
│   ├── Security/                      # 安全扩展
│   │   └── Security+Extension.swift   # 安全工具扩展
│   ├── Utilities/                     # 工具类扩展
│   │   ├── Debug+Extension.swift      # 调试和日志工具
│   │   ├── Localization+Extension.swift # 国际化/本地化扩展
│   │   └── PerformanceOptimizer.swift # 性能优化器
│   ├── Network/                       # 网络扩展
│   │   └── URLSession+Extension.swift # URL会话扩展
│   └── Animation/                     # 动画扩展
│       └── UIView+Animation.swift     # UIView动画扩展
├── Tests/
│   └── iOSExtensionKitTests/
│       ├── StringExtensionTests.swift
│       ├── DoubleFloatExtensionTests.swift
│       ├── UserDefaultsExtensionTests.swift
│       ├── SetExtensionTests.swift
│       ├── PerformanceTests.swift
│       └── DispatchQueueExtensionTests.swift
├── Examples/                          # 示例代码
│   ├── Foundation/                    # Foundation示例
│   │   └── FoundationExamples.swift   # Foundation扩展示例
│   ├── UIKit/                         # UIKit示例
│   └── SwiftUI/                       # SwiftUI示例
├── Resources/                         # 资源文件
├── benchmarks.md                      # 性能基准测试
├── Package.swift                      # SPM配置文件
├── README.md                          # 项目文档
└── LICENSE                           # MIT许可证
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