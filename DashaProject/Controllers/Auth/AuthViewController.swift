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
    let phoneTextField = OneLineTextField(font: .avenir20())
    let loginButton = UIButton(title: "Войти", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()

    }
    
    @objc private func loginButtonTapped() {
//        present(loginVC, animated: true)
    }
}

// MARK: - UI
extension AuthViewController {
    private func setupConstraints() {
        
        let phoneView = TextFieldFormView(label: phoneLabel, textField: phoneTextField)
        
        let stackView = UIStackView(arrangedSubviews: [phoneView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
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

