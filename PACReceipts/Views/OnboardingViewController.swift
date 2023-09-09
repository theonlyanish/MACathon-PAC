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
        label.text = "This is a passage underneath the title. Adjust the text as needed."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0 // Allows the label to wrap text across multiple lines
        label.textColor = .white // Based on the theme's background colors
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap Me", for: .normal)
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
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
            actionButton.topAnchor.constraint(equalTo: passageLabel.bottomAnchor, constant: 20),
            actionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
}
