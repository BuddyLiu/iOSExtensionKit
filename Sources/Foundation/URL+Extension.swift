// URL+Extension.swift
// URL扩展，提供便捷的URL操作和验证方法

import Foundation

public extension URL {
    
    // MARK: - 属性和验证
    
    /// 检查URL是否有效
    var isValid: Bool {
        return !absoluteString.isEmpty && scheme != nil && host != nil
    }
    
    /// 检查是否是HTTP/HTTPS URL
    var isHTTPURL: Bool {
        guard let scheme = scheme?.lowercased() else { return false }
        return scheme == "http" || scheme == "https"
    }
    
    /// 检查是否是安全的HTTPS URL
    var isHTTPSURL: Bool {
        return scheme?.lowercased() == "https"
    }
    
    /// 检查是否是文件URL
    var isFileURL: Bool {
        return scheme?.lowercased() == "file"
    }
    
    /// 获取URL的主机名（不包括www前缀）
    var hostName: String? {
        guard let host = host else { return nil }
        return host.replacingOccurrences(of: "^www\\.", with: "", options: .regularExpression)
    }
    
    /// 获取URL的顶级域名
    var topLevelDomain: String? {
        guard let host = host else { return nil }
        let components = host.components(separatedBy: ".")
        return components.last
    }
    
    /// 获取URL的路径扩展名（小写）
    var pathExtensionLowercased: String {
        return pathExtension.lowercased()
    }
    
    /// 检查URL是否有指定的路径扩展名
    /// - Parameter extensions: 扩展名数组（不区分大小写）
    /// - Returns: 是否有指定扩展名
    func hasPathExtension(_ extensions: [String]) -> Bool {
        let lowercasedExtension = pathExtension.lowercased()
        let lowercasedExtensions = extensions.map { $0.lowercased() }
        return lowercasedExtensions.contains(lowercasedExtension)
    }
    
