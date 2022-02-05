//
//  HorizontalPickerViewCell.swift
//  HorizontalPickerView
//
//  Created by Afraz Siddiqui on 2/5/22.
//

import UIKit

/// Picker item cell
final class HorizontalPickerViewCell: UICollectionViewCell {
    /// Cell identifier
    static let identifier = String(describing: HorizontalPickerViewCell.self)

    /// Title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
    }

    public func configure(with title: NSAttributedString?, isSelected: Bool) {
        titleLabel.attributedText = title
        backgroundColor = isSelected ? .systemBlue : .systemFill
    }
}
