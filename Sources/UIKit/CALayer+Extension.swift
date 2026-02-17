// CALayer+Extension.swift
// CALayer扩展，提供便捷的图层样式和动画方法

#if canImport(UIKit)
import UIKit

public extension CALayer {
    
    // MARK: - 样式扩展
    
    /// 设置圆角样式
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 圆角位置（仅在设置了maskedCorners时有效）
    func setCornerRadius(_ radius: CGFloat, corners: CACornerMask? = nil) {
        cornerRadius = radius
        if let corners = corners {
            maskedCorners = corners
        }
        masksToBounds = true
    }
    
    /// 设置所有圆角
    /// - Parameter radius: 圆角半径
    func setAllCorners(_ radius: CGFloat) {
        setCornerRadius(radius, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, 
                                          .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
    /// 设置顶部圆角
    /// - Parameter radius: 圆角半径
    func setTopCorners(_ radius: CGFloat) {
        setCornerRadius(radius, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    /// 设置底部圆角
    /// - Parameter radius: 圆角半径
    func setBottomCorners(_ radius: CGFloat) {
        setCornerRadius(radius, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
    /// 设置左侧圆角
    /// - Parameter radius: 圆角半径
    func setLeftCorners(_ radius: CGFloat) {
        setCornerRadius(radius, corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
    }
    
    /// 设置右侧圆角
    /// - Parameter radius: 圆角半径
    func setRightCorners(_ radius: CGFloat) {
        setCornerRadius(radius, corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
    }
    
    /// 设置边框样式
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    func setBorder(width: CGFloat, color: UIColor) {
        borderWidth = width
        borderColor = color.cgColor
    }
    
    /// 设置阴影样式
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - radius: 阴影半径
    ///   - offset: 阴影偏移
    ///   - opacity: 阴影透明度
    func setShadow(color: UIColor = .black,
                   radius: CGFloat = 3.0,
                   offset: CGSize = .zero,
                   opacity: Float = 0.2) {
        shadowColor = color.cgColor
        shadowRadius = radius
        shadowOffset = offset
        shadowOpacity = opacity
        masksToBounds = false
    }
    
    /// 设置内阴影（通过子层实现）
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - radius: 阴影半径
    ///   - offset: 阴影偏移
    ///   - opacity: 阴影透明度
    func setInnerShadow(color: UIColor = .black,
                        radius: CGFloat = 3.0,
                        offset: CGSize = .zero,
                        opacity: Float = 0.2) {
        // 移除现有的内阴影层
        sublayers?.removeAll { $0.name == "innerShadowLayer" }
        
        let innerShadowLayer = CALayer()
        innerShadowLayer.name = "innerShadowLayer"
        innerShadowLayer.frame = bounds
        
        let path = UIBezierPath(rect: bounds.insetBy(dx: -radius, dy: -radius))
        let cutout = UIBezierPath(rect: bounds).reversing()
        path.append(cutout)
        
        innerShadowLayer.shadowPath = path.cgPath
        innerShadowLayer.shadowColor = color.cgColor
        innerShadowLayer.shadowOffset = offset
        innerShadowLayer.shadowOpacity = opacity
        innerShadowLayer.shadowRadius = radius
        innerShadowLayer.masksToBounds = true
        
        addSublayer(innerShadowLayer)
    }
    
    /// 设置渐变色背景
    /// - Parameters:
    ///   - colors: 渐变色数组
    ///   - startPoint: 起始点
    ///   - endPoint: 结束点
    ///   - locations: 位置数组
    func setGradientBackground(colors: [UIColor],
                               startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                               endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0),
                               locations: [NSNumber]? = nil) {
        // 移除现有的渐变色层
        sublayers?.removeAll { $0 is CAGradientLayer }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        
        insertSublayer(gradientLayer, at: 0)
    }
    
    /// 设置径向渐变色背景
    /// - Parameters:
    ///   - colors: 渐变色数组
    ///   - center: 中心点
    ///   - radius: 半径
    func setRadialGradientBackground(colors: [UIColor],
                                     center: CGPoint = CGPoint(x: 0.5, y: 0.5),
                                     radius: CGFloat = 0.5) {
        // 移除现有的渐变色层
        sublayers?.removeAll { $0 is CAGradientLayer }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.type = .radial
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = center
        
        // 径向渐变需要计算结束点
        let endRadius = min(bounds.width, bounds.height) * radius / max(bounds.width, bounds.height)
        gradientLayer.endPoint = CGPoint(x: center.x + endRadius, y: center.y + endRadius)
        
        insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - 动画扩展
    
    /// 添加淡入动画
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - delay: 延迟时间
    /// - Returns: 动画对象
    @discardableResult
    func addFadeInAnimation(duration: CFTimeInterval = 0.3, delay: CFTimeInterval = 0) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        add(animation, forKey: "fadeIn")
        opacity = 1.0
        
        return animation
    }
    
    /// 添加淡出动画
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - delay: 延迟时间
    /// - Returns: 动画对象
    @discardableResult
    func addFadeOutAnimation(duration: CFTimeInterval = 0.3, delay: CFTimeInterval = 0) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        add(animation, forKey: "fadeOut")
        opacity = 0.0
        
        return animation
    }
    
    /// 添加缩放动画
    /// - Parameters:
    ///   - fromScale: 起始缩放比例
    ///   - toScale: 结束缩放比例
    ///   - duration: 动画时长
    ///   - delay: 延迟时间
    /// - Returns: 动画对象
    @discardableResult
    func addScaleAnimation(from fromScale: CGFloat = 1.0,
                           to toScale: CGFloat,
                           duration: CFTimeInterval = 0.3,
                           delay: CFTimeInterval = 0) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = fromScale
        animation.toValue = toScale
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        add(animation, forKey: "scale")
        transform = CATransform3DMakeScale(toScale, toScale, 1.0)
        
        return animation
    }
    
    /// 添加弹跳动画
    /// - Parameters:
    ///   - scale: 最大缩放比例
    ///   - duration: 动画时长
    ///   - delay: 延迟时间
    /// - Returns: 动画组对象
    @discardableResult
    func addBounceAnimation(scale: CGFloat = 1.1,
                            duration: CFTimeInterval = 0.5,
                            delay: CFTimeInterval = 0) -> CAAnimationGroup {
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.fromValue = 1.0
        scaleUp.toValue = scale
        scaleUp.duration = duration * 0.5
        scaleUp.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = scale
        scaleDown.toValue = 1.0
        scaleDown.duration = duration * 0.5
        scaleDown.beginTime = duration * 0.5
        scaleDown.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleUp, scaleDown]
        animationGroup.duration = duration
        animationGroup.beginTime = CACurrentMediaTime() + delay
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        
        add(animationGroup, forKey: "bounce")
        
        return animationGroup
    }
    
    /// 添加旋转动画
    /// - Parameters:
    ///   - angle: 旋转角度（弧度）
    ///   - duration: 动画时长
    ///   - delay: 延迟时间
    ///   - repeatCount: 重复次数
    /// - Returns: 动画对象
    @discardableResult
    func addRotationAnimation(angle: CGFloat,
                              duration: CFTimeInterval = 1.0,
                              delay: CFTimeInterval = 0,
                              repeatCount: Float = .infinity) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = angle
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.repeatCount = repeatCount
        animation.isCumulative = true
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        add(animation, forKey: "rotation")
        
        return animation
    }
    
    /// 添加连续旋转动画（360度）
    /// - Parameters:
    ///   - duration: 每圈动画时长
    ///   - delay: 延迟时间
    ///   - repeatCount: 重复次数
    ///   - clockwise: 是否顺时针旋转
    /// - Returns: 动画对象
    @discardableResult
    func addSpinAnimation(duration: CFTimeInterval = 1.0,
                          delay: CFTimeInterval = 0,
                          repeatCount: Float = .infinity,
                          clockwise: Bool = true) -> CABasicAnimation {
        let direction: CGFloat = clockwise ? 1 : -1
        return addRotationAnimation(angle: direction * .pi * 2,
                                    duration: duration,
                                    delay: delay,
                                    repeatCount: repeatCount)
    }
    
    /// 添加移动动画
    /// - Parameters:
    ///   - fromPoint: 起始点
    ///   - toPoint: 结束点
    ///   - duration: 动画时长
    ///   - delay: 延迟时间
    /// - Returns: 动画对象
    @discardableResult
    func addMoveAnimation(from fromPoint: CGPoint,
                          to toPoint: CGPoint,
                          duration: CFTimeInterval = 0.3,
                          delay: CFTimeInterval = 0) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = fromPoint
        animation.toValue = toPoint
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        add(animation, forKey: "move")
        position = toPoint
        
        return animation
    }
    
    /// 添加弹簧动画
    /// - Parameters:
    ///   - property: 动画属性
    ///   - fromValue: 起始值
    ///   - toValue: 结束值
    ///   - damping: 阻尼系数
    ///   - mass: 质量
    ///   - stiffness: 刚度
    ///   - initialVelocity: 初始速度
    /// - Returns: 弹簧动画对象
    @discardableResult
    func addSpringAnimation(property: String,
                            from fromValue: Any?,
                            to toValue: Any?,
                            damping: CGFloat = 10,
                            mass: CGFloat = 1,
                            stiffness: CGFloat = 100,
                            initialVelocity: CGFloat = 0) -> CASpringAnimation {
        let animation = CASpringAnimation(keyPath: property)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.damping = damping
        animation.mass = mass
        animation.stiffness = stiffness
        animation.initialVelocity = initialVelocity
        animation.duration = animation.settlingDuration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        add(animation, forKey: "spring_\(property)")
        
        // 设置最终值
        if property == "position", let toValue = toValue as? CGPoint {
            position = toValue
        } else if property == "transform.scale", let toValue = toValue as? CGFloat {
            transform = CATransform3DMakeScale(toValue, toValue, 1.0)
        } else if property == "opacity", let toValue = toValue as? Float {
            opacity = toValue
        }
        
        return animation
    }
    
    /// 添加关键帧动画
    /// - Parameters:
    ///   - property: 动画属性
    ///   - values: 关键帧值数组
    ///   - keyTimes: 关键帧时间数组（0-1）
    ///   - duration: 动画时长
    ///   - delay: 延迟时间
    /// - Returns: 关键帧动画对象
    @discardableResult
    func addKeyframeAnimation(property: String,
                              values: [Any],
                              keyTimes: [NSNumber]? = nil,
                              duration: CFTimeInterval = 0.3,
                              delay: CFTimeInterval = 0) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: property)
        animation.values = values
        animation.keyTimes = keyTimes
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        add(animation, forKey: "keyframe_\(property)")
        
        // 设置最终值
        if let lastValue = values.last {
            if property == "position", let lastValue = lastValue as? CGPoint {
                position = lastValue
            } else if property == "transform.scale", let lastValue = lastValue as? CGFloat {
                transform = CATransform3DMakeScale(lastValue, lastValue, 1.0)
            } else if property == "opacity", let lastValue = lastValue as? Float {
                opacity = lastValue
            }
        }
        
        return animation
    }
    
