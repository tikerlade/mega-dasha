//
//  AuthViewController.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    let phoneLabel = UILabel(text: "Введите ваш номер", font: .avenir20())
    let phoneNumberTextField = OneLineTextField(font: .avenir20())
    let loginButton = UIButton(title: "Войти", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        guard let phoneNumberString = phoneNumberTextField.text else { return }
        guard let phoneNumber = Int(phoneNumberString) else { return }
        NetworkManager.shared.login(phoneNumber: phoneNumber) { tasks in
            DispatchQueue.main.async {
                let mainTabBar = MainTabBarController(phoneNumber: phoneNumber, tasks: tasks)
                mainTabBar.modalPresentationStyle = .fullScreen
                self.present(mainTabBar, animated: true)
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
        
        phoneNumberTextField.keyboardType = .numberPad
        let phoneView = TextFieldFormView(label: phoneLabel, textField: phoneNumberTextField)
        
        let stackView = UIStackView(arrangedSubviews: [phoneView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}

// MARK: - AuthNavigatingDelegate
//extension AuthViewController: AuthNavigatingDelegate {
//    func toLoginVC() {
//        present(loginVC, animated: true)
//    }
//
//    func toSignUpVC() {
//        present(signUpVC, animated: true)
//    }
//}

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

