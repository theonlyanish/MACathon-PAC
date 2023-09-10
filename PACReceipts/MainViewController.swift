import UIKit
import AVFoundation
import VisionKit


class MainViewController: UIViewController {
    enum SectionLayoutKind: Int, CaseIterable {
        case categories, monthSection
        
        var columnCount: Int {
            switch self {
            case .monthSection:
                return 1
            case .categories:
                return 3
            }
        }
    }
    
    var categories: [String] = Job.expenseCategories
    var monthlyData: [MonthCellDataModel] = []
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, AnyHashable>! = nil
    private var collectionView: UICollectionView! = nil
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configureHierarchy()
        configureDataSource()
        fetchData()
    }
    
    func configViews() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let store = appDelegate.receiptStore
        store.fetchAllReceipts { data in
            for item in data! {
                // Unpack and process each item here
                print("Name: \(item.name ?? "N/A")")
                print("Category: \(item.category ?? "N/A")")
                print("Total: \(item.total)")
                print("isTaxDeductible: \(item.isTaxDeductible)")
                print("image: \(item.image)")
                print("date: \(item.date)")
            }
        }
        
        store.fetchReceiptsGroupedByMonth {
            data in
            if let dataGroups = data {
                self.monthlyData = convertToMonthCellDataModel(receiptGroups: dataGroups)
                print(self.monthlyData)
            }
            
            var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, AnyHashable>()
            snapshot.appendSections([.categories, .monthSection])
            snapshot.appendItems(self.categories, toSection: .categories)
            snapshot.appendItems(self.monthlyData, toSection: .monthSection)
            print(self.monthlyData)
            
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            
        }
    }
    
    @objc
    func addButtonTapped() {
        requestCameraPermission { (granted) in
            if granted {
                // Camera permission granted, now present the document scanner
                guard VNDocumentCameraViewController.isSupported else { print("Document scanning not supported"); return }
                let scannerViewController = VNDocumentCameraViewController()
                scannerViewController.delegate = self
                self.present(scannerViewController, animated: true, completion: nil)
            } else {
                // Camera permission denied or restricted, show an alert
                let alert = UIAlertController(
                    title: "Camera Access Required",
                    message: "Please enable camera access in Settings to use the document scanner.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension MainViewController {
    /// - Tag: PerSection
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            
            switch sectionLayoutKind {
            case .categories:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
                
                let groupHeight = NSCollectionLayoutDimension.absolute(44)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: groupHeight)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: sectionLayoutKind.columnCount)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                return section
            case .monthSection:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 2)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: sectionLayoutKind.columnCount)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
                
                return section
            }
        }
        return layout
    }
}

extension MainViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let categoryCellRegistration = UICollectionView.CellRegistration<CategoryCell, String> { (cell, indexPath, category) in
            cell.label.text = "\(category)"
        }
        
        let monthCellRegistration = UICollectionView.CellRegistration<MonthCell, MonthCellDataModel> { (cell, indexPath, data) in
            cell.monthLabel.text = "\(data.month)"
            cell.setCountText(data.receiptsCount)
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            
            if let category = item as? String {
                return SectionLayoutKind(rawValue: indexPath.section)! == .categories ?
                collectionView.dequeueConfiguredReusableCell(using: categoryCellRegistration, for: indexPath, item: category) : nil
            } else if let month = item as? MonthCellDataModel {
                return SectionLayoutKind(rawValue: indexPath.section)! == .monthSection ?
                collectionView.dequeueConfiguredReusableCell(using: monthCellRegistration, for: indexPath, item: month) : nil
            } else {
                return nil
            }
        }
        
        // Initial data
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, AnyHashable>()
        snapshot.appendSections([.categories, .monthSection])
        snapshot.appendItems(categories, toSection: .categories)
        snapshot.appendItems(self.monthlyData, toSection: .monthSection)
        print(self.monthlyData)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MainViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // Handle the scanned document here
        if scan.pageCount > 1 {
            let alert = UIAlertController(title: "Error", message: "Please scan only one page at a time.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        } else {
            // Handle the single scanned image
            let scannedImage = scan.imageOfPage(at: 0)
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
            detectText(in: scannedImage)  { [self] scannedText in
                if let text = scannedText {
                    DispatchQueue.main.async {
                        controller.dismiss(animated: true, completion: nil)
                        let successVC = ImageUploadSuccessViewController(ocrText: text, image: scannedImage)
                        let navController = UINavigationController(rootViewController: successVC)
                        
                        // Hide the navigation bar and tab bar
                        navController.modalPresentationStyle = .fullScreen
                        self.present(navController, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Cannot detect text", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                        controller.dismiss(animated: true, completion: nil)
                    }))
                    controller.present(alert, animated: true, completion: nil)
                }
                
            }
            
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        // Handle any errors here
        print("Document scanning error: \(error.localizedDescription)")
        controller.dismiss(animated: true, completion: nil)
    }
}


func convertToMonthCellDataModel(receiptGroups: [String:[Receipt]]) -> [MonthCellDataModel] {
    var monthData: [MonthCellDataModel] = []

    // Create an array of tuples with (month: String, receiptsCount: Int)
    let monthCountTuples = receiptGroups.map { (month: $0.key, receiptsCount: $0.value.count) }

    // Sort the array of tuples in descending order based on receiptsCount
    let sortedTuples = monthCountTuples.sorted { $0.receiptsCount > $1.receiptsCount }

    // Convert the sorted tuples back to MonthCellDataModel
    monthData = sortedTuples.map { MonthCellDataModel(month: $0.month, receiptsCount: $0.receiptsCount) }

    return monthData
}
func requestCameraPermission(completion: @escaping (Bool) -> Void) {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    
    switch status {
    case .authorized:
        // Camera access already granted
        completion(true)
    case .notDetermined:
        // Request permission
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            completion(granted)
        }
    case .denied, .restricted:
        // User denied camera access or it's restricted
        completion(false)
    @unknown default:
        completion(false)
    }
}



