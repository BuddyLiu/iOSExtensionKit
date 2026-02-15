// DispatchQueueExtensionTests.swift
// 测试DispatchQueue扩展功能

import XCTest
@testable import iOSExtensionKit

final class DispatchQueueExtensionTests: XCTestCase {
    
    // MARK: - 基本功能测试
    
    func testSafeAsync() {
        let expectation = XCTestExpectation(description: "异步任务完成")
        
        DispatchQueue.main.safeAsync {
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSafeAsyncAfter() {
        let expectation = XCTestExpectation(description: "延迟异步任务完成")
        let startTime = Date()
        
        DispatchQueue.main.safeAsyncAfter(interval: 0.1) {
            XCTAssertTrue(Thread.isMainThread)
            let elapsed = Date().timeIntervalSince(startTime)
            XCTAssertGreaterThan(elapsed, 0.09) // 稍微宽松一点
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSafeSync() {
        let expectation = XCTestExpectation(description: "同步任务完成")
        
        let result = DispatchQueue.global().safeSync {
            expectation.fulfill()
            return 42
        }
        
        XCTAssertEqual(result, 42)
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - 屏障操作测试
    
    func testSafeAsyncBarrier() {
        let expectation = XCTestExpectation(description: "异步屏障操作完成")
        
        let queue = DispatchQueue(label: "com.test.barrier", attributes: .concurrent)
        
        queue.safeAsyncBarrier {
            // 屏障操作应该等待前面所有任务完成
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSafeSyncBarrier() {
        let expectation = XCTestExpectation(description: "同步屏障操作完成")
        
        let queue = DispatchQueue(label: "com.test.syncbarrier", attributes: .concurrent)
        
        let result = queue.safeSyncBarrier {
            expectation.fulfill()
            return "test"
        }
        
        XCTAssertEqual(result, "test")
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - 便捷全局队列测试
    
    func testSafeMain() {
        let mainQueue = DispatchQueue.safeMain
        XCTAssertEqual(mainQueue, DispatchQueue.main)
    }
    
    func testSafeGlobal() {
        let globalQueue = DispatchQueue.safeGlobal(qos: .default)
        XCTAssertNotNil(globalQueue)
    }
    
    func testSafeMainAsyncAfter() {
        let expectation = XCTestExpectation(description: "主队列延迟执行完成")
        let startTime = Date()
        
        DispatchQueue.safeMainAsyncAfter(interval: 0.1) {
            XCTAssertTrue(Thread.isMainThread)
            let elapsed = Date().timeIntervalSince(startTime)
            XCTAssertGreaterThan(elapsed, 0.09) // 稍微宽松一点
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - AsyncTask测试
    
    func testAsyncTaskRun() async {
        do {
            let result = try await AsyncTask.run {
                // 模拟耗时操作
                Thread.sleep(forTimeInterval: 0.01)
                return "async_result"
            }
            
            XCTAssertEqual(result, "async_result")
        } catch {
            XCTFail("不应该抛出错误: \(error)")
        }
    }
    
    func testAsyncTaskRunThrowing() async {
        do {
            _ = try await AsyncTask.run {
                throw NSError(domain: "TestError", code: 42)
            }
            XCTFail("应该抛出错误")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "TestError")
            XCTAssertEqual(nsError.code, 42)
        }
    }
    
    func testAsyncTaskOnMain() {
        let expectation = XCTestExpectation(description: "主线程任务完成")
        
        AsyncTask.onMain {
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAsyncTaskOnMainAsync() async {
        do {
            let result = try await AsyncTask.onMain {
                XCTAssertTrue(Thread.isMainThread)
                return "main_thread_result"
            }
            
            XCTAssertEqual(result, "main_thread_result")
        } catch {
            XCTFail("不应该抛出错误")
        }
    }
    
    func testAsyncTaskDelayed() {
        let expectation = XCTestExpectation(description: "延迟任务完成")
        let startTime = Date()
        
        AsyncTask.delayed(interval: 0.1) {
            let elapsed = Date().timeIntervalSince(startTime)
            XCTAssertGreaterThan(elapsed, 0.09) // 稍微宽松一点
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - ThreadSafe测试
    
    func testThreadSafeValue() {
        let safeValue = ThreadSafe(42)
        
        XCTAssertEqual(safeValue.value, 42)
        
        safeValue.value = 100
        XCTAssertEqual(safeValue.value, 100)
    }
    
    func testThreadSafeMutate() {
        let safeCounter = ThreadSafe(0)
        
        // 模拟并发修改
        let group = DispatchGroup()
        let iterations = 100
        
        for _ in 0..<iterations {
            group.enter()
            DispatchQueue.global().async {
                safeCounter.mutate { $0 += 1 }
                group.leave()
            }
        }
        
        let result = group.wait(timeout: .now() + 5.0)
        XCTAssertEqual(result, .success)
        XCTAssertEqual(safeCounter.value, iterations)
    }
    
    func testThreadSafeGetAndSet() {
        let safeValue = ThreadSafe("old_value")
        
        let oldValue = safeValue.getAndSet("new_value")
        XCTAssertEqual(oldValue, "old_value")
        XCTAssertEqual(safeValue.value, "new_value")
    }
    
    // MARK: - SafeSemaphore测试
    
    func testSafeSemaphore() {
        let semaphore = SafeSemaphore(value: 0)
        let expectation = XCTestExpectation(description: "信号量测试完成")
        
        DispatchQueue.global().async {
            // 等待信号量
            let result = semaphore.wait(timeout: .now() + 0.5)
            XCTAssertEqual(result, .success)
            
            expectation.fulfill()
        }
        
        // 主线程发送信号
        semaphore.signal()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSafeSemaphoreTimeout() {
        let semaphore = SafeSemaphore(value: 0)
        
        let result = semaphore.wait(timeout: .now() + 0.1)
        XCTAssertEqual(result, .timedOut)
    }
    
    // MARK: - 并发性能测试
    
    func testConcurrentPerformSafe() {
        let results = ThreadSafe([Int]())
        
        DispatchQueue.concurrentPerformSafe(iterations: 10) { index in
            results.mutate { array in
                array.append(index * 2)
            }
        }
        
        XCTAssertEqual(results.value.count, 10)
        XCTAssertEqual(results.value.sorted(), [0, 2, 4, 6, 8, 10, 12, 14, 16, 18])
    }
    
    // MARK: - 全局便捷函数测试
    
    func testOnMainThread() {
        let expectation = XCTestExpectation(description: "onMainThread完成")
        
        onMainThread {
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOnMainThreadAsync() async {
        do {
            let result = try await onMainThread {
                XCTAssertTrue(Thread.isMainThread)
                return "main_thread"
            }
            
            XCTAssertEqual(result, "main_thread")
        } catch {
            XCTFail("不应该抛出错误")
        }
    }
    
    func testOnBackgroundThread() {
        let expectation = XCTestExpectation(description: "onBackgroundThread完成")
        
        onBackgroundThread {
            XCTAssertFalse(Thread.isMainThread)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOnBackgroundThreadAsync() async {
        do {
            let result = try await onBackgroundThread {
                XCTAssertFalse(Thread.isMainThread)
                return "background_thread"
            }
            
            XCTAssertEqual(result, "background_thread")
        } catch {
            XCTFail("不应该抛出错误")
        }
    }
    
    // MARK: - 边界条件测试
    
    func testThreadSafeInitialValue() {
        let stringValue = ThreadSafe("initial")
        let intValue = ThreadSafe(0)
        let doubleValue = ThreadSafe(0.0)
        let boolValue = ThreadSafe(false)
        
        XCTAssertEqual(stringValue.value, "initial")
        XCTAssertEqual(intValue.value, 0)
        XCTAssertEqual(doubleValue.value, 0.0)
        XCTAssertEqual(boolValue.value, false)
    }
    
    func testSemaphoreInitialValues() {
        _ = SafeSemaphore(value: 0) // 测试创建，不使用
        let semaphore1 = SafeSemaphore(value: 1)
        let semaphore5 = SafeSemaphore(value: 5)
        
        // 信号量为1时应该能立即获取
        let result = semaphore1.wait(timeout: .now() + 0.1)
        XCTAssertEqual(result, .success)
        
        // 信号量为5时应该能获取5次
        for _ in 0..<5 {
            let result = semaphore5.wait(timeout: .now() + 0.1)
            XCTAssertEqual(result, .success)
        }
    }
}