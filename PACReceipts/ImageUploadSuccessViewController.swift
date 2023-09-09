import UIKit

class ImageUploadSuccessViewController: UIViewController {
    
    let ocrText:String
    let image: UIImage
    var isProcessing: Bool = true {
        didSet {
            updateLabel()
        }
    }
    
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
        view.backgroundColor = .systemTeal
        
        // Add the success label to the view
        view.addSubview(successLabel)
        
        // Add the AI label to the view
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
        
        Task {
            await extractMetaData()
        }
       
    }
    
    func extractMetaData() async {
        
        // get categories and occupation from userDefaults
        if let occupation = UserDefaults.standard.string(forKey: "SelectedJob") {
            let metadata = await getOCRMetaData(from: ocrText , categories: ["Food", "Car", "Self-education"] , occupation: occupation)
            guard let metadata = metadata else { return }
            print(metadata)
            isProcessing = false
            self.dismiss(animated: true)
        }
        
        
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