    /// 检查URL是否是图片URL
    var isImageURL: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "tif", "webp", "heic"]
        return hasPathExtension(imageExtensions)
    }
    
    /// 检查URL是否是视频URL
    var isVideoURL: Bool {
        let videoExtensions = ["mp4", "mov", "avi", "mkv", "flv", "wmv", "webm", "m4v", "3gp"]
        return hasPathExtension(videoExtensions)
    }
    
    /// 检查URL是否是音频URL
    var isAudioURL: Bool {
        let audioExtensions = ["mp3", "wav", "aac", "flac", "m4a", "ogg", "wma", "aiff"]
        return hasPathExtension(audioExtensions)
    }
    
    /// 检查URL是否是文档URL
    var isDocumentURL: Bool {
        let documentExtensions = ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "rtf", "pages", "numbers", "key"]
        return hasPathExtension(documentExtensions)
    }
    
    // MARK: - 安全构造方法
    
    /// 从字符串安全地创建URL
    /// - Parameter string: URL字符串
    /// - Returns: 如果字符串有效则返回URL，否则返回nil
    init?(safe string: String) {
        // 清理字符串
        let cleanedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedString.isEmpty,
              let url = URL(string: cleanedString) else {
            return nil
        }
        
        self = url
    }
    
    /// 从字符串创建URL，自动添加缺失的协议
    /// - Parameter string: URL字符串
    /// - Parameter defaultScheme: 默认协议（如果缺失）
    /// - Returns: 如果字符串有效则返回URL，否则返回nil
    init?(autoComplete string: String, defaultScheme: String = "https") {
        let cleanedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedString.isEmpty else {
            return nil
        }
        
        // 检查是否已有协议
        let urlString: String
        if cleanedString.contains("://") {
            urlString = cleanedString
        } else {
            urlString = "\(defaultScheme)://\(cleanedString)"
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        self = url
    }
    
    // MARK: - 查询参数操作
    
    /// 获取查询参数字典
    var queryDictionary: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        
        var dict: [String: String] = [:]
        for item in queryItems {
            dict[item.name] = item.value ?? ""
        }
        return dict
    }
    
    /// 添加查询参数
    /// - Parameter parameters: 参数字典
    /// - Returns: 添加参数后的新URL，如果失败则返回nil
    func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        var queryItems = components.queryItems ?? []
        for (key, value) in parameters {
            // 检查是否已存在该参数
            if let existingIndex = queryItems.firstIndex(where: { $0.name == key }) {
                queryItems[existingIndex].value = value
            } else {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        
        components.queryItems = queryItems
        return components.url
    }
    
    /// 移除指定查询参数
    /// - Parameter keys: 要移除的参数键
    /// - Returns: 移除参数后的新URL，如果失败则返回nil
    func removingQueryParameters(_ keys: [String]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        var queryItems = components.queryItems ?? []
        queryItems.removeAll { keys.contains($0.name) }
        
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }
    
    /// 获取指定查询参数的值
    /// - Parameter key: 参数键
    /// - Returns: 参数值，如果不存在则返回nil
    func queryValue(for key: String) -> String? {
        return queryDictionary[key]
    }
    
    /// 检查是否包含指定的查询参数
    /// - Parameter key: 参数键
    /// - Returns: 是否包含该参数
    func containsQueryParameter(_ key: String) -> Bool {
        return queryDictionary.keys.contains(key)
    }
    
    // MARK: - 路径操作
    
    /// 获取URL的目录URL
    var directoryURL: URL? {
        return deletingLastPathComponent()
    }
    
    /// 安全地追加路径组件
    /// - Parameter component: 路径组件
    /// - Returns: 追加后的新URL
    func appendingPathComponentSafely(_ component: String) -> URL {
        let trimmedComponent = component.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return appendingPathComponent(trimmedComponent)
    }
    
    /// 追加多个路径组件
    /// - Parameter components: 路径组件数组
    /// - Returns: 追加后的新URL
    func appendingPathComponents(_ components: [String]) -> URL {
        var result = self
        for component in components {
            result = result.appendingPathComponentSafely(component)
        }
        return result
    }
    
    /// 获取相对路径（相对于基础URL）
    /// - Parameter baseURL: 基础URL
    /// - Returns: 相对路径字符串，如果不相关则返回nil
    func relativePath(to baseURL: URL) -> String? {
        guard let baseComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false),
              let selfComponents = URLComponents(url: self, resolvingAgainstBaseURL: false),
              baseComponents.scheme == selfComponents.scheme,
              baseComponents.host == selfComponents.host,
              baseComponents.port == selfComponents.port else {
            return nil
        }
        
        let basePath = baseComponents.path
        let selfPath = selfComponents.path
        
        if selfPath.hasPrefix(basePath) {
            return String(selfPath.dropFirst(basePath.count)).trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }
        
        return nil
    }
    
    // MARK: - 文件URL操作
    
    /// 检查文件是否存在
    var fileExists: Bool {
        guard isFileURL else { return false }
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// 获取文件大小（如果适用）
    var fileSize: Int64? {
        guard isFileURL else { return nil }
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            return (attributes[.size] as? NSNumber)?.int64Value
        } catch {
            return nil
        }
    }
    
    /// 获取文件修改日期（如果适用）
    var fileModificationDate: Date? {
        guard isFileURL else { return nil }
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            return attributes[.modificationDate] as? Date
        } catch {
            return nil
        }
    }
    
    /// 获取文件创建日期（如果适用）
    var fileCreationDate: Date? {
        guard isFileURL else { return nil }
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            return attributes[.creationDate] as? Date
        } catch {
            return nil
        }
    }
    
    /// 检查文件是否可读
    var isReadable: Bool {
        guard isFileURL else { return false }
        return FileManager.default.isReadableFile(atPath: path)
    }
    
    /// 检查文件是否可写
    var isWritable: Bool {
        guard isFileURL else { return false }
        return FileManager.default.isWritableFile(atPath: path)
    }
    
    /// 检查文件是否可执行
    var isExecutable: Bool {
        guard isFileURL else { return false }
        return FileManager.default.isExecutableFile(atPath: path)
    }
    
    /// 检查文件是否可删除
    var isDeletable: Bool {
        guard isFileURL else { return false }
        return FileManager.default.isDeletableFile(atPath: path)
    }
    
    // MARK: - 编码和解码
    
    /// 对URL进行编码
    /// - Returns: 编码后的URL
    var encoded: URL? {
        guard let encodedString = absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: encodedString)
    }
    
    /// 对查询参数进行编码
    /// - Returns: 查询参数编码后的URL
    var withEncodedQuery: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return self
        }
        
        var encodedQueryItems: [URLQueryItem] = []
        for item in queryItems {
            if let value = item.value,
               let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                encodedQueryItems.append(URLQueryItem(name: item.name, value: encodedValue))
            } else {
                encodedQueryItems.append(item)
            }
        }
        
        components.queryItems = encodedQueryItems
        return components.url
    }
    
    /// 从URL中解码百分比编码
    /// - Returns: 解码后的URL字符串
    var decodedString: String {
        return absoluteString.removingPercentEncoding ?? absoluteString
    }
    
    // MARK: - 便利构造器
    
    /// 使用基础URL和路径组件创建URL
    /// - Parameters:
    ///   - baseURL: 基础URL
    ///   - pathComponents: 路径组件数组
    init?(baseURL: URL, pathComponents: [String]) {
        var url = baseURL
        for component in pathComponents {
            url = url.appendingPathComponentSafely(component)
        }
        self = url
    }
    
    /// 创建临时文件URL
    /// - Parameter extension: 文件扩展名
    /// - Returns: 临时文件URL
    static func temporaryFile(extension: String? = nil) -> URL {
        let uuid = UUID().uuidString
        let fileName = `extension` != nil ? "\(uuid).\(`extension`!)" : uuid
        return FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
    }
    
    /// 创建缓存文件URL
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - extension: 文件扩展名
    /// - Returns: 缓存文件URL
    static func cacheFile(named fileName: String, extension: String? = nil) -> URL {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fullFileName = `extension` != nil ? "\(fileName).\(`extension`!)" : fileName
        return cacheDirectory.appendingPathComponent(fullFileName)
    }
    
    /// 创建文档文件URL
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - extension: 文件扩展名
    /// - Returns: 文档文件URL
    static func documentFile(named fileName: String, extension: String? = nil) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fullFileName = `extension` != nil ? "\(fileName).\(`extension`!)" : fileName
        return documentDirectory.appendingPathComponent(fullFileName)
    }
    
    // MARK: - 比较和相等性
    
    /// 检查两个URL是否相等（忽略查询参数）
    /// - Parameter other: 另一个URL
    /// - Returns: 是否相等
    func isEqualIgnoringQuery(to other: URL) -> Bool {
        var components1 = URLComponents(url: self, resolvingAgainstBaseURL: false)
        var components2 = URLComponents(url: other, resolvingAgainstBaseURL: false)
        
        components1?.queryItems = nil
        components2?.queryItems = nil
        
        return components1?.url == components2?.url
    }
    
    /// 检查两个URL是否相等（忽略协议）
    /// - Parameter other: 另一个URL
    /// - Returns: 是否相等
    func isEqualIgnoringScheme(to other: URL) -> Bool {
        var components1 = URLComponents(url: self, resolvingAgainstBaseURL: false)
        var components2 = URLComponents(url: other, resolvingAgainstBaseURL: false)
        
        components1?.scheme = nil
        components2?.scheme = nil
        
        return components1?.url == components2?.url
    }
    
    /// 检查URL是否以指定前缀开头
    /// - Parameter prefix: 前缀URL
    /// - Returns: 是否以该前缀开头
    func hasPrefix(_ prefix: URL) -> Bool {
        return absoluteString.hasPrefix(prefix.absoluteString)
    }
}

