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
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Please fill out this information"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "Job"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select Job"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let jobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Job Description"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Description"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let jobPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let jobOptions = ["Doctor", "Lawyer", "Engineer", "Teacher", "Artist"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
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

//                                UIColor(red: 7/255, green: 163/255, blue: 178/255, alpha: 1.0),
//                                UIColor(red: 217/255, green: 236/255, blue: 199/255, alpha: 1.0)])

//            UIColor(red: 14/255, green: 15/255, blue: 172/255, alpha: 1.0),
//            UIColor(red: 75/255, green: 8/255, blue: 109/255, alpha: 1.0)])

               UIColor(red: 242/255, green: 186/255, blue: 232/255, alpha: 1.0)])

         pastelView.startAnimation()
        
        view.insertSubview(pastelView, at: 0)
    }
    
    func setupUI() {
        view.addSubview(infoLabel)
        view.addSubview(jobLabel)
        view.addSubview(jobTextField)
        view.addSubview(jobDescriptionLabel)
        view.addSubview(jobDescriptionTextField)
        
        jobTextField.delegate = self
        jobPicker.dataSource = self
        jobPicker.delegate = self
        
        jobTextField.inputView = jobPicker
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            jobLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
            jobLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            jobTextField.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 10),
            jobTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            jobTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            jobDescriptionLabel.topAnchor.constraint(equalTo: jobTextField.bottomAnchor, constant: 30),
            jobDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            jobDescriptionTextField.topAnchor.constraint(equalTo: jobDescriptionLabel.bottomAnchor, constant: 10),
            jobDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            jobDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
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

    @IBAction func nextBtnClicked(_ sender: UIButton) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
         controller.modalPresentationStyle = .fullScreen
         controller.modalTransitionStyle = .flipHorizontal
         UserDefaults.standard.hasOnboarded = true
         present(controller, animated: true, completion: nil)
        
    }
}