    /// 添加组合动画
    /// - Parameters:
    ///   - animations: 动画数组
    ///   - duration: 动画时长
    ///   - delay: 延迟时间
    /// - Returns: 动画组对象
    @discardableResult
    func addAnimationGroup(_ animations: [CAAnimation],
                           duration: CFTimeInterval = 0.3,
                           delay: CFTimeInterval = 0) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = animations
        animationGroup.duration = duration
        animationGroup.beginTime = CACurrentMediaTime() + delay
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        
        add(animationGroup, forKey: "animationGroup")
        
        return animationGroup
    }
    
    // MARK: - 工具方法
    
    /// 暂停所有动画
    func pauseAnimations() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    /// 恢复所有动画
    func resumeAnimations() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
    
    /// 移除所有动画
    func removeAllAnimations() {
        removeAllAnimations()
    }
    
    /// 移除指定动画
    /// - Parameter key: 动画键
    func removeAnimation(forKey key: String) {
        removeAnimation(forKey: key)
    }
    
    /// 动画是否正在运行
    var isAnimating: Bool {
        return animationKeys()?.isEmpty == false
    }
    
    /// 获取图层截图
    /// - Returns: 截图UIImage
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 安全设置图层的frame
    /// - Parameter frame: 新的frame
    func safeSetFrame(_ frame: CGRect) {
        // 确保frame有效
        guard !frame.isInfinite && !frame.isNull else { return }
        self.frame = frame
    }
    
    /// 安全设置图层的大小
    /// - Parameter size: 新的size
    func safeSetSize(_ size: CGSize) {
        // 确保size有效
        guard size.width >= 0 && size.height >= 0 else { return }
        bounds.size = size
    }
    
    /// 安全设置图层的位置
    /// - Parameter position: 新的position
    func safeSetPosition(_ position: CGPoint) {
        // 确保position有效
        guard !position.x.isInfinite && !position.y.isInfinite else { return }
        self.position = position
    }
    
    /// 安全设置图层的bounds
    /// - Parameter bounds: 新的bounds
    func safeSetBounds(_ bounds: CGRect) {
        // 确保bounds有效
        guard !bounds.isInfinite && !bounds.isNull else { return }
        self.bounds = bounds
    }
    
    /// 获取图层在屏幕上的绝对位置
    /// - Returns: 绝对位置矩形
    func absoluteFrame(in view: UIView? = nil) -> CGRect {
        guard let view = view ?? (delegate as? UIView) else { return .zero }
        return view.convert(frame, to: nil)
    }
    
    /// 查找指定类型的子图层
    /// - Parameter type: 要查找的图层类型
    /// - Returns: 找到的图层数组
    func findSublayers<T: CALayer>(ofType type: T.Type) -> [T] {
        var result: [T] = []
        
        for sublayer in sublayers ?? [] {
            if let typedSublayer = sublayer as? T {
                result.append(typedSublayer)
            }
            result.append(contentsOf: sublayer.findSublayers(ofType: type))
        }
        
        return result
    }
    
    /// 移除所有子图层
    func removeAllSublayers() {
        sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    /// 移除指定类型的子图层
    /// - Parameter type: 要移除的图层类型
    func removeSublayers<T: CALayer>(ofType type: T.Type) {
        sublayers?.forEach {
            if $0 is T {
                $0.removeFromSuperlayer()
            }
        }
    }
}

#endif