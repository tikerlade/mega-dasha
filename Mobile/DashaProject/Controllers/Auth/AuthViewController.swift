//
//  AuthViewController.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "dasha")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let phoneLabel = UILabel(text: "Введите ваш номер", font: .avenir20())
    let friendPhoneLabel = UILabel(text: "Введите номер друга", font: .avenir20())
    let phoneNumberTextField = OneLineTextField(font: .avenir20())
    let friendPhoneNumberTextField = OneLineTextField(font: .avenir20())
    let loginButton = UIButton(title: "Войти", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton.applyGradients(cornerRadius: 10)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = .zero
    }
    
    @objc private func loginButtonTapped() {
        guard let phoneNumberString = phoneNumberTextField.text else { return }
        guard let phoneNumber = Int(phoneNumberString) else { return }
        var friendPhoneNumbers: [Int]? = nil
        if let friendPhoneNumberString = friendPhoneNumberTextField.text {
            friendPhoneNumbers = [Int(friendPhoneNumberString)!]
        }
        
        self.showSpinner(onView: self.view)
        view.endEditing(true)
        NetworkManager.shared.login(phoneNumber: phoneNumber, friendPhoneNumbers: friendPhoneNumbers) { tasks in
            DispatchQueue.main.async {
                TasksViewController.phoneNumber = phoneNumber
                let mainTabBar = MainTabBarController(friendPhoneNumber: friendPhoneNumbers?.first, tasks: tasks)
                mainTabBar.modalPresentationStyle = .fullScreen
                self.present(mainTabBar, animated: true)
                self.removeSpinner()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UI
extension AuthViewController {
    private func setupConstraints() {
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 0.5 * view.frame.size.width),
        ])
        
        phoneNumberTextField.keyboardType = .numberPad
        friendPhoneNumberTextField.keyboardType = .numberPad
        let phoneView = TextFieldFormView(label: phoneLabel, textField: phoneNumberTextField)
        let friendPhoneView = TextFieldFormView(label: friendPhoneLabel, textField: friendPhoneNumberTextField)
        
        let stackView = UIStackView(arrangedSubviews: [phoneView, friendPhoneView], axis: .vertical, spacing: 30)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 230),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AuthViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AuthViewControllerProvider.ContainerView>) -> AuthViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: AuthViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthViewControllerProvider.ContainerView>) {
            
        }
    }
}

