import UIKit
import VisionKit
import Vision

class MainViewController: UIViewController {
    enum SectionLayoutKind: Int, CaseIterable {
        case categories, monthCell
        
        var columnCount: Int {
            switch self {
            case .monthCell:
                return 1
            case .categories:
                return 3
            }
        }
    }
    
    var categories: [Category]?
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Int>! = nil
    private var collectionView: UICollectionView! = nil
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configureHierarchy()
        configureDataSource()
    }
    
    func configViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
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
            case .monthCell:
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
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<CategoryCell, String> { (cell, indexPath, identifier) in
            cell.label.text = "\(identifier)"
        }
        
        let textCellRegistration = UICollectionView.CellRegistration<MonthCell, Int> { (cell, indexPath, identifier) in
            cell.label.text = "\(identifier)"
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return SectionLayoutKind(rawValue: indexPath.section)! == .categories ?
            collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: "Category" ) :
            collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: identifier)
        }
        
        // Initial data
        let itemsPerSection = 10
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
        SectionLayoutKind.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
        }
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
            // Inform user they can only scan a single page
            let alert = UIAlertController(title: "Error", message: "Please scan only one page at a time.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        } else {
            // Handle the single scanned image
            let scannedImage = scan.imageOfPage(at: 0)
            detectText(in: scannedImage)
            // Do something with scannedImage
            controller.dismiss(animated: true, completion: nil)
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


import AVFoundation

func detectText(in image: UIImage) {
    guard let image = image.cgImage else {
        print("Invalid image")
        return
    }
    
    
    let request = VNRecognizeTextRequest { (request, error) in
        if let error = error {
            print("Error detecting text: \(error)")
        } else {
            handleDetectionResults(results: request.results)
        }
    }
    
    request.recognitionLanguages = ["en_US"]
    request.recognitionLevel = .accurate
    
    performDetection(request: request, image: image)
}

func performDetection(request: VNRecognizeTextRequest, image: CGImage) {
    let requests = [request]
    
    let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])
    
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try handler.perform(requests)
        } catch let error {
            print("Error: \(error)")
        }
    }
}


func handleDetectionResults(results: [Any]?) {
    var textOCRResults: [String] = []
    guard let results = results, results.count > 0 else {
        print("No text found")
        return
    }
    
    for result in results {
        if let observation = result as? VNRecognizedTextObservation {
            for text in observation.topCandidates(1) {
                print(text.string)
                textOCRResults.append(text.string)
            }
        }
        
    }
    
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



