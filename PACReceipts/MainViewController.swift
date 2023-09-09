//
//  ViewController.swift
//  PACReceipts
//
//  Created by kent daniel on 9/9/2023.
//

import UIKit

class MainViewController: UIViewController {
    let titleView = UIView()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }
    
    func configViews(){
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = UIColor.lightGray
        titleView.layer.cornerRadius = 20
        view.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleView.widthAnchor.constraint(equalToConstant: 200),  // Adjust the width as needed
            titleView.heightAnchor.constraint(equalToConstant: 100)  // Adjust the height as needed
            
        ])
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Hello, Receipts!" // Set the text you want to display
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleView.addSubview(titleLabel)
        
        // Center the label in the titleView.
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
    }
    
    
}

