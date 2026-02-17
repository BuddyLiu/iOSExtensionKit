// SetExtensionTests.swift
// Set扩展测试用例

import XCTest
@testable import iOSExtensionKit

final class SetExtensionTests: XCTestCase {
    
    // MARK: - 集合操作测试
    
    func testIntersectionSafe() {
        let set1: Set = [1, 2, 3, 4, 5]
        let set2: Set = [3, 4, 5, 6, 7]
        let result = set1.intersection(safe: set2)
        XCTAssertEqual(result, [3, 4, 5])
    }
    
    func testUnionSafe() {
        let set1: Set = [1, 2, 3]
        let set2: Set = [3, 4, 5]
        let result = set1.union(safe: set2)
        XCTAssertEqual(result, [1, 2, 3, 4, 5])
    }
    
    func testSubtractingSafe() {
        let set1: Set = [1, 2, 3, 4, 5]
        let set2: Set = [3, 4, 5]
        let result = set1.subtracting(safe: set2)
        XCTAssertEqual(result, [1, 2])
    }
    
    func testSymmetricDifferenceSafe() {
        let set1: Set = [1, 2, 3, 4]
        let set2: Set = [3, 4, 5, 6]
        let result = set1.symmetricDifference(safe: set2)
        XCTAssertEqual(result, [1, 2, 5, 6])
    }
    
    // MARK: - 元素操作测试
    
    func testContainsAll() {
        let set: Set = [1, 2, 3, 4, 5]
        XCTAssertTrue(set.contains(all: [1, 2, 3]))
        XCTAssertFalse(set.contains(all: [1, 2, 6]))
    }
    
    func testContainsAny() {
        let set: Set = [1, 2, 3, 4, 5]
        XCTAssertTrue(set.contains(any: [5, 6, 7]))
        XCTAssertFalse(set.contains(any: [6, 7, 8]))
    }
    
    func testFilterSet() {
        let set: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let result = set.filterSet { $0 % 2 == 0 }
        XCTAssertEqual(result, [2, 4, 6, 8, 10])
    }
    
    func testMapSet() {
        let set: Set = [1, 2, 3]
        let result = set.mapSet { "\($0)" }
        XCTAssertEqual(result, ["1", "2", "3"])
    }
    
    func testCompactMapSet() {
        let set: Set = [1, 2, 3, 4, 5]
        let result = set.compactMapSet { $0 % 2 == 0 ? "\($0)" : nil }
        XCTAssertEqual(result, ["2", "4"])
    }
    
    // MARK: - 集合关系测试
    
    func testDisjoint() {
        let set1: Set = [1, 2, 3]
        let set2: Set = [4, 5, 6]
        let set3: Set = [3, 4, 5]
        
        XCTAssertTrue(set1.disjoint(with: set2))
        XCTAssertFalse(set1.disjoint(with: set3))
    }
    
    func testSubset() {
        let set1: Set = [1, 2, 3]
        let set2: Set = [1, 2, 3, 4, 5]
        let set3: Set = [1, 2]
        
        XCTAssertTrue(set1.subset(of: set2))
        XCTAssertFalse(set1.subset(of: set3))
    }
    
    func testStrictSubset() {
        let set1: Set = [1, 2, 3]
        let set2: Set = [1, 2, 3, 4, 5]
        let set3: Set = [1, 2, 3]
        
        XCTAssertTrue(set1.strictSubset(of: set2))
        XCTAssertFalse(set1.strictSubset(of: set3))
    }
    
    func testSuperset() {
        let set1: Set = [1, 2, 3, 4, 5]
        let set2: Set = [1, 2, 3]
        let set3: Set = [1, 2, 3, 4, 5, 6]
        
        XCTAssertTrue(set1.superset(of: set2))
        XCTAssertFalse(set1.superset(of: set3))
    }
    
    func testStrictSuperset() {
        let set1: Set = [1, 2, 3, 4, 5]
        let set2: Set = [1, 2, 3]
        let set3: Set = [1, 2, 3, 4, 5]
        
        XCTAssertTrue(set1.strictSuperset(of: set2))
        XCTAssertFalse(set1.strictSuperset(of: set3))
    }
    
    // MARK: - 转换方法测试
    
    func testToArray() {
        let set: Set = [3, 1, 2]
        let array = set.toArray
        XCTAssertEqual(array.sorted(), [1, 2, 3])
    }
    
    func testToSortedArray() {
        let set: Set = [5, 1, 3, 2, 4]
        let sortedArray = set.toSortedArray()
        XCTAssertEqual(sortedArray, [1, 2, 3, 4, 5])
    }
    
    func testGrouped() {
        let set: Set = [1, 2, 3, 4, 5, 6]
        let grouped = set.grouped { $0 % 2 == 0 ? "even" : "odd" }
        
        XCTAssertEqual(grouped["even"]?.sorted(), [2, 4, 6])
        XCTAssertEqual(grouped["odd"]?.sorted(), [1, 3, 5])
    }
    
    // MARK: - 实用方法测试
    
    func testKeepWhere() {
        var set: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        set.keep { $0 % 2 == 0 }
        XCTAssertEqual(set, [2, 4, 6, 8, 10])
    }
    
    func testPartitioned() {
        let set: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let (even, odd) = set.partitioned { $0 % 2 == 0 }
        
        XCTAssertEqual(even, [2, 4, 6, 8, 10])
        XCTAssertEqual(odd, [1, 3, 5, 7, 9])
    }
    
    // MARK: - 统计方法测试
    
    func testCountWhere() {
        let set: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let evenCount = set.count { $0 % 2 == 0 }
        XCTAssertEqual(evenCount, 5)
    }
    
