// URLSession+Extension.swift
// 网络请求扩展，提供便捷的HTTP请求方法

import Foundation

public extension URLSession {
    
    // MARK: - Async/Await 请求方法
    
    /// 执行通用请求 (Async/Await)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - method: HTTP方法
    ///   - body: 请求体数据
    ///   - headers: 请求头
    /// - Returns: 响应数据
    func request(url: URL, 
                 method: String = "GET", 
                 body: Data? = nil, 
                 headers: [String: String]? = nil) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
        
        return data
    }
    
    /// 执行GET请求 (Async/Await)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - headers: 请求头
    /// - Returns: 响应数据
    func get(from url: URL, headers: [String: String]? = nil) async throws -> Data {
        return try await request(url: url, method: "GET", body: nil, headers: headers)
    }
    
    /// 执行POST请求 (Async/Await)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - body: 请求体数据
    ///   - headers: 请求头
    /// - Returns: 响应数据
    func post(to url: URL, body: Data? = nil, headers: [String: String]? = nil) async throws -> Data {
        return try await request(url: url, method: "POST", body: body, headers: headers)
    }
    
    /// 执行PUT请求 (Async/Await)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - body: 请求体数据
    ///   - headers: 请求头
    /// - Returns: 响应数据
    func put(to url: URL, body: Data? = nil, headers: [String: String]? = nil) async throws -> Data {
        return try await request(url: url, method: "PUT", body: body, headers: headers)
    }
    
    /// 执行DELETE请求 (Async/Await)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - headers: 请求头
    /// - Returns: 响应数据
    func delete(from url: URL, headers: [String: String]? = nil) async throws -> Data {
        return try await request(url: url, method: "DELETE", body: nil, headers: headers)
    }
    
    // MARK: - JSON请求方法 (Async/Await)
    
    /// 执行JSON GET请求 (Async/Await)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - headers: 请求头
    /// - Returns: 解码后的对象
    func getJSON<T: Decodable>(from url: URL, headers: [String: String]? = nil) async throws -> T {
        let data = try await get(from: url, headers: headers)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// 执行JSON POST请求 (Async/Await)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - body: 可编码的请求体
    ///   - headers: 请求头
    /// - Returns: 解码后的对象
    func postJSON<T: Decodable, U: Encodable>(to url: URL, body: U? = nil, headers: [String: String]? = nil) async throws -> T {
        var requestHeaders = headers ?? [:]
        requestHeaders["Content-Type"] = "application/json"
        
        var requestBody: Data?
        if let body = body {
            requestBody = try JSONEncoder().encode(body)
        }
        
        let data = try await post(to: url, body: requestBody, headers: requestHeaders)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// 执行JSON PUT请求 (Async/Await)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - body: 可编码的请求体
    ///   - headers: 请求头
    /// - Returns: 解码后的对象
    func putJSON<T: Decodable, U: Encodable>(to url: URL, body: U? = nil, headers: [String: String]? = nil) async throws -> T {
        var requestHeaders = headers ?? [:]
        requestHeaders["Content-Type"] = "application/json"
        
        var requestBody: Data?
        if let body = body {
            requestBody = try JSONEncoder().encode(body)
        }
        
        let data = try await put(to: url, body: requestBody, headers: requestHeaders)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - 上传下载方法 (Async/Await)
    
    /// 上传文件 (Async/Await)
    /// - Parameters:
    ///   - fileURL: 本地文件URL
    ///   - url: 上传目标URL
    ///   - method: HTTP方法，默认为POST
    ///   - headers: 请求头
    /// - Returns: 响应数据
    func uploadFile(_ fileURL: URL, 
                    to url: URL, 
                    method: String = "POST", 
                    headers: [String: String]? = nil) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await upload(for: request, fromFile: fileURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
        
        return data
    }
    
    /// 下载文件 (Async/Await)
    /// - Parameters:
    ///   - url: 文件URL
    ///   - headers: 请求头
    ///   - destination: 目标目录URL，默认为文档目录
    /// - Returns: 下载文件的URL
    func downloadFile(from url: URL, 
                      headers: [String: String]? = nil,
                      destination: URL? = nil) async throws -> URL {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (tempURL, response) = try await download(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: nil)
        }
        
        // 创建永久文件URL
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = destination ?? documentsURL.appendingPathComponent(url.lastPathComponent)
        
        if fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.removeItem(at: destinationURL)
        }
        
        try fileManager.copyItem(at: tempURL, to: destinationURL)
        return destinationURL
    }
    
    // MARK: - 便捷闭包方法 (向后兼容)
    
    /// 执行GET请求 (闭包版本)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - headers: 请求头
    ///   - completion: 完成回调
    /// - Returns: URLSessionDataTask
    @discardableResult
    @available(*, deprecated, message: "使用异步版本 get(from:headers:)")
    func get(from url: URL,
             headers: [String: String]? = nil,
             completion: @escaping @Sendable (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        Task {
            do {
                let data = try await get(from: url, headers: headers)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
        
        // 返回一个占位任务
        return URLSessionDataTask()
    }
    
    /// 执行POST请求 (闭包版本)
    /// - Parameters:
    ///   - url: 请求URL
    ///   - body: 请求体数据
    ///   - headers: 请求头
    ///   - completion: 完成回调
    /// - Returns: URLSessionDataTask
    @discardableResult
    @available(*, deprecated, message: "使用异步版本 post(to:body:headers:)")
    func post(to url: URL,
              body: Data? = nil,
              headers: [String: String]? = nil,
              completion: @escaping @Sendable (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        Task {
            do {
                let data = try await post(to: url, body: body, headers: headers)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
        
        // 返回一个占位任务
        return URLSessionDataTask()
    }
}

// MARK: - 网络错误定义

public enum NetworkError: LocalizedError {
    case invalidResponse
    case noData
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case encodingError(Error)
    case invalidURL
    case timeout
    case networkUnavailable
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "无效的响应"
        case .noData:
            return "没有数据"
        case .httpError(let statusCode, _):
            return "HTTP错误: \(statusCode)"
        case .decodingError(let error):
            return "数据解析失败: \(error.localizedDescription)"
        case .encodingError(let error):
            return "数据编码失败: \(error.localizedDescription)"
        case .invalidURL:
            return "无效的URL"
        case .timeout:
            return "请求超时"
        case .networkUnavailable:
            return "网络不可用"
        }
    }
    
    public var statusCode: Int? {
        switch self {
        case .httpError(let statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
    
    public var responseData: Data? {
        switch self {
        case .httpError(_, let data):
            return data
        default:
            return nil
        }
    }
}

// MARK: - URL扩展

public extension URL {
    
    /// 从字符串创建URL，如果无效则抛出错误
    /// - Parameter string: URL字符串
    /// - Returns: URL
    static func from(string: String) throws -> URL {
        guard let url = URL(string: string) else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    /// 安全地从字符串创建URL，如果无效则返回nil
    /// - Parameter string: URL字符串
    /// - Returns: URL或nil
    static func safeInit(_ string: String) -> URL? {
        return URL(string: string)
    }
    
    /// 安全地添加查询参数
    /// - Parameter parameters: 查询参数字典
    /// - Returns: 新的URL
    func addingQueryParameters(_ parameters: [String: String]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        var queryItems = components.queryItems ?? []
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        components.queryItems = queryItems
        return components.url
    }
    
    /// 获取查询参数
    var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        
        var parameters: [String: String] = [:]
        for item in queryItems {
            parameters[item.name] = item.value ?? ""
        }
        
        return parameters
    }
    
    /// 是否是有效的HTTP/HTTPS URL
    var isValidHTTPURL: Bool {
        guard let scheme = scheme?.lowercased() else { return false }
        return scheme == "http" || scheme == "https"
    }
}

// MARK: - URLRequest扩展

public extension URLRequest {
    
    /// 设置JSON请求体
    /// - Parameter encodable: 可编码的对象
    mutating func setJSONBody<T: Encodable>(_ encodable: T) throws {
        httpBody = try JSONEncoder().encode(encodable)
        setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    /// 设置表单数据请求体
    /// - Parameter parameters: 参数字典
    mutating func setFormBody(_ parameters: [String: String]) {
        let formString = parameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        httpBody = formString.data(using: .utf8)
        setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
    
    /// 设置请求头
    /// - Parameter headers: 请求头字典
    mutating func setHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            setValue(value, forHTTPHeaderField: key)
        }
    }
    
    /// 设置授权头
    /// - Parameter token: 授权令牌
    mutating func setAuthorization(_ token: String) {
        setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    /// 设置超时时间
    /// - Parameter timeout: 超时时间（秒）
    mutating func setTimeout(_ timeout: TimeInterval) {
        timeoutInterval = timeout
    }
    
    /// 设置缓存策略
    /// - Parameter cachePolicy: 缓存策略
    mutating func setCachePolicy(_ cachePolicy: URLRequest.CachePolicy) {
        self.cachePolicy = cachePolicy
    }
}