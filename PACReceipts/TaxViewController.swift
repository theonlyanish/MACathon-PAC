import UIKit

class TaxViewController: UIViewController {
    var startDatePicker: UIDatePicker!
    var endDatePicker: UIDatePicker!
    var dateRangeLabel: UILabel!
    var tableView: UITableView!
    var tableData: [Receipt] = []
    var compileAllButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the date range label
        dateRangeLabel = UILabel()
        dateRangeLabel.text = "Select a Date Range"
        dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateRangeLabel.textAlignment = .left
        view.addSubview(dateRangeLabel)
        
        // Create and configure the start date picker
        startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged) // Add target action
        view.addSubview(startDatePicker)
        
        // Create and configure the end date picker
        endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged) // Add target action
        view.addSubview(endDatePicker)
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        compileAllButton = UIButton(type: .system)
        compileAllButton.backgroundColor = UIColor.systemTeal  // Set the background color
        compileAllButton.setTitle("Compile All", for: .normal)
        compileAllButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        compileAllButton.setTitleColor(UIColor.white, for: .normal)  // Set the title color
        compileAllButton.layer.cornerRadius = 12
        compileAllButton.translatesAutoresizingMaskIntoConstraints = false
        compileAllButton.addTarget(self, action: #selector(compileAllButtonTapped), for: .touchUpInside)
        view.addSubview(compileAllButton)
        tableView.register(TaxCell.self, forCellReuseIdentifier: "TaxCell")
        
        
        // Create constraints for the date range label
        NSLayoutConstraint.activate([
            dateRangeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 20),
            dateRangeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
        
        // Create constraints for the start date picker
        NSLayoutConstraint.activate([
            startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startDatePicker.topAnchor.constraint(equalTo: dateRangeLabel.bottomAnchor, constant: 20),
        ])
        
        // Create constraints for the end date picker
        NSLayoutConstraint.activate([
            endDatePicker.leadingAnchor.constraint(equalTo: startDatePicker.trailingAnchor, constant: 20),
            endDatePicker.topAnchor.constraint(equalTo: dateRangeLabel.bottomAnchor, constant: 20),
        ])
        
        // Create constraints for the table view
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: compileAllButton.topAnchor, constant: -20),
        ])
        
        
        // Create constraints for the "Compile All" button
        NSLayoutConstraint.activate([
            compileAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            compileAllButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            compileAllButton.widthAnchor.constraint(equalToConstant: 200), // Set a specific width
            compileAllButton.heightAnchor.constraint(equalToConstant: 50),  // Set a specific height
        ])
        
        
    }
    
    
    @objc
    func compileAllButtonTapped() {
        // Create a folder name based on the selected date range
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let folderName = "Tax_receipts " + dateFormatter.string(from: startDatePicker.date) + "_" + dateFormatter.string(from: endDatePicker.date)

        // Get the documents directory URL
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Create a directory with the folder name if it doesn't exist
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)

                // Save images to the folder
                for (index, receipt) in tableData.enumerated() {
                    let imageFileName = "Image_\(index).jpg"
                    let imageFileURL = folderURL.appendingPathComponent(imageFileName)
                    if !FileManager.default.fileExists(atPath: imageFileURL.path) {
                        if let imageData = receipt.image.jpegData(compressionQuality: 1.0) { // Adjust compression quality as needed
                            try? imageData.write(to: imageFileURL)
                        }
                    }
                }

                // Show an alert to inform the user about the successful save
                let alert = UIAlertController(title: "Save Completed", message: "Images saved to folder: \(folderName)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } catch {
                // Show an alert for any errors encountered during folder creation or image saving
                let errorAlert = UIAlertController(title: "Error", message: "An error occurred while saving images.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                present(errorAlert, animated: true, completion: nil)
                print("Error creating folder or saving images: \(error)")
            }
        }
    }


    
    @objc
    func dateValueChanged(){
        fetchData()
    }
    
    func fetchData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let store = appDelegate.receiptStore
        store.fetchReceipts(inDateRange: startDatePicker.date, endDate: endDatePicker.date) { receipts in
            if let receipts  = receipts {
//                let deductibleReceipts = receipts.filter { $0.isTaxDeductible }
                self.tableData = receipts
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


extension TaxViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaxCell", for: indexPath) as! TaxCell
        
        
        // Configure the cell's UI elements with data from your TaxCellDataModel
        let dataModel = tableData[indexPath.row]
        cell.dateLabel.text = dateToString(dataModel.date) ?? ""
        cell.totalLabel.text = String(format: "%.2f", dataModel.total)
        cell.nameLabel.text = dataModel.name
        cell.categoryLabel.text = dataModel.category
        cell.thumbnailImageView.image = dataModel.image
        cell.categoryLabel.text = dataModel.category
        
        return cell
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Adjust the date format as needed
        return dateFormatter.string(from: date)
    }
    
}