    func testProportion() {
        let set: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let evenProportion = set.proportion { $0 % 2 == 0 }
        XCTAssertEqual(evenProportion, 0.5)
    }
    
    func testPercentage() {
        let set: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let evenPercentage = set.percentage { $0 % 2 == 0 }
        XCTAssertEqual(evenPercentage, 50.0)
    }
    
    // MARK: - 可比较元素扩展测试
    
    func testMinElement() {
        let set: Set = [5, 3, 1, 4, 2]
        XCTAssertEqual(set.minElement, 1)
        
        let emptySet: Set<Int> = []
        XCTAssertNil(emptySet.minElement)
    }
    
    func testMaxElement() {
        let set: Set = [5, 3, 1, 4, 2]
        XCTAssertEqual(set.maxElement, 5)
        
        let emptySet: Set<Int> = []
        XCTAssertNil(emptySet.maxElement)
    }
    
    func testMinAndMax() {
        let set: Set = [5, 3, 1, 4, 2]
        let (min, max) = set.minAndMax!
        XCTAssertEqual(min, 1)
        XCTAssertEqual(max, 5)
        
        let emptySet: Set<Int> = []
        XCTAssertNil(emptySet.minAndMax)
    }
    
    // MARK: - 数值元素扩展测试
    
    func testSum() {
        let set: Set = [1, 2, 3, 4, 5]
        XCTAssertEqual(set.sum, 15)
    }
    
    func testProduct() {
        let set: Set = [1, 2, 3, 4]
        XCTAssertEqual(set.product, 24)
        
        let emptySet: Set<Int> = []
        XCTAssertEqual(emptySet.product, 1)
    }
    
    // MARK: - 便捷初始化方法测试
    
    func testOptionalElements() {
        let optionalElements: [Int?] = [1, nil, 2, nil, 3]
        let set = Set(optionalElements: optionalElements)
        XCTAssertEqual(set, [1, 2, 3])
        
        let allNil: [Int?] = [nil, nil, nil]
        XCTAssertNil(Set(optionalElements: allNil))
    }
    
    // MARK: - 哈希元素扩展测试
    
    func testSingle() {
        let set = Set.single(42)
        XCTAssertEqual(set, [42])
    }
    
    func testOfVarargs() {
        let set = Set.of(1, 2, 3, 4, 5)
        XCTAssertEqual(set, [1, 2, 3, 4, 5])
    }
    
    func testOfArray() {
        let set = Set.of([1, 2, 3, 4, 5])
        XCTAssertEqual(set, [1, 2, 3, 4, 5])
    }
    
    // MARK: - 随机元素测试
    
    func testRandomElements() {
        let set: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        // 测试获取0个元素
        XCTAssertEqual(set.randomElements(0), [])
        
        // 测试获取部分元素
        let randomElements = set.randomElements(3)
        XCTAssertEqual(randomElements.count, 3)
        XCTAssertTrue(randomElements.allSatisfy { set.contains($0) })
        
        // 测试获取超过集合大小的元素
        let allElements = set.randomElements(20)
        XCTAssertEqual(allElements.count, 10)
        XCTAssertEqual(Set(allElements), set)
    }
    
    // MARK: - 批量操作测试
    
    func testInsertElementsArray() {
        var set: Set = [1, 2, 3]
        set.insert([4, 5, 6])
        XCTAssertEqual(set, [1, 2, 3, 4, 5, 6])
    }
    
    func testInsertElementsSet() {
        var set: Set = [1, 2, 3]
        set.insert([4, 5, 6])
        XCTAssertEqual(set, [1, 2, 3, 4, 5, 6])
    }
    
    func testRemoveElementsArray() {
        var set: Set = [1, 2, 3, 4, 5, 6]
        set.remove([4, 5, 6])
        XCTAssertEqual(set, [1, 2, 3])
    }
    
    func testRemoveElementsSet() {
        var set: Set = [1, 2, 3, 4, 5, 6]
        set.remove([4, 5, 6])
        XCTAssertEqual(set, [1, 2, 3])
    }
    
    // MARK: - 功能方法测试
    
    func testForEachIndexed() {
        let set: Set = ["a", "b", "c"]
        var result: [(Int, String)] = []
        
        set.forEachIndexed { index, element in
            result.append((index, element))
        }
        
        XCTAssertEqual(result.map { $0.0 }.sorted(), [0, 1, 2])
        XCTAssertEqual(Set(result.map { $0.1 }), set)
    }
    
    func testReduceElements() {
        let set: Set = [1, 2, 3, 4, 5]
        let sum = set.reduceElements(0, +)
        XCTAssertEqual(sum, 15)
        
        let product = set.reduceElements(1, *)
        XCTAssertEqual(product, 120)
    }
    
    func testReduceElementsWithFirst() {
        let set: Set = [1, 2, 3, 4, 5]
        let sum = set.reduceElements(+)
        XCTAssertEqual(sum, 15)
        
        let emptySet: Set<Int> = []
        XCTAssertNil(emptySet.reduceElements(+))
    }
    
    // MARK: - 集合操作性能测试
    
    func testLargeSetOperations() {
        // 测试大型集合操作
        let largeSet1 = Set(1...1000)
        let largeSet2 = Set(500...1500)
        
        measure {
            _ = largeSet1.intersection(safe: largeSet2)
            _ = largeSet1.union(safe: largeSet2)
            _ = largeSet1.subtracting(safe: largeSet2)
            _ = largeSet1.symmetricDifference(safe: largeSet2)
        }
    }
}