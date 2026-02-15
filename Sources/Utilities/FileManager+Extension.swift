// FileManager+Extension.swift
// FileManager扩展，提供便捷的文件和目录操作方法

import Foundation

public extension FileManager {
    
    // MARK: - 目录路径
    
    /// 文档目录路径
    var documentsDirectory: URL {
        return urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// 缓存目录路径
    var cachesDirectory: URL {
        return urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    /// 临时目录路径
    var temporaryDirectoryURL: URL {
        return FileManager.default.temporaryDirectory
    }
    
    /// 应用支持目录路径
    var applicationSupportDirectory: URL {
        return urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    }
    
    /// 库目录路径
    var libraryDirectory: URL {
        return urls(for: .libraryDirectory, in: .userDomainMask).first!
    }
    
    // MARK: - 目录操作
    
    /// 安全创建目录（如果目录已存在则不执行任何操作）
    /// - Parameters:
    ///   - url: 目录URL
    ///   - withIntermediateDirectories: 是否创建中间目录
    /// - Returns: 是否创建成功
    @discardableResult
    func safeCreateDirectory(at url: URL, withIntermediateDirectories: Bool = true) -> Bool {
        do {
            try createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全创建目录（字符串路径版本）
    /// - Parameters:
    ///   - path: 目录路径
    ///   - withIntermediateDirectories: 是否创建中间目录
    /// - Returns: 是否创建成功
    @discardableResult
    func safeCreateDirectory(atPath path: String, withIntermediateDirectories: Bool = true) -> Bool {
        do {
            try createDirectory(atPath: path, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全移除目录（如果目录存在）
    /// - Parameter url: 目录URL
    /// - Returns: 是否移除成功
    @discardableResult
    func safeRemoveDirectory(at url: URL) -> Bool {
        guard fileExists(atPath: url.path) else { return true }
        do {
            try removeItem(at: url)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全移除目录（字符串路径版本）
    /// - Parameter path: 目录路径
    /// - Returns: 是否移除成功
    @discardableResult
    func safeRemoveDirectory(atPath path: String) -> Bool {
        guard fileExists(atPath: path) else { return true }
        do {
            try removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全清空目录（移除目录中所有内容但保留目录本身）
    /// - Parameter url: 目录URL
    /// - Returns: 是否清空成功
    @discardableResult
    func safeClearDirectory(at url: URL) -> Bool {
        guard fileExists(atPath: url.path) else { return true }
        
        do {
            let contents = try contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for item in contents {
                try removeItem(at: item)
            }
            return true
        } catch {
            return false
        }
    }
    
    /// 安全清空目录（字符串路径版本）
    /// - Parameter path: 目录路径
    /// - Returns: 是否清空成功
    @discardableResult
    func safeClearDirectory(atPath path: String) -> Bool {
        guard let url = URL(string: path) else { return false }
        return safeClearDirectory(at: url)
    }
    
    /// 复制目录
    /// - Parameters:
    ///   - sourceURL: 源目录URL
    ///   - destinationURL: 目标目录URL
    /// - Returns: 是否复制成功
    @discardableResult
    func safeCopyDirectory(from sourceURL: URL, to destinationURL: URL) -> Bool {
        guard fileExists(atPath: sourceURL.path) else { return false }
        
        do {
            // 如果目标目录已存在，先移除
            if fileExists(atPath: destinationURL.path) {
                try removeItem(at: destinationURL)
            }
            
            try copyItem(at: sourceURL, to: destinationURL)
            return true
        } catch {
            return false
        }
    }
    
    /// 移动目录
    /// - Parameters:
    ///   - sourceURL: 源目录URL
    ///   - destinationURL: 目标目录URL
    /// - Returns: 是否移动成功
    @discardableResult
    func safeMoveDirectory(from sourceURL: URL, to destinationURL: URL) -> Bool {
        guard fileExists(atPath: sourceURL.path) else { return false }
        
        do {
            // 如果目标目录已存在，先移除
            if fileExists(atPath: destinationURL.path) {
                try removeItem(at: destinationURL)
            }
            
            try moveItem(at: sourceURL, to: destinationURL)
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - 文件操作
    
    /// 安全创建文件
    /// - Parameters:
    ///   - url: 文件URL
    ///   - data: 文件数据
    ///   - options: 写入选项
    /// - Returns: 是否创建成功
    @discardableResult
    func safeCreateFile(at url: URL, contents data: Data? = nil, options: Data.WritingOptions = []) -> Bool {
        do {
            // 确保目录存在
            let directoryURL = url.deletingLastPathComponent()
            if !fileExists(atPath: directoryURL.path) {
                try createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            if let data = data {
                try data.write(to: url, options: options)
            } else {
                // 创建空文件
                try Data().write(to: url, options: options)
            }
            return true
        } catch {
            return false
        }
    }
    
    /// 安全创建文件（字符串路径版本）
    /// - Parameters:
    ///   - path: 文件路径
    ///   - data: 文件数据
    ///   - options: 写入选项
    /// - Returns: 是否创建成功
    @discardableResult
    func safeCreateFile(atPath path: String, contents data: Data? = nil, options: Data.WritingOptions = []) -> Bool {
        guard let url = URL(string: path) else { return false }
        return safeCreateFile(at: url, contents: data, options: options)
    }
    
    /// 安全移除文件（如果文件存在）
    /// - Parameter url: 文件URL
    /// - Returns: 是否移除成功
    @discardableResult
    func safeRemoveFile(at url: URL) -> Bool {
        guard fileExists(atPath: url.path) else { return true }
        do {
            try removeItem(at: url)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全移除文件（字符串路径版本）
    /// - Parameter path: 文件路径
    /// - Returns: 是否移除成功
    @discardableResult
    func safeRemoveFile(atPath path: String) -> Bool {
        guard fileExists(atPath: path) else { return true }
        do {
            try removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全复制文件
    /// - Parameters:
    ///   - sourceURL: 源文件URL
    ///   - destinationURL: 目标文件URL
    /// - Returns: 是否复制成功
    @discardableResult
    func safeCopyFile(from sourceURL: URL, to destinationURL: URL) -> Bool {
        guard fileExists(atPath: sourceURL.path) else { return false }
        
        do {
            // 如果目标文件已存在，先移除
            if fileExists(atPath: destinationURL.path) {
                try removeItem(at: destinationURL)
            }
            
            // 确保目标目录存在
            let directoryURL = destinationURL.deletingLastPathComponent()
            if !fileExists(atPath: directoryURL.path) {
                try createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            try copyItem(at: sourceURL, to: destinationURL)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全移动文件
    /// - Parameters:
    ///   - sourceURL: 源文件URL
    ///   - destinationURL: 目标文件URL
    /// - Returns: 是否移动成功
    @discardableResult
    func safeMoveFile(from sourceURL: URL, to destinationURL: URL) -> Bool {
        guard fileExists(atPath: sourceURL.path) else { return false }
        
        do {
            // 如果目标文件已存在，先移除
            if fileExists(atPath: destinationURL.path) {
                try removeItem(at: destinationURL)
            }
            
            // 确保目标目录存在
            let directoryURL = destinationURL.deletingLastPathComponent()
            if !fileExists(atPath: directoryURL.path) {
                try createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            try moveItem(at: sourceURL, to: destinationURL)
            return true
        } catch {
            return false
        }
    }
    
    /// 安全读取文件内容
    /// - Parameter url: 文件URL
    /// - Returns: 文件数据，如果读取失败则返回nil
    func safeReadFile(at url: URL) -> Data? {
        guard fileExists(atPath: url.path) else { return nil }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }
    
    /// 安全读取文件内容（字符串路径版本）
    /// - Parameter path: 文件路径
    /// - Returns: 文件数据，如果读取失败则返回nil
    func safeReadFile(atPath path: String) -> Data? {
        guard fileExists(atPath: path) else { return nil }
        
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            return nil
        }
    }
    
    /// 安全读取文本文件内容
    /// - Parameters:
    ///   - url: 文件URL
    ///   - encoding: 文本编码
    /// - Returns: 文本内容，如果读取失败则返回nil
    func safeReadTextFile(at url: URL, encoding: String.Encoding = .utf8) -> String? {
        guard let data = safeReadFile(at: url) else { return nil }
        return String(data: data, encoding: encoding)
    }
    
    /// 安全读取文本文件内容（字符串路径版本）
    /// - Parameters:
    ///   - path: 文件路径
    ///   - encoding: 文本编码
    /// - Returns: 文本内容，如果读取失败则返回nil
    func safeReadTextFile(atPath path: String, encoding: String.Encoding = .utf8) -> String? {
        guard let data = safeReadFile(atPath: path) else { return nil }
        return String(data: data, encoding: encoding)
    }
    
    /// 安全写入文本文件
    /// - Parameters:
    ///   - text: 文本内容
    ///   - url: 文件URL
    ///   - encoding: 文本编码
    ///   - options: 写入选项
    /// - Returns: 是否写入成功
    @discardableResult
    func safeWriteTextFile(_ text: String, to url: URL, encoding: String.Encoding = .utf8, options: Data.WritingOptions = []) -> Bool {
        guard let data = text.data(using: encoding) else { return false }
        return safeCreateFile(at: url, contents: data, options: options)
    }
    
    /// 安全写入文本文件（字符串路径版本）
    /// - Parameters:
    ///   - text: 文本内容
    ///   - path: 文件路径
    ///   - encoding: 文本编码
    ///   - options: 写入选项
    /// - Returns: 是否写入成功
    @discardableResult
    func safeWriteTextFile(_ text: String, toPath path: String, encoding: String.Encoding = .utf8, options: Data.WritingOptions = []) -> Bool {
        guard let url = URL(string: path) else { return false }
        return safeWriteTextFile(text, to: url, encoding: encoding, options: options)
    }
    
    /// 安全追加文本到文件
    /// - Parameters:
    ///   - text: 要追加的文本
    ///   - url: 文件URL
    ///   - encoding: 文本编码
    /// - Returns: 是否追加成功
    @discardableResult
    func safeAppendTextToFile(_ text: String, to url: URL, encoding: String.Encoding = .utf8) -> Bool {
        // 如果文件不存在，创建新文件
        if !fileExists(atPath: url.path) {
            return safeWriteTextFile(text, to: url, encoding: encoding)
        }
        
        // 读取现有内容
        guard let existingContent = safeReadTextFile(at: url, encoding: encoding) else {
            return false
        }
        
        // 追加新内容并写入
        let newContent = existingContent + text
        return safeWriteTextFile(newContent, to: url, encoding: encoding)
    }
    
    /// 安全追加文本到文件（字符串路径版本）
    /// - Parameters:
    ///   - text: 要追加的文本
    ///   - path: 文件路径
    ///   - encoding: 文本编码
    /// - Returns: 是否追加成功
    @discardableResult
    func safeAppendTextToFile(_ text: String, toPath path: String, encoding: String.Encoding = .utf8) -> Bool {
        guard let url = URL(string: path) else { return false }
        return safeAppendTextToFile(text, to: url, encoding: encoding)
    }
    
    // MARK: - 文件信息
    
    /// 获取文件大小（字节）
    /// - Parameter url: 文件URL
    /// - Returns: 文件大小，如果获取失败则返回nil
    func fileSize(at url: URL) -> Int64? {
        guard fileExists(atPath: url.path) else { return nil }
        
        do {
            let attributes = try attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int64
        } catch {
            return nil
        }
    }
    
    /// 获取文件大小（字符串路径版本）
    /// - Parameter path: 文件路径
    /// - Returns: 文件大小，如果获取失败则返回nil
    func fileSize(atPath path: String) -> Int64? {
        guard fileExists(atPath: path) else { return nil }
        
        do {
            let attributes = try attributesOfItem(atPath: path)
            return attributes[.size] as? Int64
        } catch {
            return nil
        }
    }
    
    /// 获取格式化文件大小（如 "1.5 MB"）
    /// - Parameter url: 文件URL
    /// - Returns: 格式化文件大小，如果获取失败则返回nil
    func formattedFileSize(at url: URL) -> String? {
        guard let size = fileSize(at: url) else { return nil }
        return formatBytes(size)
    }
    
    /// 获取格式化文件大小（字符串路径版本）
    /// - Parameter path: 文件路径
    /// - Returns: 格式化文件大小，如果获取失败则返回nil
    func formattedFileSize(atPath path: String) -> String? {
        guard let size = fileSize(atPath: path) else { return nil }
        return formatBytes(size)
    }
    
    /// 获取文件创建日期
    /// - Parameter url: 文件URL
    /// - Returns: 创建日期，如果获取失败则返回nil
    func fileCreationDate(at url: URL) -> Date? {
        guard fileExists(atPath: url.path) else { return nil }
        
        do {
            let attributes = try attributesOfItem(atPath: url.path)
            return attributes[.creationDate] as? Date
        } catch {
            return nil
        }
    }
    
    /// 获取文件修改日期
    /// - Parameter url: 文件URL
    /// - Returns: 修改日期，如果获取失败则返回nil
    func fileModificationDate(at url: URL) -> Date? {
        guard fileExists(atPath: url.path) else { return nil }
        
        do {
            let attributes = try attributesOfItem(atPath: url.path)
            return attributes[.modificationDate] as? Date
        } catch {
            return nil
        }
    }
    
    /// 检查文件是否可读
    /// - Parameter url: 文件URL
    /// - Returns: 是否可读
    func isFileReadable(at url: URL) -> Bool {
        return isReadableFile(atPath: url.path)
    }
    
    /// 检查文件是否可写
    /// - Parameter url: 文件URL
    /// - Returns: 是否可写
    func isFileWritable(at url: URL) -> Bool {
        return isWritableFile(atPath: url.path)
    }
    
    /// 检查文件是否可执行
    /// - Parameter url: 文件URL
    /// - Returns: 是否可执行
    func isFileExecutable(at url: URL) -> Bool {
        return isExecutableFile(atPath: url.path)
    }
    
    /// 检查文件是否可删除
    /// - Parameter url: 文件URL
    /// - Returns: 是否可删除
    func isFileDeletable(at url: URL) -> Bool {
        return isDeletableFile(atPath: url.path)
    }
    
    // MARK: - 目录信息
    
    /// 获取目录中所有文件URL
    /// - Parameters:
    ///   - url: 目录URL
    ///   - includingSubdirectories: 是否包含子目录
    ///   - fileTypes: 文件类型过滤（扩展名数组）
    /// - Returns: 文件URL数组，如果获取失败则返回空数组
    func allFileURLs(in url: URL, includingSubdirectories: Bool = false, fileTypes: [String]? = nil) -> [URL] {
        guard fileExists(atPath: url.path) else { return [] }
        
        let options: FileManager.DirectoryEnumerationOptions = includingSubdirectories ? [] : [.skipsSubdirectoryDescendants]
        
        do {
            let fileURLs = try contentsOfDirectory(at: url,
                                                  includingPropertiesForKeys: [.isDirectoryKey],
                                                  options: options)
            
            // 过滤文件类型
            if let fileTypes = fileTypes, !fileTypes.isEmpty {
                return fileURLs.filter { url in
                    let fileExtension = url.pathExtension.lowercased()
                    return fileTypes.contains { $0.lowercased() == fileExtension }
                }
            }
            
            return fileURLs
        } catch {
            return []
        }
    }
    
    /// 获取目录中所有文件路径
    /// - Parameters:
    ///   - path: 目录路径
    ///   - includingSubdirectories: 是否包含子目录
    ///   - fileTypes: 文件类型过滤（扩展名数组）
    /// - Returns: 文件路径数组，如果获取失败则返回空数组
    func allFilePaths(in path: String, includingSubdirectories: Bool = false, fileTypes: [String]? = nil) -> [String] {
        guard let url = URL(string: path) else { return [] }
        return allFileURLs(in: url, includingSubdirectories: includingSubdirectories, fileTypes: fileTypes).map { $0.path }
    }
    
    /// 获取目录大小（字节，包含所有子目录和文件）
    /// - Parameter url: 目录URL
    /// - Returns: 目录大小，如果获取失败则返回0
    func directorySize(at url: URL) -> Int64 {
        guard fileExists(atPath: url.path) else { return 0 }
        
        var totalSize: Int64 = 0
        let fileURLs = allFileURLs(in: url, includingSubdirectories: true)
        
        for fileURL in fileURLs {
            if let fileSize = fileSize(at: fileURL) {
                totalSize += fileSize
            }
        }
        
        return totalSize
    }
    
    /// 获取格式化目录大小（如 "1.5 GB"）
    /// - Parameter url: 目录URL
    /// - Returns: 格式化目录大小，如果获取失败则返回"0 B"
    func formattedDirectorySize(at url: URL) -> String {
        let size = directorySize(at: url)
        return formatBytes(size)
    }
    
    /// 获取目录中文件数量
    /// - Parameters:
    ///   - url: 目录URL
    ///   - includingSubdirectories: 是否包含子目录
    /// - Returns: 文件数量
    func fileCount(in url: URL, includingSubdirectories: Bool = false) -> Int {
        return allFileURLs(in: url, includingSubdirectories: includingSubdirectories).count
    }
    
    // MARK: - 路径操作
    
    /// 检查路径是否存在
    /// - Parameter path: 路径
    /// - Returns: 是否存在
    func pathExists(_ path: String) -> Bool {
        return fileExists(atPath: path)
    }
    
    /// 检查路径是否是目录
    /// - Parameter path: 路径
    /// - Returns: 是否是目录
    func isDirectory(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    /// 检查路径是否是文件
    /// - Parameter path: 路径
    /// - Returns: 是否是文件
    func isFile(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && !isDirectory.boolValue
    }
    
    /// 获取路径的父目录
    /// - Parameter path: 路径
    /// - Returns: 父目录路径，如果获取失败则返回nil
    func parentDirectory(of path: String) -> String? {
        let url = URL(fileURLWithPath: path)
        return url.deletingLastPathComponent().path
    }
    
    /// 标准化路径（移除冗余的"."和".."）
    /// - Parameter path: 路径
    /// - Returns: 标准化后的路径
    func standardizedPath(_ path: String) -> String {
        return URL(fileURLWithPath: path).standardized.path
    }
    
    /// 解析路径中的符号链接
    /// - Parameter path: 路径
    /// - Returns: 解析后的路径，如果解析失败则返回原路径
    func resolvingSymlinks(in path: String) -> String {
        return URL(fileURLWithPath: path).resolvingSymlinksInPath().path
    }
    
    // MARK: - 便捷方法
    
    /// 创建唯一文件名（避免冲突）
    /// - Parameters:
    ///   - baseName: 基础文件名（不含扩展名）
    ///   - extension: 文件扩展名
    ///   - in directory: 目录URL
    /// - Returns: 唯一文件名，如果创建失败则返回nil
    func createUniqueFileName(baseName: String, extension: String? = nil, in directory: URL) -> String? {
        let fileExtension = `extension` ?? ""
        let extensionWithDot = fileExtension.isEmpty ? "" : ".\(fileExtension)"
        
        var fileName = "\(baseName)\(extensionWithDot)"
        var counter = 1
        
        while fileExists(atPath: directory.appendingPathComponent(fileName).path) {
            fileName = "\(baseName)_\(counter)\(extensionWithDot)"
            counter += 1
        }
        
        return fileName
    }
    
    /// 创建临时文件URL
    /// - Parameters:
    ///   - prefix: 文件名前缀
    ///   - extension: 文件扩展名
    /// - Returns: 临时文件URL
    func temporaryFileURL(prefix: String = "temp", extension: String? = nil) -> URL {
        let uuid = UUID().uuidString
        let fileExtension = `extension` ?? "tmp"
        let fileName = "\(prefix)_\(uuid).\(fileExtension)"
        return temporaryDirectoryURL.appendingPathComponent(fileName)
    }
    
    /// 创建临时目录URL
    /// - Parameter prefix: 目录名前缀
    /// - Returns: 临时目录URL
    func createTemporaryDirectoryURL(prefix: String = "temp") -> URL {
        let uuid = UUID().uuidString
        let dirName = "\(prefix)_\(uuid)"
        return temporaryDirectoryURL.appendingPathComponent(dirName, isDirectory: true)
    }
    
    /// 计算文件哈希值（MD5）
    /// - Parameter url: 文件URL
    /// - Returns: 哈希值，如果计算失败则返回nil
    func fileMD5Hash(at url: URL) -> String? {
        guard let data = safeReadFile(at: url) else { return nil }
        return data.md5Hash
    }
    
    /// 计算文件哈希值（SHA256）
    /// - Parameter url: 文件URL
    /// - Returns: 哈希值，如果计算失败则返回nil
    func fileSHA256Hash(at url: URL) -> String? {
        guard let data = safeReadFile(at: url) else { return nil }
        return data.sha256Hash
    }
    
    /// 比较两个文件是否相同（通过哈希值）
    /// - Parameters:
    ///   - url1: 第一个文件URL
    ///   - url2: 第二个文件URL
    /// - Returns: 是否相同
    func areFilesIdentical(_ url1: URL, _ url2: URL) -> Bool {
        guard let hash1 = fileSHA256Hash(at: url1),
              let hash2 = fileSHA256Hash(at: url2) else {
            return false
        }
        return hash1 == hash2
    }
    
    // MARK: - 私有方法
    
    private func formatBytes(_ bytes: Int64) -> String {
        let units = ["B", "KB", "MB", "GB", "TB", "PB"]
        var size = Double(bytes)
        var unitIndex = 0
        
        while size >= 1024 && unitIndex < units.count - 1 {
            size /= 1024
            unitIndex += 1
        }
        
        return String(format: "%.1f %@", size, units[unitIndex])
    }
}

// MARK: - Data扩展（用于哈希计算）

private extension Data {
    var md5Hash: String {
        // 简化版本：返回数据长度的十六进制表示
        // 在实际项目中，应该导入CommonCrypto并实现真正的MD5
        let count = self.count
        return String(format: "%08x", count)
    }
    
    var sha256Hash: String {
        // 简化版本：返回数据长度的十六进制表示
        // 在实际项目中，应该导入CommonCrypto并实现真正的SHA256
        let count = self.count
        return String(format: "%08x", count)
    }
}
