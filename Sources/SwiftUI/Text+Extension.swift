// Text+Extension.swift
// SwiftUI Text扩展，提供便捷的文本样式和格式化方法

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension Text {
    
    // MARK: - 字体样式
    
    /// 设置大型标题字体
    func largeTitle() -> Text {
        self.font(.largeTitle)
    }
    
    /// 设置标题字体
    func title() -> Text {
        self.font(.title)
    }
    
    /// 设置标题2字体
    func title2() -> Text {
        self.font(.title2)
    }
    
    /// 设置标题3字体
    func title3() -> Text {
        self.font(.title3)
    }
    
    /// 设置标题字体
    func headline() -> Text {
        self.font(.headline)
    }
    
    /// 设置子标题字体
    func subheadline() -> Text {
        self.font(.subheadline)
    }
    
    /// 设置正文字体
    func body() -> Text {
        self.font(.body)
    }
    
    /// 设置说明文字字体
    func callout() -> Text {
        self.font(.callout)
    }
    
    /// 设置脚注字体
    func footnote() -> Text {
        self.font(.footnote)
    }
    
    /// 设置小标题字体
    func caption() -> Text {
        self.font(.caption)
    }
    
    /// 设置小标题2字体
    func caption2() -> Text {
        self.font(.caption2)
    }
    
    /// 设置粗体字体
    func bold() -> Text {
        self.bold()
    }
    
    /// 设置斜体字体
    func italic() -> Text {
        self.italic()
    }
    
    /// 设置字体粗细
    func fontWeight(_ weight: Font.Weight) -> Text {
        self.fontWeight(weight)
    }
    
    /// 设置系统字体大小
    func systemFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Text {
        self.font(.system(size: size, weight: weight, design: design))
    }
    
    /// 设置等宽字体
    func monospaced() -> Text {
        self.monospaced()
    }
    
    // MARK: - 文本颜色
    
    /// 设置主要文本颜色
    func primaryColor() -> Text {
        self.foregroundColor(.primary)
    }
    
    /// 设置次要文本颜色
    func secondaryColor() -> Text {
        self.foregroundColor(.secondary)
    }
    
    /// 设置强调色文本颜色
    func accentColor() -> Text {
        self.foregroundColor(.accentColor)
    }
    
    /// 设置红色文本颜色
    func red() -> Text {
        self.foregroundColor(.red)
    }
    
    /// 设置橙色文本颜色
    func orange() -> Text {
        self.foregroundColor(.orange)
    }
    
    /// 设置黄色文本颜色
    func yellow() -> Text {
        self.foregroundColor(.yellow)
    }
    
    /// 设置绿色文本颜色
    func green() -> Text {
        self.foregroundColor(.green)
    }
    
    /// 设置蓝色文本颜色
    func blue() -> Text {
        self.foregroundColor(.blue)
    }
    
    /// 设置紫色文本颜色
    func purple() -> Text {
        self.foregroundColor(.purple)
    }
    
    /// 设置粉色文本颜色
    func pink() -> Text {
        self.foregroundColor(.pink)
    }
    
    /// 设置自定义颜色
    func customColor(_ color: Color) -> Text {
        self.foregroundColor(color)
    }
    
    // MARK: - 文本对齐
    
    /// 左对齐文本
    func alignLeft() -> some View {
        self.multilineTextAlignment(.leading)
    }
    
    /// 居中对齐文本
    func alignCenter() -> some View {
        self.multilineTextAlignment(.center)
    }
    
    /// 右对齐文本
    func alignRight() -> some View {
        self.multilineTextAlignment(.trailing)
    }
    
    /// 设置文本对齐方式
    func alignment(_ alignment: TextAlignment) -> some View {
        self.multilineTextAlignment(alignment)
    }
    
    // MARK: - 文本修饰
    
    /// 添加下划线
    func underline(_ color: Color? = nil) -> Text {
        if let color = color {
            return self.underline(true, color: color)
        } else {
            return self.underline(true)
        }
    }
    
    /// 添加删除线
    func strikethrough(_ color: Color? = nil) -> Text {
        if let color = color {
            return self.strikethrough(true, color: color)
        } else {
            return self.strikethrough(true)
        }
    }
    
    /// 设置字间距
    func kerning(_ kerning: CGFloat) -> Text {
        self.kerning(kerning)
    }
    
    /// 设置行间距
    func lineSpacing(_ spacing: CGFloat) -> Text {
        self.lineSpacing(spacing)
    }
    
    /// 设置文本基线偏移
    func baselineOffset(_ offset: CGFloat) -> Text {
        self.baselineOffset(offset)
    }
    
    /// 设置文本跟踪
    func tracking(_ tracking: CGFloat) -> Text {
        self.tracking(tracking)
    }
    
    /// 限制文本行数
    func lineLimit(_ number: Int?) -> Text {
        self.lineLimit(number)
    }
    
    /// 设置最小缩放比例
    func minimumScaleFactor(_ factor: CGFloat) -> Text {
        self.minimumScaleFactor(factor)
    }
    
    /// 设置截断模式
    func truncationMode(_ mode: Text.TruncationMode) -> Text {
        self.truncationMode(mode)
    }
    
    // MARK: - 链式调用示例
    
    /// 链式设置标题样式
    func titleStyle(color: Color = .primary) -> Text {
        self
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(color)
    }
    
    /// 链式设置副标题样式
    func subtitleStyle(color: Color = .secondary) -> Text {
        self
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(color)
    }
    
    /// 链式设置正文样式
    func bodyStyle(color: Color = .primary) -> Text {
        self
            .font(.body)
            .foregroundColor(color)
            .lineSpacing(4)
    }
    
    /// 链式设置链接样式
    func linkStyle(color: Color = .blue) -> Text {
        self
            .font(.body)
            .foregroundColor(color)
            .underline(color)
    }
    
    /// 链式设置错误样式
    func errorStyle() -> Text {
        self
            .font(.caption)
            .foregroundColor(.red)
            .bold()
    }
    
    /// 链式设置成功样式
    func successStyle() -> Text {
        self
            .font(.caption)
            .foregroundColor(.green)
            .bold()
    }
    
    /// 链式设置警告样式
    func warningStyle() -> Text {
        self
            .font(.caption)
            .foregroundColor(.orange)
            .bold()
    }
    
    /// 链式设置提示样式
    func hintStyle() -> Text {
        self
            .font(.caption)
            .foregroundColor(.gray)
    }
}

