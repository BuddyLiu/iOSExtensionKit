// StringExtensionTests.swift
// 测试String扩展功能

import XCTest
@testable import iOSExtensionKit

final class StringExtensionTests: XCTestCase {
    
    // MARK: - 基础测试
    
    func testIsBlank() {
        XCTAssertTrue("".isBlank)
        XCTAssertTrue("   ".isBlank)
        XCTAssertTrue("\n".isBlank)
        XCTAssertTrue("\t".isBlank)
        XCTAssertFalse("hello".isBlank)
        XCTAssertFalse("  hello  ".isBlank)
    }
    
    func testIsNotBlank() {
        XCTAssertFalse("".isNotBlank)
        XCTAssertFalse("   ".isNotBlank)
        XCTAssertFalse("\n".isNotBlank)
        XCTAssertTrue("hello".isNotBlank)
        XCTAssertTrue("  hello  ".isNotBlank)
    }
    
    func testSafeLength() {
        XCTAssertEqual("".safeLength, 0)
        XCTAssertEqual("hello".safeLength, 5)
        XCTAssertEqual("你好".safeLength, 2)
        XCTAssertEqual("  hello  ".safeLength, 9)
    }
    
    func testTrimmed() {
        XCTAssertEqual("  hello  ".trimmed, "hello")
        XCTAssertEqual("\nhello\t".trimmed, "hello")
        XCTAssertEqual("  hello\nworld\t".trimmed, "hello\nworld")
        XCTAssertEqual("".trimmed, "")
        XCTAssertEqual("   ".trimmed, "")
    }
    
    // MARK: - 验证测试
    
    func testIsValidEmail() {
        XCTAssertTrue("test@example.com".isValidEmail)
        XCTAssertTrue("user.name@domain.co.uk".isValidEmail)
        XCTAssertTrue("user+tag@domain.org".isValidEmail)
        
        XCTAssertFalse("test".isValidEmail)
        XCTAssertFalse("test@".isValidEmail)
        XCTAssertFalse("@example.com".isValidEmail)
        XCTAssertFalse("test@.com".isValidEmail)
        XCTAssertFalse("test@domain.".isValidEmail)
    }
    
    func testIsValidChineseMobile() {
        XCTAssertTrue("13800138000".isValidChineseMobile)
        XCTAssertTrue("13912345678".isValidChineseMobile)
        XCTAssertTrue("15012345678".isValidChineseMobile)
        XCTAssertTrue("18812345678".isValidChineseMobile)
        
        XCTAssertFalse("1234567890".isValidChineseMobile) // 位数不够
        XCTAssertFalse("1380013800".isValidChineseMobile) // 位数不够
        XCTAssertFalse("23800138000".isValidChineseMobile) // 错误开头
        XCTAssertFalse("1380013800a".isValidChineseMobile) // 包含字母
        XCTAssertFalse("13800138000 ".isValidChineseMobile) // 包含空格
    }
    
    func testIsValidChineseID() {
        // 注意：这只是简单的正则验证，实际身份证验证需要校验码
        XCTAssertTrue("11010119900307667X".isValidChineseID)
        XCTAssertTrue("11010119900307667x".isValidChineseID) // 小写x
        XCTAssertFalse("123456789012345678".isValidChineseID) // 无效格式
        XCTAssertFalse("".isValidChineseID)
        XCTAssertFalse("abc".isValidChineseID)
    }
    
    // MARK: - 转换测试
    
    func testToInt() {
        XCTAssertEqual("123".toInt(), 123)
        XCTAssertEqual("0".toInt(), 0)
        XCTAssertEqual("-456".toInt(), -456)
        XCTAssertEqual("abc".toInt(), 0) // 默认值
        XCTAssertEqual("12.3".toInt(), 0) // 默认值
        XCTAssertEqual("".toInt(), 0) // 默认值
        
        // 使用自定义默认值
        XCTAssertEqual("abc".toInt(defaultValue: -1), -1)
        XCTAssertEqual("".toInt(defaultValue: 999), 999)
    }
    
    func testToDouble() {
        XCTAssertEqual("123.45".toDouble(), 123.45, accuracy: 0.001)
        XCTAssertEqual("0".toDouble(), 0, accuracy: 0.001)
        XCTAssertEqual("-78.9".toDouble(), -78.9, accuracy: 0.001)
        XCTAssertEqual("abc".toDouble(), 0.0, accuracy: 0.001) // 默认值
        XCTAssertEqual("".toDouble(), 0.0, accuracy: 0.001) // 默认值
        
        // 使用自定义默认值
        XCTAssertEqual("abc".toDouble(defaultValue: -1.5), -1.5, accuracy: 0.001)
    }
    
