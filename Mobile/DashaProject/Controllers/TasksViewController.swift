//
//  TasksViewController.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    
    var tableView: UITableView!
    var phoneNumber = Int()
    var tasks: [Task]?
    
    init(phoneNumber: Int, tasks: [Task]?) {
        super.init(nibName: nil, bundle: nil)
        self.phoneNumber = phoneNumber
        self.tasks = tasks ?? [Task]()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = barButtonItem
        
        let firstCellType = TaskTableViewCell.self
//        let secondCellType = OwnCreatedQueueItemTableViewCell.self
        let firstId = TaskTableViewCell.id
//        let secondId = OwnCreatedQueueItemTableViewCell.id
        tableView.register(firstCellType, forCellReuseIdentifier: firstId)
//        tableView.register(secondCellType, forCellReuseIdentifier: secondId)
        
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
        
//        setupUI()
    }
    
    @objc private func addButtonTapped() {
        let createTaskVC = CreateTaskViewController()
        present(createTaskVC, animated: true)
        
        createTaskVC.completionHandler = { task in
            self.tasks?.append(task)
            
            NetworkManager.shared.addTask(phoneNumber: self.phoneNumber, task: task) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        currentQueue.people.count
//        guard TasksViewController.currentQueue != nil else { return 0 }
        return /* currentQueue!.people.count */ tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard TasksViewController.currentQueue != nil else { return UITableViewCell() }
        
        let id = TaskTableViewCell.id
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskTableViewCell
        
        cell.setupUI(with: tasks![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard QueueViewCTasksViewControllerontroller.currentQueue != nil else { return 0 }
        return 80
    }
}

// MARK: - SwiftUI
import SwiftUI

struct TasksVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<TasksVCProvider.ContainerView>) -> MainTabBarController  {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: TasksVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TasksVCProvider.ContainerView>) {
            
        }
    }
}
