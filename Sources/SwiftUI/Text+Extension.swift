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
    
    /// 设置为粗体字体
    func boldText() -> Text {
        self.bold()
    }

    /// 设置为斜体字体
    func italicText() -> Text {
        self.italic()
    }

    /// 设置字体粗细
    func setFontWeight(_ weight: Font.Weight) -> Text {
        self.fontWeight(weight)
    }
    
    /// 设置系统字体大小
    func systemFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Text {
        self.font(.system(size: size, weight: weight, design: design))
    }
    
    /// 设置为等宽字体
    @available(iOS 16.0, macOS 13.3, tvOS 16.0, watchOS 9.1, *)
    func monospacedText() -> Text {
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
    func redColor() -> Text {
        self.foregroundColor(.red)
    }
    
    /// 设置橙色文本颜色
    func orangeColor() -> Text {
        self.foregroundColor(.orange)
    }
    
    /// 设置黄色文本颜色
    func yellowColor() -> Text {
        self.foregroundColor(.yellow)
    }
    
    /// 设置绿色文本颜色
    func greenColor() -> Text {
        self.foregroundColor(.green)
    }
    
    /// 设置蓝色文本颜色
    func blueColor() -> Text {
        self.foregroundColor(.blue)
    }
    
    /// 设置紫色文本颜色
    func purpleColor() -> Text {
        self.foregroundColor(.purple)
    }
    
    /// 设置粉色文本颜色
    func pinkColor() -> Text {
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
    func addUnderline(_ color: Color? = nil) -> Text {
        if let color = color {
            return self.underline(true, color: color)
        } else {
            return self.underline(true)
        }
    }
    
    /// 添加删除线
    func addStrikethrough(_ color: Color? = nil) -> Text {
        if let color = color {
            return self.strikethrough(true, color: color)
        } else {
            return self.strikethrough(true)
        }
    }
    
    /// 设置文本字间距
    func setKerning(_ kerning: CGFloat) -> Text {
        self.kerning(kerning)
    }

    /// 设置文本行间距
    func setLineSpacing(_ spacing: CGFloat) -> some View {
        self.lineSpacing(spacing)
    }

    /// 设置文本基线偏移
    func setBaselineOffset(_ offset: CGFloat) -> Text {
        self.baselineOffset(offset)
    }

    /// 设置文本跟踪
    func setTracking(_ tracking: CGFloat) -> Text {
        self.tracking(tracking)
    }

    /// 限制文本行数
    func setLineLimit(_ number: Int?) -> some View {
        self.lineLimit(number)
    }

    /// 设置最小缩放比例
    func setMinimumScaleFactor(_ factor: CGFloat) -> some View {
        self.minimumScaleFactor(factor)
    }

    /// 设置截断模式
    func setTruncationMode(_ mode: Text.TruncationMode) -> some View {
        self.truncationMode(mode)
    }
    
    // MARK: - 链式样式
    
    /// 应用标题样式
    func applyTitleStyle(color: Color = .primary) -> some View {
        self
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(color)
    }
    
    /// 应用副标题样式
    func applySubtitleStyle(color: Color = .secondary) -> some View {
        self
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(color)
    }
    
    /// 应用正文样式
    func applyBodyStyle(color: Color = .primary) -> some View {
        self
            .font(.body)
            .foregroundColor(color)
    }
    
    /// 应用链接样式
    func applyLinkStyle(color: Color = .blue) -> some View {
        self
            .font(.body)
            .foregroundColor(color)
            .underline(true, color: color)
    }
    
    /// 应用错误样式
    func applyErrorStyle() -> some View {
        self
            .font(.caption)
            .foregroundColor(.red)
            .bold()
    }
    
    /// 应用成功样式
    func applySuccessStyle() -> some View {
        self
            .font(.caption)
            .foregroundColor(.green)
            .bold()
    }
    
    /// 应用警告样式
    func applyWarningStyle() -> some View {
        self
            .font(.caption)
            .foregroundColor(.orange)
            .bold()
    }
    
    /// 应用提示样式
    func applyHintStyle() -> some View {
        self
            .font(.caption)
            .foregroundColor(.gray)
    }
}

// MARK: - Text 工厂方法

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension Text {
    
    /// 创建标题文本
    static func styledTitle(_ text: String, color: Color = .primary) -> some View {
        Text(text).applyTitleStyle(color: color)
    }
    
    /// 创建副标题文本
    static func styledSubtitle(_ text: String, color: Color = .secondary) -> some View {
        Text(text).applySubtitleStyle(color: color)
    }
    
    /// 创建正文文本
    static func styledBody(_ text: String, color: Color = .primary) -> some View {
        Text(text).applyBodyStyle(color: color)
    }
    
    /// 创建链接文本
    static func styledLink(_ text: String, color: Color = .blue) -> some View {
        Text(text).applyLinkStyle(color: color)
    }
    
    /// 创建错误文本
    static func styledError(_ text: String) -> some View {
        Text(text).applyErrorStyle()
    }
    
    /// 创建成功文本
    static func styledSuccess(_ text: String) -> some View {
        Text(text).applySuccessStyle()
    }
    
    /// 创建警告文本
    static func styledWarning(_ text: String) -> some View {
        Text(text).applyWarningStyle()
    }
    
    /// 创建提示文本
    static func styledHint(_ text: String) -> some View {
        Text(text).applyHintStyle()
    }
    
    /// 创建带图标的文本
    static func withSystemIcon(_ systemName: String, text: String, color: Color = .primary) -> Text {
        Text(Image(systemName: systemName)) + Text(" ") + Text(text).foregroundColor(color)
    }
    
    /// 格式化日期文本
    static func formattedDate(_ date: Date, format: String = "yyyy-MM-dd") -> Text {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return Text(formatter.string(from: date))
    }
    
    /// 格式化数字文本
    static func formattedNumber(_ number: Double, format: String = "%.2f") -> Text {
        return Text(String(format: format, number))
    }
    
    /// 格式化货币文本
    static func formattedCurrency(_ amount: Double, locale: Locale = .current) -> Text {
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
    
    /// 创建带标题样式的文本
    func asStyledTitle(color: Color = .primary) -> some View {
        Text(self).applyTitleStyle(color: color)
    }
    
    /// 创建带副标题样式的文本
    func asStyledSubtitle(color: Color = .secondary) -> some View {
        Text(self).applySubtitleStyle(color: color)
    }
    
    /// 创建带正文样式的文本
    func asStyledBody(color: Color = .primary) -> some View {
        Text(self).applyBodyStyle(color: color)
    }
    
    /// 创建带链接样式的文本
    func asStyledLink(color: Color = .blue) -> some View {
        Text(self).applyLinkStyle(color: color)
    }
    
    /// 创建带错误样式的文本
    func asStyledError() -> some View {
        Text(self).applyErrorStyle()
    }
    
    /// 创建带成功样式的文本
    func asStyledSuccess() -> some View {
        Text(self).applySuccessStyle()
    }
}

#endif