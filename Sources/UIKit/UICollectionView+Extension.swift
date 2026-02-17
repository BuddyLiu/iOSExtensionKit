// UICollectionView+Extension.swift
// UICollectionView扩展，提供便捷的集合视图操作方法

#if canImport(UIKit)
import UIKit

public extension UICollectionView {
    
    // MARK: - 注册与出队
    
    /// 使用类名注册单元格
    /// - Parameter cellClass: 单元格类
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let identifier = String(describing: cellClass)
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    /// 使用类名注册补充视图
    /// - Parameters:
    ///   - viewClass: 补充视图类
    ///   - kind: 补充视图类型
    func registerSupplementaryView<T: UICollectionReusableView>(_ viewClass: T.Type, forKind kind: String) {
        let identifier = String(describing: viewClass)
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    /// 使用类名注册头部视图
    /// - Parameter viewClass: 头部视图类
    func registerHeaderView<T: UICollectionReusableView>(_ viewClass: T.Type) {
        registerSupplementaryView(viewClass, forKind: UICollectionView.elementKindSectionHeader)
    }
    
    /// 使用类名注册尾部视图
    /// - Parameter viewClass: 尾部视图类
    func registerFooterView<T: UICollectionReusableView>(_ viewClass: T.Type) {
        registerSupplementaryView(viewClass, forKind: UICollectionView.elementKindSectionFooter)
    }
    
    /// 使用类名出队单元格
    /// - Parameters:
    ///   - cellClass: 单元格类
    ///   - indexPath: 索引路径
    /// - Returns: 出队的单元格实例
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("无法出队单元格: \(identifier)")
        }
        return cell
    }
    
    /// 使用类名出队补充视图
    /// - Parameters:
    ///   - viewClass: 补充视图类
    ///   - kind: 补充视图类型
    ///   - indexPath: 索引路径
    /// - Returns: 出队的补充视图实例
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ viewClass: T.Type, ofKind kind: String, for indexPath: IndexPath) -> T {
        let identifier = String(describing: viewClass)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("无法出队补充视图: \(identifier)")
        }
        return view
    }
    
    /// 使用类名出队头部视图
    /// - Parameters:
    ///   - viewClass: 头部视图类
    ///   - indexPath: 索引路径
    /// - Returns: 出队的头部视图实例
    func dequeueReusableHeaderView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(viewClass, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
    }
    
    /// 使用类名出队尾部视图
    /// - Parameters:
    ///   - viewClass: 尾部视图类
    ///   - indexPath: 索引路径
    /// - Returns: 出队的尾部视图实例
    func dequeueReusableFooterView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(viewClass, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
    }
    
    // MARK: - 安全操作方法
    
    /// 安全滚动到指定索引路径
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否使用动画
    /// - Returns: 是否滚动成功
    @discardableResult
    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) -> Bool {
        guard indexPath.section < numberOfSections else { return false }
        guard indexPath.item < numberOfItems(inSection: indexPath.section) else { return false }
        
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        return true
    }
    
    /// 安全滚动到第一个项目
    /// - Parameters:
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否使用动画
    /// - Returns: 是否滚动成功
    @discardableResult
    func safeScrollToFirstItem(at scrollPosition: UICollectionView.ScrollPosition = .top, animated: Bool = true) -> Bool {
        guard numberOfSections > 0 else { return false }
        
        for section in 0..<numberOfSections {
            if numberOfItems(inSection: section) > 0 {
                return safeScrollToItem(at: IndexPath(item: 0, section: section), at: scrollPosition, animated: animated)
            }
        }
        
        return false
    }
    
    /// 安全滚动到最后一个项目
    /// - Parameters:
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否使用动画
    /// - Returns: 是否滚动成功
    @discardableResult
    func safeScrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition = .bottom, animated: Bool = true) -> Bool {
        guard numberOfSections > 0 else { return false }
        
        for section in (0..<numberOfSections).reversed() {
            let itemCount = numberOfItems(inSection: section)
            if itemCount > 0 {
                return safeScrollToItem(at: IndexPath(item: itemCount - 1, section: section), at: scrollPosition, animated: animated)
            }
        }
        
        return false
    }
    
    /// 安全选择指定索引路径的项目
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - animated: 是否使用动画
    ///   - scrollPosition: 滚动位置（可选）
    /// - Returns: 是否选择成功
    @discardableResult
    func safeSelectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition? = nil) -> Bool {
        guard let indexPath = indexPath else {
            selectItem(at: nil, animated: animated, scrollPosition: .top)
            return true
        }
        
        guard indexPath.section < numberOfSections else { return false }
        guard indexPath.item < numberOfItems(inSection: indexPath.section) else { return false }
        
        selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition ?? .top)
        return true
    }
    
    /// 安全取消选择指定索引路径的项目
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - animated: 是否使用动画
    /// - Returns: 是否取消选择成功
    @discardableResult
    func safeDeselectItem(at indexPath: IndexPath, animated: Bool) -> Bool {
        guard indexPath.section < numberOfSections else { return false }
        guard indexPath.item < numberOfItems(inSection: indexPath.section) else { return false }
        
        deselectItem(at: indexPath, animated: animated)
        return true
    }
    
    /// 安全重新加载指定索引路径的项目
    /// - Parameter indexPath: 索引路径
    /// - Returns: 是否重新加载成功
    @discardableResult
    func safeReloadItem(at indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections else { return false }
        guard indexPath.item < numberOfItems(inSection: indexPath.section) else { return false }
        
        reloadItems(at: [indexPath])
        return true
    }
    
    /// 安全重新加载指定索引路径集合的项目
    /// - Parameter indexPaths: 索引路径集合
    /// - Returns: 成功重新加载的索引路径数量
    @discardableResult
    func safeReloadItems(at indexPaths: [IndexPath]) -> Int {
        let validIndexPaths = indexPaths.filter { indexPath in
            indexPath.section < numberOfSections && indexPath.item < numberOfItems(inSection: indexPath.section)
        }
        
        if !validIndexPaths.isEmpty {
            reloadItems(at: validIndexPaths)
        }
        
        return validIndexPaths.count
    }
    
    /// 安全删除指定索引路径的项目
    /// - Parameter indexPath: 索引路径
    /// - Returns: 是否删除成功
    @discardableResult
    func safeDeleteItem(at indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections else { return false }
        guard indexPath.item < numberOfItems(inSection: indexPath.section) else { return false }
        
        deleteItems(at: [indexPath])
        return true
    }
    
    /// 安全删除指定索引路径集合的项目
    /// - Parameter indexPaths: 索引路径集合
    /// - Returns: 成功删除的索引路径数量
    @discardableResult
    func safeDeleteItems(at indexPaths: [IndexPath]) -> Int {
        let validIndexPaths = indexPaths.filter { indexPath in
            indexPath.section < numberOfSections && indexPath.item < numberOfItems(inSection: indexPath.section)
        }
        
        if !validIndexPaths.isEmpty {
            deleteItems(at: validIndexPaths)
        }
        
        return validIndexPaths.count
    }
    
    /// 安全移动项目
    /// - Parameters:
    ///   - fromIndexPath: 起始索引路径
    ///   - toIndexPath: 目标索引路径
    /// - Returns: 是否移动成功
    @discardableResult
    func safeMoveItem(from fromIndexPath: IndexPath, to toIndexPath: IndexPath) -> Bool {
        guard fromIndexPath.section < numberOfSections,
              fromIndexPath.item < numberOfItems(inSection: fromIndexPath.section) else { return false }
        
        guard toIndexPath.section < numberOfSections,
              toIndexPath.item <= numberOfItems(inSection: toIndexPath.section) else { return false }
        
        moveItem(at: fromIndexPath, to: toIndexPath)
        return true
    }
    
    // MARK: - 索引路径操作
    
    /// 获取所有项目的索引路径
    /// - Returns: 所有项目的索引路径数组
    func allIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        
        for section in 0..<numberOfSections {
            for item in 0..<numberOfItems(inSection: section) {
                indexPaths.append(IndexPath(item: item, section: section))
            }
        }
        
        return indexPaths
    }
    
    /// 获取可见项目的索引路径
    /// - Returns: 可见项目的索引路径数组
    var visibleIndexPaths: [IndexPath] {
        return indexPathsForVisibleItems.sorted { $0.section < $1.section || ($0.section == $1.section && $0.item < $1.item) }
    }
    
    /// 获取选中项目的索引路径
    /// - Returns: 选中项目的索引路径数组
    var selectedIndexPaths: [IndexPath] {
        return indexPathsForSelectedItems ?? []
    }
    
    /// 检查索引路径是否有效
    /// - Parameter indexPath: 要检查的索引路径
    /// - Returns: 索引路径是否有效
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.item < numberOfItems(inSection: indexPath.section)
    }
    
    /// 检查索引路径集合是否有效
    /// - Parameter indexPaths: 要检查的索引路径集合
    /// - Returns: 无效的索引路径数组
    func invalidIndexPaths(in indexPaths: [IndexPath]) -> [IndexPath] {
        return indexPaths.filter { !isValidIndexPath($0) }
    }
    
    /// 获取下一个索引路径（按顺序）
    /// - Parameter indexPath: 当前索引路径
    /// - Returns: 下一个索引路径（如果存在）
    func nextIndexPath(after indexPath: IndexPath) -> IndexPath? {
        guard isValidIndexPath(indexPath) else { return nil }
        
        let itemCountInSection = numberOfItems(inSection: indexPath.section)
        
        // 先尝试同一章节的下一个项目
        if indexPath.item + 1 < itemCountInSection {
            return IndexPath(item: indexPath.item + 1, section: indexPath.section)
        }
        
        // 尝试下一章节的第一个项目
        if indexPath.section + 1 < numberOfSections {
            for section in (indexPath.section + 1)..<numberOfSections {
                if numberOfItems(inSection: section) > 0 {
                    return IndexPath(item: 0, section: section)
                }
            }
        }
        
        return nil
    }
    
    /// 获取上一个索引路径（按顺序）
    /// - Parameter indexPath: 当前索引路径
    /// - Returns: 上一个索引路径（如果存在）
    func previousIndexPath(before indexPath: IndexPath) -> IndexPath? {
        guard isValidIndexPath(indexPath) else { return nil }
        
        // 先尝试同一章节的上一个项目
        if indexPath.item > 0 {
            return IndexPath(item: indexPath.item - 1, section: indexPath.section)
        }
        
        // 尝试上一章节的最后一个项目
        if indexPath.section > 0 {
            for section in (0..<indexPath.section).reversed() {
                let itemCount = numberOfItems(inSection: section)
                if itemCount > 0 {
                    return IndexPath(item: itemCount - 1, section: section)
                }
            }
        }
        
        return nil
    }
    
    // MARK: - 单元格操作
    
    /// 获取指定索引路径的单元格
    /// - Parameter indexPath: 索引路径
    /// - Returns: 单元格（如果可见）
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        guard isValidIndexPath(indexPath) else { return nil }
        return cellForItem(at: indexPath)
    }
    
    /// 获取指定索引路径的单元格（泛型版本）
    /// - Parameters:
    ///   - cellClass: 单元格类
    ///   - indexPath: 索引路径
    /// - Returns: 特定类型的单元格（如果可见）
    func cellForItem<T: UICollectionViewCell>(_ cellClass: T.Type, at indexPath: IndexPath) -> T? {
        return cellForItem(at: indexPath) as? T
    }
    
    /// 获取可见单元格数组（泛型版本）
    /// - Parameter cellClass: 单元格类
    /// - Returns: 特定类型的可见单元格数组
    func visibleCells<T: UICollectionViewCell>(ofType cellClass: T.Type) -> [T] {
        return visibleCells.compactMap { $0 as? T }
    }
    
    /// 更新单元格的可见性
    /// - Parameter indexPath: 索引路径
    /// - Returns: 单元格是否可见
    func isCellVisible(at indexPath: IndexPath) -> Bool {
        guard let cell = cellForItem(at: indexPath) else { return false }
        return bounds.contains(cell.frame)
    }
    
    /// 获取完全可见的单元格（完全在可视范围内）
    var fullyVisibleCells: [UICollectionViewCell] {
        return visibleCells.filter { bounds.contains($0.frame) }
    }
    
    /// 获取部分可见的单元格（部分在可视范围内）
    var partiallyVisibleCells: [UICollectionViewCell] {
        return visibleCells.filter { bounds.intersects($0.frame) && !bounds.contains($0.frame) }
    }
    
    // MARK: - 布局操作
    
    /// 获取当前布局
    /// - Returns: 当前布局
    var currentLayout: UICollectionViewLayout {
        return collectionViewLayout
    }
    
    /// 安全设置布局
    /// - Parameters:
    ///   - layout: 新布局
    ///   - animated: 是否使用动画
    ///   - completion: 完成回调
    func safeSetLayout(_ layout: UICollectionViewLayout, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionViewLayout = layout
                self.layoutIfNeeded()
            }, completion: completion)
        } else {
            collectionViewLayout = layout
            completion?(true)
        }
    }
    
    /// 无效化布局
    /// - Parameter animated: 是否使用动画
    func invalidateLayout(animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.collectionViewLayout.invalidateLayout()
                self.layoutIfNeeded()
            }
        } else {
            collectionViewLayout.invalidateLayout()
        }
    }
    
    /// 重新加载数据并保持滚动位置
    /// - Parameter completion: 完成回调
    func reloadDataPreservingScrollPosition(completion: (() -> Void)? = nil) {
        let offset = contentOffset
        let contentHeight = contentSize.height
        
        reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let newContentHeight = self.contentSize.height
            let delta = newContentHeight - contentHeight
            
            if delta > 0 {
                self.contentOffset = CGPoint(x: offset.x, y: offset.y + delta)
            }
            
            completion?()
        }
    }
    
    // MARK: - 动画操作
    
    /// 执行批量更新操作
    /// - Parameters:
    ///   - updates: 更新闭包
    ///   - completion: 完成回调
    func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        performBatchUpdates(updates, completion: completion)
    }
    
    /// 安全执行批量更新操作（包含错误处理）
    /// - Parameters:
    ///   - updates: 更新闭包
    ///   - completion: 完成回调
    func safePerformBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        do {
            try performBatchUpdates(updates, completion: completion)
        } catch {
            print("批量更新失败: \(error)")
            completion?(false)
        }
    }
    
    /// 动画插入项目
    /// - Parameters:
    ///   - indexPaths: 索引路径数组
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func animateInsertItems(at indexPaths: [IndexPath], duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.insertItems(at: indexPaths)
        } completion: { finished in
            completion?(finished)
        }
    }
    
    /// 动画删除项目
    /// - Parameters:
    ///   - indexPaths: 索引路径数组
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func animateDeleteItems(at indexPaths: [IndexPath], duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.deleteItems(at: indexPaths)
        } completion: { finished in
            completion?(finished)
        }
    }
    
    /// 动画重新加载项目
    /// - Parameters:
    ///   - indexPaths: 索引路径数组
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func animateReloadItems(at indexPaths: [IndexPath], duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.reloadItems(at: indexPaths)
        } completion: { finished in
            completion?(finished)
        }
    }
    
    /// 动画移动项目
    /// - Parameters:
    ///   - fromIndexPath: 起始索引路径
    ///   - toIndexPath: 目标索引路径
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func animateMoveItem(from fromIndexPath: IndexPath, to toIndexPath: IndexPath, duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.moveItem(at: fromIndexPath, to: toIndexPath)
        } completion: { finished in
            completion?(finished)
        }
    }
    
    // MARK: - 工具方法
    
    /// 获取集合视图的内容大小
    /// - Returns: 内容大小
    var contentSizeValue: CGSize {
        return contentSize
    }
    
    /// 获取集合视图的可见区域
    /// - Returns: 可见区域
    var visibleRect: CGRect {
        return bounds
    }
    
    /// 检查集合视图是否为空
    /// - Returns: 是否为空
    var isEmpty: Bool {
        return numberOfSections == 0 || (0..<numberOfSections).allSatisfy { numberOfItems(inSection: $0) == 0 }
    }
    
    /// 检查集合视图是否包含数据
    /// - Returns: 是否包含数据
    var hasData: Bool {
        return !isEmpty
    }
    
    /// 获取项目总数
    /// - Returns: 项目总数
    var totalItemCount: Int {
        return (0..<numberOfSections).reduce(0) { $0 + numberOfItems(inSection: $1) }
    }
    
    /// 获取指定章节的项目数（安全版本）
    /// - Parameter section: 章节索引
    /// - Returns: 项目数
    func safeNumberOfItems(inSection section: Int) -> Int {
        guard section >= 0 && section < numberOfSections else { return 0 }
        return numberOfItems(inSection: section)
    }
    
    /// 清空选中状态
    /// - Parameter animated: 是否使用动画
    func clearSelection(animated: Bool = false) {
        indexPathsForSelectedItems?.forEach { deselectItem(at: $0, animated: animated) }
    }
    
    /// 检查是否正在滚动
    /// - Returns: 是否正在滚动
    var isScrolling: Bool {
        return isTracking || isDragging || isDecelerating
    }
    
    /// 停止滚动
    /// - Parameter animated: 是否使用动画
    func stopScrolling(animated: Bool = false) {
        setContentOffset(contentOffset, animated: animated)
    }
}

#endif