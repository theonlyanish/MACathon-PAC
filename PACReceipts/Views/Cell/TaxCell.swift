import UIKit

class TaxCell: UITableViewCell {
    // Declare UI elements you want to display in the cell
    let dateLabel = UILabel()
    let totalLabel = UILabel()
    let nameLabel = UILabel()
    let categoryLabel = UILabel()
    let thumbnailImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure the cell's UI elements (e.g., fonts, colors, constraints, etc.) here
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add and configure UI elements
        addSubview(dateLabel)
        addSubview(totalLabel)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(thumbnailImageView)
        
        // Customize the appearance of your UI elements
        
        
        contentView.layer.borderWidth = 1.0 // Adjust the border width as needed
        contentView.layer.borderColor = UIColor.lightGray.cgColor // Adjust the border color as needed
        contentView.layer.cornerRadius = 8.0 // Adjust the corner radius as needed

        dateLabel.font = UIFont.systemFont(ofSize: 16)
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        categoryLabel.font = UIFont.italicSystemFont(ofSize: 12)
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
        
        // Set up constraints for UI elements within the cell
        // You can use Auto Layout or other layout methods
        
        // Example constraint setup:
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 15),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            dateLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            
            totalLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            totalLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 5),
            categoryLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

