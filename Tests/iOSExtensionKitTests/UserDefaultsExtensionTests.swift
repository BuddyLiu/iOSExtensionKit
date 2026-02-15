// UserDefaultsExtensionTests.swift
// 测试UserDefaults扩展功能

import XCTest
@testable import iOSExtensionKit

final class UserDefaultsExtensionTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // 使用临时UserDefaults进行测试，避免影响系统设置
        userDefaults = UserDefaults.temporaryDefaults
    }
    
    override func tearDown() {
        // 清理测试数据
        userDefaults.removePersistentDomain(forName: "temp_test")
        userDefaults = nil
        super.tearDown()
    }
    
    // MARK: - 基础功能测试
    
    func testGetAndSet() {
        // 创建一个自定义键
        let testKey = UserDefaults.Key<String>(name: "testString", defaultValue: "default")
        
        // 测试默认值
        XCTAssertEqual(userDefaults.get(for: testKey), "default")
        
        // 测试设置和获取值
        userDefaults.set("newValue", for: testKey)
        XCTAssertEqual(userDefaults.get(for: testKey), "newValue")
        
        // 测试不同类型的键
        let intKey = UserDefaults.Key<Int>(name: "testInt", defaultValue: 0)
        XCTAssertEqual(userDefaults.get(for: intKey), 0)
        
        userDefaults.set(42, for: intKey)
        XCTAssertEqual(userDefaults.get(for: intKey), 42)
        
        let boolKey = UserDefaults.Key<Bool>(name: "testBool", defaultValue: false)
        XCTAssertEqual(userDefaults.get(for: boolKey), false)
        
        userDefaults.set(true, for: boolKey)
        XCTAssertEqual(userDefaults.get(for: boolKey), true)
    }
    
    func testHasKey() {
        let testKey = UserDefaults.Key<String>(name: "testHas", defaultValue: "default")
        
        // 初始时应该不存在
        XCTAssertFalse(userDefaults.has(key: testKey))
        
        // 设置值后应该存在
        userDefaults.set("value", for: testKey)
        XCTAssertTrue(userDefaults.has(key: testKey))
        
        // 移除后应该不存在
        userDefaults.remove(for: testKey)
        XCTAssertFalse(userDefaults.has(key: testKey))
    }
    
    func testRemove() {
        let testKey = UserDefaults.Key<String>(name: "testRemove", defaultValue: "default")
        
        userDefaults.set("value", for: testKey)
        XCTAssertTrue(userDefaults.has(key: testKey))
        
        userDefaults.remove(for: testKey)
        XCTAssertFalse(userDefaults.has(key: testKey))
        XCTAssertEqual(userDefaults.get(for: testKey), "default")
    }
    
    // MARK: - 便捷访问器测试
    
    func testConvenienceAccessors() {
        // 字符串
        let stringKey = UserDefaults.Key<String>(name: "convenienceString", defaultValue: "default")
        XCTAssertEqual(userDefaults.string(for: stringKey), "default")
        userDefaults.set("hello", for: stringKey)
        XCTAssertEqual(userDefaults.string(for: stringKey), "hello")
        
        // 整数
        let intKey = UserDefaults.Key<Int>(name: "convenienceInt", defaultValue: 0)
        XCTAssertEqual(userDefaults.integer(for: intKey), 0)
        userDefaults.set(100, for: intKey)
        XCTAssertEqual(userDefaults.integer(for: intKey), 100)
        
        // 浮点数
        let doubleKey = UserDefaults.Key<Double>(name: "convenienceDouble", defaultValue: 0.0)
        XCTAssertEqual(userDefaults.double(for: doubleKey), 0.0, accuracy: 0.001)
        userDefaults.set(3.14159, for: doubleKey)
        XCTAssertEqual(userDefaults.double(for: doubleKey), 3.14159, accuracy: 0.001)
        
        // 布尔值
        let boolKey = UserDefaults.Key<Bool>(name: "convenienceBool", defaultValue: false)
        XCTAssertEqual(userDefaults.bool(for: boolKey), false)
        userDefaults.set(true, for: boolKey)
        XCTAssertEqual(userDefaults.bool(for: boolKey), true)
        
        // 日期
        let dateKey = UserDefaults.Key<Date>(name: "convenienceDate", defaultValue: Date.distantPast)
        let testDate = Date()
        XCTAssertEqual(userDefaults.date(for: dateKey), Date.distantPast)
        userDefaults.set(testDate, for: dateKey)
        XCTAssertEqual(userDefaults.date(for: dateKey).timeIntervalSince1970, 
                      testDate.timeIntervalSince1970, 
                      accuracy: 0.001)
        
        // 数据
        let dataKey = UserDefaults.Key<Data>(name: "convenienceData", defaultValue: Data())
        let testData = "test".data(using: .utf8)!
        XCTAssertEqual(userDefaults.data(for: dataKey), Data())
        userDefaults.set(testData, for: dataKey)
        XCTAssertEqual(userDefaults.data(for: dataKey), testData)
    }
    
    // MARK: - 原子操作测试
    
    func testIncrement() {
        let intKey = UserDefaults.Key<Int>(name: "incrementInt", defaultValue: 0)
        
        // 测试默认递增
        XCTAssertEqual(userDefaults.increment(key: intKey), 1)
        XCTAssertEqual(userDefaults.integer(for: intKey), 1)
        
        // 测试指定增量
        XCTAssertEqual(userDefaults.increment(key: intKey, by: 5), 6)
        XCTAssertEqual(userDefaults.integer(for: intKey), 6)
        
        // 测试负数增量
        XCTAssertEqual(userDefaults.increment(key: intKey, by: -3), 3)
        XCTAssertEqual(userDefaults.integer(for: intKey), 3)
        
        // 测试浮点数递增
        let doubleKey = UserDefaults.Key<Double>(name: "incrementDouble", defaultValue: 0.0)
        XCTAssertEqual(userDefaults.increment(key: doubleKey), 1.0, accuracy: 0.001)
        XCTAssertEqual(userDefaults.double(for: doubleKey), 1.0, accuracy: 0.001)
        
        XCTAssertEqual(userDefaults.increment(key: doubleKey, by: 2.5), 3.5, accuracy: 0.001)
        XCTAssertEqual(userDefaults.double(for: doubleKey), 3.5, accuracy: 0.001)
    }
    
    func testToggle() {
        let boolKey = UserDefaults.Key<Bool>(name: "toggleBool", defaultValue: false)
        
        // 从false切换到true
        XCTAssertEqual(userDefaults.toggle(key: boolKey), true)
        XCTAssertEqual(userDefaults.bool(for: boolKey), true)
        
        // 从true切换到false
        XCTAssertEqual(userDefaults.toggle(key: boolKey), false)
        XCTAssertEqual(userDefaults.bool(for: boolKey), false)
        
        // 再次切换
        XCTAssertEqual(userDefaults.toggle(key: boolKey), true)
        XCTAssertEqual(userDefaults.bool(for: boolKey), true)
    }
    
    // MARK: - 批量操作测试
    
    func testSetValues() {
        let values = [
            "key1": "value1",
            "key2": 123,
            "key3": true,
            "key4": 3.14
        ] as [String: Any]
        
        userDefaults.setValues(values)
        
        XCTAssertEqual(userDefaults.string(forKey: "key1"), "value1")
        XCTAssertEqual(userDefaults.integer(forKey: "key2"), 123)
        XCTAssertEqual(userDefaults.bool(forKey: "key3"), true)
        XCTAssertEqual(userDefaults.double(forKey: "key4"), 3.14, accuracy: 0.001)
    }
    
    func testGetValues() {
        userDefaults.set("value1", forKey: "key1")
        userDefaults.set(123, forKey: "key2")
        userDefaults.set(true, forKey: "key3")
        
        let values = userDefaults.getValues(for: ["key1", "key2", "key3", "nonexistent"])
        
        XCTAssertEqual(values.count, 3) // 不存在的键不会被包含
        XCTAssertEqual(values["key1"] as? String, "value1")
        XCTAssertEqual(values["key2"] as? Int, 123)
        XCTAssertEqual(values["key3"] as? Bool, true)
    }
    
    func testRemoveValues() {
        userDefaults.set("value1", forKey: "key1")
        userDefaults.set("value2", forKey: "key2")
        userDefaults.set("value3", forKey: "key3")
        
        XCTAssertNotNil(userDefaults.string(forKey: "key1"))
        XCTAssertNotNil(userDefaults.string(forKey: "key2"))
        XCTAssertNotNil(userDefaults.string(forKey: "key3"))
        
        userDefaults.removeValues(for: ["key1", "key3"])
        
        XCTAssertNil(userDefaults.string(forKey: "key1"))
        XCTAssertNotNil(userDefaults.string(forKey: "key2"))
        XCTAssertNil(userDefaults.string(forKey: "key3"))
    }
    
    func testRemoveAll() {
        userDefaults.set("value1", forKey: "key1")
        userDefaults.set("value2", forKey: "key2")
        userDefaults.set("value3", forKey: "keepThis")
        
        XCTAssertNotNil(userDefaults.string(forKey: "key1"))
        XCTAssertNotNil(userDefaults.string(forKey: "key2"))
        XCTAssertNotNil(userDefaults.string(forKey: "keepThis"))
        
        userDefaults.removeAll(except: ["keepThis"])
        
        XCTAssertNil(userDefaults.string(forKey: "key1"))
        XCTAssertNil(userDefaults.string(forKey: "key2"))
        XCTAssertNotNil(userDefaults.string(forKey: "keepThis"))
    }
    
    // MARK: - 安全操作测试
    
    func testSafeGet() {
        let testKey = UserDefaults.Key<String>(name: "testSafeGet", defaultValue: "default")
        
        // 键不存在时返回nil
        XCTAssertNil(userDefaults.safeGet(for: testKey))
        
        // 设置值后可以获取
        userDefaults.set("value", for: testKey)
        XCTAssertEqual(userDefaults.safeGet(for: testKey), "value")
        
        // 类型不匹配时返回nil
        userDefaults.set(123, forKey: testKey.name)
        XCTAssertNil(userDefaults.safeGet(for: testKey))
    }
    
    func testSafeSet() {
        let testKey = UserDefaults.Key<String>(name: "testSafeSet", defaultValue: "default")
        
        // 键不存在时返回false
        XCTAssertFalse(userDefaults.safeSet("value1", for: testKey))
        XCTAssertNil(userDefaults.safeGet(for: testKey))
        
        // 先设置值，然后可以安全更新
        userDefaults.set("initial", for: testKey)
        XCTAssertTrue(userDefaults.safeSet("updated", for: testKey))
        XCTAssertEqual(userDefaults.get(for: testKey), "updated")
    }
    
    func testGetOrSet() {
        let testKey = UserDefaults.Key<String>(name: "testGetOrSet", defaultValue: "default")
        
        // 键不存在时设置并返回默认值
        XCTAssertEqual(userDefaults.getOrSet(for: testKey, defaultValue: "newDefault"), "newDefault")
        XCTAssertEqual(userDefaults.get(for: testKey), "newDefault")
        
        // 键存在时返回值
        XCTAssertEqual(userDefaults.getOrSet(for: testKey, defaultValue: "differentValue"), "newDefault")
        XCTAssertEqual(userDefaults.get(for: testKey), "newDefault")
    }
    
    // MARK: - Codable对象测试
    
    func testCodableObject() {
        struct TestStruct: Codable, Equatable {
            let id: Int
            let name: String
            let isActive: Bool
        }
        
        let testKey = UserDefaults.Key<TestStruct>(
            name: "testCodable",
            defaultValue: TestStruct(id: 0, name: "default", isActive: false)
        )
        
        let original = TestStruct(id: 1, name: "Test", isActive: true)
        
        // 设置和获取Codable对象
        userDefaults.set(original, for: testKey)
        let retrieved = userDefaults.object(for: testKey)
        
        XCTAssertEqual(retrieved.id, 1)
        XCTAssertEqual(retrieved.name, "Test")
        XCTAssertEqual(retrieved.isActive, true)
        
        // 测试获取不存在的数据时返回默认值
        userDefaults.remove(for: testKey)
        let defaultValue = userDefaults.object(for: testKey)
        XCTAssertEqual(defaultValue.id, 0)
        XCTAssertEqual(defaultValue.name, "default")
        XCTAssertEqual(defaultValue.isActive, false)
    }
    
    // MARK: - 全局便捷方法测试
    
    func testStandardDefaults() {
        let standard = UserDefaults.standardDefaults
        XCTAssertTrue(standard === UserDefaults.standard)
    }
    
    func testTemporaryDefaults() {
        let temp1 = UserDefaults.temporaryDefaults
        let temp2 = UserDefaults.temporaryDefaults
        
        // 两个临时UserDefaults应该是不同的实例
        XCTAssertFalse(temp1 === temp2)
        XCTAssertFalse(temp1 === UserDefaults.standard)
        XCTAssertFalse(temp2 === UserDefaults.standard)
    }
    
    // MARK: - 应用设置封装测试
    
    func testAppSettings() {
        var settings = UserDefaults.AppSettings(defaults: userDefaults)
        
        // 测试默认值
        XCTAssertTrue(settings.isFirstLaunch)
        XCTAssertEqual(settings.userId, "")
        XCTAssertEqual(settings.userToken, "")
        XCTAssertEqual(settings.launchCount, 0)
        
        // 测试设置值
        settings.isFirstLaunch = false
        settings.userId = "user123"
        settings.userToken = "token456"
        settings.launchCount = 5
        
        XCTAssertFalse(settings.isFirstLaunch)
        XCTAssertEqual(settings.userId, "user123")
        XCTAssertEqual(settings.userToken, "token456")
        XCTAssertEqual(settings.launchCount, 5)
        
        // 测试记录应用启动
        settings.recordAppLaunch()
        XCTAssertEqual(settings.launchCount, 6)
        XCTAssertFalse(settings.isFirstLaunch) // 首次启动标志应该被清除
        
        // 测试记录登录
        settings.recordLogin(userId: "newUser", token: "newToken")
        XCTAssertEqual(settings.userId, "newUser")
        XCTAssertEqual(settings.userToken, "newToken")
        XCTAssertTrue(settings.lastLoginDate.timeIntervalSinceNow < 1) // 应该很接近当前时间
        
        // 测试记录登出
        settings.recordLogout()
        XCTAssertEqual(settings.userToken, "")
        XCTAssertEqual(settings.userId, "newUser") // userId应该保持不变
        
        // 测试清除用户数据
        settings.clearUserData()
        XCTAssertEqual(settings.userId, "")
        XCTAssertEqual(settings.userToken, "")
        
        // 测试清除所有设置
        settings.isFirstLaunch = false
        settings.language = "en"
        settings.theme = "dark"
        
        settings.clearAllSettings()
        
        // 首次启动标志应该被保留
        XCTAssertFalse(settings.isFirstLaunch)
        // 其他设置应该被重置为默认值
        XCTAssertEqual(settings.language, "zh-Hans")
        XCTAssertEqual(settings.theme, "light")
    }
    
    // MARK: - 边界条件测试
    
    func testEmptyStringKey() {
        let emptyKey = UserDefaults.Key<String>(name: "", defaultValue: "default")
        
        // 空键名应该也能工作（虽然不推荐）
        userDefaults.set("value", for: emptyKey)
        XCTAssertEqual(userDefaults.get(for: emptyKey), "value")
    }
    
    func testLargeValue() {
        let largeString = String(repeating: "test", count: 10000)
        let testKey = UserDefaults.Key<String>(name: "largeValue", defaultValue: "")
        
        userDefaults.set(largeString, for: testKey)
        XCTAssertEqual(userDefaults.get(for: testKey), largeString)
    }
    
    func testNilValues() {
        // 测试设置nil值（应该移除键）
        let testKey = UserDefaults.Key<String?>(name: "optionalKey", defaultValue: nil)
        
        // 注意：这里的泛型是String?，但我们的API不支持可选类型的泛型
        // 所以这个测试主要是为了演示如何处理可选值
        let wrappedKey = UserDefaults.Key<String>(name: "optionalKey", defaultValue: "default")
        
        userDefaults.set("value", for: wrappedKey)
        XCTAssertEqual(userDefaults.get(for: wrappedKey), "value")
        
        // 通过移除来处理nil
        userDefaults.remove(for: wrappedKey)
        XCTAssertEqual(userDefaults.get(for: wrappedKey), "default")
    }
    
    // MARK: - 性能测试
    
    func testPerformanceGetSet() {
        let testKey = UserDefaults.Key<Int>(name: "perfTest", defaultValue: 0)
        
        measure {
            for i in 0..<1000 {
                userDefaults.set(i, for: testKey)
                _ = userDefaults.get(for: testKey)
            }
        }
    }
    
    func testPerformanceBatchOperations() {
        measure {
            let values = (0..<100).reduce(into: [String: Any]()) { dict, i in
                dict["key\(i)"] = "value\(i)"
            }
            
            userDefaults.setValues(values)
            _ = userDefaults.getValues(for: Array(values.keys))
            userDefaults.removeValues(for: Array(values.keys))
        }
    }
}