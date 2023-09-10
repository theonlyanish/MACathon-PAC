import UIKit
import CoreData

class ReceiptDetailViewController: UIViewController {
    
    var receipt: Receipt? {
        didSet {
            configureView()
        }
    }

    // UI Components
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit // Adjusts the content to fit the size of the view
        return imgView
    }()
    
    let stackView: UIStackView = {
           let stack = UIStackView()
           stack.translatesAutoresizingMaskIntoConstraints = false
           stack.axis = .vertical
           stack.spacing = 8
           return stack
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        configureView()
    }
    
    func setupUI() {
        view.addSubview(imageView)
        view.addSubview(stackView)
        
        // Image view constraints
        NSLayoutConstraint.activate([
             imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
             imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             imageView.widthAnchor.constraint(equalToConstant: 150), // Adjust width as needed
             imageView.heightAnchor.constraint(equalToConstant: 150) // Adjust height as needed
         ])
         
         // StackView constraints
         NSLayoutConstraint.activate([
             stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
             stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
             stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
         ])
    }
    
    func configureView() {
        guard let receiptData = receipt else { return }
        imageView.image = receiptData.image as? UIImage
        
        // Name
        let nameLabel = UILabel()
        nameLabel.text = "Name: \(receiptData.name ?? "")"
        nameLabel.textColor = .black
        
        // Category
        let categoryLabel = UILabel()
        categoryLabel.text = "Category: \(receiptData.category ?? "")"
        
        categoryLabel.textColor = .black
        
        // Total
        let totalLabel = UILabel()
        totalLabel.text = String(format: "Total: $%.2f", receiptData.total)
        totalLabel.textColor = .black
        // Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateLabel = UILabel()
        dateLabel.text = "Date: \(dateFormatter.string(from: receiptData.date))"
        dateLabel.textColor = .black
        // Is Tax Deductible
        let taxDeductibleLabel = UILabel()
        taxDeductibleLabel.text = "Tax Deductible: \(receiptData.isTaxDeductible ? "Yes" : "No")"
        taxDeductibleLabel.textColor = .black
        // Add these labels to the stack view
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(totalLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(taxDeductibleLabel)
    }

}