// MARK: - 静态便捷方法

public extension URL {
    
    /// 检查字符串是否为有效的URL
    /// - Parameter string: 要检查的字符串
    /// - Returns: 是否为有效URL
    static func isValid(_ string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        return url.isValid
    }
    
    /// 检查字符串是否为有效的HTTP/HTTPS URL
    /// - Parameter string: 要检查的字符串
    /// - Returns: 是否为有效HTTP/HTTPS URL
    static func isValidHTTP(_ string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        return url.isHTTPURL
    }
    
    /// 从字符串数组创建URL数组
    /// - Parameter strings: 字符串数组
    /// - Returns: 有效URL数组
    static func fromStrings(_ strings: [String]) -> [URL] {
        return strings.compactMap { URL(string: $0) }
    }
    
    /// 从字符串数组安全地创建URL数组（忽略无效字符串）
    /// - Parameter strings: 字符串数组
    /// - Returns: 有效URL数组
    static func safeFromStrings(_ strings: [String]) -> [URL] {
        return strings.compactMap { URL(safe: $0) }
    }
}

// MARK: - 自定义运算符

public extension URL {
    
    /// URL拼接运算符（用于路径组件）
    /// - Parameters:
    ///   - lhs: 基础URL
    ///   - rhs: 路径组件
    /// - Returns: 拼接后的URL
    static func / (lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponentSafely(rhs)
    }
    
    /// URL拼接运算符（用于多个路径组件）
    /// - Parameters:
    ///   - lhs: 基础URL
    ///   - rhs: 路径组件数组
    /// - Returns: 拼接后的URL
    static func / (lhs: URL, rhs: [String]) -> URL {
        return lhs.appendingPathComponents(rhs)
    }
}

// MARK: - 集合扩展

public extension Collection where Element == URL {
    
    /// 过滤出有效的URL
    var validURLs: [URL] {
        return filter { $0.isValid }
    }
    
    /// 过滤出HTTP/HTTPS URL
    var httpURLs: [URL] {
        return filter { $0.isHTTPURL }
    }
    
    /// 过滤出文件URL
    var fileURLs: [URL] {
        return filter { $0.isFileURL }
    }
    
    /// 过滤出图片URL
    var imageURLs: [URL] {
        return filter { $0.isImageURL }
    }
    
    /// 过滤出视频URL
    var videoURLs: [URL] {
        return filter { $0.isVideoURL }
    }
    
    /// 过滤出音频URL
    var audioURLs: [URL] {
        return filter { $0.isAudioURL }
    }
    
    /// 获取URL的主机集合（去重）
    var hosts: Set<String> {
        return Set(compactMap { $0.host })
    }
    
    /// 获取URL的协议集合（去重）
    var schemes: Set<String> {
        return Set(compactMap { $0.scheme })
    }
}

// MARK: - Codable支持

extension URL: @retroactive ExpressibleByStringLiteral {
    
    /// 允许URL使用字符串字面量初始化
    public init(stringLiteral value: String) {
        guard let url = URL(string: value) else {
            preconditionFailure("无效的URL字符串: \(value)")
        }
        self = url
    }
}

extension URL: @retroactive ExpressibleByExtendedGraphemeClusterLiteral {
    
    /// 支持字符簇字面量
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension URL: @retroactive ExpressibleByUnicodeScalarLiteral {
    
    /// 支持Unicode标量字面量
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}