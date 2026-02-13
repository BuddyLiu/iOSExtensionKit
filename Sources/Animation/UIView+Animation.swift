// UIView+Animation.swift
// UIView动画扩展，提供便捷的动画方法

#if canImport(UIKit)
import UIKit

public extension UIView {
    
    // MARK: - 基础动画
    
    /// 淡入动画
    /// - Parameters:
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func fadeIn(duration: TimeInterval = 0.3, 
                delay: TimeInterval = 0, 
                completion: ((Bool) -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveEaseInOut,
                      animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /// 淡出动画
    /// - Parameters:
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - hideAfterAnimation: 动画后是否隐藏视图
    ///   - completion: 完成回调
    func fadeOut(duration: TimeInterval = 0.3, 
                 delay: TimeInterval = 0, 
                 hideAfterAnimation: Bool = true,
                 completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveEaseInOut,
                      animations: {
            self.alpha = 0
        }, completion: { finished in
            if hideAfterAnimation {
                self.isHidden = true
            }
            completion?(finished)
        })
    }
    
    /// 淡入淡出切换动画
    /// - Parameters:
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    func fadeToggle(duration: TimeInterval = 0.3, 
                    delay: TimeInterval = 0) {
        let isHidden = self.isHidden || self.alpha == 0
        
        if isHidden {
            fadeIn(duration: duration, delay: delay)
        } else {
            fadeOut(duration: duration, delay: delay)
        }
    }
    
    // MARK: - 移动动画
    
    /// 从指定位置移动到当前位置
    /// - Parameters:
    ///   - fromX: 起始X坐标
    ///   - fromY: 起始Y坐标
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func moveFrom(x fromX: CGFloat, 
                  y fromY: CGFloat, 
                  duration: TimeInterval = 0.3, 
                  delay: TimeInterval = 0, 
                  completion: ((Bool) -> Void)? = nil) {
        let originalFrame = self.frame
        self.frame.origin = CGPoint(x: fromX, y: fromY)
        
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveEaseInOut,
                      animations: {
            self.frame = originalFrame
        }, completion: completion)
    }
    
