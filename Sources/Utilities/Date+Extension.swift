// Date+Extension.swift
// 日期时间扩展，提供便捷的日期操作和格式化方法

import Foundation

public extension Date {
    
    // MARK: - 时间间隔常量
    
    /// 1秒的时间间隔
    static let second: TimeInterval = 1
    
    /// 1分钟的时间间隔
    static let minute: TimeInterval = 60
    
    /// 1小时的时间间隔
    static let hour: TimeInterval = 3600
    
    /// 1天的时间间隔
    static let day: TimeInterval = 86400
    
    /// 1周的时间间隔
    static let week: TimeInterval = 604800
    
    /// 1个月的时间间隔（按30天计算）
    static let month: TimeInterval = 2592000
    
    /// 1年的时间间隔（按365天计算）
    static let year: TimeInterval = 31536000
    
    // MARK: - 便捷属性
    
    /// 获取当前日历
    private var calendar: Calendar {
        return Calendar.current
    }
    
    /// 年份
    var year: Int {
        return calendar.component(.year, from: self)
    }
    
    /// 月份（1-12）
    var month: Int {
        return calendar.component(.month, from: self)
    }
    
    /// 日期（1-31）
    var day: Int {
        return calendar.component(.day, from: self)
    }
    
    /// 小时（0-23）
    var hour: Int {
        return calendar.component(.hour, from: self)
    }
    
    /// 分钟（0-59）
    var minute: Int {
        return calendar.component(.minute, from: self)
    }
    
    /// 秒（0-59）
    var second: Int {
        return calendar.component(.second, from: self)
    }
    
    /// 星期几（1-7，1为周日）
    var weekday: Int {
        return calendar.component(.weekday, from: self)
    }
    
    /// 星期几的中文名称
    var weekdayChinese: String {
        let weekdays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return weekdays[weekday - 1]
    }
    
    /// 是否在今天
    var isToday: Bool {
        return calendar.isDateInToday(self)
    }
    
