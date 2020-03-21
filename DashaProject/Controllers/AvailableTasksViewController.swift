//
//  AvailableTasksViewController.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class AvailableTasksViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct AvailableTasksVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AvailableTasksVCProvider.ContainerView>) -> MainTabBarController  {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: AvailableTasksVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AvailableTasksVCProvider.ContainerView>) {
            
        }
    }
}
