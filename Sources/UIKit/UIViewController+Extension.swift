// UIViewController+Extension.swift
// UIViewController扩展，提供便捷的导航、数据传递和生命周期管理方法

#if canImport(UIKit)
import UIKit

@MainActor
public extension UIViewController {
    
    // MARK: - 便捷属性
    
    /// 是否在屏幕上可见
    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }
    
    /// 安全区域布局指南
    var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            let topInset = topLayoutGuide.length
            let bottomInset = bottomLayoutGuide.length
            return UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        }
    }
    
    /// 安全区域框架
    var safeAreaFrame: CGRect {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.layoutFrame
        } else {
            let topInset = topLayoutGuide.length
            let bottomInset = bottomLayoutGuide.length
            let height = view.bounds.height - topInset - bottomInset
            return CGRect(x: 0, y: topInset, width: view.bounds.width, height: height)
        }
    }
    
    // MARK: - 子视图控制器管理
    
    /// 添加子视图控制器
    /// - Parameters:
    ///   - child: 子视图控制器
    ///   - containerView: 容器视图，如果为nil则使用当前视图控制器的view
    func addChildViewController(_ child: UIViewController, to containerView: UIView? = nil) {
        addChild(child)
        let targetView = containerView ?? view
        child.view.frame = targetView?.bounds ?? .zero
        targetView?.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// 移除子视图控制器
    /// - Parameter child: 要移除的子视图控制器
    func removeChildViewController(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    /// 安全移除所有子视图控制器
    func removeAllChildViewControllers() {
        children.forEach { removeChildViewController($0) }
    }
    
    /// 替换当前子视图控制器
    /// - Parameters:
    ///   - oldChild: 旧的子视图控制器
    ///   - newChild: 新的子视图控制器
    ///   - containerView: 容器视图
    ///   - animated: 是否使用动画
    func replaceChildViewController(_ oldChild: UIViewController,
                                     with newChild: UIViewController,
                                     in containerView: UIView? = nil,
                                     animated: Bool = false) {
        if animated {
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.removeChildViewController(oldChild)
                self.addChildViewController(newChild, to: containerView)
            }, completion: nil)
        } else {
            removeChildViewController(oldChild)
            addChildViewController(newChild, to: containerView)
        }
    }
    
    // MARK: - 导航控制
    
    /// 安全弹出当前视图控制器
    /// - Parameters:
    ///   - animated: 是否使用动画
    ///   - completion: 完成回调
    func popViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: animated)
            if animated, let transitionCoordinator = navigationController.transitionCoordinator {
                transitionCoordinator.animate(alongsideTransition: nil) { _ in
                    completion?()
                }
            } else {
                completion?()
            }
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }
    
    /// 安全返回（优先弹出，无法弹出则关闭）
    func goBack() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /// 安全关闭模态视图控制器
    /// - Parameters:
    ///   - animated: 是否使用动画
    ///   - completion: 完成回调
    func dismissViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }
    
    /// 安全呈现模态视图控制器
    /// - Parameters:
    ///   - viewController: 要呈现的视图控制器
    ///   - animated: 是否使用动画
    ///   - completion: 完成回调
    func presentViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(viewController, animated: animated, completion: completion)
    }
    
    /// 安全推入导航堆栈
    /// - Parameters:
    ///   - viewController: 要推入的视图控制器
    ///   - animated: 是否使用动画
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /// 安全返回根视图控制器
    /// - Parameter animated: 是否使用动画
    func popToRootViewController(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    // MARK: - 数据传递
    
    /// 安全传递数据到目标视图控制器
    /// - Parameters:
    ///   - data: 要传递的数据
    ///   - destinationViewController: 目标视图控制器
    func passData<T>(_ data: T, to destinationViewController: UIViewController) {
        // 这个方法需要子类重写来实现具体的数据传递逻辑
        // 这里提供了一个通用的框架
    }
    
    /// 从源视图控制器接收数据
    /// - Parameters:
    ///   - data: 接收到的数据
    ///   - sourceViewController: 源视图控制器
    func receiveData<T>(_ data: T, from sourceViewController: UIViewController) {
        // 这个方法需要子类重写来实现具体的数据接收逻辑
        // 这里提供了一个通用的框架
    }
    
    /// 准备传递数据（在跳转前调用）
    /// - Parameters:
    ///   - segue: 跳转对象
    ///   - data: 要传递的数据
    func prepareForSegue<T>(_ segue: UIStoryboardSegue, with data: T) {
        // 这个方法需要子类重写来实现具体的segue数据传递逻辑
    }
    
    // MARK: - 视图控制器查找
    
    /// 查找指定类型的父视图控制器
    /// - Parameter type: 要查找的视图控制器类型
    /// - Returns: 找到的父视图控制器，如果没有找到则返回nil
    func findParentViewController<T: UIViewController>(ofType type: T.Type) -> T? {
        var parent = self.parent
        while let currentParent = parent {
            if let typedParent = currentParent as? T {
                return typedParent
            }
            parent = currentParent.parent
        }
        return nil
    }
    
    /// 查找指定类型的子视图控制器
    /// - Parameter type: 要查找的视图控制器类型
    /// - Returns: 找到的子视图控制器数组
    func findChildViewControllers<T: UIViewController>(ofType type: T.Type) -> [T] {
        var result: [T] = []
        
        for child in children {
            if let typedChild = child as? T {
                result.append(typedChild)
            }
            result.append(contentsOf: child.findChildViewControllers(ofType: type))
        }
        
        return result
    }
    
    /// 查找导航控制器栈中的上一个视图控制器
    /// - Returns: 上一个视图控制器，如果没有则返回nil
    func previousViewController() -> UIViewController? {
        guard let navigationController = navigationController,
              let index = navigationController.viewControllers.firstIndex(of: self),
              index > 0 else {
            return nil
        }
        return navigationController.viewControllers[index - 1]
    }
    
    /// 查找导航控制器栈中的下一个视图控制器
    /// - Returns: 下一个视图控制器，如果没有则返回nil
    func nextViewController() -> UIViewController? {
        guard let navigationController = navigationController,
              let index = navigationController.viewControllers.firstIndex(of: self),
              index < navigationController.viewControllers.count - 1 else {
            return nil
        }
        return navigationController.viewControllers[index + 1]
    }
    
    // MARK: - 弹窗和提示
    
    /// 显示简单警告弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - buttonTitle: 按钮标题，默认为"确定"
    ///   - completion: 按钮点击回调
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   buttonTitle: String = "确定",
                   completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /// 显示确认弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - confirmTitle: 确认按钮标题，默认为"确定"
    ///   - cancelTitle: 取消按钮标题，默认为"取消"
    ///   - confirmHandler: 确认按钮点击回调
    ///   - cancelHandler: 取消按钮点击回调
    func showConfirmAlert(title: String? = nil,
                          message: String? = nil,
                          confirmTitle: String = "确定",
                          cancelTitle: String = "取消",
                          confirmHandler: (() -> Void)? = nil,
                          cancelHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmHandler?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelHandler?()
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// 显示输入弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - placeholder: 输入框占位符
    ///   - confirmTitle: 确认按钮标题
    ///   - cancelTitle: 取消按钮标题
    ///   - confirmHandler: 确认按钮点击回调，包含输入文本
    ///   - cancelHandler: 取消按钮点击回调
    func showInputAlert(title: String? = nil,
                        message: String? = nil,
                        placeholder: String? = nil,
                        confirmTitle: String = "确定",
                        cancelTitle: String = "取消",
                        confirmHandler: ((String?) -> Void)? = nil,
                        cancelHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            let text = alert.textFields?.first?.text
            confirmHandler?(text)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelHandler?()
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// 显示动作表单
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - actions: 动作数组
    ///   - cancelTitle: 取消按钮标题
    func showActionSheet(title: String? = nil,
                         message: String? = nil,
                         actions: [UIAlertAction],
                         cancelTitle: String = "取消") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 状态管理
    
    /// 显示加载指示器
    /// - Parameters:
    ///   - message: 加载消息
    ///   - style: 指示器样式
    func showLoadingIndicator(message: String? = nil, style: UIActivityIndicatorView.Style = .large) {
        hideLoadingIndicator()
        
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loadingView.tag = 9999
        
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        
        if let message = message {
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 0
            label.frame = CGRect(x: 20, y: activityIndicator.frame.maxY + 10,
                               width: loadingView.bounds.width - 40, height: 30)
            loadingView.addSubview(label)
        }
        
        view.addSubview(loadingView)
    }
    
    /// 隐藏加载指示器
    func hideLoadingIndicator() {
        view.viewWithTag(9999)?.removeFromSuperview()
    }
    
    /// 显示空状态视图
    /// - Parameters:
    ///   - message: 空状态消息
    ///   - image: 空状态图片
    func showEmptyState(message: String, image: UIImage? = nil) {
        hideEmptyState()
        
        let emptyView = UIView(frame: view.bounds)
        emptyView.tag = 9998
        emptyView.backgroundColor = view.backgroundColor
        
        var yOffset: CGFloat = emptyView.bounds.midY - 100
        
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: yOffset,
                                   width: emptyView.bounds.width,
                                   height: 80)
            emptyView.addSubview(imageView)
            yOffset = imageView.frame.maxY + 20
        }
        
        let label = UILabel()
        label.text = message
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.frame = CGRect(x: 20, y: yOffset,
                           width: emptyView.bounds.width - 40,
                           height: 60)
        emptyView.addSubview(label)
        
        view.addSubview(emptyView)
    }
    
    /// 隐藏空状态视图
    func hideEmptyState() {
        view.viewWithTag(9998)?.removeFromSuperview()
    }
    
    /// 显示错误视图
    /// - Parameters:
    ///   - error: 错误消息
    ///   - retryHandler: 重试回调
    func showErrorView(_ error: String, retryHandler: (() -> Void)? = nil) {
        hideErrorView()
        
        let errorView = UIView(frame: view.bounds)
        errorView.tag = 9997
        errorView.backgroundColor = view.backgroundColor
        
        let label = UILabel()
        label.text = error
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.frame = CGRect(x: 20, y: errorView.bounds.midY - 30,
                           width: errorView.bounds.width - 40,
                           height: 60)
        errorView.addSubview(label)
        
        if let retryHandler = retryHandler {
            let button = UIButton(type: .system)
            button.setTitle("重试", for: .normal)
            button.frame = CGRect(x: errorView.bounds.midX - 50, y: label.frame.maxY + 20,
                                width: 100, height: 44)
            button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
            errorView.addSubview(button)
        }
        
        view.addSubview(errorView)
    }
    
    @objc private func retryButtonTapped() {
        // 这个方法需要在子类中重写来实现重试逻辑
        hideErrorView()
    }
    
    /// 隐藏错误视图
    func hideErrorView() {
        view.viewWithTag(9997)?.removeFromSuperview()
    }
    
    // MARK: - 键盘管理
    
    /// 注册键盘通知
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow(_:)),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide(_:)),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }
    
    /// 取消注册键盘通知
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                name: UIResponder.keyboardWillShowNotification,
                                                object: nil)
        NotificationCenter.default.removeObserver(self,
                                                name: UIResponder.keyboardWillHideNotification,
                                                object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // 这个方法需要在子类中重写来处理键盘显示
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // 这个方法需要在子类中重写来处理键盘隐藏
    }
    
    /// 添加点击手势以隐藏键盘
    func addTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - 生命周期工具
    
    /// 安全执行视图控制器生命周期操作
    /// - Parameter closure: 要执行的操作
    func safePerformLifecycleOperation(_ closure: @escaping () -> Void) {
        if isViewLoaded && view.window != nil {
            closure()
        } else {
            // 延迟到视图出现后执行
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if self.isViewLoaded && self.view.window != nil {
                    closure()
                }
            }
        }
    }
    
    /// 检查是否应该执行操作（基于视图控制器的状态）
    /// - Returns: 是否可以执行操作
    func shouldPerformAction() -> Bool {
        return isViewLoaded && view.window != nil && !isBeingDismissed && !isMovingFromParent
    }
    
    /// 安全延迟执行操作
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - closure: 要执行的操作
    func safePerformAfterDelay(_ delay: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self, self.shouldPerformAction() else { return }
            closure()
        }
    }
    
    // MARK: - 内存管理
    
    /// 安全清理视图控制器资源
    func safeCleanup() {
        // 这个方法需要在子类中重写来清理特定资源
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 检查内存警告状态
    var isUnderMemoryPressure: Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    /// 优化内存使用
    func optimizeMemoryUsage() {
        // 清理缓存图片
        UIImage.clearCacheIfNeeded()
        
        // 清理不需要的视图
        if !isVisible {
            view.subviews.forEach { subview in
                if let imageView = subview as? UIImageView {
                    imageView.image = nil
                } else if let webView = subview as? UIWebView {
                    webView.loadHTMLString("", baseURL: nil)
                }
            }
        }
    }
}