    /// 是否在明天
    var isTomorrow: Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    /// 是否在昨天
    var isYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }
    
    /// 是否在周末
    var isWeekend: Bool {
        return calendar.isDateInWeekend(self)
    }
    
    /// 是否在未来
    var isFuture: Bool {
        return self > Date()
    }
    
    /// 是否在过去
    var isPast: Bool {
        return self < Date()
    }
    
    /// 时间戳（秒）
    var timestamp: TimeInterval {
        return timeIntervalSince1970
    }
    
    /// 毫秒时间戳
    var timestampMilliseconds: Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
    
    // MARK: - 日期计算
    
    /// 增加指定数量的年
    /// - Parameter years: 年数
    /// - Returns: 新日期
    func adding(years: Int) -> Date {
        return calendar.date(byAdding: .year, value: years, to: self) ?? self
    }
    
    /// 增加指定数量的月
    /// - Parameter months: 月数
    /// - Returns: 新日期
    func adding(months: Int) -> Date {
        return calendar.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    /// 增加指定数量的天
    /// - Parameter days: 天数
    /// - Returns: 新日期
    func adding(days: Int) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// 增加指定数量的小时
    /// - Parameter hours: 小时数
    /// - Returns: 新日期
    func adding(hours: Int) -> Date {
        return calendar.date(byAdding: .hour, value: hours, to: self) ?? self
    }
    
    /// 增加指定数量的分钟
    /// - Parameter minutes: 分钟数
    /// - Returns: 新日期
    func adding(minutes: Int) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
    
    /// 增加指定数量的秒
    /// - Parameter seconds: 秒数
    /// - Returns: 新日期
    func adding(seconds: Int) -> Date {
        return calendar.date(byAdding: .second, value: seconds, to: self) ?? self
    }
    
    /// 减少指定数量的年
    /// - Parameter years: 年数
    /// - Returns: 新日期
    func subtracting(years: Int) -> Date {
        return adding(years: -years)
    }
    
    /// 减少指定数量的月
    /// - Parameter months: 月数
    /// - Returns: 新日期
    func subtracting(months: Int) -> Date {
        return adding(months: -months)
    }
    
    /// 减少指定数量的天
    /// - Parameter days: 天数
    /// - Returns: 新日期
    func subtracting(days: Int) -> Date {
        return adding(days: -days)
    }
    
    /// 减少指定数量的小时
    /// - Parameter hours: 小时数
    /// - Returns: 新日期
    func subtracting(hours: Int) -> Date {
        return adding(hours: -hours)
    }
    
    /// 减少指定数量的分钟
    /// - Parameter minutes: 分钟数
    /// - Returns: 新日期
    func subtracting(minutes: Int) -> Date {
        return adding(minutes: -minutes)
    }
    
    /// 减少指定数量的秒
    /// - Parameter seconds: 秒数
    /// - Returns: 新日期
    func subtracting(seconds: Int) -> Date {
        return adding(seconds: -seconds)
    }
    
    /// 获取日期的开始时间（00:00:00）
    var startOfDay: Date {
        return calendar.startOfDay(for: self)
    }
    
    /// 获取日期的结束时间（23:59:59）
    var endOfDay: Date {
        let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? self
        return Date(timeInterval: -1, since: nextDay)
    }
    
    /// 获取月份的开始日期
    var startOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 获取月份的结束日期
    var endOfMonth: Date {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) ?? self
        return Date(timeInterval: -1, since: nextMonth)
    }
    
    /// 获取年份的开始日期
    var startOfYear: Date {
        let components = calendar.dateComponents([.year], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 获取年份的结束日期
    var endOfYear: Date {
        let nextYear = calendar.date(byAdding: .year, value: 1, to: startOfYear) ?? self
        return Date(timeInterval: -1, since: nextYear)
    }
    
    /// 计算两个日期之间的天数差
    /// - Parameter date: 另一个日期
    /// - Returns: 天数差
    func days(from date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date.startOfDay, to: self.startOfDay)
        return components.day ?? 0
    }
    
    /// 计算两个日期之间的小时差
    /// - Parameter date: 另一个日期
    /// - Returns: 小时差
    func hours(from date: Date) -> Int {
        let components = calendar.dateComponents([.hour], from: date, to: self)
        return components.hour ?? 0
    }
    
    /// 计算两个日期之间的分钟差
    /// - Parameter date: 另一个日期
    /// - Returns: 分钟差
    func minutes(from date: Date) -> Int {
        let components = calendar.dateComponents([.minute], from: date, to: self)
        return components.minute ?? 0
    }
    
    // MARK: - 格式化
    
    /// 格式化为字符串
    /// - Parameter format: 格式字符串
    /// - Returns: 格式化后的字符串
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: self)
    }
    
    /// 格式化为中文日期字符串（yyyy年MM月dd日）
    var chineseDateString: String {
        return string(format: "yyyy年MM月dd日")
    }
    
    /// 格式化为中文日期时间字符串（yyyy年MM月dd日 HH:mm:ss）
    var chineseDateTimeString: String {
        return string(format: "yyyy年MM月dd日 HH:mm:ss")
    }
    
    /// 格式化为ISO 8601字符串
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    /// 格式化为相对时间字符串（如：刚刚、3分钟前、2小时前等）
    var relativeTimeString: String {
        let now = Date()
        let secondsAgo = Int(now.timeIntervalSince(self))
        
        if secondsAgo < 60 {
            return "刚刚"
        } else if secondsAgo < 3600 {
            let minutes = secondsAgo / 60
            return "\(minutes)分钟前"
        } else if secondsAgo < 86400 {
            let hours = secondsAgo / 3600
            return "\(hours)小时前"
        } else if secondsAgo < 2592000 { // 30天
            let days = secondsAgo / 86400
            return "\(days)天前"
        } else if secondsAgo < 31536000 { // 365天
            let months = secondsAgo / 2592000
            return "\(months)个月前"
        } else {
            let years = secondsAgo / 31536000
            return "\(years)年前"
        }
    }
    
    // MARK: - 静态方法
    
    /// 从时间戳创建日期
    /// - Parameter timestamp: 时间戳（秒）
    /// - Returns: 日期
    static func from(timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    /// 从毫秒时间戳创建日期
    /// - Parameter milliseconds: 毫秒时间戳
    /// - Returns: 日期
    static func from(milliseconds: Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    /// 从字符串创建日期
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - format: 格式字符串
    /// - Returns: 日期，如果解析失败则返回nil
    static func from(string: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.date(from: string)
    }
    
    /// 从ISO 8601字符串创建日期
    /// - Parameter string: ISO 8601字符串
    /// - Returns: 日期，如果解析失败则返回nil
    static func from(iso8601 string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
    
    /// 获取当前时间戳（秒）
    static var currentTimestamp: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    /// 获取当前毫秒时间戳
    static var currentTimestampMilliseconds: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

// MARK: - 日期比较运算符

public extension Date {
    
    /// 检查日期是否在某个日期范围内
    /// - Parameters:
    ///   - startDate: 开始日期
    ///   - endDate: 结束日期
    /// - Returns: 是否在范围内
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        return self >= startDate && self <= endDate
    }
    
    /// 检查日期是否与另一个日期在同一天
    /// - Parameter date: 另一个日期
    /// - Returns: 是否在同一天
    func isSameDay(as date: Date) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    /// 检查日期是否与另一个日期在同一月
    /// - Parameter date: 另一个日期
    /// - Returns: 是否在同一月
    func isSameMonth(as date: Date) -> Bool {
        return year == date.year && month == date.month
    }
    
    /// 检查日期是否与另一个日期在同一年
    /// - Parameter date: 另一个日期
    /// - Returns: 是否在同一年
    func isSameYear(as date: Date) -> Bool {
        return year == date.year
    }
}