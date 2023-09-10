import UIKit

class MonthCell: UICollectionViewCell {
    let monthLabel = UILabel()
    let countLabel = UILabel() // New label for displaying the count
    
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
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.adjustsFontForContentSizeCategory = true
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        monthLabel.textColor = .secondaryLabel
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.adjustsFontForContentSizeCategory = true
        countLabel.textAlignment = .center
        countLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        countLabel.textColor = .secondaryLabel
        
        // Add a soft drop shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 10
        
        contentView.backgroundColor = .white // Set the background color
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true // Clip to bounds
        
        addSubview(monthLabel)
        addSubview(countLabel) // Add the count label
        
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            monthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            
            // Position the count label in the bottom right corner
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: inset),
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: inset)
        ])
    }
    
    // Function to set the count text
    func setCountText(_ count: Int) {
        countLabel.text = "Number of receipts: \(count)"
    }
}
