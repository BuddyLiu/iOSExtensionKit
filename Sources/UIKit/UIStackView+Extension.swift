// UIStackView+Extension.swift
// UIStackView扩展，提供便捷的堆栈视图创建和配置方法

#if canImport(UIKit)
import UIKit

public extension UIStackView {
    
    // MARK: - 便捷创建方法
    
    /// 创建水平堆栈视图
    /// - Parameters:
    ///   - arrangedSubviews: 排列的子视图数组
    ///   - spacing: 子视图间距，默认0
    ///   - alignment: 对齐方式，默认.fill
    ///   - distribution: 分布方式，默认.fill
    /// - Returns: 配置好的UIStackView实例
    static func horizontal(arrangedSubviews: [UIView] = [],
                           spacing: CGFloat = 0,
                           alignment: UIStackView.Alignment = .fill,
                           distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        return stackView
    }
    
    /// 创建垂直堆栈视图
    /// - Parameters:
    ///   - arrangedSubviews: 排列的子视图数组
    ///   - spacing: 子视图间距，默认0
    ///   - alignment: 对齐方式，默认.fill
    ///   - distribution: 分布方式，默认.fill
    /// - Returns: 配置好的UIStackView实例
    static func vertical(arrangedSubviews: [UIView] = [],
                         spacing: CGFloat = 0,
                         alignment: UIStackView.Alignment = .fill,
                         distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        return stackView
    }
    
