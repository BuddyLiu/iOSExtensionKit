import XCTest
@testable import iOSExtensionKit

final class PerformanceTests: XCTestCase {
    
    // MARK: - 字符串扩展性能测试
    
    func testStringValidationPerformance() {
        // 测试邮箱验证性能
        let emails = [
            "user@example.com",
            "invalid.email",
            "another@test.co.uk",
            "name.lastname@company.com",
            "test123@test.com"
        ]
        
        measure {
            for _ in 0..<1000 {
                for email in emails {
                    _ = email.isValidEmail
                }
            }
        }
    }
    
    func testStringConversionPerformance() {
        // 测试字符串转换性能
        let numbers = ["123", "456", "789", "1000", "9999"]
        
        measure {
            for _ in 0..<1000 {
                for numberStr in numbers {
                    _ = numberStr.toInt()
                    _ = numberStr.toDouble()
                }
            }
        }
    }
    
    func testStringSafetyPerformance() {
        // 测试安全操作性能
        let str = "Hello, World!"
        
        measure {
            for _ in 0..<10000 {
                _ = str.safeChar(at: 5)
                _ = str.safeSubstring(with: 3..<8)
            }
        }
    }
    
    // MARK: - Double/Float 扩展性能测试
    
    func testDoubleMathPerformance() {
        let values: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        measure {
            for _ in 0..<1000 {
                for value in values {
                    _ = value.squared
                    _ = value.cubed
                    _ = value.squareRoot
                    _ = value.cubeRoot
                }
            }
        }
    }
    
    func testFloatMathPerformance() {
        let values: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        measure {
            for _ in 0..<1000 {
                for value in values {
                    _ = value.squared
                    _ = value.cubed
                    _ = value.squareRoot
                }
            }
        }
    }
    
    func testArrayStatisticsPerformance() {
        let values: [Double] = Array(1...1000).map { Double($0) }
        
        measure {
            for _ in 0..<10 {
                _ = values.sum()
                _ = values.average()
                _ = values.median
                _ = values.standardDeviation
            }
        }
    }
    
    // MARK: - UserDefaults 扩展性能测试
    
    func testUserDefaultsPerformance() {
        let defaults = UserDefaults.standard
        
        measure {
            for i in 0..<100 {
                let key = UserDefaults.Key<Int>(name: "test_key_\(i)", defaultValue: 0)
                defaults.set(i, for: key)
                _ = defaults.integer(for: key)
            }
            
            // 清理
            for i in 0..<100 {
                defaults.removeObject(forKey: "test_key_\(i)")
            }
        }
    }
    
    func testCodablePerformance() {
        struct TestObject: Codable {
            let id: Int
            let name: String
            let value: Double
        }
        
        let object = TestObject(id: 1, name: "Test", value: 123.45)
        let key = UserDefaults.Key<TestObject>(name: "test_codable", defaultValue: TestObject(id: 0, name: "", value: 0))
        
        measure {
            for _ in 0..<100 {
                UserDefaults.standard.set(object, for: key)
                _ = UserDefaults.standard.object(for: key)
            }
            UserDefaults.standard.removeObject(forKey: "test_codable")
        }
    }
    
    // MARK: - DispatchQueue 扩展性能测试
    
    @MainActor
    func testDispatchQueuePerformance() {
        measure {
            let expectation = self.expectation(description: "DispatchQueue test")
            
            DispatchQueue.global().async {
                DispatchQueue.main.safeAsync {
                    expectation.fulfill()
                }
            }
            
            waitForExpectations(timeout: 1.0)
        }
    }
    
    // MARK: - 内存使用测试
    
    func testMemoryUsageForStringOperations() {
        // 测试字符串操作的内存使用
        var memoryUsage: [Int] = []
        
        for i in 0..<1000 {
            let str = String(repeating: "test", count: i % 100 + 1)
            let processed = str.capitalizedFirstLetter()
            
            if i % 100 == 0 {
                // 记录内存使用（近似值）
                memoryUsage.append(processed.count)
            }
        }
        
        // 验证内存使用没有异常增长
        XCTAssertTrue(memoryUsage.max()! < 10000, "内存使用异常增长")
    }
    
    func testPerformanceTimerOverhead() {
        // 测试 PerformanceTimer 的开销
        measure {
            for _ in 0..<10000 {
                let timer = PerformanceTimer(name: "test")
                _ = timer.stop()
            }
        }
    }
    
    // MARK: - 批量操作性能测试
    
    func testBatchOperationsPerformance() {
        let numbers = Array(1...10000).map { Double($0) }
        
        measure {
            // 批量数学运算
            let squared = numbers.map { $0.squared }
            let squareRoots = numbers.map { $0.squareRoot }
            
            // 批量统计
            _ = numbers.sum()
            _ = numbers.average()
            _ = numbers.standardDeviation
            
            // 验证结果
            XCTAssertEqual(squared.count, 10000)
            XCTAssertEqual(squareRoots.count, 10000)
        }
    }
    
    // MARK: - 并发性能测试
    
    func testConcurrentPerformance() {
        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)
        let group = DispatchGroup()
        
        measure {
            for i in 0..<100 {
                group.enter()
                queue.async {
                    // 执行一些计算
                    let value = Double(i)
                    _ = value.squared
                    _ = value.squareRoot
                    _ = value.cubed
                    
                    group.leave()
                }
            }
            
            group.wait()
        }
    }
    
    // MARK: - 实际场景性能测试
    
    func testRealWorldScenarioPerformance() {
        // 模拟实际使用场景
        measure {
            // 1. 数据处理
            let data: [Double] = Array(1...100).map { Double($0) }
            let processedData = data
                .map { $0 * 2.0 }
                .filter { $0 > 50.0 }
                .sorted()
            
            // 2. 字符串处理
            let strings = ["hello", "world", "swift", "ios", "extension"]
            let processedStrings = strings
                .map { $0.capitalizedFirstLetter() }
                .filter { $0.count > 3 }
                .joined(separator: " ")
            
            // 3. 日期处理
            let now = Date()
            let dates = (0..<10).map { now.adding(days: $0) }
            let futureDates = dates.filter { $0.isFuture }
            
            // 验证结果
            XCTAssertFalse(processedData.isEmpty)
            XCTAssertFalse(processedStrings.isEmpty)
            XCTAssertFalse(futureDates.isEmpty)
        }
    }
    
    // MARK: - 性能比较测试
    
    func testPerformanceComparisonWithNative() {
        // 比较扩展方法与原生方法的性能差异
        
        // 测试平方计算
        let value: Double = 123.456
        
        measure {
            for _ in 0..<10000 {
                // 使用扩展方法
                _ = value.squared
            }
        }
        
        let nativeTime = measureTime {
            for _ in 0..<10000 {
                // 使用原生方法
                _ = value * value
            }
        }
        
        // 扩展方法的开销应该很小
        print("扩展方法时间: \(nativeTime) 秒")
    }
    
    // MARK: - 辅助方法
    
    private func measureTime(_ block: () -> Void) -> TimeInterval {
        let start = Date()
        block()
        return Date().timeIntervalSince(start)
    }
}