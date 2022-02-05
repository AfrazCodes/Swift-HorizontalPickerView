//
//  HorizontalPickerView.swift
//  HorizontalPickerView
//
//  Created by Afraz Siddiqui on 2/5/22.
//

import UIKit

/// Horizontal picker view
final class HorizontalPickerView: UIView {

    /// View datasource
    weak var datasource: HorizontalPickerViewDatasource? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    private var timer: Timer?

    private var highlightedIndices: Set<IndexPath> = []

    // MARK: - Subviews

    private var collectionView: UICollectionView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = bounds
    }

    /// Creates collectionView
    private func createCollectionView() {
        guard collectionView == nil, collectionView?.superview == nil else { return }

        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            return self?.layout(for: section)
        }
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.register(HorizontalPickerViewCell.self,
                                forCellWithReuseIdentifier: HorizontalPickerViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.allowsSelection = true
        addSubview(collectionView)
        self.collectionView = collectionView
    }
}

// MARK: - Public

extension HorizontalPickerView {
    /// Reload data
    public func reload() {
        collectionView?.reloadData()
    }

    /// Select item
    /// - Parameters:
    ///   - item: Item index
    ///   - row: Row index
    ///   - animated: Animated boolean
    public func select(
        item: Int,
        in row: Int,
        animated: Bool = true
    ) {
        let rowCount = datasource?.numberOfRows() ?? 0
        guard row < rowCount else { return }

        let itemCount = datasource?.numberOfItems(in: self, for: row) ?? 0
        guard item < itemCount else { return }
        collectionView?.selectItem(at: IndexPath(row: item, section: row), animated: animated, scrollPosition: .centeredHorizontally)
    }

    /// Get selected indices
    /// - Returns: Set of index paths
    public func selectedIndexPaths() -> Set<IndexPath> {
        return highlightedIndices
    }
}

// MARK: - CollectionView

extension HorizontalPickerView: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.numberOfRows() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfItems(in: self, for: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HorizontalPickerViewCell.identifier,
            for: indexPath
        ) as? HorizontalPickerViewCell else {
            fatalError()
        }

        let title = datasource?.horizontalPickerView(self, attributedTitleAt: indexPath)
        cell.configure(with: title, isSelected: false)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.highlightSelectedItems()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.highlightSelectedItems()
    }

    /// Highlight picker selected items
    private func highlightSelectedItems() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let strongSelf = self else { return }

            for item in strongSelf.highlightedIndices {
                let cell = strongSelf.collectionView?.cellForItem(at: item) as? HorizontalPickerViewCell
                cell?.configure(
                    with: strongSelf.datasource?.horizontalPickerView(strongSelf, attributedTitleAt: item),
                    isSelected: false
                )
            }

            let rowCount = strongSelf.datasource?.numberOfRows() ?? 0
            for i in 0..<rowCount {
                guard let indexPath = self?.selectedItem(in: i) else { continue }
                let cell = strongSelf.collectionView?.cellForItem(at: indexPath) as? HorizontalPickerViewCell

                if !strongSelf.highlightedIndices.contains(indexPath) {
                    strongSelf.highlightedIndices.insert(indexPath)
                }

                cell?.configure(
                    with: strongSelf.datasource?.horizontalPickerView(strongSelf, attributedTitleAt: indexPath),
                    isSelected: true
                )
            }
        }
    }

    /// Get indexPaths that should be selected for picker UX
    /// - Parameter row: Target row
    /// - Returns: Nullable indexPath
    private func selectedItem(in row: Int) -> IndexPath? {
        // Get visible indices
        let indicies = collectionView?.indexPathsForVisibleItems ?? []

        // Section filter
        let items = indicies.filter { $0.section == row }.sorted(by: {
            $0.row < $1.row
        })

        guard !items.isEmpty else {
            return nil
        }

        // Return position based on size
        if items.count == 3 {
            // First 3 in row
            if items.contains(where: { $0.row == 0 }) {
                return items[0]
            }

            // Last 3
            return items[items.count - 1]
        }
        else if items.count == 4 {
            // First 4
            if items.contains(where: { $0.row == 0 }) {
                return items[1]
            }

            // Last 4
            return items[items.count - 2]
        }
        else if items.count == 5 {
            return items[2]
        }

        return nil
    }

    /// Create and return collection layout
    /// - Parameter section: Section to create for
    /// - Returns: `NSCollectionLayoutSection`
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let rowCount = datasource?.numberOfRows() ?? 0
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )

        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.28),
                heightDimension: .absolute(height / CGFloat(rowCount))
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
}
