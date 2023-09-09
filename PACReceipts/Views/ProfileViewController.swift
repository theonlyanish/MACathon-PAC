//
//  ProfileViewController.swift
//  PACReceipts
//
//  Created by Anish Kapse on 10/9/2023.
//

import Foundation
import UIKit
import Pastel

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let jobTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let jobPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let jobOptions = ["Doctor", "Lawyer", "Engineer", "Teacher", "Student"]
    private var isEditingProfile = false
    
    private let jobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0 // Allow multiline
        label.lineBreakMode = .byWordWrapping // Break by words, not characters
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    private let jobDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBackground()
        
        // Set up the Edit button on the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
        
        loadSavedData()
    }
    
    @objc private func toggleEditMode() {
        isEditingProfile = !isEditingProfile
        nameTextField.isHidden = !isEditingProfile
        jobPicker.isHidden = !isEditingProfile
        jobDescriptionTextField.isHidden = !isEditingProfile
        
        if isEditingProfile {
            navigationItem.rightBarButtonItem?.title = "Save"
        } else {
            navigationItem.rightBarButtonItem?.title = "Edit"
            saveData()
            loadSavedData()
        }
    }
    
    private func loadSavedData() {
        if let savedName = UserDefaults.standard.string(forKey: "Name") {
            nameLabel.text = savedName
            nameTextField.text = savedName
        }
        
        if let savedJob = UserDefaults.standard.string(forKey: "SelectedJob") {
            jobTitleLabel.text = savedJob
            
            // For Kent - Use this for categories or whatever
            var expenseCategories: [String] = []
            if savedJob == "Freelance Writer/Author" {
                expenseCategories = ["Home Office", "Computer and Software", "Books and Research Materials", "Travel", "Professional Development"]
            } else if savedJob == "Construction Worker" {
                expenseCategories = ["Tools and Equipment", "Protective Gear", "Union Fees", "Travel", "Licenses and Courses"]
            } else if savedJob == "Real Estate Agent" {
                expenseCategories = ["Travel", "Advertising", "Phone and Internet", "Professional Development", "Home Office"]
            } else if savedJob == "Musician" {
                expenseCategories = ["Instruments", "Music Sheets and Copyrights", "Promotion", "Travel", "Professional Development"]
            } else if savedJob == "Fitness Instructor" {
                expenseCategories = ["Sporting Equipment", "Uniforms", "Professional Development", "Music and Choreography", "Travel"]
            }
        }
        
        if let savedJobDescription = UserDefaults.standard.string(forKey: "JobDescription") {
            jobDescriptionLabel.text = savedJobDescription
            jobDescriptionTextField.text = savedJobDescription
        }
    }
    
    private func saveData() {
        UserDefaults.standard.set(nameTextField.text, forKey: "Name")
        UserDefaults.standard.set(jobTitleLabel.text, forKey: "SelectedJob")
        UserDefaults.standard.set(jobDescriptionTextField.text, forKey: "JobDescription")
    }
    
    func setupBackground() {
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        pastelView.setColors([
            UIColor(red: 12/255, green: 123/255, blue: 179/255, alpha: 1.0),
                 UIColor(red: 7/255, green: 163/255, blue: 178/255, alpha: 1.0),
                 UIColor(red: 217/255, green: 236/255, blue: 199/255, alpha: 1.0)])
//UIColor(red: 14/255, green: 15/255, blue: 172/255, alpha: 1.0)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    
    
    private func setupUI() {
        view.backgroundColor = .white

            // Create horizontal stack views for each label-input pair
            let nameStack = createHorizontalStackView(with: nameLabel, and: nameTextField)
            let jobStack = createVerticalStackView(with: jobTitleLabel, and: jobPicker)

            let jobDescriptionStack = createVerticalStackView(with: jobDescriptionLabel, and: jobDescriptionTextField)

            // Create a vertical stack view to hold all label-input pairs
            let mainStack = UIStackView(arrangedSubviews: [nameStack, jobStack, jobDescriptionStack])
            mainStack.axis = .vertical
            mainStack.alignment = .fill
            mainStack.distribution = .fillEqually
            mainStack.spacing = 10
            mainStack.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(mainStack)

            jobPicker.delegate = self
            jobPicker.dataSource = self
            nameTextField.delegate = self
            jobDescriptionTextField.delegate = self
        

        // Constraints for the main stack view
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])

        nameTextField.isHidden = true
        jobPicker.isHidden = true
        jobDescriptionTextField.isHidden = true
    }

    private func createHorizontalStackView(with label: UILabel, and view: UIView) -> UIStackView {
        let hStack = UIStackView(arrangedSubviews: [label, view])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = 10
        return hStack
    }
    
    private func createVerticalStackView(with label: UILabel, and view: UIView) -> UIStackView {
        let vStack = UIStackView(arrangedSubviews: [label, view])
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 5  // Adjust this spacing to control the gap between label and picker
        return vStack
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
        jobTitleLabel.text = jobOptions[row]
    }
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
