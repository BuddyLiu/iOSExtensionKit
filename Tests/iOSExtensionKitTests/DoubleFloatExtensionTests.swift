import XCTest
@testable import iOSExtensionKit

final class DoubleFloatExtensionTests: XCTestCase {
    
    // MARK: - Double 扩展测试
    
    func testDoubleMathOperations() {
        let value1: Double = 3.14
        let value2: Double = -2.5
        
        // 测试正负数检查
        XCTAssertTrue(value1.isPositive)
        XCTAssertTrue(value2.isNegative)
        XCTAssertFalse(value1.isZero)
        XCTAssertTrue(0.0.isZero)
        
        // 测试绝对值
        XCTAssertEqual(value1.absoluteValue, 3.14)
        XCTAssertEqual(value2.absoluteValue, 2.5)
        
        // 测试符号
        XCTAssertEqual(value1.sign, 1)
        XCTAssertEqual(value2.sign, -1)
        XCTAssertEqual(0.0.sign, 0)
    }
    
    func testDoubleRounding() {
        let value: Double = 3.7
        
        XCTAssertEqual(value.floor, 3)
        XCTAssertEqual(value.ceil, 4)
        XCTAssertEqual(value.round, 4)
        XCTAssertEqual(value.floored, 3.0)
        XCTAssertEqual(value.ceiled, 4.0)
        XCTAssertEqual(value.roundedValue, 4.0)
    }
    
    func testDoubleClamping() {
        let value: Double = 10.0
        
        XCTAssertEqual(value.clamped(to: 0...5), 5.0)
        XCTAssertEqual(value.clamped(to: 0..<5), 5.0)
        XCTAssertEqual(value.clamped(to: 20...30), 20.0)
        XCTAssertEqual(value.clamped(to: 5...15), 10.0)
    }
    
    func testDoubleConversion() {
        let value: Double = 123.456
        
        XCTAssertEqual(value.intValue, 123)
        XCTAssertEqual(value.floatValue, Float(value))
        XCTAssertEqual(value.stringValue, "123.456")
        XCTAssertTrue(value.boolValue)
        XCTAssertFalse(0.0.boolValue)
        
        // 测试格式化的字符串
        let formatted = value.withThousandsSeparator(fractionDigits: 2)
        XCTAssertNotNil(formatted)
        
        // 测试百分比格式化
        let percentage = 25.5
        XCTAssertEqual(percentage.asPercentage(fractionDigits: 0), "26%")
    }
    
    func testDoubleTimeConversions() {
        XCTAssertEqual(60.0.seconds, 60.0)
        XCTAssertEqual(1.0.minutes, 60.0)
        XCTAssertEqual(1.0.hours, 3600.0)
        XCTAssertEqual(1.0.days, 86400.0)
        XCTAssertEqual(1000.0.milliseconds, 1.0)
    }
    
    func testDoubleByteConversions() {
        XCTAssertEqual(1024.0.kilobytes, 1.0)
        XCTAssertEqual(1024.0.megabytes, 1.0)
        XCTAssertEqual(1024.0.gigabytes, 1.0)
        XCTAssertEqual(1024.0.terabytes, 1.0)
    }
    
    func testDoubleMathFunctions() {
        let value: Double = 4.0
        
        XCTAssertEqual(value.squared, 16.0)
        XCTAssertEqual(value.cubed, 64.0)
        XCTAssertEqual(value.squareRoot, 2.0)
        XCTAssertEqual(value.cubeRoot, cbrt(4.0))
        XCTAssertEqual(value.power(3.0), 64.0)
        XCTAssertEqual(value.reciprocal, 0.25)
        XCTAssertNil(0.0.reciprocal)
    }
    
    func testDoubleRandom() {
        let random1 = Double.random(in: 0...1)
        XCTAssertTrue(random1 >= 0 && random1 <= 1)
        
        let random2 = Double.random(upTo: 10.0)
        XCTAssertTrue(random2 >= 0 && random2 < 10.0)
    }
    
    func testDoublePrecisionHandling() {
        let value: Double = 3.141592653589793
        
        XCTAssertEqual(value.rounded(toPlaces: 2), 3.14)
        XCTAssertEqual(value.rounded(toPlaces: 4), 3.1416)
        XCTAssertEqual(value.ceiled(toPlaces: 2), 3.15)
        XCTAssertEqual(value.floored(toPlaces: 2), 3.14)
        
        // 测试近似相等
        XCTAssertTrue(value.isApproximatelyEqual(to: 3.14159265))
        XCTAssertFalse(value.isApproximatelyEqual(to: 3.14))
    }
    
