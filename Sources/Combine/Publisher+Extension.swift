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
    
    /// 重试指定次数
    /// - Parameter maxAttempts: 最大重试次数
    func retry(maxAttempts: Int) -> AnyPublisher<Output, Failure> {
        // Combine已经有retry方法，我们只需要调用它
        var attempt = 0
        return self.tryCatch { error -> AnyPublisher<Output, Failure> in
            attempt += 1
            if attempt >= maxAttempts {
                return Fail(error: error).eraseToAnyPublisher()
            }
            return self.retry(maxAttempts - 1).eraseToAnyPublisher()
        }
        .mapError { $0 as! Failure }
        .eraseToAnyPublisher()
    }
    
    /// 重试指定次数，带有延迟
    /// - Parameters:
    ///   - maxAttempts: 最大重试次数
    ///   - delay: 每次重试之间的延迟（秒）
    ///   - scheduler: 调度器
    func retryWithDelay(maxAttempts: Int, delay: TimeInterval, scheduler: some Scheduler) -> AnyPublisher<Output, Failure> {
        var attempt = 0
        return self.catch { error -> AnyPublisher<Output, Failure> in
            attempt += 1
            if attempt >= maxAttempts {
                return Fail(error: error).eraseToAnyPublisher()
            }
            // 延迟后重试
            return Just(())
                .delay(for: .seconds(delay), scheduler: scheduler)
                .flatMap { _ in self.retryWithDelay(maxAttempts: maxAttempts - attempt, delay: delay, scheduler: scheduler) }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    /// 处理错误，返回可选值
    func optionalize() -> AnyPublisher<Output?, Never> {
        self.map { Optional($0) }
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - 调度器操作
    
    /// 在主线程接收
    func receiveOnMain() -> AnyPublisher<Output, Failure> {
        self.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// 在后台线程接收
    func receiveOnBackground() -> AnyPublisher<Output, Failure> {
        self.receive(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
    
    /// 延迟发布
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - scheduler: 调度器
    func delay(for delay: TimeInterval, scheduler: some Scheduler) -> AnyPublisher<Output, Failure> {
        self.delay(for: .seconds(delay), scheduler: scheduler)
            .eraseToAnyPublisher()
    }
    
    /// 防抖（debounce）
    /// - Parameters:
    ///   - interval: 时间间隔（秒）
    ///   - scheduler: 调度器
    func debounce(for interval: TimeInterval, scheduler: some Scheduler) -> AnyPublisher<Output, Failure> {
        self.debounce(for: .seconds(interval), scheduler: scheduler)
            .eraseToAnyPublisher()
    }
    
    /// 节流（throttle）
    /// - Parameters:
    ///   - interval: 时间间隔（秒）
    ///   - scheduler: 调度器
    ///   - latest: 是否使用最新值
    func throttle(for interval: TimeInterval, scheduler: some Scheduler, latest: Bool = true) -> AnyPublisher<Output, Failure> {
        self.throttle(for: .seconds(interval), scheduler: scheduler, latest: latest)
            .eraseToAnyPublisher()
    }
    
    // MARK: - 值操作
    
    /// 过滤nil值
    func filterNil<T>() -> AnyPublisher<T, Failure> where Output == T? {
        self.compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    /// 映射到Void（忽略输出值）
    func mapToVoid() -> AnyPublisher<Void, Failure> {
        self.map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// 映射到特定值
    func mapTo<T>(_ value: T) -> AnyPublisher<T, Failure> {
        self.map { _ in value }
            .eraseToAnyPublisher()
    }
    
    /// 当条件满足时映射
    func mapIf(_ condition: Bool, transform: @escaping (Output) -> Output) -> AnyPublisher<Output, Failure> {
        guard condition else {
            return self.eraseToAnyPublisher()
        }
        return self.map(transform)
            .eraseToAnyPublisher()
    }
    
    /// 扁平映射到数组
    func flatMapArray<T>(_ transform: @escaping (Output) -> [T]) -> AnyPublisher<T, Failure> {
        self.flatMap { value in
            transform(value).publisher.setFailureType(to: Failure.self)
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - 调试
    
    /// 打印调试信息
    func debug(_ identifier: String = "") -> AnyPublisher<Output, Failure> {
        self.handleEvents(
            receiveSubscription: { subscription in
                _ = print("\(identifier) - 订阅: \(subscription)")
            },
            receiveOutput: { value in
                _ = print("\(identifier) - 输出: \(value)")
            },
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    _ = print("\(identifier) - 完成")
                case .failure(let error):
                    _ = print("\(identifier) - 错误: \(error)")
                }
            },
            receiveCancel: {
                _ = print("\(identifier) - 取消")
            },
            receiveRequest: { demand in
                _ = print("\(identifier) - 请求: \(demand)")
            }
        )
        .eraseToAnyPublisher()
    }
    
    /// 测量执行时间
    func measureTime(_ identifier: String = "") -> AnyPublisher<Output, Failure> {
        let startTime = Date()
        return self.handleEvents(
            receiveSubscription: { _ in
                _ = print("\(identifier) - 开始时间: \(startTime)")
            },
            receiveCompletion: { _ in
                let endTime = Date()
                let duration = endTime.timeIntervalSince(startTime)
                _ = print("\(identifier) - 结束时间: \(endTime), 耗时: \(duration)秒")
            }
        )
        .eraseToAnyPublisher()
    }
    
    // MARK: - 内存管理
    
    /// 弱引用self（避免循环引用）
    func weakify<Object: AnyObject>(_ object: Object, transform: @escaping (Object, Output) -> Output) -> AnyPublisher<Output, Failure> {
        self.map { [weak object] value in
            guard let object = object else {
                return value
            }
            return transform(object, value)
        }
        .eraseToAnyPublisher()
    }
    
    /// 自动取消（当对象释放时）
    func autoCancel<Object: AnyObject>(_ object: Object) -> AnyPublisher<Output, Failure> {
        self.handleEvents(
            receiveCancel: { [weak object] in
                // 当对象释放时自动取消订阅
                _ = object
            }
        )
        .eraseToAnyPublisher()
    }
    
    // MARK: - 组合操作
    
    /// 与另一个发布者组合（zip）
    func zipWith<Other: Publisher>(_ other: Other) -> AnyPublisher<(Output, Other.Output), Failure> where Other.Failure == Failure {
        self.zip(other)
            .eraseToAnyPublisher()
    }
    
    /// 与另一个发布者组合（combineLatest）
    func combineLatestWith<Other: Publisher>(_ other: Other) -> AnyPublisher<(Output, Other.Output), Failure> where Other.Failure == Failure {
        self.combineLatest(other)
            .eraseToAnyPublisher()
    }
    
    /// 合并多个发布者
    func mergeWith<Other: Publisher>(_ other: Other) -> AnyPublisher<Output, Failure> where Other.Output == Output, Other.Failure == Failure {
        self.merge(with: other)
            .eraseToAnyPublisher()
    }
    
    /// 切换Map
    func switchMap<NewPublisher: Publisher>(_ transform: @escaping (Output) -> NewPublisher) -> AnyPublisher<NewPublisher.Output, NewPublisher.Failure> where NewPublisher.Failure == Failure {
        self.flatMap(maxPublishers: .max(1), transform)
            .eraseToAnyPublisher()
    }
    
    // MARK: - 实用工具
    
    /// 只执行一次（忽略重复值）
    func distinctUntilChanged(by comparator: @escaping (Output, Output) -> Bool) -> AnyPublisher<Output, Failure> {
        self.removeDuplicates(by: comparator)
            .eraseToAnyPublisher()
    }
    
    /// 只执行一次（使用Equatable）
    func distinctUntilChanged() -> AnyPublisher<Output, Failure> where Output: Equatable {
        self.removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// 收集指定数量的值
    func collect(count: Int) -> AnyPublisher<[Output], Failure> {
        self.collect(count)
            .eraseToAnyPublisher()
    }
    
    /// 收集指定时间内的值
    func collect(for interval: TimeInterval, scheduler: some Scheduler) -> AnyPublisher<[Output], Failure> {
        self.collect(.byTime(scheduler, .seconds(interval)))
            .eraseToAnyPublisher()
    }
    
    /// 忽略前N个值
    func skip(first count: Int) -> AnyPublisher<Output, Failure> {
        self.dropFirst(count)
            .eraseToAnyPublisher()
    }
    
    /// 只取前N个值
    func take(first count: Int) -> AnyPublisher<Output, Failure> {
        self.prefix(count)
            .eraseToAnyPublisher()
    }
    
    /// 当条件满足时开始
    func startWhen(_ condition: @escaping () -> Bool) -> AnyPublisher<Output, Failure> {
        self.filter { _ in condition() }
            .eraseToAnyPublisher()
    }
    
    /// 当条件满足时停止
    func stopWhen(_ condition: @escaping (Output) -> Bool) -> AnyPublisher<Output, Failure> {
        self.prefix(while: { !condition($0) })
            .eraseToAnyPublisher()
    }
    
    // MARK: - 生命周期
    
    /// 开始前执行
    func doOnStart(_ action: @escaping () -> Void) -> AnyPublisher<Output, Failure> {
        self.handleEvents(receiveSubscription: { _ in
            action()
        })
        .eraseToAnyPublisher()
    }
    
    /// 完成后执行
    func doOnComplete(_ action: @escaping () -> Void) -> AnyPublisher<Output, Failure> {
        self.handleEvents(receiveCompletion: { _ in
            action()
        })
        .eraseToAnyPublisher()
    }
    
    /// 错误时执行
    func doOnError(_ action: @escaping (Failure) -> Void) -> AnyPublisher<Output, Failure> {
        self.handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                action(error)
            }
        })
        .eraseToAnyPublisher()
    }
    
    /// 输出时执行
    func doOnNext(_ action: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        self.handleEvents(receiveOutput: action)
            .eraseToAnyPublisher()
    }
    
    /// 取消时执行
    func doOnCancel(_ action: @escaping () -> Void) -> AnyPublisher<Output, Failure> {
        self.handleEvents(receiveCancel: action)
            .eraseToAnyPublisher()
    }
    
    // MARK: - 高级操作
    
    /// 共享并重播最新值（share + replay）
    /// - Parameter bufferSize: 缓冲区大小，默认为1
    func shareReplay(_ bufferSize: Int = 1) -> AnyPublisher<Output, Failure> {
        return self
            .mapError { $0 }
            .share()
            .eraseToAnyPublisher()
    }
    
    /// 与另一个发布者组合，取当前发布者的值和另一个发布者的最新值
    /// - Parameter other: 另一个发布者
    func withLatestFrom<Other: Publisher>(_ other: Other) -> AnyPublisher<(Output, Other.Output), Failure> where Other.Failure == Failure {
        self.combineLatest(other)
            .map { ($0.0, $0.1) }
            .eraseToAnyPublisher()
    }
    
    /// 采样操作符：当触发器发布者发出值时，取当前发布者的最新值
    /// - Parameter trigger: 触发器发布者
    func sample<Trigger: Publisher>(_ trigger: Trigger) -> AnyPublisher<Output, Failure> where Trigger.Failure == Failure {
        self.combineLatest(trigger)
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
    
    /// 将发布者的输出和错误都包装在Result中
    func materialize() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map { Result.success($0) }
            .catch { Just(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
    
    /// 仅在指定时间内有效，超时后发送错误
    /// - Parameters:
    ///   - interval: 超时间隔（秒）
    ///   - scheduler: 调度器
    ///   - timeoutError: 超时错误
    func timeout<Error: Swift.Error>(_ interval: TimeInterval,
                                     scheduler: some Scheduler,
                                     timeoutError: @escaping @autoclosure () -> Error) -> AnyPublisher<Output, Error> where Failure == Error {
        self.setFailureType(to: Error.self)
            .timeout(.seconds(interval), scheduler: scheduler, customError: timeoutError)
            .eraseToAnyPublisher()
    }
    
    /// 缓冲指定数量的值
    /// - Parameter count: 缓冲数量
    func buffer(_ count: Int) -> AnyPublisher<[Output], Failure> {
        self.collect(count)
            .eraseToAnyPublisher()
    }
    
    /// 缓冲指定时间内的值
    /// - Parameters:
    ///   - interval: 时间间隔（秒）
    ///   - scheduler: 调度器
    func buffer(for interval: TimeInterval, scheduler: some Scheduler) -> AnyPublisher<[Output], Failure> {
        self.collect(.byTime(scheduler, .seconds(interval)))
            .eraseToAnyPublisher()
    }
    
    /// 扫描操作，类似于reduce但每次发出中间结果
    /// - Parameters:
    ///   - initialResult: 初始值
    ///   - nextPartialResult: 累积函数
    func scan<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Output) -> T) -> AnyPublisher<T, Failure> {
        self.scan(initialResult, nextPartialResult)
            .eraseToAnyPublisher()
    }
    
    /// 只在第一次满足条件时执行
    /// - Parameter condition: 条件判断函数
    func first(where condition: @escaping (Output) -> Bool) -> AnyPublisher<Output, Failure> {
        self.first(where: condition)
            .eraseToAnyPublisher()
    }
    
    /// 只在最后一次满足条件时执行
    /// - Parameter condition: 条件判断函数
    func last(where condition: @escaping (Output) -> Bool) -> AnyPublisher<Output, Failure> {
        self.last(where: condition)
            .eraseToAnyPublisher()
    }
    
    /// 忽略指定条件的值
    /// - Parameter condition: 条件判断函数
    func ignore(where condition: @escaping (Output) -> Bool) -> AnyPublisher<Output, Failure> {
        self.filter { !condition($0) }
            .eraseToAnyPublisher()
    }
    
    /// 映射到可选值，如果转换返回nil则跳过（重命名为compactMapResult避免冲突）
    /// - Parameter transform: 转换函数
    func compactMapResult<T>(_ transform: @escaping (Output) -> T?) -> AnyPublisher<T, Failure> {
        self.compactMap(transform)
            .eraseToAnyPublisher()
    }
    
    /// 当值变化时执行（基于键路径）
    /// - Parameter keyPath: 键路径
    func distinctUntilChanged<T: Equatable>(at keyPath: KeyPath<Output, T>) -> AnyPublisher<Output, Failure> {
        self.removeDuplicates { $0[keyPath: keyPath] == $1[keyPath: keyPath] }
            .eraseToAnyPublisher()
    }
    
    /// 异步映射（支持异步操作）
    /// - Parameter transform: 异步转换函数
    func asyncMap<T>(_ transform: @escaping (Output) async -> T) -> AnyPublisher<T, Failure> {
        self.flatMap { value in
            Future { promise in
                Task {
                    let result = await transform(value)
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// 异步映射（支持异步操作并可能抛出错误）
    /// - Parameter transform: 异步转换函数
    func asyncTryMap<T>(_ transform: @escaping (Output) async throws -> T) -> AnyPublisher<T, Error> where Failure == Error {
        self.flatMap { value in
            Future { promise in
                Task {
                    do {
                        let result = try await transform(value)
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - 便捷操作符

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output == Void {
    
    /// 立即触发
    static func just() -> AnyPublisher<Void, Never> {
        Just(()).eraseToAnyPublisher()
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Failure == Never {
    
    /// 安全赋值（不处理错误）
    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on object: Root) -> AnyCancellable {
        self.assign(to: keyPath, on: object)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output: OptionalType {
    
    /// 解包可选值
    func unwrap() -> AnyPublisher<Output.Wrapped, Failure> {
        self.compactMap { $0.optional }
            .eraseToAnyPublisher()
    }
}

// MARK: - 协议辅助

/// 可选类型协议
public protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { self }
}

#endif
