//
//  MainViewController.swift
//  iOSExtensionKitDemo
//
//  示例应用程序的主要视图控制器，展示iOSExtensionKit的各种功能
//

import UIKit
import iOSExtensionKit

/// 主要视图控制器，展示iOSExtensionKit的各种功能
class MainViewController: UIViewController {
    
    // MARK: - 私有属性
    
    /// 滚动视图容器
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    /// 内容视图容器
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    /// 功能卡片数组
    private var featureCards: [FeatureCardView] = []
    
    // MARK: - 生命周期方法
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置视图
        setupView()
        setupNavigationBar()
        setupScrollView()
        setupFeatureCards()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 布局子视图
        layoutSubviews()
    }
    
    // MARK: - 配置方法
    
    /// 配置视图控制器
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "iOSExtensionKit Demo"
        
        // 添加滚动视图
        view.addSubview(scrollView)
        
        // 添加内容视图
        scrollView.addSubview(contentView)
    }
    
    /// 配置导航栏
    private func setupNavigationBar() {
        // 添加信息按钮
        let infoButton = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(showInfo)
        )
        navigationItem.rightBarButtonItem = infoButton
    }
    
    /// 配置滚动视图
    private func setupScrollView() {
        // 设置滚动视图约束
        scrollView.fillSuperview()
        
        // 设置内容视图约束
        contentView.fillSuperview()
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    /// 配置功能卡片
    private func setupFeatureCards() {
        // 创建功能卡片数组
        let features = [
            ("Foundation", "字符串、日期、数组等基础类型扩展", UIColor.systemBlue),
            ("UIKit", "视图、控制器、颜色等UI组件扩展", UIColor.systemPurple),
            ("SwiftUI", "SwiftUI视图和修饰符扩展", UIColor.systemGreen),
            ("CoreGraphics", "几何类型扩展", UIColor.systemOrange),
            ("Combine", "响应式编程扩展", UIColor.systemPink),
            ("Security", "安全工具扩展", UIColor.systemRed)
        ]
        
        // 创建卡片视图
        for (index, feature) in features.enumerated() {
            let card = FeatureCardView()
            card.configure(
                title: feature.0,
                description: feature.1,
                color: feature.2,
                tag: index
            )
            card.addTarget(self, action: #selector(featureCardTapped(_:)), for: .touchUpInside)
            
            contentView.addSubview(card)
            featureCards.append(card)
        }
    }
    
    /// 布局子视图
    private func layoutSubviews() {
        let padding: CGFloat = 20
        let cardHeight: CGFloat = 120
        let cardSpacing: CGFloat = 16
        
        // 计算总高度
        let totalHeight = CGFloat(featureCards.count) * (cardHeight + cardSpacing) + padding * 2
        
        // 设置内容视图高度
        contentView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        
        // 布局卡片
        for (index, card) in featureCards.enumerated() {
            let y = padding + CGFloat(index) * (cardHeight + cardSpacing)
            card.frame = CGRect(
                x: padding,
                y: y,
                width: view.bounds.width - padding * 2,
                height: cardHeight
            )
        }
    }
    
    // MARK: - 动作方法
    
    /// 显示信息
    @objc private func showInfo() {
        let alert = UIAlertController(
            title: "iOSExtensionKit Demo",
            message: """
            版本：\(iOSExtensionKit.version)
            开发者：\(iOSExtensionKit.author)
            主页：\(iOSExtensionKit.homepageURL)
            
            展示iOSExtensionKit框架的各种功能。
            """,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        alert.addAction(UIAlertAction(title: "访问GitHub", style: .default) { _ in
            if let url = URL(string: iOSExtensionKit.homepageURL) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }
    
    /// 功能卡片点击事件
    @objc private func featureCardTapped(_ sender: FeatureCardView) {
        switch sender.tag {
        case 0:
            showFoundationDemo()
        case 1:
            showUIKitDemo()
        case 2:
            showSwiftUIDemo()
        case 3:
            showCoreGraphicsDemo()
        case 4:
            showCombineDemo()
        case 5:
            showSecurityDemo()
        default:
            break
        }
    }
    
    // MARK: - 演示方法
    
    /// 显示Foundation扩展演示
    private func showFoundationDemo() {
        let demoVC = FoundationDemoViewController()
        navigationController?.pushViewController(demoVC, animated: true)
    }
    
    /// 显示UIKit扩展演示
    private func showUIKitDemo() {
        let demoVC = UIKitDemoViewController()
        navigationController?.pushViewController(demoVC, animated: true)
    }
    
    /// 显示SwiftUI扩展演示
    private func showSwiftUIDemo() {
        let demoVC = SwiftUIDemoViewController()
        navigationController?.pushViewController(demoVC, animated: true)
    }
    
    /// 显示CoreGraphics扩展演示
    private func showCoreGraphicsDemo() {
        let demoVC = CoreGraphicsDemoViewController()
        navigationController?.pushViewController(demoVC, animated: true)
    }
    
    /// 显示Combine扩展演示
    private func showCombineDemo() {
        let demoVC = CombineDemoViewController()
        navigationController?.pushViewController(demoVC, animated: true)
    }
    
    /// 显示Security扩展演示
    private func showSecurityDemo() {
        let demoVC = SecurityDemoViewController()
        navigationController?.pushViewController(demoVC, animated: true)
    }
}

// MARK: - 功能卡片视图

/// 功能卡片视图
private class FeatureCardView: UIControl {
    
    // MARK: - 私有属性
    
    /// 标题标签
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    /// 描述标签
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    /// 图标视图
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    /// 颜色视图
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 图标名称数组
    private let iconNames = [
        "doc.text",
        "square.grid.2x2",
        "swift",
        "crop",
        "arrow.triangle.2.circlepath",
        "lock.shield"
    ]
    
    // MARK: - 初始化
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 配置方法
    
    /// 配置卡片
    func configure(title: String, description: String, color: UIColor, tag: Int) {
        titleLabel.text = title
        descriptionLabel.text = description
        colorView.backgroundColor = color
        self.tag = tag
        
        // 设置图标
        if tag < iconNames.count {
            iconView.image = UIImage(systemName: iconNames[tag])
        }
    }
    
    /// 设置视图
    private func setupView() {
        // 添加子视图
        addSubview(colorView)
        colorView.addSubview(iconView)
        colorView.addSubview(titleLabel)
        colorView.addSubview(descriptionLabel)
        
        // 添加阴影
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
        layer.cornerRadius = 16
        layer.masksToBounds = false
        
        // 设置颜色视图约束
        colorView.fillSuperview()
        
        // 设置图标约束
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 20),
            iconView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 设置标题标签约束
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -20)
        ])
        
        // 设置描述标签约束
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: colorView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - 触摸处理
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateScale(scale: 0.95)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateScale(scale: 1.0)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateScale(scale: 1.0)
    }
    
    /// 动画缩放
    private func animateScale(scale: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}