// MARK: - Text 工厂方法

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension Text {
    
    /// 创建标题文本
    static func title(_ text: String, color: Color = .primary) -> Text {
        Text(text)
            .titleStyle(color: color)
    }
    
    /// 创建副标题文本
    static func subtitle(_ text: String, color: Color = .secondary) -> Text {
        Text(text)
            .subtitleStyle(color: color)
    }
    
    /// 创建正文文本
    static func body(_ text: String, color: Color = .primary) -> Text {
        Text(text)
            .bodyStyle(color: color)
    }
    
    /// 创建链接文本
    static func link(_ text: String, color: Color = .blue) -> Text {
        Text(text)
            .linkStyle(color: color)
    }
    
    /// 创建错误文本
    static func error(_ text: String) -> Text {
        Text(text)
            .errorStyle()
    }
    
    /// 创建成功文本
    static func success(_ text: String) -> Text {
        Text(text)
            .successStyle()
    }
    
    /// 创建警告文本
    static func warning(_ text: String) -> Text {
        Text(text)
            .warningStyle()
    }
    
    /// 创建提示文本
    static func hint(_ text: String) -> Text {
        Text(text)
            .hintStyle()
    }
    
    /// 创建带图标的文本
    static func withIcon(_ systemName: String, text: String, color: Color = .primary) -> Text {
        Text(Image(systemName: systemName)) + Text(" ") + Text(text).foregroundColor(color)
    }
    
    /// 格式化日期文本
    static func date(_ date: Date, format: String = "yyyy-MM-dd") -> Text {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return Text(formatter.string(from: date))
    }
    
    /// 格式化数字文本
    static func number(_ number: Double, format: String = "%.2f") -> Text {
        return Text(String(format: format, number))
    }
    
    /// 格式化货币文本
    static func currency(_ amount: Double, locale: Locale = .current) -> Text {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return Text(formatter.string(from: NSNumber(value: amount)) ?? "\(amount)")
    }
}

// MARK: - 字符串扩展（提供Text转换）

public extension String {
    
    /// 转换为Text对象
    var toText: Text {
        Text(self)
    }
    
    /// 创建带样式的Text对象
    func styledAsTitle(color: Color = .primary) -> Text {
        Text(self).titleStyle(color: color)
    }
    
    /// 创建带副标题样式的Text对象
    func styledAsSubtitle(color: Color = .secondary) -> Text {
        Text(self).subtitleStyle(color: color)
    }
    
    /// 创建带正文样式的Text对象
    func styledAsBody(color: Color = .primary) -> Text {
        Text(self).bodyStyle(color: color)
    }
    
    /// 创建带链接样式的Text对象
    func styledAsLink(color: Color = .blue) -> Text {
        Text(self).linkStyle(color: color)
    }
    
    /// 创建带错误样式的Text对象
    func styledAsError() -> Text {
        Text(self).errorStyle()
    }
    
    /// 创建带成功样式的Text对象
    func styledAsSuccess() -> Text {
        Text(self).successStyle()
    }
}

#endif
