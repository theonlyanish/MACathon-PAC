//
//  OnboardingViewController.swift
//  PACReceipts
//
//  Created by Anish Kapse on 9/9/2023.
//

import Foundation
import UIKit
import SwiftUI
import Pastel

class OnboardingViewController: UIViewController {
    
    // UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Receipt Rover"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .white // Based on the theme's background colors
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let passageLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Receipt Rover, an app where you can automate the task of receipt tracking with the power of AI to save time and efforts that go behind your tax filings."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0 // Allows the label to wrap text across multiple lines
        label.textColor = .white // Based on the theme's background colors
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        // Teal color (RGB: 0, 128, 128)
        button.backgroundColor = UIColor(red: 12/255, green: 123/255, blue: 179/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor(white: 0.0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupUI()
    }

    func setupBackground() {
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 5.0
        pastelView.setColors([
            UIColor(red: 12/255, green: 123/255, blue: 179/255, alpha: 1.0),
                 UIColor(red: 7/255, green: 163/255, blue: 178/255, alpha: 1.0),
                 UIColor(red: 217/255, green: 236/255, blue: 199/255, alpha: 1.0)])
//UIColor(red: 14/255, green: 15/255, blue: 172/255, alpha: 1.0)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    func setupUI() {
        // Add the UI elements to the view
        view.addSubview(titleLabel)
        view.addSubview(passageLabel)
        view.addSubview(actionButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.25),
            
            passageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            passageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            actionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),

                   actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func actionButtonTapped() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "InpVC") as! NameViewController
    
    controller.modalPresentationStyle = .fullScreen
    present(controller, animated: true, completion: nil)
        
    }
}