    func testToBool() {
        XCTAssertTrue("true".toBool())
        XCTAssertTrue("TRUE".toBool())
        XCTAssertTrue("1".toBool())
        XCTAssertTrue("yes".toBool())
        XCTAssertTrue("YES".toBool())
        XCTAssertTrue("y".toBool())
        XCTAssertTrue("Y".toBool())
        
        XCTAssertFalse("false".toBool())
        XCTAssertFalse("0".toBool())
        XCTAssertFalse("no".toBool())
        XCTAssertFalse("abc".toBool())
        XCTAssertFalse("".toBool())
        XCTAssertFalse(" ".toBool())
    }
    
    func testToURL() {
        XCTAssertNotNil("https://www.example.com".toURL)
        XCTAssertNotNil("http://example.com/path".toURL)
        XCTAssertNotNil("ftp://files.example.com".toURL)
        XCTAssertNil("".toURL)
        
        // URL(string:) 会将空格编码为 %20，所以会成功创建URL
        // 我们只需要测试它不会崩溃
        _ = "not a url".toURL
    }
    
    func testToSafeURL() {
        XCTAssertNotNil("https://www.example.com".toSafeURL)
        XCTAssertNotNil("http://example.com".toSafeURL)
        // 自动添加https://
        let url1 = "www.example.com".toSafeURL
        XCTAssertNotNil(url1)
        XCTAssertTrue(url1?.absoluteString.hasPrefix("https://") == true)
        
        let url2 = "example.com".toSafeURL
        XCTAssertNotNil(url2)
        XCTAssertTrue(url2?.absoluteString.hasPrefix("https://") == true)
        
        XCTAssertNil("".toSafeURL)
    }
    
    // MARK: - 安全操作测试
    
    func testSafeChar() {
        let str = "Hello"
        
        XCTAssertEqual(str.safeChar(at: 0), "H")
        XCTAssertEqual(str.safeChar(at: 4), "o")
        XCTAssertNil(str.safeChar(at: -1))
        XCTAssertNil(str.safeChar(at: 5))
        XCTAssertNil(str.safeChar(at: 10))
        
        XCTAssertNil("".safeChar(at: 0))
    }
    
    func testSafeSubstring() {
        let str = "Hello, World!"
        
        XCTAssertEqual(str.safeSubstring(from: 0, to: 5), "Hello")
        XCTAssertEqual(str.safeSubstring(from: 7, to: 12), "World")
        XCTAssertNil(str.safeSubstring(from: -1, to: 5))
        XCTAssertNil(str.safeSubstring(from: 0, to: 20))
        XCTAssertNil(str.safeSubstring(from: 10, to: 5)) // 开始>结束
        
        XCTAssertNil("".safeSubstring(from: 0, to: 1))
        
        // 边缘情况：相等范围应该返回空字符串
        XCTAssertEqual(str.safeSubstring(from: 0, to: 0), "")
        XCTAssertEqual(str.safeSubstring(from: 5, to: 5), "")
    }
    
    func testSafePrefix() {
        XCTAssertEqual("Hello".safePrefix(3), "Hel")
        XCTAssertEqual("Hello".safePrefix(5), "Hello")
        XCTAssertEqual("Hello".safePrefix(10), "Hello") // 长度超过字符串长度
        XCTAssertEqual("Hello".safePrefix(0), "Hello") // 长度<=0
        XCTAssertEqual("Hello".safePrefix(-1), "Hello") // 长度<=0
        XCTAssertEqual("".safePrefix(3), "")
    }
    
    func testSafeSuffix() {
        XCTAssertEqual("Hello".safeSuffix(3), "llo")
        XCTAssertEqual("Hello".safeSuffix(5), "Hello")
        XCTAssertEqual("Hello".safeSuffix(10), "Hello") // 长度超过字符串长度
        XCTAssertEqual("Hello".safeSuffix(0), "Hello") // 长度<=0
        XCTAssertEqual("Hello".safeSuffix(-1), "Hello") // 长度<=0
        XCTAssertEqual("".safeSuffix(3), "")
    }
    
