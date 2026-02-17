// UIImage+Extension.swift
// UIKit图像扩展，提供便捷的图像处理和操作方法

#if canImport(UIKit)
import UIKit

public extension UIImage {
    
    // MARK: - 图像属性
    
    /// 图像的宽高比（宽度/高度）
    var aspectRatio: CGFloat {
        guard size.height > 0 else { return 0 }
        return size.width / size.height
    }
    
    /// 图像是否为正方形
    var isSquare: Bool {
        return size.width == size.height
    }
    
    /// 图像是否包含透明通道
    var hasAlpha: Bool {
        guard let cgImage = cgImage else { return false }
        let alpha = cgImage.alphaInfo
        return alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast
    }
    
    /// 图像的像素尺寸（以点为单位的尺寸乘以缩放比例）
    var pixelSize: CGSize {
        return CGSize(width: size.width * scale, height: size.height * scale)
    }
    
    /// 图像的字节大小（估算）
    var estimatedByteSize: Int {
        guard let cgImage = cgImage else { return 0 }
        let bytesPerPixel: Int
        switch cgImage.bitsPerPixel {
        case 32: bytesPerPixel = 4
        case 24: bytesPerPixel = 3
        case 16: bytesPerPixel = 2
        case 8: bytesPerPixel = 1
        default: bytesPerPixel = 4
        }
        return Int(pixelSize.width * pixelSize.height) * bytesPerPixel
    }
    
    // MARK: - 图像创建
    