    func testDoubleSequenceOperations() {
        let values: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        XCTAssertEqual(values.sum(), 15.0)
        XCTAssertEqual(values.average(), 3.0)
        XCTAssertEqual(values.product(), 120.0)
        
        XCTAssertEqual(values.maxValue(), 5.0)
        XCTAssertEqual(values.minValue(), 1.0)
        XCTAssertEqual(values.median, 3.0)
        
        // 测试方差和标准差
        XCTAssertEqual(values.standardDeviation, sqrt(2.5))
    }
    
    // MARK: - Float 扩展测试
    
    func testFloatMathOperations() {
        let value1: Float = 3.14
        let value2: Float = -2.5
        
        XCTAssertTrue(value1.isPositive)
        XCTAssertTrue(value2.isNegative)
        XCTAssertFalse(value1.isZero)
        XCTAssertTrue(0.0.isZero)
        
        XCTAssertEqual(value1.absoluteValue, 3.14)
        XCTAssertEqual(value2.absoluteValue, 2.5)
        
        XCTAssertEqual(value1.sign, 1)
        XCTAssertEqual(value2.sign, -1)
        XCTAssertEqual(Float(0.0).sign, 0)
    }
    
    func testFloatRounding() {
        let value: Float = 3.7
        
        XCTAssertEqual(value.floor, 3)
        XCTAssertEqual(value.ceil, 4)
        XCTAssertEqual(value.round, 4)
        XCTAssertEqual(value.floored, 3.0)
        XCTAssertEqual(value.ceiled, 4.0)
        XCTAssertEqual(value.roundedValue, 4.0)
    }
    
    func testFloatClamping() {
        let value: Float = 10.0
        
        XCTAssertEqual(value.clamped(to: 0...5), 5.0)
        XCTAssertEqual(value.clamped(to: 0..<5), 5.0)
        XCTAssertEqual(value.clamped(to: 20...30), 20.0)
        XCTAssertEqual(value.clamped(to: 5...15), 10.0)
    }
    
    func testFloatConversion() {
        let value: Float = 123.456
        
        XCTAssertEqual(value.intValue, 123)
        XCTAssertEqual(value.doubleValue, Double(value))
        XCTAssertEqual(value.stringValue, "123.456")
        XCTAssertTrue(value.boolValue)
        XCTAssertFalse(Float(0.0).boolValue)
        
        let formatted = value.formatted()
        XCTAssertNotNil(formatted)
    }
    
    func testFloatMathFunctions() {
        let value: Float = 4.0
        
        XCTAssertEqual(value.squared, 16.0)
        XCTAssertEqual(value.cubed, 64.0)
        XCTAssertEqual(value.squareRoot, 2.0)
        XCTAssertEqual(value.power(3.0), 64.0)
        XCTAssertEqual(value.reciprocal, 0.25)
        XCTAssertNil(Float(0.0).reciprocal)
    }
    
    func testFloatRandom() {
        let random1 = Float.random(in: 0...1)
        XCTAssertTrue(random1 >= 0 && random1 <= 1)
        
        let random2 = Float.random(upTo: 10.0)
        XCTAssertTrue(random2 >= 0 && random2 < 10.0)
    }
    
    func testFloatPrecisionHandling() {
        let value: Float = 3.14159265
        
        XCTAssertEqual(value.rounded(toPlaces: 2), 3.14)
        
        // 测试近似相等
        XCTAssertTrue(value.isApproximatelyEqual(to: 3.14159))
        XCTAssertFalse(value.isApproximatelyEqual(to: 3.14, tolerance: 0.001))
    }
    
    func testFloatSequenceOperations() {
        let values: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        XCTAssertEqual(values.sum(), 15.0)
        XCTAssertEqual(values.average(), 3.0)
        XCTAssertEqual(values.product(), 120.0)
        
        XCTAssertEqual(values.maxValue(), 5.0)
        XCTAssertEqual(values.minValue(), 1.0)
        XCTAssertEqual(values.median, 3.0)
        
        // 测试标准差
        let stdDev = values.standardDeviation
        XCTAssertNotNil(stdDev)
        XCTAssertEqual(stdDev!, sqrtf(2.5), accuracy: 0.0001)
    }
    
    func testAngularConversions() {
        let angle90: Double = 90.0
        let angle90Float: Float = 90.0
        
        XCTAssertEqual(angle90.radians, .pi / 2, accuracy: 0.0001)
        XCTAssertEqual(angle90Float.radians, .pi / 2, accuracy: 0.0001)
        
        let radianPi: Double = .pi
        let radianPiFloat: Float = .pi
        
        XCTAssertEqual(radianPi.degrees, 180.0, accuracy: 0.0001)
        XCTAssertEqual(radianPiFloat.degrees, 180.0, accuracy: 0.0001)
    }
    
