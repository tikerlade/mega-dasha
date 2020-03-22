//
//  TasksViewController.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    
    static let updateNotificationName = Notification.Name("updateNotificationName")
    static var phoneNumber = Int()
    
    var tableView: UITableView!
    var friendPhoneNumber: Int? = Int()
    var tasks: [Task]?
    var activeTasks: [Task]?
    //    var oldLocation = (Double(), Double())
    var oldTime = Date()
    
    init(friendPhoneNumber: Int?, tasks: [Task]?) {
        super.init(nibName: nil, bundle: nil)
        self.friendPhoneNumber = friendPhoneNumber
        self.tasks = tasks ?? [Task]()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite()
        
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 140, width: view.frame.size.width, height: view.frame.size.height - 140), style: .insetGrouped)
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTasks), name: TasksViewController.updateNotificationName, object: nil)
    }
    
    @objc private func addButtonTapped() {
        let createTaskVC = CreateTaskViewController()
        present(createTaskVC, animated: true)
        
        createTaskVC.completionHandler = { task in
            self.tasks?.append(task)
            
            NetworkManager.shared.addTask(task: task) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func updateTasks(with notification: Notification) {
        guard let location = notification.userInfo!["location"] as? (Double, Double) else { return }
        
        //        if oldLocation.0 == 0 && oldLocation.1 == 0 {
        //            oldLocation = location
        //        }
        //        print(oldLocation)
        
        //        if (abs(location.1 - oldLocation.1)) > 0.0003 || (abs(location.0 - oldLocation.0)) > 0.0003 {
        //        print(oldTime.timeIntervalSinceNow)
        if abs(oldTime.timeIntervalSinceNow) > TimeInterval(10) {
            NetworkManager.shared.getActiveTasks(radius: 5000, location: "\(location.0),\(location.1)", friendPhoneNumber: friendPhoneNumber) { activeTasks in
                guard let tasks = activeTasks else { return }
                self.activeTasks = tasks
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                //                self.oldLocation = location
            }
            self.oldTime = Date()
            //            print(#line, location)
        }
        
        NetworkManager.shared.getOpportunities(location: "\(location.0),\(location.1)", friendPhoneNumber: friendPhoneNumber) { results in
            guard let results = results else { return }
            
            MapViewController.items = results
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Активные задачи"
        case 1:
            return "Все задачи"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return activeTasks?.count ?? 0
        case 1:
            return tasks?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        guard TasksViewController.currentQueue != nil else { return UITableViewCell() }
        
        let id = TaskTableViewCell.id
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TaskTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.setupUI(with: activeTasks![indexPath.row])
            return cell
        case 1:
            cell.setupUI(with: tasks![indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
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