    /// 创建纯色图像
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 尺寸
    /// - Returns: 纯色图像
    static func withColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 创建线性渐变图像
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - size: 尺寸
    ///   - startPoint: 起点（归一化坐标）
    ///   - endPoint: 终点（归一化坐标）
    ///   - locations: 颜色位置数组
    /// - Returns: 渐变图像
    static func gradientImage(
        colors: [UIColor],
        size: CGSize,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1),
        locations: [CGFloat]? = nil
    ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor }
        
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: cgColors as CFArray,
            locations: locations
        ) else { return nil }
        
        let start = CGPoint(x: startPoint.x * size.width, y: startPoint.y * size.height)
        let end = CGPoint(x: endPoint.x * size.width, y: endPoint.y * size.height)
        
        context.drawLinearGradient(
            gradient,
            start: start,
            end: end,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        )
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 创建径向渐变图像
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - size: 尺寸
    ///   - center: 中心点（归一化坐标）
    ///   - radius: 半径
    /// - Returns: 径向渐变图像
    static func radialGradientImage(
        colors: [UIColor],
        size: CGSize,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: CGFloat = 0.5
    ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor }
        
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: cgColors as CFArray,
            locations: [0.0, 1.0]
        ) else { return nil }
        
        let centerPoint = CGPoint(x: center.x * size.width, y: center.y * size.height)
        let gradientRadius = min(size.width, size.height) * radius
        
        context.drawRadialGradient(
            gradient,
            startCenter: centerPoint,
            startRadius: 0,
            endCenter: centerPoint,
            endRadius: gradientRadius,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        )
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 创建带圆角的图像
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 尺寸
    ///   - cornerRadius: 圆角半径
    /// - Returns: 带圆角的图像
    static func roundedRect(
        color: UIColor,
        size: CGSize,
        cornerRadius: CGFloat
    ) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.addClip()
        
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 从视图创建图像
    /// - Parameter view: 视图
    /// - Returns: 视图截图
    static func fromView(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 从图层创建图像
    /// - Parameter layer: 图层
    /// - Returns: 图层截图
    static func fromLayer(_ layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // MARK: - 图像处理
    
    /// 调整图像尺寸
    /// - Parameter targetSize: 目标尺寸
    /// - Returns: 调整尺寸后的图像
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    /// 调整图像尺寸，保持宽高比
    /// - Parameter targetSize: 目标尺寸
    /// - Parameter mode: 调整模式（.scaleAspectFit 或 .scaleAspectFill）
    /// - Returns: 调整尺寸后的图像
    func resized(toFit targetSize: CGSize, mode: ContentMode = .scaleAspectFit) -> UIImage? {
        let aspectWidth = targetSize.width / size.width
        let aspectHeight = targetSize.height / size.height
        let aspectRatio: CGFloat
        
        switch mode {
        case .scaleAspectFit:
            aspectRatio = min(aspectWidth, aspectHeight)
        case .scaleAspectFill:
            aspectRatio = max(aspectWidth, aspectHeight)
        default:
            aspectRatio = min(aspectWidth, aspectHeight)
        }
        
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        return resized(to: newSize)
    }
    
    /// 裁剪图像
    /// - Parameter rect: 裁剪区域（相对于图像坐标系）
    /// - Returns: 裁剪后的图像
    func cropped(to rect: CGRect) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        
        let scale = self.scale
        let cropRect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.size.width * scale,
            height: rect.size.height * scale
        )
        
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
    
    /// 裁剪图像为正方形
    /// - Returns: 正方形图像
    func croppedToSquare() -> UIImage? {
        let minSide = min(size.width, size.height)
        let squareRect = CGRect(
            x: (size.width - minSide) / 2,
            y: (size.height - minSide) / 2,
            width: minSide,
            height: minSide
        )
        return cropped(to: squareRect)
    }
    
    /// 添加圆角
    /// - Parameter radius: 圆角半径
    /// - Returns: 带圆角的图像
    func withRoundedCorners(radius: CGFloat) -> UIImage? {
        let imageRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        let path = UIBezierPath(roundedRect: imageRect, cornerRadius: radius)
        path.addClip()
        draw(in: imageRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 添加圆形蒙版
    /// - Returns: 圆形图像
    func circular() -> UIImage? {
        let minSide = min(size.width, size.height)
        let circleRect = CGRect(
            x: (size.width - minSide) / 2,
            y: (size.height - minSide) / 2,
            width: minSide,
            height: minSide
        )
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: minSide, height: minSide), false, scale)
        defer { UIGraphicsEndImageContext() }
        
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: minSide, height: minSide)))
        path.addClip()
        
        let drawRect = CGRect(
            x: -circleRect.origin.x,
            y: -circleRect.origin.y,
            width: size.width,
            height: size.height
        )
        draw(in: drawRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 旋转图像
    /// - Parameter radians: 旋转弧度
    /// - Returns: 旋转后的图像
    func rotated(by radians: CGFloat) -> UIImage? {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .size
        
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: radians)
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
    
    /// 翻转图像
    /// - Parameter horizontally: 是否水平翻转
    /// - Returns: 翻转后的图像
    func flipped(horizontally: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        if horizontally {
            context.translateBy(x: size.width, y: 0)
            context.scaleBy(x: -1, y: 1)
        } else {
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)
        }
        
        draw(in: CGRect(origin: .zero, size: size))
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flippedImage
    }
    
    /// 调整图像亮度、对比度和饱和度
    /// - Parameters:
    ///   - brightness: 亮度调整（-1.0 到 1.0）
    ///   - contrast: 对比度调整（0.0 到 4.0，1.0为原始对比度）
    ///   - saturation: 饱和度调整（0.0 到 2.0，1.0为原始饱和度）
    /// - Returns: 调整后的图像
    func adjusted(brightness: CGFloat, contrast: CGFloat, saturation: CGFloat) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
        filter?.setValue(contrast, forKey: kCIInputContrastKey)
        filter?.setValue(saturation, forKey: kCIInputSaturationKey)
        
        guard let outputImage = filter?.outputImage,
              let outputCGImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage, scale: scale, orientation: imageOrientation)
    }
    
    /// 为图像添加高斯模糊
    /// - Parameter radius: 模糊半径
    /// - Returns: 模糊后的图像
    func blurred(radius: CGFloat = 10) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputImage = filter?.outputImage,
              let outputCGImage = CIContext().createCGImage(outputImage, from: ciImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage, scale: scale, orientation: imageOrientation)
    }
    
    /// 为图像添加颜色叠加
    /// - Parameter color: 叠加颜色
    /// - Returns: 颜色叠加后的图像
    func withColorOverlay(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: .zero, size: size)
        
        // 绘制原始图像
        draw(in: rect)
        
        // 设置混合模式并绘制颜色
        context?.setBlendMode(.sourceAtop)
        color.setFill()
        UIRectFill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // MARK: - 图像转换
    
    /// 将图像转换为JPEG数据
    /// - Parameter compressionQuality: 压缩质量（0.0 到 1.0）
    /// - Returns: JPEG数据
    func jpegData(compressionQuality: CGFloat = 0.8) -> Data? {
        return self.jpegData(compressionQuality: compressionQuality)
    }
    
    /// 将图像转换为PNG数据
    /// - Returns: PNG数据
    func pngData() -> Data? {
        return self.pngData()
    }
    
    /// 将图像转换为Base64编码的字符串
    /// - Parameter compressionQuality: JPEG压缩质量（仅当图像不是PNG时使用）
    /// - Returns: Base64编码的字符串
    func base64String(compressionQuality: CGFloat = 0.8) -> String? {
        let data: Data?
        if hasAlpha {
            data = pngData()
        } else {
            data = jpegData(compressionQuality: compressionQuality)
        }
        return data?.base64EncodedString()
    }
    
    /// 获取图像的主色调
    /// - Returns: 主色调
    func dominantColor() -> UIColor? {
        guard let cgImage = cgImage else { return nil }
        
        let width = 1
        let height = 1
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        guard let pixelData = context.data else { return nil }
        let data = pixelData.bindMemory(to: UInt8.self, capacity: bytesPerPixel)
        
        let red = CGFloat(data[0]) / 255.0
        let green = CGFloat(data[1]) / 255.0
        let blue = CGFloat(data[2]) / 255.0
        let alpha = CGFloat(data[3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // MARK: - 图标和符号
    
    /// 创建系统图标图像
    /// - Parameters:
    ///   - systemName: 系统图标名称
    ///   - configuration: 图标配置
    /// - Returns: 系统图标图像
    @available(iOS 13.0, *)
    static func systemImage(_ systemName: String, configuration: UIImage.Configuration? = nil) -> UIImage? {
        return UIImage(systemName: systemName, withConfiguration: configuration)
    }
    
    /// 创建带颜色的系统图标
    /// - Parameters:
    ///   - systemName: 系统图标名称
    ///   - color: 图标颜色
    ///   - configuration: 图标配置
    /// - Returns: 带颜色的系统图标图像
    @available(iOS 13.0, *)
    static func systemImage(_ systemName: String, color: UIColor, configuration: UIImage.Configuration? = nil) -> UIImage? {
        return UIImage(systemName: systemName, withConfiguration: configuration)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    // MARK: - 图像缓存
    
    /// 图像缓存键（基于图像的属性）
    var cacheKey: String {
        var key = "\(size.width)x\(size.height)-\(scale)-\(imageOrientation.rawValue)"
        if let cgImage = cgImage {
            key += "-\(cgImage.hash)"
        }
        return key
    }
    
    /// 检查图像是否与另一个图像相似（尺寸和比例相同）
    /// - Parameter other: 另一个图像
    /// - Returns: 是否相似
    func isSimilar(to other: UIImage) -> Bool {
        return size == other.size &&
               scale == other.scale &&
               imageOrientation == other.imageOrientation
    }
}

// MARK: - UIImage 便利构造函数

public extension UIImage {
    
    /// 从Base64字符串创建图像
    /// - Parameter base64String: Base64编码的字符串
    /// - Returns: 图像
    convenience init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data)
    }
    
    /// 从文件路径创建图像
    /// - Parameter filePath: 文件路径
    /// - Returns: 图像
    convenience init?(filePath: String) {
        let url = URL(fileURLWithPath: filePath)
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
}

// MARK: - UIImage 数组扩展

public extension Array where Element == UIImage {
    
    /// 将多个图像拼接成网格
    /// - Parameters:
    ///   - columns: 列数
    ///   - spacing: 图像间距
    ///   - backgroundColor: 背景颜色
    /// - Returns: 拼接后的图像
    func combinedGrid(columns: Int, spacing: CGFloat = 0, backgroundColor: UIColor = .clear) -> UIImage? {
        guard !isEmpty else { return nil }
        
        let rows = Int(ceil(Double(count) / Double(columns)))
        
        // 计算每个图像的最大尺寸
        let maxWidth = self.map { $0.size.width }.max() ?? 0
        let maxHeight = self.map { $0.size.height }.max() ?? 0
        
        // 计算总尺寸
        let totalWidth = CGFloat(columns) * maxWidth + CGFloat(columns - 1) * spacing
        let totalHeight = CGFloat(rows) * maxHeight + CGFloat(rows - 1) * spacing
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: totalWidth, height: totalHeight), false, 0)
        defer { UIGraphicsEndImageContext() }
        
        // 填充背景
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: CGSize(width: totalWidth, height: totalHeight)))
        
        // 绘制每个图像
        for (index, image) in enumerated() {
            let row = index / columns
            let column = index % columns
            
            let x = CGFloat(column) * (maxWidth + spacing)
            let y = CGFloat(row) * (maxHeight + spacing)
            
            // 居中绘制图像
            let drawX = x + (maxWidth - image.size.width) / 2
            let drawY = y + (maxHeight - image.size.height) / 2
            
            image.draw(at: CGPoint(x: drawX, y: drawY))
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 将多个图像水平拼接
    /// - Parameter spacing: 图像间距
    /// - Returns: 水平拼接的图像
    func combinedHorizontally(spacing: CGFloat = 0) -> UIImage? {
        guard !isEmpty else { return nil }
        
        // 计算总宽度和最大高度
        let totalWidth = reduce(0) { $0 + $1.size.width } + CGFloat(count - 1) * spacing
        let maxHeight = self.map { $0.size.height }.max() ?? 0
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: totalWidth, height: maxHeight), false, 0)
        defer { UIGraphicsEndImageContext() }
        
        var currentX: CGFloat = 0
        for image in self {
            // 垂直居中绘制
            let drawY = (maxHeight - image.size.height) / 2
            image.draw(at: CGPoint(x: currentX, y: drawY))
            currentX += image.size.width + spacing
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 将多个图像垂直拼接
    /// - Parameter spacing: 图像间距
    /// - Returns: 垂直拼接的图像
    func combinedVertically(spacing: CGFloat = 0) -> UIImage? {
        guard !isEmpty else { return nil }
        
        // 计算最大宽度和总高度
        let maxWidth = self.map { $0.size.width }.max() ?? 0
        let totalHeight = reduce(0) { $0 + $1.size.height } + CGFloat(count - 1) * spacing
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: totalHeight), false, 0)
        defer { UIGraphicsEndImageContext() }
        
        var currentY: CGFloat = 0
        for image in self {
            // 水平居中绘制
            let drawX = (maxWidth - image.size.width) / 2
            image.draw(at: CGPoint(x: drawX, y: currentY))
            currentY += image.size.height + spacing
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - UIImage 枚举扩展

public extension UIImage {
    
    /// 常见图像尺寸
    enum CommonSize {
        /// 小图标尺寸 (24x24)
        public static let iconSmall = CGSize(width: 24, height: 24)
        /// 中图标尺寸 (32x32)
        public static let iconMedium = CGSize(width: 32, height: 32)
        /// 大图标尺寸 (48x48)
        public static let iconLarge = CGSize(width: 48, height: 48)
        /// 头像小尺寸 (40x40)
        public static let avatarSmall = CGSize(width: 40, height: 40)
        /// 头像中尺寸 (60x60)
        public static let avatarMedium = CGSize(width: 60, height: 60)
        /// 头像大尺寸 (100x100)
        public static let avatarLarge = CGSize(width: 100, height: 100)
        /// 缩略图小尺寸 (120x120)
        public static let thumbnailSmall = CGSize(width: 120, height: 120)
        /// 缩略图中尺寸 (200x200)
        public static let thumbnailMedium = CGSize(width: 200, height: 200)
        /// 缩略图大尺寸 (320x320)
        public static let thumbnailLarge = CGSize(width: 320, height: 320)
    }
    
    /// 常见占位符图像
    static var placeholder: UIImage? {
        return UIImage.withColor(.lightGray, size: CGSize(width: 100, height: 100))
    }
    
    /// 错误图像
    static var errorImage: UIImage? {
        return UIImage.withColor(.systemRed, size: CGSize(width: 100, height: 100))
    }
}

#endif