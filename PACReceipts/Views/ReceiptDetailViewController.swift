//
//  ReceiptDetailViewController.swift
//  PACReceipts
//
//  Created by Anish Kapse on 10/9/2023.
//

import Foundation
import UIKit

class ReceiptDetailViewController: UIViewController {

    var receipt: Receipt
    let imageView = UIImageView()
    

    //... add other UI elements like labels for displaying the receipt details

    init(receipt: Receipt) {
        self.receipt = receipt
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize UI layout
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // Configure and layout imageView
        imageView.frame = CGRect(x: 20, y: 40, width: self.view.bounds.width - 40, height: 200)
        if let image = receipt.image as? UIImage {
            imageView.image = image
        }
        view.addSubview(imageView)
        
        //... configure and layout other UI elements
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the view controller when any area outside the content is tapped
        if touches.first?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

