import UIKit

class ImageUploadSuccessViewController: UIViewController {
    private var store: ReceiptStore?
    let ocrText:String
    let image: UIImage
    var isProcessing: Bool = true {
        didSet {
            updateLabel()
        }
    }
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.tintColor = .systemBlue
        button.backgroundColor = .white
        button.layer.cornerRadius = 12 // Adjust the corner radius as needed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // This label will display a success message
    let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Processing..." // Initial label text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // New label for "Sit back and let AI do its job"
    let aiLabel: UILabel = {
        let label = UILabel()
        label.text = "Sit back and let AI do its job"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(ocrText: String, image: UIImage) {
        self.ocrText = ocrText
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.store = appDelegate.receiptStore
        
        view.backgroundColor = .systemTeal
        
        // Add the success label to the view
        view.addSubview(successLabel)
        
        view.addSubview(doneButton)
        view.addSubview(aiLabel)
        
        
        // Configure constraints for the success label
        NSLayoutConstraint.activate([
            successLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Configure constraints for the AI label
        NSLayoutConstraint.activate([
            aiLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 10), // Adjust the spacing as needed
            aiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            aiLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Configure constraints for the "Done" button
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60) // Adjust the height as needed
        ])
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.isHidden = true
        Task {
            await extractMetaData()
        }
        
    }
    
    func extractMetaData() async {
        
        // get categories and occupation from userDefaults
        if let occupation = UserDefaults.standard.string(forKey: "SelectedJob") {
            let metadata = await getOCRMetaData(from: ocrText , categories: Job.expenseCategories , occupation: occupation)
            guard let metadata = metadata else { return }
            print(metadata)
            let date = convertStringToDate(metadata.date ?? "")
            store?.createReceipt(
                name: metadata.name ?? "untitled",
                category: metadata.category ?? "Unknown",
                total: metadata.totalAmount ?? 0.0 ,
                image: self.image,
                isTaxDeductible: metadata.isTaxDeductible ?? false,
                date: date)
            
            isProcessing = false
            doneButton.isHidden = false
        }
        
        
    }
    
    private func convertStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            // If the input string is invalid, return today's date
            return Date()
        }
    }

    
    // Handler for the "Done" button tap
    @objc func doneButtonTapped() {
        // You can dismiss the view controller or perform any other action
        navigationController?.dismiss(animated: true)
    }
    
    func updateLabel() {
        DispatchQueue.main.async {
            if self.isProcessing {
                self.successLabel.text = "Processing..."
            } else {
                self.successLabel.text = "Success"
            }
        }
    }
    
}



