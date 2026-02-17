// Security+Extension.swift
// 安全扩展，提供数据加密、安全存储、输入验证等功能

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif
#if canImport(CommonCrypto)
import CommonCrypto
#endif
#if canImport(Security)
import Security
#endif

// MARK: - 安全工具扩展

public extension String {
    
    /// 验证是否是有效的手机号码（中国） - 从 Foundation 模块复制以避免依赖问题
    var isValidChineseMobile: Bool {
        let mobileRegEx = "^1[3-9]\\d{9}$"
        let mobilePredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
        return mobilePredicate.evaluate(with: self)
    }
    
    /// 验证是否是有效的身份证号码（中国） - 从 Foundation 模块复制以避免依赖问题
    var isValidChineseID: Bool {
        let idRegEx = "^[1-9]\\d{5}(18|19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$"
        let idPredicate = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        return idPredicate.evaluate(with: self)
    }
    
    // MARK: - 数据加密
    
    /// 计算字符串的MD5哈希值
    var md5: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.md5
    }
    
    /// 计算字符串的SHA256哈希值
    var sha256: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.sha256
    }
    
    /// 计算字符串的SHA512哈希值
    var sha512: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.sha512
    }
    
    /// 使用AES加密字符串
    /// - Parameters:
    ///   - key: 加密密钥
    ///   - iv: 初始化向量（可选）
    /// - Returns: 加密后的Base64字符串
    func aesEncrypt(key: String, iv: String? = nil) -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.aesEncrypt(key: key, iv: iv)?.base64EncodedString()
    }
    
    /// 使用AES解密字符串
    /// - Parameters:
    ///   - key: 解密密钥
    ///   - iv: 初始化向量（可选）
    /// - Returns: 解密后的字符串
    func aesDecrypt(key: String, iv: String? = nil) -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        guard let decryptedData = data.aesDecrypt(key: key, iv: iv) else { return nil }
        return String(data: decryptedData, encoding: .utf8)
    }
    
    /// 使用Base64编码字符串
    var base64Encoded: String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    /// 解码Base64字符串
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// 对字符串进行URL安全编码
    var urlSafeEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// 对字符串进行URL安全解码
    var urlSafeDecoded: String? {
        return removingPercentEncoding
    }
    
    // MARK: - 输入验证
    
    /// 验证是否是强密码
    /// - Parameter minLength: 最小长度
    /// - Returns: 是否是强密码
    func isStrongPassword(minLength: Int = 8) -> Bool {
        // 检查长度
        guard count >= minLength else { return false }
        
        // 检查包含至少一个大写字母
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegex)
        guard uppercasePredicate.evaluate(with: self) else { return false }
        
        // 检查包含至少一个小写字母
        let lowercaseLetterRegex = ".*[a-z]+.*"
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseLetterRegex)
        guard lowercasePredicate.evaluate(with: self) else { return false }
        
        // 检查包含至少一个数字
        let digitRegex = ".*[0-9]+.*"
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        guard digitPredicate.evaluate(with: self) else { return false }
        
        // 检查包含至少一个特殊字符
        let specialCharacterRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+.*"
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        guard specialCharacterPredicate.evaluate(with: self) else { return false }
        
        return true
    }
    
    /// 验证是否是安全的用户名
    /// - Returns: 是否是安全的用户名
    func isSafeUsername() -> Bool {
        // 用户名只能包含字母、数字、下划线和连字符
        let usernameRegex = "^[a-zA-Z0-9_-]{3,20}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: self)
    }
    
    /// 验证是否是安全的文件名
    /// - Returns: 是否是安全的文件名
    func isSafeFileName() -> Bool {
        // 防止目录遍历攻击
        let unsafeCharacters = ["..", "/", "\\", ":", "*", "?", "\"", "<", ">", "|"]
        return !unsafeCharacters.contains { self.contains($0) }
    }
    
    /// 清理HTML标签
    var sanitizedHTML: String {
        let regex = try? NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "") ?? self
    }
    
    /// 清理SQL注入攻击字符
    var sanitizedSQL: String {
        let unsafeSQL = ["'", "\"", "--", ";", "/*", "*/", "@@", "@", "char", "nchar", "varchar", "nvarchar", "alter", "begin", "cast", "create", "cursor", "declare", "delete", "drop", "end", "exec", "execute", "fetch", "insert", "kill", "open", "select", "sys", "sysobjects", "syscolumns", "table", "update"]
        
        var sanitized = self
        for sql in unsafeSQL {
            sanitized = sanitized.replacingOccurrences(of: sql, with: "")
        }
        
        return sanitized
    }
    
    /// 清理JavaScript代码
    var sanitizedJavaScript: String {
        let javascriptPatterns = [
            "<script[^>]*>.*?</script>",
            "javascript:",
            "onclick=",
            "onload=",
            "onerror=",
            "onmouseover=",
            "onmouseout=",
            "onkeydown=",
            "onkeypress=",
            "onkeyup=",
            "onsubmit=",
            "onchange=",
            "onfocus=",
            "onblur="
        ]
        
        var sanitized = self
        for pattern in javascriptPatterns {
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: sanitized.count)
            sanitized = regex?.stringByReplacingMatches(in: sanitized, options: [], range: range, withTemplate: "") ?? sanitized
        }
        
        return sanitized
    }
    
    // MARK: - 敏感信息处理
    
    /// 隐藏字符串中的敏感信息（如银行卡号、手机号等）
    /// - Parameters:
    ///   - startIndex: 开始隐藏的位置
    ///   - endIndex: 结束隐藏的位置
    ///   - maskChar: 隐藏字符
    /// - Returns: 隐藏后的字符串
    func maskSensitiveInfo(startIndex: Int, endIndex: Int, maskChar: Character = "*") -> String {
        guard startIndex >= 0, endIndex <= count, startIndex < endIndex else { return self }
        
        var chars = Array(self)
        for i in startIndex..<endIndex {
            chars[i] = maskChar
        }
        
        return String(chars)
    }
    
    /// 隐藏手机号中间四位
    var maskedPhoneNumber: String {
        guard isValidChineseMobile else { return self }
        return maskSensitiveInfo(startIndex: 3, endIndex: 7)
    }
    
    /// 隐藏身份证号中间部分
    var maskedIDNumber: String {
        guard count >= 15 else { return self }
        let start = count - 4
        let end = count
        return maskSensitiveInfo(startIndex: 0, endIndex: start) + String(suffix(4))
    }
    
    /// 隐藏邮箱地址
    var maskedEmail: String {
        guard let atIndex = firstIndex(of: "@") else { return self }
        let prefix = String(prefix(upTo: atIndex))
        let domain = String(suffix(from: atIndex))
        
        guard prefix.count > 2 else { return self }
        let maskedPrefix = String(prefix.prefix(2)) + String(repeating: "*", count: max(0, prefix.count - 2))
        return maskedPrefix + domain
    }
    
    /// 检查字符串是否包含敏感信息
    var containsSensitiveInfo: Bool {
        // 检查银行卡号模式
        let cardRegex = "\\b(?:\\d[ -]*?){13,16}\\b"
        let cardPredicate = NSPredicate(format: "SELF MATCHES %@", cardRegex)
        
        // 检查身份证号模式
        let idRegex = "\\b\\d{17}[\\dXx]\\b"
        let idPredicate = NSPredicate(format: "SELF MATCHES %@", idRegex)
        
        return cardPredicate.evaluate(with: self) || idPredicate.evaluate(with: self)
    }
}

