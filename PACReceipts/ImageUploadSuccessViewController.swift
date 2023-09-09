import UIKit

class ImageUploadSuccessViewController: UIViewController {
    
    let ocrText:String
    let image: UIImage
    
    // This label will display a success message
    let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Image Upload Successful!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
        view.backgroundColor = .systemCyan
        
        // Add the success label to the view
        view.addSubview(successLabel)
        
        // Configure constraints for the success label
        NSLayoutConstraint.activate([
            successLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func extractMetaData() async {
        
            // get categories and occupation from userDefaults
            let metadata = await getOCRMetaData(from: ocrText , categories: ["Food", "Car", "Self-education"] , occupation: "Bus Driver")
            guard let metadata = metadata else { return }
            // save image and metadata to coreData

    }
    
    
    
}