// MARK: - 导航控制器扩展

public extension UINavigationController {
    
    /// 安全推入视图控制器数组
    /// - Parameters:
    ///   - viewControllers: 视图控制器数组
    ///   - animated: 是否使用动画
    func pushViewControllers(_ viewControllers: [UIViewController], animated: Bool = true) {
        var currentViewControllers = self.viewControllers
        currentViewControllers.append(contentsOf: viewControllers)
        setViewControllers(currentViewControllers, animated: animated)
    }
    
    /// 安全替换当前视图控制器
    /// - Parameters:
    ///   - viewController: 新的视图控制器
    ///   - animated: 是否使用动画
    func replaceCurrentViewController(with viewController: UIViewController, animated: Bool = true) {
        var currentViewControllers = self.viewControllers
        if !currentViewControllers.isEmpty {
            currentViewControllers.removeLast()
            currentViewControllers.append(viewController)
            setViewControllers(currentViewControllers, animated: animated)
        }
    }
    
    /// 安全插入视图控制器
    /// - Parameters:
    ///   - viewController: 要插入的视图控制器
    ///   - at index: 插入位置
    ///   - animated: 是否使用动画
    func insertViewController(_ viewController: UIViewController, at index: Int, animated: Bool = true) {
        var currentViewControllers = self.viewControllers
        if index >= 0 && index <= currentViewControllers.count {
            currentViewControllers.insert(viewController, at: index)
            setViewControllers(currentViewControllers, animated: animated)
        }
    }
    
    /// 安全移除指定位置的视图控制器
    /// - Parameters:
    ///   - at index: 要移除的位置
    ///   - animated: 是否使用动画
    func removeViewController(at index: Int, animated: Bool = true) {
        var currentViewControllers = self.viewControllers
        if index >= 0 && index < currentViewControllers.count {
            currentViewControllers.remove(at: index)
            setViewControllers(currentViewControllers, animated: animated)
        }
    }
    
    /// 安全移除指定类型的视图控制器
    /// - Parameters:
    ///   - ofType type: 要移除的视图控制器类型
    ///   - animated: 是否使用动画
    func removeViewControllers<T: UIViewController>(ofType type: T.Type, animated: Bool = true) {
        var currentViewControllers = self.viewControllers
        currentViewControllers.removeAll { $0 is T }
        setViewControllers(currentViewControllers, animated: animated)
    }
    
    /// 获取指定类型的视图控制器
    /// - Parameter type: 要查找的视图控制器类型
    /// - Returns: 找到的视图控制器数组
    func viewControllers<T: UIViewController>(ofType type: T.Type) -> [T] {
        return viewControllers.compactMap { $0 as? T }
    }
}

#endif