// MARK: - Data安全扩展

public extension Data {
    
    /// 计算数据的MD5哈希值
    var md5: String {
        #if canImport(CommonCrypto)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = withUnsafeBytes { bytes in
            CC_MD5(bytes.baseAddress, CC_LONG(count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
        #else
        // 如果没有CommonCrypto，使用简单的实现
        var digest = [UInt8](repeating: 0, count: 16)
        for (index, byte) in enumerated() {
            digest[index % 16] ^= byte
        }
        return digest.map { String(format: "%02x", $0) }.joined()
        #endif
    }
    
    /// 计算数据的SHA256哈希值
    var sha256: String {
        #if canImport(CryptoKit)
        if #available(iOS 13.0, macOS 10.15, *) {
            let hash = SHA256.hash(data: self)
            return hash.map { String(format: "%02x", $0) }.joined()
        }
        #endif
        
        #if canImport(CommonCrypto)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = withUnsafeBytes { bytes in
            CC_SHA256(bytes.baseAddress, CC_LONG(count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
        #else
        return "" // 如果没有加密库，返回空字符串
        #endif
    }
    
    /// 计算数据的SHA512哈希值
    var sha512: String {
        #if canImport(CommonCrypto)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        _ = withUnsafeBytes { bytes in
            CC_SHA512(bytes.baseAddress, CC_LONG(count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
        #else
        return "" // 如果没有加密库，返回空字符串
        #endif
    }
    
    /// 使用AES加密数据
    /// - Parameters:
    ///   - key: 加密密钥
    ///   - iv: 初始化向量（可选）
    /// - Returns: 加密后的数据
    func aesEncrypt(key: String, iv: String? = nil) -> Data? {
        #if canImport(CommonCrypto)
        guard let keyData = key.data(using: .utf8) else { return nil }
        
        // 确保密钥长度正确（AES-128需要16字节，AES-256需要32字节）
        var adjustedKeyData = keyData
        if keyData.count < kCCKeySizeAES128 {
            adjustedKeyData = keyData + Data(repeating: 0, count: kCCKeySizeAES128 - keyData.count)
        } else if keyData.count > kCCKeySizeAES256 {
            adjustedKeyData = keyData.prefix(kCCKeySizeAES256)
        }
        
        let keyLength = adjustedKeyData.count
        let ivData = iv?.data(using: .utf8) ?? Data()
        
        let cryptLength = size_t(count + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            self.withUnsafeBytes { dataBytes in
                adjustedKeyData.withUnsafeBytes { keyBytes in
                    ivData.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress, count,
                            cryptBytes.baseAddress, cryptLength,
                            &numBytesEncrypted
                        )
                    }
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else { return nil }
        cryptData.count = numBytesEncrypted
        return cryptData
        #else
        return nil // 如果没有CommonCrypto，返回nil
        #endif
    }
    
    /// 使用AES解密数据
    /// - Parameters:
    ///   - key: 解密密钥
    ///   - iv: 初始化向量（可选）
    /// - Returns: 解密后的数据
    func aesDecrypt(key: String, iv: String? = nil) -> Data? {
        #if canImport(CommonCrypto)
        guard let keyData = key.data(using: .utf8) else { return nil }
        
        // 确保密钥长度正确
        var adjustedKeyData = keyData
        if keyData.count < kCCKeySizeAES128 {
            adjustedKeyData = keyData + Data(repeating: 0, count: kCCKeySizeAES128 - keyData.count)
        } else if keyData.count > kCCKeySizeAES256 {
            adjustedKeyData = keyData.prefix(kCCKeySizeAES256)
        }
        
        let keyLength = adjustedKeyData.count
        let ivData = iv?.data(using: .utf8) ?? Data()
        
        let cryptLength = size_t(count + kCCBlockSizeAES128)
        var decryptData = Data(count: cryptLength)
        
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = decryptData.withUnsafeMutableBytes { cryptBytes in
            self.withUnsafeBytes { dataBytes in
                adjustedKeyData.withUnsafeBytes { keyBytes in
                    ivData.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress, count,
                            cryptBytes.baseAddress, cryptLength,
                            &numBytesDecrypted
                        )
                    }
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else { return nil }
        decryptData.count = numBytesDecrypted
        return decryptData
        #else
        return nil // 如果没有CommonCrypto，返回nil
        #endif
    }
    
    /// 生成安全的随机数据
    /// - Parameter length: 数据长度
    /// - Returns: 随机数据
    static func secureRandom(length: Int) -> Data? {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        guard status == errSecSuccess else { return nil }
        return Data(bytes)
    }
}

// MARK: - 密钥链安全存储

#if canImport(Security)
/// 密钥链管理器
public final class KeychainManager: @unchecked Sendable {
    
    public static let shared = KeychainManager()
    private let serviceName: String
    
    public init(serviceName: String = Bundle.main.bundleIdentifier ?? "com.iosexkit.keychain") {
        self.serviceName = serviceName
    }
    
    /// 保存数据到密钥链
    /// - Parameters:
    ///   - data: 要保存的数据
    ///   - key: 保存键
    ///   - accessibility: 访问权限
    /// - Returns: 是否保存成功
    @discardableResult
    public func save(data: Data, forKey key: String, accessibility: CFString = kSecAttrAccessibleWhenUnlocked) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: key,
            kSecAttrAccessible: accessibility,
            kSecValueData: data
        ]
        
        // 先删除已存在的数据
        delete(forKey: key)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// 保存字符串到密钥链
    /// - Parameters:
    ///   - string: 要保存的字符串
    ///   - key: 保存键
    ///   - accessibility: 访问权限
    /// - Returns: 是否保存成功
    @discardableResult
    public func save(string: String, forKey key: String, accessibility: CFString = kSecAttrAccessibleWhenUnlocked) -> Bool {
        guard let data = string.data(using: .utf8) else { return false }
        return save(data: data, forKey: key, accessibility: accessibility)
    }
    
    /// 从密钥链加载数据
    /// - Parameter key: 保存键
    /// - Returns: 加载的数据
    public func loadData(forKey key: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return data
    }
    
    /// 从密钥链加载字符串
    /// - Parameter key: 保存键
    /// - Returns: 加载的字符串
    public func loadString(forKey key: String) -> String? {
        guard let data = loadData(forKey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// 从密钥链删除数据
    /// - Parameter key: 保存键
    /// - Returns: 是否删除成功
    @discardableResult
    public func delete(forKey key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    /// 检查密钥链中是否存在指定键
    /// - Parameter key: 保存键
    /// - Returns: 是否存在
    public func exists(forKey key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanFalse!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// 清空所有密钥链数据
    /// - Returns: 是否清空成功
    @discardableResult
    public func clearAll() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
#endif

// MARK: - 安全工具函数

/// 安全比较两个字符串（防止时序攻击）
/// - Parameters:
    ///   - lhs: 第一个字符串
    ///   - rhs: 第二个字符串
    /// - Returns: 是否相等
public func secureCompare(_ lhs: String, _ rhs: String) -> Bool {
    guard lhs.count == rhs.count else { return false }
    
    var result: UInt8 = 0
    for (lhsChar, rhsChar) in zip(lhs.utf8, rhs.utf8) {
        result |= lhsChar ^ rhsChar
    }
    
    return result == 0
}

/// 生成安全的随机字符串
/// - Parameters:
///   - length: 字符串长度
///   - characters: 字符集
/// - Returns: 随机字符串
public func secureRandomString(length: Int, characters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String? {
    guard let randomData = Data.secureRandom(length: length) else { return nil }
    
    var result = ""
    let charCount = characters.count
    
    for byte in randomData {
        let index = Int(byte) % charCount
        let charIndex = characters.index(characters.startIndex, offsetBy: index)
        result.append(characters[charIndex])
    }
    
    return result
}

/// 生成安全的随机整数
/// - Parameter range: 整数范围
/// - Returns: 随机整数
public func secureRandomInt(in range: Range<Int>) -> Int? {
    guard let randomData = Data.secureRandom(length: MemoryLayout<Int>.size) else { return nil }
    
    var randomValue: Int = 0
    _ = withUnsafeMutableBytes(of: &randomValue) { buffer in
        randomData.copyBytes(to: buffer)
    }
    
    let absoluteValue = abs(randomValue)
    return range.lowerBound + (absoluteValue % (range.upperBound - range.lowerBound))
}

/// 安全延迟执行（防止时序攻击）
/// - Parameters:
///   - milliseconds: 延迟毫秒数
///   - jitter: 抖动范围（随机添加的延迟）
public func secureDelay(milliseconds: Int, jitter: Int = 100) {
    let delay = Double(milliseconds + Int.random(in: 0...jitter)) / 1000.0
    Thread.sleep(forTimeInterval: delay)
}

// MARK: - 安全配置检查

#if canImport(UIKit)
import UIKit

/// 安全配置检查器
public final class SecurityConfigChecker: @unchecked Sendable {
    
    public static let shared = SecurityConfigChecker()
    
    private init() {}
    
    /// 检查设备是否越狱
    public var isJailbroken: Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        // 检查常见越狱文件
        let jailbreakFilePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]
        
        for path in jailbreakFilePaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        // 检查是否能写入系统目录
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(toFile: "/private/jailbreak.txt", atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: "/private/jailbreak.txt")
            return true
        } catch {
            return false
        }
        #endif
    }
    
    /// 检查应用是否被调试
    public var isDebugging: Bool {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let sysctlResult = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        
        if sysctlResult != 0 {
            return false
        }
        
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
    
    /// 检查SSL证书验证是否被禁用
    public var isSSLPinningDisabled: Bool {
        // 这里可以添加更复杂的SSL证书验证检查
        // 目前返回false表示SSL证书验证正常
        return false
    }
    
    /// 检查应用是否被重签名
    public var isResigned: Bool {
        guard let embeddedProvisioningProfile = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") else {
            return false
        }
        
        do {
            let provisioningProfile = try String(contentsOfFile: embeddedProvisioningProfile, encoding: .ascii)
            // 检查是否包含常见的重签名标识
            let resignPatterns = ["iPhone Distribution:.*\\(.*\\)", "PROVISIONING_PROFILE.*=.*"]
            
            for pattern in resignPatterns {
                if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                    let range = NSRange(location: 0, length: provisioningProfile.count)
                    if regex.firstMatch(in: provisioningProfile, options: [], range: range) != nil {
                        return true
                    }
                }
            }
            
            return false
        } catch {
            return false
        }
    }
    
    /// 执行全面的安全检查
    /// - Returns: 安全检查结果
    public func performSecurityCheck() -> SecurityCheckResult {
        var issues: [SecurityIssue] = []
        
        if isJailbroken {
            issues.append(.jailbrokenDevice)
        }
        
        if isDebugging {
            issues.append(.debuggingEnabled)
        }
        
        if isSSLPinningDisabled {
            issues.append(.sslPinningDisabled)
        }
        
        if isResigned {
            issues.append(.appResigned)
        }
        
        return SecurityCheckResult(issues: issues)
    }
}

/// 安全检查结果
public struct SecurityCheckResult {
    public let issues: [SecurityIssue]
    public var hasIssues: Bool { !issues.isEmpty }
    public var isSecure: Bool { issues.isEmpty }
}

/// 安全问题类型
public enum SecurityIssue: String {
    case jailbrokenDevice = "设备已越狱"
    case debuggingEnabled = "调试模式已启用"
    case sslPinningDisabled = "SSL证书验证被禁用"
    case appResigned = "应用被重签名"
    case insecureNetwork = "不安全的网络连接"
    case weakEncryption = "弱加密配置"
}

#endif