    /// 创建带配置的堆栈视图
    /// - Parameters:
    ///   - axis: 布局轴方向
    ///   - arrangedSubviews: 排列的子视图数组
    ///   - spacing: 子视图间距
    ///   - alignment: 对齐方式
    ///   - distribution: 分布方式
    ///   - isBaselineRelativeArrangement: 是否基线相对排列
    ///   - isLayoutMarginsRelativeArrangement: 是否布局边距相对排列
    convenience init(axis: NSLayoutConstraint.Axis,
                     arrangedSubviews: [UIView] = [],
                     spacing: CGFloat = 0,
                     alignment: UIStackView.Alignment = .fill,
                     distribution: UIStackView.Distribution = .fill,
                     isBaselineRelativeArrangement: Bool = false,
                     isLayoutMarginsRelativeArrangement: Bool = false) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.isBaselineRelativeArrangement = isBaselineRelativeArrangement
        self.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
    }
    
    // MARK: - 子视图管理
    
    /// 安全添加排列子视图
    /// - Parameter view: 要添加的子视图
    func safeAddArrangedSubview(_ view: UIView) {
        guard !arrangedSubviews.contains(view) else { return }
        addArrangedSubview(view)
    }
    
    /// 安全添加多个排列子视图
    /// - Parameter views: 要添加的子视图数组
    func safeAddArrangedSubviews(_ views: [UIView]) {
        views.forEach { safeAddArrangedSubview($0) }
    }
    
    /// 安全插入排列子视图
    /// - Parameters:
    ///   - view: 要插入的子视图
    ///   - stackIndex: 插入位置索引
    func safeInsertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        guard !arrangedSubviews.contains(view) else { return }
        guard stackIndex >= 0 && stackIndex <= arrangedSubviews.count else { return }
        insertArrangedSubview(view, at: stackIndex)
    }
    
    /// 安全移除排列子视图
    /// - Parameter view: 要移除的子视图
    func safeRemoveArrangedSubview(_ view: UIView) {
        guard arrangedSubviews.contains(view) else { return }
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    /// 安全移除所有排列子视图
    func safeRemoveAllArrangedSubviews() {
        arrangedSubviews.forEach { safeRemoveArrangedSubview($0) }
    }
    
    /// 替换排列子视图
    /// - Parameters:
    ///   - oldView: 要替换的旧视图
    ///   - newView: 替换的新视图
    /// - Returns: 是否替换成功
    @discardableResult
    func replaceArrangedSubview(_ oldView: UIView, with newView: UIView) -> Bool {
        guard let index = arrangedSubviews.firstIndex(of: oldView) else { return false }
        
        safeRemoveArrangedSubview(oldView)
        safeInsertArrangedSubview(newView, at: index)
        
        return true
    }
    
    /// 交换两个排列子视图的位置
    /// - Parameters:
    ///   - view1: 第一个子视图
    ///   - view2: 第二个子视图
    /// - Returns: 是否交换成功
    @discardableResult
    func swapArrangedSubviews(_ view1: UIView, _ view2: UIView) -> Bool {
        guard let index1 = arrangedSubviews.firstIndex(of: view1),
              let index2 = arrangedSubviews.firstIndex(of: view2) else { return false }
        
        removeArrangedSubview(view1)
        removeArrangedSubview(view2)
        
        if index1 < index2 {
            insertArrangedSubview(view2, at: index1)
            insertArrangedSubview(view1, at: index2)
        } else {
            insertArrangedSubview(view1, at: index2)
            insertArrangedSubview(view2, at: index1)
        }
        
        return true
    }
    
    // MARK: - 配置方法
    
    /// 设置堆栈视图配置
    /// - Parameters:
    ///   - spacing: 子视图间距
    ///   - alignment: 对齐方式
    ///   - distribution: 分布方式
    func configure(spacing: CGFloat? = nil,
                   alignment: UIStackView.Alignment? = nil,
                   distribution: UIStackView.Distribution? = nil) {
        if let spacing = spacing {
            self.spacing = spacing
        }
        if let alignment = alignment {
            self.alignment = alignment
        }
        if let distribution = distribution {
            self.distribution = distribution
        }
    }
    
    /// 设置布局边距
    /// - Parameters:
    ///   - margins: 边距
    ///   - relative: 是否相对布局边距
    func setLayoutMargins(_ margins: UIEdgeInsets, relative: Bool = true) {
        layoutMargins = margins
        isLayoutMarginsRelativeArrangement = relative
    }
    
    /// 设置统一的布局边距
    /// - Parameter margin: 统一的边距值
    func setUniformLayoutMargins(_ margin: CGFloat) {
        setLayoutMargins(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
    }
    
    /// 启用自定义间距
    /// - Parameters:
    ///   - spacing: 间距值
    ///   - after: 在哪个子视图后应用
    @available(iOS 11.0, *)
    func setCustomSpacing(_ spacing: CGFloat, after view: UIView) {
        setCustomSpacing(spacing, after: view)
    }
    
    /// 获取自定义间距
    /// - Parameter view: 子视图
    /// - Returns: 自定义间距值
    @available(iOS 11.0, *)
    func getCustomSpacing(after view: UIView) -> CGFloat {
        return customSpacing(after: view)
    }
    
    // MARK: - 布局工具
    
    /// 添加间隔视图
    /// - Parameters:
    ///   - spacing: 间隔大小
    ///   - color: 间隔视图颜色（可选）
    /// - Returns: 创建的间隔视图
    @discardableResult
    func addSpacer(_ spacing: CGFloat, color: UIColor? = nil) -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = color
        
        if axis == .horizontal {
            spacer.widthAnchor.constraint(equalToConstant: spacing).isActive = true
        } else {
            spacer.heightAnchor.constraint(equalToConstant: spacing).isActive = true
        }
        
        addArrangedSubview(spacer)
        return spacer
    }
    
    /// 在指定位置添加间隔视图
    /// - Parameters:
    ///   - spacing: 间隔大小
    ///   - index: 插入位置
    ///   - color: 间隔视图颜色（可选）
    /// - Returns: 创建的间隔视图
    @discardableResult
    func insertSpacer(_ spacing: CGFloat, at index: Int, color: UIColor? = nil) -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = color
        
        if axis == .horizontal {
            spacer.widthAnchor.constraint(equalToConstant: spacing).isActive = true
        } else {
            spacer.heightAnchor.constraint(equalToConstant: spacing).isActive = true
        }
        
        insertArrangedSubview(spacer, at: index)
        return spacer
    }
    
    /// 添加弹性间隔视图（弹簧）
    /// - Returns: 创建的弹性间隔视图
    @discardableResult
    func addFlexibleSpacer() -> UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: axis == .horizontal ? .horizontal : .vertical)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: axis == .horizontal ? .horizontal : .vertical)
        
        addArrangedSubview(spacer)
        return spacer
    }
    
    /// 包装视图（添加边距）
    /// - Parameters:
    ///   - view: 要包装的视图
    ///   - insets: 边距
    /// - Returns: 包装后的堆栈视图
    static func wrap(_ view: UIView, insets: UIEdgeInsets) -> UIStackView {
        let wrapper = UIStackView(arrangedSubviews: [view])
        wrapper.isLayoutMarginsRelativeArrangement = true
        wrapper.layoutMargins = insets
        return wrapper
    }
    
    /// 包装视图（统一边距）
    /// - Parameters:
    ///   - view: 要包装的视图
    ///   - margin: 统一边距值
    /// - Returns: 包装后的堆栈视图
    static func wrap(_ view: UIView, margin: CGFloat) -> UIStackView {
        return wrap(view, insets: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
    }
    
    // MARK: - 隐藏/显示管理
    
    /// 安全隐藏排列子视图
    /// - Parameter view: 要隐藏的子视图
    func safeHideArrangedSubview(_ view: UIView) {
        guard arrangedSubviews.contains(view) else { return }
        view.isHidden = true
    }
    
    /// 安全显示排列子视图
    /// - Parameter view: 要显示的子视图
    func safeShowArrangedSubview(_ view: UIView) {
        guard arrangedSubviews.contains(view) else { return }
        view.isHidden = false
    }
    
    /// 切换排列子视图的隐藏状态
    /// - Parameter view: 要切换的子视图
    func toggleArrangedSubview(_ view: UIView) {
        guard arrangedSubviews.contains(view) else { return }
        view.isHidden = !view.isHidden
    }
    
    /// 隐藏所有排列子视图
    func hideAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.isHidden = true }
    }
    
    /// 显示所有排列子视图
    func showAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.isHidden = false }
    }
    
    /// 根据条件隐藏排列子视图
    /// - Parameter condition: 隐藏条件闭包
    func hideArrangedSubviews(where condition: (UIView) -> Bool) {
        arrangedSubviews.forEach { view in
            if condition(view) {
                view.isHidden = true
            }
        }
    }
    
    /// 根据条件显示排列子视图
    /// - Parameter condition: 显示条件闭包
    func showArrangedSubviews(where condition: (UIView) -> Bool) {
        arrangedSubviews.forEach { view in
            if condition(view) {
                view.isHidden = false
            }
        }
    }
    
    // MARK: - 动画
    
    /// 动画显示/隐藏排列子视图
    /// - Parameters:
    ///   - view: 要动画显示/隐藏的子视图
    ///   - hidden: 是否隐藏
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func animateArrangedSubview(_ view: UIView,
                                hidden: Bool,
                                duration: TimeInterval = 0.3,
                                completion: ((Bool) -> Void)? = nil) {
        guard arrangedSubviews.contains(view) else { return }
        guard view.isHidden != hidden else {
            completion?(true)
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            view.isHidden = hidden
            view.alpha = hidden ? 0 : 1
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    /// 动画插入排列子视图
    /// - Parameters:
    ///   - view: 要插入的子视图
    ///   - index: 插入位置
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func animateInsertArrangedSubview(_ view: UIView,
                                      at index: Int,
                                      duration: TimeInterval = 0.3,
                                      completion: ((Bool) -> Void)? = nil) {
        guard !arrangedSubviews.contains(view) else { return }
        guard index >= 0 && index <= arrangedSubviews.count else { return }
        
        view.alpha = 0
        view.isHidden = true
        
        insertArrangedSubview(view, at: index)
        
        UIView.animate(withDuration: duration, animations: {
            view.isHidden = false
            view.alpha = 1
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    /// 动画移除排列子视图
    /// - Parameters:
    ///   - view: 要移除的子视图
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func animateRemoveArrangedSubview(_ view: UIView,
                                      duration: TimeInterval = 0.3,
                                      completion: ((Bool) -> Void)? = nil) {
        guard arrangedSubviews.contains(view) else { return }
        
        UIView.animate(withDuration: duration, animations: {
            view.isHidden = true
            view.alpha = 0
            self.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            completion?(finished)
        })
    }
    
    // MARK: - 工具方法
    
    /// 获取可见的排列子视图
    var visibleArrangedSubviews: [UIView] {
        return arrangedSubviews.filter { !$0.isHidden }
    }
    
    /// 获取隐藏的排列子视图
    var hiddenArrangedSubviews: [UIView] {
        return arrangedSubviews.filter { $0.isHidden }
    }
    
    /// 检查是否包含指定类型的排列子视图
    /// - Parameter type: 要检查的视图类型
    /// - Returns: 是否包含
    func containsArrangedSubview<T: UIView>(ofType type: T.Type) -> Bool {
        return arrangedSubviews.contains { $0 is T }
    }
    
    /// 查找指定类型的排列子视图
    /// - Parameter type: 要查找的视图类型
    /// - Returns: 找到的视图数组
    func findArrangedSubviews<T: UIView>(ofType type: T.Type) -> [T] {
        return arrangedSubviews.compactMap { $0 as? T }
    }
    
    /// 获取排列子视图的索引
    /// - Parameter view: 子视图
    /// - Returns: 索引（如果存在）
    func indexOfArrangedSubview(_ view: UIView) -> Int? {
        return arrangedSubviews.firstIndex(of: view)
    }
    
    /// 设置排列子视图的布局优先级
    /// - Parameters:
    ///   - view: 子视图
    ///   - huggingPriority: 抗拉伸优先级
    ///   - compressionResistancePriority: 抗压缩优先级
    func setLayoutPriorities(for view: UIView,
                             huggingPriority: UILayoutPriority? = nil,
                             compressionResistancePriority: UILayoutPriority? = nil) {
        if let huggingPriority = huggingPriority {
            let axis: NSLayoutConstraint.Axis = (self.axis == .horizontal) ? .horizontal : .vertical
            view.setContentHuggingPriority(huggingPriority, for: axis)
        }
        
        if let compressionResistancePriority = compressionResistancePriority {
            let axis: NSLayoutConstraint.Axis = (self.axis == .horizontal) ? .horizontal : .vertical
            view.setContentCompressionResistancePriority(compressionResistancePriority, for: axis)
        }
    }
    
    /// 批量设置排列子视图的布局优先级
    /// - Parameters:
    ///   - huggingPriority: 抗拉伸优先级
    ///   - compressionResistancePriority: 抗压缩优先级
    func setLayoutPrioritiesForAll(huggingPriority: UILayoutPriority? = nil,
                                   compressionResistancePriority: UILayoutPriority? = nil) {
        arrangedSubviews.forEach {
            setLayoutPriorities(for: $0,
                              huggingPriority: huggingPriority,
                              compressionResistancePriority: compressionResistancePriority)
        }
    }
    
    /// 调整堆栈视图的内容大小（根据内容自适应）
    func adjustToContentSize() {
        setContentHuggingPriority(.required, for: axis == .horizontal ? .horizontal : .vertical)
        setContentCompressionResistancePriority(.required, for: axis == .horizontal ? .horizontal : .vertical)
    }
}

#endif