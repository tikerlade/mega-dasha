//
//  CreateTaskViewController.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    
    var completionHandler: ((Task) -> Void)?
    let categories = ["Рестораны", "Кафе", "Фаст-Фуд", "Развлечения", "Достопримечательности", "Транспорт", "Аэропорт", "Проживание", "Шоппинг", "Активный Отдых", "Учреждения", "Природа", "Заправки", "Банкоматы", "Туалеты", "Больницы"]
    
    let titleLabel = UILabel(text: "Добавьте задачу", font: .avenir26())
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите категорию"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let nameTextField = OneLineTextField(font: .avenir20())
    let categoryTextField = OneLineTextField(font: .avenir20())
    let pickerView = UIPickerView()
    
//    let setCurrentDateLabel = UILabel(text: "Использовать текущую дату?", font: .avenir16())
//    let setCurrentDateSwitch = UISwitch()
    
    let createButton = UIButton(title: "Создать", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        setCurrentDateSwitch.addTarget(self, action: #selector(setCurrentDateSwitchTapped), for: .touchUpInside)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - keyboardSize.height + 60
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = .zero
    }
    
    @objc private func createButtonTapped() {
        guard let name = nameTextField.text,
            let category = categoryTextField.text,
//            let startDate = startDateTextField.text,
            name != "",
            category != "" else {
                return
        }
        
        let task = Task(name: name, phoneNumber: TasksViewController.phoneNumber, category: category)

        self.completionHandler?(task)
        dismiss(animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UI
extension CreateTaskViewController {
    private func setupUI() {
        nameTextField.placeholder = "Название"
        categoryTextField.placeholder = "Категория"
        let nameTextFieldFormView = TextFieldFormView(label: nameLabel, textField: nameTextField)
        let categoryTextFieldFormView = TextFieldFormView(label: categoryLabel, textField: categoryTextField)
        
        pickerView.backgroundColor = .white
        categoryTextField.inputView = pickerView
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let stackView = UIStackView(arrangedSubviews: [nameTextFieldFormView, categoryTextFieldFormView], axis: .vertical, spacing: 30)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
//            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
        ])
    
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 230),
            createButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CreateTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
    }
}

// MARK: - SwiftUI
import SwiftUI

struct CreateTaskVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let createTaskVC = CreateTaskViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<CreateTaskVCProvider.ContainerView>) -> CreateTaskViewController {
            return createTaskVC
        }
        
        func updateUIViewController(_ uiViewController: CreateTaskVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<CreateTaskVCProvider.ContainerView>) {
            
        }
    }
}

