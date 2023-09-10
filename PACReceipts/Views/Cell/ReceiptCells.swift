//
//  ReceiptCells.swift
//  PACReceipts
//
//  Created by Anish Kapse on 10/9/2023.
//

import Foundation
import UIKit

class ReceiptCell: UICollectionViewCell {

    var receiptImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.layer.cornerRadius = 8
        self.backgroundColor = .systemGray5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(receiptImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(priceLabel)
        addSubview(categoryLabel)

        NSLayoutConstraint.activate([
            receiptImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            receiptImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            receiptImageView.heightAnchor.constraint(equalToConstant: 80),
            receiptImageView.widthAnchor.constraint(equalToConstant: 80),

            nameLabel.topAnchor.constraint(equalTo: receiptImageView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: receiptImageView.rightAnchor, constant: 15),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            dateLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),

            priceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            categoryLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with receipt: Receipt) {
        nameLabel.text = receipt.name
        if let image = receipt.image as? UIImage {
            receiptImageView.image = image
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: receipt.date)
        priceLabel.text = String(format: "$%.2f", receipt.total)
        categoryLabel.text = receipt.category
    }

}