    // MARK: - 工具方法测试
    
    func testCapitalizedFirstLetter() {
        XCTAssertEqual("hello".capitalizedFirstLetter(), "Hello")
        XCTAssertEqual("Hello".capitalizedFirstLetter(), "Hello")
        XCTAssertEqual("HELLO".capitalizedFirstLetter(), "HELLO")
        XCTAssertEqual("".capitalizedFirstLetter(), "")
        XCTAssertEqual("h".capitalizedFirstLetter(), "H")
        XCTAssertEqual(" hello".capitalizedFirstLetter(), " hello") // 注意：不trim空格
    }
    
    func testHasCaseInsensitivePrefix() {
        XCTAssertTrue("Hello World".hasCaseInsensitivePrefix("hello"))
        XCTAssertTrue("HELLO World".hasCaseInsensitivePrefix("hello"))
        XCTAssertTrue("hello World".hasCaseInsensitivePrefix("HELLO"))
        XCTAssertFalse("Hello World".hasCaseInsensitivePrefix("world"))
        XCTAssertFalse("".hasCaseInsensitivePrefix("hello"))
        XCTAssertTrue("Hello".hasCaseInsensitivePrefix(""))
    }
    
    func testHasCaseInsensitiveSuffix() {
        XCTAssertTrue("Hello World".hasCaseInsensitiveSuffix("world"))
        XCTAssertTrue("Hello WORLD".hasCaseInsensitiveSuffix("world"))
        XCTAssertTrue("Hello world".hasCaseInsensitiveSuffix("WORLD"))
        XCTAssertFalse("Hello World".hasCaseInsensitiveSuffix("hello"))
        XCTAssertFalse("".hasCaseInsensitiveSuffix("world"))
        XCTAssertTrue("World".hasCaseInsensitiveSuffix(""))
    }
    
    // MARK: - 边界条件测试
    
    func testEmptyStringOperations() {
        let empty = ""
        
        XCTAssertTrue(empty.isBlank)
        XCTAssertFalse(empty.isNotBlank)
        XCTAssertEqual(empty.safeLength, 0)
        XCTAssertEqual(empty.trimmed, "")
        XCTAssertFalse(empty.isValidEmail)
        XCTAssertFalse(empty.isValidChineseMobile)
        XCTAssertFalse(empty.isValidChineseID)
        XCTAssertEqual(empty.toInt(), 0)
        XCTAssertEqual(empty.toDouble(), 0.0)
        XCTAssertFalse(empty.toBool())
        XCTAssertNil(empty.toURL)
        XCTAssertNil(empty.toSafeURL)
        XCTAssertNil(empty.safeChar(at: 0))
        XCTAssertNil(empty.safeSubstring(from: 0, to: 1))
        XCTAssertEqual(empty.safePrefix(3), "")
        XCTAssertEqual(empty.safeSuffix(3), "")
        XCTAssertEqual(empty.capitalizedFirstLetter(), "")
        XCTAssertFalse(empty.hasCaseInsensitivePrefix("test"))
        XCTAssertFalse(empty.hasCaseInsensitiveSuffix("test"))
    }
    
    func testWhitespaceStringOperations() {
        let whitespace = "   \n\t  "
        
        XCTAssertTrue(whitespace.isBlank)
        XCTAssertFalse(whitespace.isNotBlank)
        XCTAssertEqual(whitespace.safeLength, 7) // 3空格 + 1换行 + 1制表符 + 2空格 = 7
        XCTAssertEqual(whitespace.trimmed, "")
        XCTAssertFalse(whitespace.isValidEmail)
        XCTAssertFalse(whitespace.isValidChineseMobile)
        XCTAssertFalse(whitespace.isValidChineseID)
        XCTAssertEqual(whitespace.toInt(), 0)
        XCTAssertEqual(whitespace.toDouble(), 0.0)
        XCTAssertFalse(whitespace.toBool())
        // toURL可能会成功，因为URL(string:)会编码空格，我们只需要确保它不会崩溃
        _ = whitespace.toURL
        XCTAssertNil(whitespace.toSafeURL)
        XCTAssertEqual(whitespace.capitalizedFirstLetter(), "   \n\t  ") // 注意：不trim空格
        XCTAssertTrue(whitespace.hasCaseInsensitivePrefix("   \n"))
        XCTAssertTrue(whitespace.hasCaseInsensitiveSuffix("\t  "))
    }
}
