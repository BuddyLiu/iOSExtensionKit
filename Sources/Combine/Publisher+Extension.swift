// Publisher+Extension.swift
// Combine Publisher扩展，提供便捷的操作符和实用方法

#if canImport(Combine)
import Combine
import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    
    // MARK: - 错误处理
    
    /// 替换错误为默认值
    /// - Parameter defaultValue: 默认值
    func replaceError(with defaultValue: Output) -> AnyPublisher<Output, Never> {
        self.catch { _ in
            Just(defaultValue)
        }
        .eraseToAnyPublisher()
    }
    
    /// 忽略错误，转换为Result
    func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map { .success($0) }
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
#endif