    func testTrigonometricFunctions() {
        let angle: Double = .pi / 6 // 30度
        let angleFloat: Float = .pi / 6
        
        XCTAssertEqual(angle.sinValue, 0.5, accuracy: 0.0001)
        XCTAssertEqual(angleFloat.sinValue, 0.5, accuracy: 0.0001)
        
        XCTAssertEqual(angle.cosValue, sqrt(3)/2, accuracy: 0.0001)
        XCTAssertEqual(angleFloat.cosValue, sqrtf(3)/2, accuracy: 0.0001)
        
        XCTAssertEqual(angle.tanValue, 1/sqrt(3), accuracy: 0.0001)
        XCTAssertEqual(angleFloat.tanValue, 1/sqrtf(3), accuracy: 0.0001)
    }
    
    func testInterpolation() {
        let start: Double = 0.0
        let end: Double = 10.0
        
        XCTAssertEqual(start.lerp(to: end, t: 0.5), 5.0)
        XCTAssertEqual(start.lerp(to: end, t: 0.0), 0.0)
        XCTAssertEqual(start.lerp(to: end, t: 1.0), 10.0)
        
        let startFloat: Float = 0.0
        let endFloat: Float = 10.0
        
        XCTAssertEqual(startFloat.lerp(to: endFloat, t: 0.5), 5.0)
        XCTAssertEqual(startFloat.lerp(to: endFloat, t: 0.0), 0.0)
        XCTAssertEqual(startFloat.lerp(to: endFloat, t: 1.0), 10.0)
    }
    
    func testArrayNormalization() {
        let values: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0]
        let normalized = values.normalized
        
        XCTAssertEqual(normalized[0], 0.0, accuracy: 0.0001)
        XCTAssertEqual(normalized[4], 1.0, accuracy: 0.0001)
        
        let standardized = values.standardized
        XCTAssertNotNil(standardized)
    }
    
    func testComparisonMethods() {
        let value: Double = 5.0
        
        XCTAssertTrue(value.isGreater(than: 4.0))
        XCTAssertTrue(value.isLess(than: 6.0))
        XCTAssertTrue(value.isGreaterOrEqual(to: 5.0))
        XCTAssertTrue(value.isLessOrEqual(to: 5.0))
        XCTAssertTrue(value.isBetween(4.0, and: 6.0))
        XCTAssertFalse(value.isBetween(6.0, and: 7.0))
        
        let valueFloat: Float = 5.0
        XCTAssertTrue(valueFloat.isGreater(than: 4.0))
        XCTAssertTrue(valueFloat.isLess(than: 6.0))
        XCTAssertTrue(valueFloat.isGreaterOrEqual(to: 5.0))
        XCTAssertTrue(valueFloat.isLessOrEqual(to: 5.0))
        XCTAssertTrue(valueFloat.isBetween(4.0, and: 6.0))
    }
    
    // MARK: - 边界情况测试
    
    func testEdgeCases() {
        // 测试无穷大和NaN
        XCTAssertTrue(Double.infinity.isInfinite)
        XCTAssertTrue(Double.infinity.isInfinite)
        XCTAssertTrue(Double.nan.isNaN)
        XCTAssertTrue(Double.nan.isNaN)
        XCTAssertFalse(Double.infinity.isFinite)
        XCTAssertFalse(Double.infinity.isNormal)
        
        XCTAssertTrue(Float.infinity.isInfiniteNumber)
        XCTAssertTrue(Float.nan.isNaNValue)
        XCTAssertFalse(Float.infinity.isFiniteNumber)
        XCTAssertFalse(Float.infinity.isNormalNumber)
        
        // 测试百分比有效性
        XCTAssertTrue(50.0.isValidPercentage)
        XCTAssertFalse(150.0.isValidPercentage)
        XCTAssertFalse((-10.0).isValidPercentage)
        
        // 测试倒数
        XCTAssertNil(0.0.reciprocal)
        XCTAssertEqual(2.0.reciprocal, 0.5)
    }
    
    func testSpecialValues() {
        // 测试物理常数
        XCTAssertEqual(Double.pi, .pi)
        XCTAssertEqual(Double.e, M_E)
        XCTAssertEqual(Double.goldenRatio, 1.618033988749895, accuracy: 0.000000000000001)
        XCTAssertEqual(Double.speedOfLight, 299792458)
        XCTAssertEqual(Double.gravity, 9.80665)
    }
}