// FoundationExamples.swift
// Foundation扩展示例代码

import Foundation
import iOSExtensionKit_Foundation

// MARK: - 字符串扩展示例
struct StringExamples {
    
    static func demonstrate() {
        print("🔤 字符串扩展示例")
        print("================\n")
        
        // 1. 字符串验证
        let email = "user@example.com"
        print("1. 邮箱验证:")
        print("   '\(email)' 是有效的邮箱吗？ \(email.isValidEmail)")
        print("   '\(email)' 包含中文吗？ \(email.containsChinese)")
        
        let phone = "13812345678"
        print("   '\(phone)' 是中国手机号吗？ \(phone.isValidChineseMobile)")
        print("   隐藏手机号中间四位: \(phone.maskedPhoneNumber)")
        
        // 2. 字符串转换
        let str = "hello world"
        print("\n2. 字符串转换:")
        print("   首字母大写: '\(str.capitalizedFirstLetter())'")
        print("   单词首字母大写: '\(str.capitalizedEachWord())'")
        print("   驼峰命名法: '\(str.toCamelCase())'")
        print("   蛇形命名法: '\(str.toSnakeCase())'")
        print("   安全子字符串(0..<5): '\(str.safeSubstring(with: 0..<5) ?? "索引越界")'")
        
        // 3. 字符串安全操作
        let emptyStr = ""
        print("\n3. 字符串安全操作:")
        print("   空字符串检测: \(emptyStr.isBlank)")
        print("   非空字符串检测: \(emptyStr.isNotBlank)")
        print("   字符串长度: \(str.count)")
        print("   去除空白字符: ' hello  '.trimmed")
        
        // 4. URL字符串处理
        let urlStr = "https://example.com/path?query=测试"
        print("\n4. URL字符串处理:")
        print("   URL编码: '\(urlStr.urlEncoded ?? "编码失败")'")
        print("   URL解码: '\(urlStr.urlEncoded?.urlDecoded ?? "解码失败")'")
        
        // 5. 字符串加密
        let secret = "mySecretPassword"
        print("\n5. 字符串加密:")
        print("   MD5哈希: \(secret.md5 ?? "计算失败")")
        print("   SHA256哈希: \(secret.sha256 ?? "计算失败")")
        print("   安全比较(防止时序攻击): \(secureCompare("secret", "secret"))")
        
        print("\n✅ 字符串示例完成\n")
    }
}

// MARK: - 日期扩展示例
struct DateExamples {
    
    static func demonstrate() {
        print("📅 日期扩展示例")
        print("================\n")
        
        let now = Date()
        
        // 1. 日期格式化
        print("1. 日期格式化:")
        print("   当前时间: \(now.description)")
        print("   中文日期: \(now.chineseDateString)")
        print("   简短日期: \(now.shortDateString)")
        print("   自定义格式(yyyy-MM-dd HH:mm:ss): \(now.string(format: "yyyy-MM-dd HH:mm:ss"))")
        
        // 2. 日期计算
        let yesterday = now.subtracting(days: 1)
        let tomorrow = now.adding(days: 1)
        
        print("\n2. 日期计算:")
        print("   昨天: \(yesterday.shortDateString)")
        print("   明天: \(tomorrow.shortDateString)")
        print("   下周: \(now.adding(days: 7).shortDateString)")
        print("   上个月: \(now.subtracting(months: 1).shortDateString)")
        
        // 3. 日期判断
        print("\n3. 日期判断:")
        print("   今天是今天吗？ \(now.isToday)")
        print("   昨天是昨天吗？ \(yesterday.isYesterday)")
        print("   明天是明天吗？ \(tomorrow.isTomorrow)")
        print("   是工作日吗？ \(now.isWeekday)")
        print("   是周末吗？ \(now.isWeekend)")
        
        // 4. 相对时间
        let fiveMinutesAgo = now.subtracting(minutes: 5)
        let twoHoursAgo = now.subtracting(hours: 2)
        let threeDaysAgo = now.subtracting(days: 3)
        
        print("\n4. 相对时间:")
        print("   5分钟前: \(fiveMinutesAgo.relativeTimeString)")
        print("   2小时前: \(twoHoursAgo.relativeTimeString)")
        print("   3天前: \(threeDaysAgo.relativeTimeString)")
        print("   简短格式(5分钟前): \(fiveMinutesAgo.shortRelativeTimeString)")
        
        // 5. 日期组件
        print("\n5. 日期组件:")
        print("   年: \(now.year)")
        print("   月: \(now.month)")
        print("   日: \(now.day)")
        print("   小时: \(now.hour)")
        print("   分钟: \(now.minute)")
        print("   星期几: \(now.weekdayString)")
        
        print("\n✅ 日期示例完成\n")
    }
}

