// UIView+Extension.swift
// UIView扩展，提供便捷的布局、样式和动画方法

#if canImport(UIKit)
import UIKit

@MainActor
public extension UIView {
    
    // MARK: - 布局扩展
    
    /// 安全获取父视图控制器
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    /// 添加多个子视图
    /// - Parameter subviews: 子视图数组
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    /// 添加多个子视图（数组版本）
    /// - Parameter subviews: 子视图数组
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    /// 安全移除所有子视图
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    /// 安全移除指定类型的子视图
    /// - Parameter type: 要移除的子视图类型
    func removeSubviews<T: UIView>(ofType type: T.Type) {
        subviews.forEach {
            if $0 is T {
                $0.removeFromSuperview()
            }
        }
    }
    
    /// 使用AutoLayout填充父视图（四边约束）
    /// - Parameters:
    ///   - edges: 边距，默认为.zero
    ///   - safeArea: 是否使用安全区域，默认为false
    func fillSuperview(edges: UIEdgeInsets = .zero, safeArea: Bool = false) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        let guide: UILayoutGuide? = safeArea ? superview.safeAreaLayoutGuide : nil
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: guide?.leadingAnchor ?? superview.leadingAnchor, constant: edges.left),
            trailingAnchor.constraint(equalTo: guide?.trailingAnchor ?? superview.trailingAnchor, constant: -edges.right),
            topAnchor.constraint(equalTo: guide?.topAnchor ?? superview.topAnchor, constant: edges.top),
            bottomAnchor.constraint(equalTo: guide?.bottomAnchor ?? superview.bottomAnchor, constant: -edges.bottom)
        ])
    }
    
    /// 在父视图中居中
    /// - Parameter size: 可选大小，如果提供则设置大小约束
    func centerInSuperview(size: CGSize? = nil) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
        
        if let size = size {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: size.width),
                heightAnchor.constraint(equalToConstant: size.height)
            ])
        }
    }
    
    /// 设置视图的大小约束
    /// - Parameter size: 大小
    func setSize(_ size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
    
    // MARK: - 样式扩展
    
    /// 添加圆角
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 圆角位置，默认为所有角
    func roundCorners(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        layer.masksToBounds = true
    }
    
    /// 添加边框
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// 添加阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - radius: 阴影半径
    ///   - offset: 阴影偏移
    ///   - opacity: 阴影透明度
    func addShadow(color: UIColor = .black,
                   radius: CGFloat = 3.0,
                   offset: CGSize = .zero,
                   opacity: Float = 0.2) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    /// 渐变色背景
    /// - Parameters:
    ///   - colors: 渐变色数组
    ///   - startPoint: 起始点
    ///   - endPoint: 结束点
    ///   - locations: 位置数组
    func setGradientBackground(colors: [UIColor],
                               startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                               endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0),
                               locations: [NSNumber]? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        
        // 移除已有的渐变层
        layer.sublayers?.removeAll { $0 is CAGradientLayer }
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 设置背景图片
    /// - Parameter image: 背景图片
    func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(imageView, at: 0)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - 动画扩展
    
    /// 淡入动画
    /// - Parameters:
    ///   - duration: 动画时长，默认为0.3秒
    ///   - completion: 完成回调
    func fadeIn(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        isHidden = false
        alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /// 淡出动画
    /// - Parameters:
    ///   - duration: 动画时长，默认为0.3秒
    ///   - completion: 完成回调
    func fadeOut(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: { finished in
            self.isHidden = true
            self.alpha = 1
            completion?(finished)
        })
    }
    
    /// 缩放动画
    /// - Parameters:
    ///   - scale: 缩放比例
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func scale(to scale: CGFloat, duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: completion)
    }
    
    /// 恢复原始大小
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func resetScale(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = .identity
        }, completion: completion)
    }
    
    /// 震动动画
    /// - Parameters:
    ///   - intensity: 震动强度，默认为10
    ///   - duration: 动画时长，默认为0.5秒
    func shake(intensity: CGFloat = 10, duration: TimeInterval = 0.5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.values = [-intensity, intensity, -intensity, intensity, -intensity/2, intensity/2, -intensity/4, intensity/4, 0]
        layer.add(animation, forKey: "shake")
    }
    
    // MARK: - 工具方法
    
    /// 生成视图的截图
    /// - Returns: 截图UIImage
    func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
    
    /// 安全设置视图的隐藏状态
    /// - Parameters:
    ///   - hidden: 是否隐藏
    ///   - animated: 是否使用动画
    ///   - duration: 动画时长
    func setHidden(_ hidden: Bool, animated: Bool = false, duration: TimeInterval = 0.3) {
        guard self.isHidden != hidden else { return }
        
        if animated {
            if hidden {
                fadeOut(duration: duration)
            } else {
                fadeIn(duration: duration)
            }
        } else {
            self.isHidden = hidden
        }
    }
    
    /// 安全地切换视图的隐藏状态
    /// - Parameter animated: 是否使用动画
    func toggleHidden(animated: Bool = false) {
        setHidden(!isHidden, animated: animated)
    }
    
    /// 获取视图在屏幕上的绝对位置
    var absoluteFrame: CGRect {
        guard let window = window else { return .zero }
        return convert(bounds, to: window)
    }
    
    /// 安全查找指定类型的子视图
    /// - Parameter type: 要查找的视图类型
    /// - Returns: 找到的视图数组
    func findSubviews<T: UIView>(ofType type: T.Type) -> [T] {
        var result: [T] = []
        
        for subview in subviews {
            if let typedSubview = subview as? T {
                result.append(typedSubview)
            }
            result.append(contentsOf: subview.findSubviews(ofType: type))
        }
        
        return result
    }
}

#endif