    /// 移动到指定位置
    /// - Parameters:
    ///   - toX: 目标X坐标
    ///   - toY: 目标Y坐标
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func moveTo(x toX: CGFloat, 
                y toY: CGFloat, 
                duration: TimeInterval = 0.3, 
                delay: TimeInterval = 0, 
                completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveEaseInOut,
                      animations: {
            self.frame.origin = CGPoint(x: toX, y: toY)
        }, completion: completion)
    }
    
    /// 向上移动
    /// - Parameters:
    ///   - distance: 移动距离
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func moveUp(distance: CGFloat, 
                duration: TimeInterval = 0.3, 
                delay: TimeInterval = 0, 
                completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveEaseInOut,
                      animations: {
            self.frame.origin.y -= distance
        }, completion: completion)
    }
    
    /// 向下移动
    /// - Parameters:
    ///   - distance: 移动距离
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func moveDown(distance: CGFloat, 
                  duration: TimeInterval = 0.3, 
                  delay: TimeInterval = 0, 
                  completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveEaseInOut,
                      animations: {
            self.frame.origin.y += distance
        }, completion: completion)
    }
    
    // MARK: - 缩放动画
    
    /// 缩放动画
    /// - Parameters:
    ///   - scale: 缩放比例
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func scale(to scale: CGFloat, 
               duration: TimeInterval = 0.3, 
               delay: TimeInterval = 0, 
               completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveEaseInOut,
                      animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: completion)
    }
    
    /// 缩放动画（从指定比例到当前比例）
    /// - Parameters:
    ///   - fromScale: 起始缩放比例
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func scaleFrom(_ fromScale: CGFloat, 
                   duration: TimeInterval = 0.3, 
                   delay: TimeInterval = 0, 
                   completion: ((Bool) -> Void)? = nil) {
        self.transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
        
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveEaseInOut,
                      animations: {
            self.transform = .identity
        }, completion: completion)
    }
    
    /// 弹跳动画
    /// - Parameters:
    ///   - scale: 最大缩放比例，默认1.1
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func bounce(scale: CGFloat = 1.1, 
                duration: TimeInterval = 0.3, 
                delay: TimeInterval = 0, 
                completion: ((Bool) -> Void)? = nil) {
        let originalTransform = self.transform
        
        UIView.animateKeyframes(withDuration: duration, 
                               delay: delay, 
                               options: .calculationModeCubic,
                               animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.transform = originalTransform
            }
        }, completion: completion)
    }
    
    // MARK: - 旋转动画
    
    /// 旋转动画
    /// - Parameters:
    ///   - angle: 旋转角度（弧度）
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func rotate(angle: CGFloat, 
                duration: TimeInterval = 0.3, 
                delay: TimeInterval = 0, 
                completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveLinear,
                      animations: {
            self.transform = self.transform.rotated(by: angle)
        }, completion: completion)
    }
    
    /// 旋转到指定角度
    /// - Parameters:
    ///   - angle: 目标角度（弧度）
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func rotateTo(angle: CGFloat, 
                  duration: TimeInterval = 0.3, 
                  delay: TimeInterval = 0, 
                  completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: .curveLinear,
                      animations: {
            self.transform = CGAffineTransform(rotationAngle: angle)
        }, completion: completion)
    }
    
    /// 连续旋转动画
    /// - Parameters:
    ///   - duration: 每圈动画时长，默认1秒
    ///   - repeatCount: 重复次数（默认无限循环）
    ///   - clockwise: 是否顺时针旋转
    func spin(duration: TimeInterval = 1.0, 
              repeatCount: Float = .infinity, 
              clockwise: Bool = true) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let direction: CGFloat = clockwise ? 1 : -1
        animation.toValue = NSNumber(value: direction * Double.pi * 2)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        
        self.layer.add(animation, forKey: "spinAnimation")
    }
    
    /// 停止旋转动画
    func stopSpin() {
        self.layer.removeAnimation(forKey: "spinAnimation")
    }
    
    // MARK: - 震动动画
    
    /// 震动动画
    /// - Parameters:
    ///   - intensity: 震动强度，默认10
    ///   - duration: 动画时长，默认0.5秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func shake(intensity: CGFloat = 10, 
               duration: TimeInterval = 0.5, 
               delay: TimeInterval = 0, 
               completion: ((Bool) -> Void)? = nil) {
        let originalPosition = self.center
        
        UIView.animateKeyframes(withDuration: duration, 
                               delay: delay, 
                               options: .calculationModeCubic,
                               animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) {
                self.center = CGPoint(x: originalPosition.x + intensity, y: originalPosition.y)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1) {
                self.center = CGPoint(x: originalPosition.x - intensity, y: originalPosition.y)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1) {
                self.center = CGPoint(x: originalPosition.x + intensity, y: originalPosition.y)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1) {
                self.center = CGPoint(x: originalPosition.x - intensity, y: originalPosition.y)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.1) {
                self.center = CGPoint(x: originalPosition.x + intensity, y: originalPosition.y)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1) {
                self.center = CGPoint(x: originalPosition.x - intensity, y: originalPosition.y)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2) {
                self.center = originalPosition
            }
        }, completion: completion)
    }
    
    /// 轻微震动动画
    /// - Parameters:
    ///   - intensity: 震动强度，默认5
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func shakeLight(intensity: CGFloat = 5, 
                    duration: TimeInterval = 0.3, 
                    delay: TimeInterval = 0, 
                    completion: ((Bool) -> Void)? = nil) {
        shake(intensity: intensity, duration: duration, delay: delay, completion: completion)
    }
    
    /// 强震动动画
    /// - Parameters:
    ///   - intensity: 震动强度，默认20
    ///   - duration: 动画时长，默认0.7秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func shakeHeavy(intensity: CGFloat = 20, 
                    duration: TimeInterval = 0.7, 
                    delay: TimeInterval = 0, 
                    completion: ((Bool) -> Void)? = nil) {
        shake(intensity: intensity, duration: duration, delay: delay, completion: completion)
    }
    
    // MARK: - 弹簧动画
    
    /// 弹簧动画（移动）
    /// - Parameters:
    ///   - toPoint: 目标点
    ///   - damping: 阻尼系数（0-1），默认0.5
    ///   - velocity: 初始速度，默认0.5
    ///   - duration: 动画时长，默认0.5秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func springMove(to toPoint: CGPoint, 
                    damping: CGFloat = 0.5, 
                    velocity: CGFloat = 0.5, 
                    duration: TimeInterval = 0.5, 
                    delay: TimeInterval = 0, 
                    completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      usingSpringWithDamping: damping,
                      initialSpringVelocity: velocity,
                      options: .curveEaseInOut,
                      animations: {
            self.center = toPoint
        }, completion: completion)
    }
    
    /// 弹簧动画（缩放）
    /// - Parameters:
    ///   - toScale: 目标缩放比例
    ///   - damping: 阻尼系数（0-1），默认0.5
    ///   - velocity: 初始速度，默认0.5
    ///   - duration: 动画时长，默认0.5秒
    ///   - delay: 延迟时间，默认0秒
    ///   - completion: 完成回调
    func springScale(to toScale: CGFloat, 
                     damping: CGFloat = 0.5, 
                     velocity: CGFloat = 0.5, 
                     duration: TimeInterval = 0.5, 
                     delay: TimeInterval = 0, 
                     completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      usingSpringWithDamping: damping,
                      initialSpringVelocity: velocity,
                      options: .curveEaseInOut,
                      animations: {
            self.transform = CGAffineTransform(scaleX: toScale, y: toScale)
        }, completion: completion)
    }
    
    // MARK: - 组合动画
    
    /// 组合动画（同时执行多个动画）
    /// - Parameters:
    ///   - animations: 动画块数组
    ///   - duration: 动画时长，默认0.3秒
    ///   - delay: 延迟时间，默认0秒
    ///   - options: 动画选项
    ///   - completion: 完成回调
    func animateGroup(_ animations: [() -> Void], 
                      duration: TimeInterval = 0.3, 
                      delay: TimeInterval = 0, 
                      options: UIView.AnimationOptions = .curveEaseInOut,
                      completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, 
                      delay: delay, 
                      options: options,
                      animations: {
            animations.forEach { $0() }
        }, completion: completion)
    }
    
    /// 序列动画（按顺序执行多个动画）
    /// - Parameters:
    ///   - animations: 动画块数组，每个块包含动画和持续时间
    ///   - completion: 完成回调
    func animateSequence(_ animations: [((() -> Void), TimeInterval)], 
                         completion: ((Bool) -> Void)? = nil) {
        var currentDelay: TimeInterval = 0
        
        for (animation, duration) in animations {
            UIView.animate(withDuration: duration, 
                          delay: currentDelay, 
                          options: .curveEaseInOut,
                          animations: animation,
                          completion: nil)
            currentDelay += duration
        }
        
        if let completion = completion {
            DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) {
                completion(true)
            }
        }
    }
    
    // MARK: - 脉冲动画
    
    /// 脉冲动画（心脏跳动效果）
    /// - Parameters:
    ///   - scale: 缩放比例，默认1.1
    ///   - duration: 动画时长，默认0.5秒
    ///   - repeatCount: 重复次数，默认1
    func pulse(scale: CGFloat = 1.1, 
               duration: TimeInterval = 0.5, 
               repeatCount: Float = 1) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = duration
        animation.fromValue = 1.0
        animation.toValue = scale
        animation.autoreverses = true
        animation.repeatCount = repeatCount
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.layer.add(animation, forKey: "pulseAnimation")
    }
    
    /// 停止脉冲动画
    func stopPulse() {
        self.layer.removeAnimation(forKey: "pulseAnimation")
    }
    
    // MARK: - 闪烁动画
    
    /// 闪烁动画
    /// - Parameters:
    ///   - duration: 动画时长，默认0.5秒
    ///   - repeatCount: 重复次数，默认1
    func blink(duration: TimeInterval = 0.5, 
               repeatCount: Float = 1) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.autoreverses = true
        animation.repeatCount = repeatCount
        
        self.layer.add(animation, forKey: "blinkAnimation")
    }
    
    /// 停止闪烁动画
    func stopBlink() {
        self.layer.removeAnimation(forKey: "blinkAnimation")
    }
    
    // MARK: - 工具方法
    
    /// 暂停所有动画
    func pauseAnimations() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    /// 恢复所有动画
    func resumeAnimations() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    /// 移除所有动画
    func removeAllAnimations() {
        layer.removeAllAnimations()
    }
    
    /// 动画是否正在运行
    var isAnimating: Bool {
        return layer.animationKeys()?.isEmpty == false
    }
}

#endif