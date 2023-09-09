//
//  TextCell.swift
//  PACReceipts
//
//  Created by kent daniel on 9/9/2023.
//

import Foundation

import UIKit

class CategoryCell: UICollectionViewCell {
    let label = UILabel()
    static let reuseIdentifier = "text-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

extension CategoryCell {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 20
        contentView.addSubview(label)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}
