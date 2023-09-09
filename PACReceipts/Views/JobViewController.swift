//
//  JobViewController.swift
//  PACReceipts
//
//  Created by Anish Kapse on 9/9/2023.
//

import Foundation
import UIKit
import Pastel

class JobViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
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
        button.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Please fill out this information"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "Job"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.placeholder = "Select Job"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let jobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Job Description"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.placeholder = "Enter your Job Description in brief"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    
    let jobPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let jobOptions = ["Doctor", "Lawyer", "Engineer", "Teacher", "Student"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        if let savedDescription = UserDefaults.standard.string(forKey: "JobDescription") {
            jobDescriptionTextField.text = savedDescription
        }

        
      

        // Create the toolbar with the Done button
        let jobPickerTextField: UITextField = {
            let textField = UITextField()
            textField.inputView = jobPicker // Set the UIPickerView as the input view
            return textField
        }()
        
        if let savedJob = UserDefaults.standard.string(forKey: "SelectedJob") {
            jobTextField.text = savedJob
        }

       
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupBackground() {
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
        
 //           UIColor(red: 12/255, green: 123/255, blue: 179/255, alpha: 1.0),

//                                UIColor(red: 7/255, green: 163/255, blue: 178/255, alpha: 1.0),
//                                UIColor(red: 217/255, green: 236/255, blue: 199/255, alpha: 1.0)])

//            UIColor(red: 14/255, green: 15/255, blue: 172/255, alpha: 1.0),
//            UIColor(red: 75/255, green: 8/255, blue: 109/255, alpha: 1.0)])

//               UIColor(red: 242/255, green: 186/255, blue: 232/255, alpha: 1.0)])

         pastelView.startAnimation()
        
        view.insertSubview(pastelView, at: 0)
    }
    
    func setupUI() {
        view.addSubview(infoLabel)
        view.addSubview(jobLabel)
        view.addSubview(jobTextField)
        view.addSubview(jobDescriptionLabel)
        view.addSubview(jobDescriptionTextField)
        view.addSubview(actionButton)
        
        jobTextField.delegate = self
        jobPicker.dataSource = self
        jobPicker.delegate = self
        jobDescriptionTextField.delegate = self

        jobTextField.inputView = jobPicker
        
        NSLayoutConstraint.activate([
            // Center the labels and text fields horizontally
            // Title label (infoLabel) in the upper half of the page
                    infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                    infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    
                    // Vertical spacing between the title and the first field
                    jobLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
                    
                    // Vertical spacing between each title and its field
                    jobTextField.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 10),
                    jobDescriptionLabel.topAnchor.constraint(equalTo: jobTextField.bottomAnchor, constant: 20),
                    jobDescriptionTextField.topAnchor.constraint(equalTo: jobDescriptionLabel.bottomAnchor, constant: 10),
                    
                    // Center the labels and text fields horizontally
                    jobLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    jobTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    jobDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    jobDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    
                    // Set the right constraints for the text fields
                    jobTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    jobDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    
                    // Bottom constraint to keep the fields within the middle region
                    jobDescriptionTextField.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            actionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),

                   actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    // MARK: - PickerView DataSource & Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jobOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return jobOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        jobTextField.text = jobOptions[row]
        
        // Save the selected job to UserDefaults
        UserDefaults.standard.set(jobOptions[row], forKey: "SelectedJob")
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == jobTextField {
            jobDescriptionTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    @objc func nextBtnClicked(_ sender: UIButton) {
        
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
         controller.modalPresentationStyle = .fullScreen
         controller.modalTransitionStyle = .flipHorizontal
         UserDefaults.standard.hasOnboarded = true
         present(controller, animated: true, completion: nil)
        
    }
    
    // MARK: Functions to handle keyboard dismissal
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == jobDescriptionTextField {
            guard let description = textField.text, description.count <= 100 else {
                // Show an alert if the description exceeds 100 characters
                let alert = UIAlertController(title: "Error", message: "Job description should be up to 100 characters only.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return false
            }
            
            // Save the job description to UserDefaults
            UserDefaults.standard.set(description, forKey: "JobDescription")
        }
        
        return true
    }

    
    
    

}
