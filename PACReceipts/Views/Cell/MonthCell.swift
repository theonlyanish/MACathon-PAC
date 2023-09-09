import UIKit

class MonthCell: UICollectionViewCell {
    let label = UILabel()
    static let reuseIdentifier = "month-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

extension MonthCell {
    func configure() {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .black
        contentView.layer.borderColor = UIColor.systemGray2.cgColor
        layer.borderWidth = 1
        addSubview(label)
        layer.cornerRadius = 20
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
}
