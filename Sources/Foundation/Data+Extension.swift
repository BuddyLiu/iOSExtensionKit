// Data+Extension.swift
// Data扩展，提供便捷的数据操作、转换和验证方法

import Foundation

public extension Data {
    
    // MARK: - 属性和验证
    
    /// 检查Data是否为空
    var isEmpty: Bool {
        return count == 0
    }
    
    /// 检查Data是否不为空
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// 获取Data的十六进制字符串表示
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
    
    /// 获取Data的十六进制字符串表示（带分隔符）
    /// - Parameter separator: 分隔符
    /// - Returns: 带分隔符的十六进制字符串
    func hexString(with separator: String = " ") -> String {
        return map { String(format: "%02x", $0) }.joined(separator: separator)
    }
    
    /// 获取Data的Base64编码字符串
    var base64String: String {
        return base64EncodedString()
    }
    
    /// 获取Data的大小描述（如：1.2 MB）
    var sizeDescription: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(count))
    }
    
    /// 检查Data是否以指定字节开头
    /// - Parameter bytes: 字节数组
    /// - Returns: 是否以指定字节开头
    func starts(with bytes: [UInt8]) -> Bool {
        guard bytes.count <= count else { return false }
        return prefix(bytes.count) == Data(bytes)
    }
    
    /// 检查Data是否以指定字节结尾
    /// - Parameter bytes: 字节数组
    /// - Returns: 是否以指定字节结尾
    func ends(with bytes: [UInt8]) -> Bool {
        guard bytes.count <= count else { return false }
        return suffix(bytes.count) == Data(bytes)
    }
    
    // MARK: - 安全访问
    
    /// 安全获取指定范围的子数据
    /// - Parameter range: 范围
    /// - Returns: 子数据，如果范围越界则返回nil
    func safeSubdata(in range: Range<Int>) -> Data? {
        guard range.lowerBound >= 0,
              range.upperBound <= count,
              range.lowerBound <= range.upperBound else {
            return nil
        }
        return subdata(in: range)
    }
    
    /// 安全获取指定位置的字节
    /// - Parameter index: 索引
    /// - Returns: 字节，如果索引越界则返回nil
    func safeByte(at index: Int) -> UInt8? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    /// 安全获取前N个字节
    /// - Parameter count: 字节数
    /// - Returns: 前N个字节
    func safePrefix(_ count: Int) -> Data {
        guard count > 0 else { return Data() }
        return prefix(Swift.min(count, self.count))
    }
    
    /// 安全获取后N个字节
    /// - Parameter count: 字节数
    /// - Returns: 后N个字节
    func safeSuffix(_ count: Int) -> Data {
        guard count > 0 else { return Data() }
        return suffix(Swift.min(count, self.count))
    }
    
    // MARK: - 转换方法
    
    /// 将Data转换为字符串（UTF-8编码）
    /// - Returns: 字符串，如果转换失败则返回nil
    var stringValue: String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// 将Data转换为指定编码的字符串
    /// - Parameter encoding: 字符串编码
    /// - Returns: 字符串，如果转换失败则返回nil
    func stringValue(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    /// 将Data转换为Int
    /// - Returns: Int值，如果转换失败则返回nil
    var intValue: Int? {
        guard count <= MemoryLayout<Int>.size else { return nil }
        var value: Int = 0
        _ = withUnsafeBytes { bytes in
            memcpy(&value, bytes.baseAddress, Swift.min(count, MemoryLayout<Int>.size))
        }
        return value
    }
    
    /// 将Data转换为Double
    /// - Returns: Double值，如果转换失败则返回nil
    var doubleValue: Double? {
        guard count == MemoryLayout<Double>.size else { return nil }
        var value: Double = 0
        _ = withUnsafeBytes { bytes in
            memcpy(&value, bytes.baseAddress, MemoryLayout<Double>.size)
        }
        return value
    }
    
    /// 将Data转换为Float
    /// - Returns: Float值，如果转换失败则返回nil
    var floatValue: Float? {
        guard count == MemoryLayout<Float>.size else { return nil }
        var value: Float = 0
        _ = withUnsafeBytes { bytes in
            memcpy(&value, bytes.baseAddress, MemoryLayout<Float>.size)
        }
        return value
    }
    
    /// 将Data转换为布尔值
    /// - Returns: 布尔值（非零为true）
    var boolValue: Bool {
        return !allSatisfy { $0 == 0 }
    }
    
    /// 尝试将Data解码为JSON对象
    /// - Returns: JSON对象，如果解码失败则返回nil
    var jsonObject: Any? {
        try? JSONSerialization.jsonObject(with: self, options: [])
    }
    
    /// 尝试将Data解码为指定类型的对象
    /// - Parameter type: 解码类型
    /// - Returns: 解码后的对象，如果失败则返回nil
    func decodeJSON<T: Decodable>(_ type: T.Type) -> T? {
        try? JSONDecoder().decode(type, from: self)
    }
    
    /// 将Data转换为字节数组
    var bytes: [UInt8] {
        return Array(self)
    }
    
    // MARK: - 创建方法
    
    /// 从十六进制字符串创建Data
    /// - Parameter hexString: 十六进制字符串
    /// - Returns: Data，如果字符串无效则返回nil
    init?(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard hexString.count.isMultiple(of: 2) else { return nil }
        
        var data = Data()
        var index = hexString.startIndex
        
        while index < hexString.endIndex {
            let nextIndex = hexString.index(index, offsetBy: 2)
            let byteString = hexString[index..<nextIndex]
            
            guard let byte = UInt8(byteString, radix: 16) else {
                return nil
            }
            
            data.append(byte)
            index = nextIndex
        }
        
        self = data
    }
    
    /// 从Base64字符串创建Data
    /// - Parameter base64String: Base64字符串
    /// - Returns: Data，如果字符串无效则返回nil
    init?(safeBase64String: String) {
        guard let data = Data(base64Encoded: safeBase64String) else {
            return nil
        }
        self = data
    }
    
    /// 从字符串创建Data（UTF-8编码）
    /// - Parameter string: 字符串
    /// - Returns: Data，如果字符串为nil则返回空Data
    init?(safeString: String?) {
        guard let safeString = safeString else { return nil }
        guard let data = safeString.data(using: String.Encoding.utf8) else { return nil }
        self = data
    }
    
    
    // MARK: - 修改方法
    
    /// 追加字符串（UTF-8编码）
    /// - Parameter string: 要追加的字符串
    /// - Returns: 新的Data
    func appending(_ string: String) -> Data {
        guard let stringData = string.data(using: .utf8) else { return self }
        var result = self
        result.append(stringData)
        return result
    }
    
    /// 追加字节
    /// - Parameter byte: 要追加的字节
    /// - Returns: 新的Data
    func appending(_ byte: UInt8) -> Data {
        var result = self
        result.append(byte)
        return result
    }
    
    /// 追加字节数组
    /// - Parameter bytes: 要追加的字节数组
    /// - Returns: 新的Data
    func appending(_ bytes: [UInt8]) -> Data {
        var result = self
        result.append(contentsOf: bytes)
        return result
    }
    
    /// 在指定位置插入数据
    /// - Parameters:
    ///   - data: 要插入的数据
    ///   - index: 插入位置
    /// - Returns: 新的Data，如果索引越界则返回原Data
    func inserting(_ data: Data, at index: Int) -> Data {
        guard index >= 0 && index <= count else { return self }
        
        var result = self
        let prefixData = result.prefix(index)
        let suffixData = result.suffix(count - index)
        
        result = prefixData + data + suffixData
        return result
    }
    
    /// 移除指定范围的数据
    /// - Parameter range: 要移除的范围
    /// - Returns: 新的Data，如果范围越界则返回原Data
    func removing(in range: Range<Int>) -> Data {
        guard range.lowerBound >= 0,
              range.upperBound <= count,
              range.lowerBound <= range.upperBound else {
            return self
        }
        
        var result = self
        let prefixData = result.prefix(range.lowerBound)
        let suffixData = result.suffix(count - range.upperBound)
        
        result = prefixData + suffixData
        return result
    }
    
    /// 替换指定范围的数据
    /// - Parameters:
    ///   - range: 要替换的范围
    ///   - data: 替换数据
    /// - Returns: 新的Data，如果范围越界则返回原Data
    func replacing(in range: Range<Int>, with data: Data) -> Data {
        guard range.lowerBound >= 0,
              range.upperBound <= count,
              range.lowerBound <= range.upperBound else {
            return self
        }
        
        var result = self
        let prefixData = result.prefix(range.lowerBound)
        let suffixData = result.suffix(count - range.upperBound)
        
        result = prefixData + data + suffixData
        return result
    }
    
    // MARK: - 加密相关（占位符）
    
    /// 计算MD5哈希值（占位符）
    var md5: Data? {
        // 需要导入CryptoKit或实现自己的MD5算法
        // 这里返回nil，实际使用时应根据需要实现
        return nil
    }
    
    /// 计算SHA1哈希值（占位符）
    var sha1: Data? {
        // 需要导入CryptoKit或实现自己的SHA1算法
        // 这里返回nil，实际使用时应根据需要实现
        return nil
    }
    
    /// 计算SHA256哈希值（占位符）
    var sha256: Data? {
        // 需要导入CryptoKit或实现自己的SHA256算法
        // 这里返回nil，实际使用时应根据需要实现
        return nil
    }
    
    /// 计算SHA512哈希值（占位符）
    var sha512: Data? {
        // 需要导入CryptoKit或实现自己的SHA512算法
        // 这里返回nil，实际使用时应根据需要实现
        return nil
    }
    
    // MARK: - 压缩和解压缩（占位符）
    
    /// 压缩数据（占位符）
    /// - Parameter algorithm: 压缩算法
    /// - Returns: 压缩后的数据，如果失败则返回nil
    func compressed(algorithm: CompressionAlgorithm = .zlib) -> Data? {
        // 需要导入Compression框架
        // 这里返回nil，实际使用时应根据需要实现
        return nil
    }
    
    /// 解压缩数据（占位符）
    /// - Parameter algorithm: 压缩算法
    /// - Returns: 解压缩后的数据，如果失败则返回nil
    func decompressed(algorithm: CompressionAlgorithm = .zlib) -> Data? {
        // 需要导入Compression框架
        // 这里返回nil，实际使用时应根据需要实现
        return nil
    }
    
    // MARK: - 文件操作
    
    /// 将Data写入文件
    /// - Parameters:
    ///   - url: 文件URL
    ///   - options: 写入选项
    /// - Returns: 是否写入成功
    @discardableResult
    func writeToFile(at url: URL, options: Data.WritingOptions = []) -> Bool {
        do {
            try self.write(to: url, options: options)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全地将Data写入文件，如果文件已存在则备份
    /// - Parameters:
    ///   - url: 文件URL
    ///   - options: 写入选项
    /// - Returns: 是否写入成功
    @discardableResult
    func safeWriteToFile(at url: URL, options: Data.WritingOptions = []) -> Bool {
        let fileManager = FileManager.default
        
        // 如果文件已存在，先备份
        if fileManager.fileExists(atPath: url.path) {
            let backupURL = url.appendingPathExtension("bak")
            do {
                if fileManager.fileExists(atPath: backupURL.path) {
                    try fileManager.removeItem(at: backupURL)
                }
                try fileManager.moveItem(at: url, to: backupURL)
            } catch {
                return false
            }
        }
        
        // 写入新文件
        do {
            try self.write(to: url, options: options)
            return true
        } catch {
            // 如果写入失败，尝试恢复备份
            let backupURL = url.appendingPathExtension("bak")
            if fileManager.fileExists(atPath: backupURL.path) {
                try? fileManager.moveItem(at: backupURL, to: url)
            }
            return false
        }
    }
    
    /// 从文件读取Data
    /// - Parameter url: 文件URL
    /// - Returns: Data，如果读取失败则返回nil
    static func readFromFile(at url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }
}

// MARK: - 压缩算法枚举（占位符）

public enum CompressionAlgorithm {
    case zlib
    case lzfse
    case lzma
    case lz4
}

// MARK: - 压缩错误（占位符）

public enum CompressionError: Error {
    case compressionFailed
    case decompressionFailed
    case unsupportedAlgorithm
}

// MARK: - 便捷静态方法

public extension Data {
    
    /// 创建指定大小的零数据
    /// - Parameter size: 数据大小（字节）
    /// - Returns: 零数据
    static func zeros(count: Int) -> Data {
        return Data(repeating: 0, count: Swift.max(0, count))
    }
    
    /// 创建随机数据
    /// - Parameter count: 数据大小（字节）
    /// - Returns: 随机数据
    static func random(count: Int) -> Data {
        var bytes = [UInt8](repeating: 0, count: count)
        _ = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
        return Data(bytes)
    }
    
    /// 从多个Data对象连接创建Data
    /// - Parameter dataArray: Data数组
    /// - Returns: 连接后的Data
    static func joined(_ dataArray: [Data]) -> Data {
        var result = Data()
        for data in dataArray {
            result.append(data)
        }
        return result
    }
}

// MARK: - 运算符重载

public extension Data {
    
    /// Data拼接运算符
    static func + (lhs: Data, rhs: Data) -> Data {
        var result = lhs
        result.append(rhs)
        return result
    }
    
    /// Data拼接运算符（字符串）
    static func + (lhs: Data, rhs: String) -> Data {
        return lhs.appending(rhs)
    }
    
    /// Data拼接运算符（字节）
    static func + (lhs: Data, rhs: UInt8) -> Data {
        return lhs.appending(rhs)
    }
    
    /// Data拼接运算符（字节数组）
    static func + (lhs: Data, rhs: [UInt8]) -> Data {
        var result = lhs
        result.append(contentsOf: rhs)
        return result
    }
    
    /// Data相等运算符（忽略字节顺序）
    static func == (lhs: Data, rhs: Data) -> Bool {
        return lhs.elementsEqual(rhs)
    }
}

// MARK: - 序列扩展

public extension Sequence where Element == Data {
    
    /// 连接所有Data
    var joined: Data {
        return Data.joined(Array(self))
    }
    
    /// 计算总大小
    var totalSize: Int {
        return reduce(0) { $0 + $1.count }
    }
    
    /// 过滤非空Data
    var nonEmpty: [Data] {
        return filter { $0.isNotEmpty }
    }
    
    /// 转换为字符串数组（UTF-8编码）
    var strings: [String] {
        return compactMap { $0.stringValue }
    }
}

// MARK: - Codable支持

extension Data: @retroactive ExpressibleByStringLiteral {
    
    /// 允许Data使用字符串字面量初始化（作为十六进制字符串）
    public init(stringLiteral value: String) {
        if let data = Data(hexString: value) {
            self = data
        } else {
            self = Data()
        }
    }
}

extension Data: @retroactive ExpressibleByExtendedGraphemeClusterLiteral {
    
    /// 支持字符簇字面量
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension Data: @retroactive ExpressibleByUnicodeScalarLiteral {
    
    /// 支持Unicode标量字面量
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

// MARK: - 自定义描述扩展

public extension Data {
    
    /// 简化的描述（不覆盖标准description）
    var simplifiedDescription: String {
        return "Data(count: \(count), hex: \(prefix(16).hexString)\(count > 16 ? "..." : ""))"
    }
    
    /// 调试描述（不覆盖标准debugDescription）
    var simplifiedDebugDescription: String {
        return "Data(count: \(count), hex: \(hexString))"
    }
}