// MARK: - 数组和字典扩展示例
struct CollectionExamples {
    
    static func demonstrate() {
        print("📚 集合扩展示例")
        print("================\n")
        
        // 1. 数组操作
        var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        print("1. 数组操作:")
        print("   原始数组: \(numbers)")
        print("   安全访问第3个元素: \(numbers[safe: 2] ?? "索引越界")")
        print("   安全访问第15个元素: \(numbers[safe: 14] ?? "索引越界")")
        print("   移除重复元素: \([1, 2, 2, 3, 3, 3].removingDuplicates())")
        print("   分页(每页3个): \(numbers.chunked(into: 3))")
        print("   打乱顺序: \(numbers.shuffled())")
        
        // 2. 字典操作
        var userInfo: [String: Any] = [
            "name": "张三",
            "age": 25,
            "email": "zhangsan@example.com",
            "city": "北京"
        ]
        
        print("\n2. 字典操作:")
        print("   原始字典: \(userInfo)")
        print("   安全获取不存在的键: \(userInfo.safeValue(forKey: "address") ?? "键不存在")")
        print("   安全获取存在的键: \(userInfo.safeValue(forKey: "name") ?? "键不存在")")
        
        let additionalInfo = ["country": "中国", "language": "中文"]
        userInfo.mergeSafely(additionalInfo)
        print("   安全合并字典后: \(userInfo)")
        
        // 3. 集合操作
        let set1: Set<Int> = [1, 2, 3, 4, 5]
        let set2: Set<Int> = [4, 5, 6, 7, 8]
        
        print("\n3. 集合操作:")
        print("   集合1: \(set1)")
        print("   集合2: \(set2)")
        print("   交集: \(set1.intersection(set2))")
        print("   并集: \(set1.union(set2))")
        print("   差集: \(set1.subtracting(set2))")
        print("   对称差集: \(set1.symmetricDifference(set2))")
        print("   集合1包含所有[1,2]吗？ \(set1.contains(all: [1, 2]))")
        print("   集合1包含任意[6,7]吗？ \(set1.contains(any: [6, 7]))")
        
        print("\n✅ 集合示例完成\n")
    }
}

// MARK: - 数字和可选值扩展示例
struct ValueExamples {
    
    static func demonstrate() {
        print("🔢 数字和可选值扩展示例")
        print("======================\n")
        
        // 1. 数字格式化
        let price = 1234.56
        let count = 1000
        
        print("1. 数字格式化:")
        print("   价格格式化: \(price.formattedPrice)")
        print("   百分比格式化(0.75): \(0.75.formattedPercent)")
        print("   文件大小格式化(1024*1024): \(Int64(1024*1024).formattedFileSize)")
        
        // 2. 可选值操作
        var optionalString: String? = "Hello"
        var nilString: String? = nil
        
        print("\n2. 可选值操作:")
        print("   可选字符串: \(optionalString.unwrap(or: "默认值"))")
        print("   空字符串解包: \(nilString.unwrap(or: "默认值"))")
        print("   可选值存在时执行: \(optionalString.ifLet { "值存在: \($0)" } ?? "值不存在")")
        print("   可选值转换: \(optionalString.map { $0.uppercased() } ?? "nil")")
        
        // 3. Bool值操作
        let isEnabled = true
        let isDisabled = false
        
        print("\n3. Bool值操作:")
        print("   isEnabled的相反值: \(isEnabled.toggled)")
        print("   isDisabled的相反值: \(isDisabled.toggled)")
        print("   所有条件都为真: \([true, true, true].allTrue)")
        print("   任意条件为真: \([false, false, true].anyTrue)")
        
        // 4. 数据加密
        let sensitiveData = Data("Sensitive Information".utf8)
        
        print("\n4. 数据安全:")
        print("   原始数据: \(String(data: sensitiveData, encoding: .utf8) ?? "转换失败")")
        print("   Base64编码: \(sensitiveData.base64EncodedString())")
        print("   MD5哈希: \(sensitiveData.md5)")
        
        print("\n✅ 数字和可选值示例完成\n")
    }
}

// MARK: - 主函数
func runFoundationExamples() {
    print("🚀 iOSExtensionKit - Foundation扩展示例")
    print("=====================================\n")
    
    StringExamples.demonstrate()
    DateExamples.demonstrate()
    CollectionExamples.demonstrate()
    ValueExamples.demonstrate()
    
    print("🎉 所有Foundation扩展示例完成！")
}

// 运行示例（在合适的环境下调用）
// runFoundationExamples()