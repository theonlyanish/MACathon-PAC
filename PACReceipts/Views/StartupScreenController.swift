//
//  StartupScreenController.swift
//  PACReceipts
//
//  Created by Anish Kapse on 9/9/2023.
//

import Foundation
import UIKit
import Pastel


class StartupScreenController: UIViewController{
    
    // Outlet for label
    @IBOutlet weak var label: UILabel!
    var text: String?
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
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
        setupUI()
        if text != nil {
            label.text = text
        }
        
        let pastelView = PastelView(frame: view.bounds)

         // Custom Direction
         pastelView.startPastelPoint = .bottomLeft
         pastelView.endPastelPoint = .topRight

         // Custom Duration
         pastelView.animationDuration = 3.0

         // Custom Color
        pastelView.setColors([
            UIColor(red: 12/255, green: 123/255, blue: 179/255, alpha: 1.0),
                 UIColor(red: 7/255, green: 163/255, blue: 178/255, alpha: 1.0),
                 UIColor(red: 217/255, green: 236/255, blue: 199/255, alpha: 1.0)])
//            UIColor(red: 75/255, green: 8/255, blue: 109/255, alpha: 1.0)])
           
//                              UIColor(red: 242/255, green: 186/255, blue: 232/255, alpha: 1.0)])

         pastelView.startAnimation()
         view.insertSubview(pastelView, at: 0)
        
        //(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func setupUI() {
        // Add the UI elements to the view
        
        view.addSubview(actionButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            actionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),

                   actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func actionButtonTapped() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "JobVC") as! JobViewController
    
    controller.modalPresentationStyle = .fullScreen
    present(controller, animated: true, completion: nil)
        
    }

            
}

