//
//  ReceiptsViewController.swift
//  PACReceipts
//
//  Created by kent daniel on 10/9/2023.
//

import UIKit

class ReceiptsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var receipts: [Receipt] = []
    var receiptStore = ReceiptStore()
    
    // This lazy var block is to initialize the collectionView and configure it
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ReceiptCell.self, forCellWithReuseIdentifier: "ReceiptCell")
        cv.backgroundColor = .white
        cv.delegate = self  // Set delegate inside the block
        cv.dataSource = self  // Set dataSource inside the block
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        loadReceipts()
        
     
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
    }

    func loadReceipts() {
        receiptStore.fetchAllReceipts { (fetchedReceipts) in
            if let fetchedReceipts = fetchedReceipts {
                self.receipts = fetchedReceipts
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // Other UICollectionView delegate, datasource and flowlayout methods will go here.
}

    
extension ReceiptsViewController {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receipts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell
        let receipt = receipts[indexPath.item]
        cell.configure(with: receipt)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 130)
    }


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let receiptDetailVC = ReceiptDetailViewController()
        receiptDetailVC.receipt = receipts[indexPath.item]
        present(receiptDetailVC, animated: true, completion: nil)
        collectionView.deselectItem(at: indexPath, animated: true) // Deselect the cell after tap
    }


    
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


