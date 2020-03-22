//
//  NetworkManager.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init() {}
    
    let baseURL = URL(string: "https://mega-dasha.herokuapp.com")!
    
    func login(phoneNumber: Int, friendPhoneNumbers: [Int]?, completion: @escaping ([Task]?) -> Void) {
        let registerURL = baseURL.appendingPathComponent("/get_tasks/")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        let data: [String: Any] = ["me": phoneNumber, "users": [132]]
        let data = AuthData()
        data.me = phoneNumber
        data.users = friendPhoneNumbers ?? []
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(#line, #function, "Couldn't get data")
                completion(nil)
                return
            }
            let jsonDecoder = JSONDecoder()
            
            guard let tasks = try? jsonDecoder.decode(Tasks.self, from: data) else {
                print(#line, #function, "Couldn't decode tasks")
                return completion(nil)
            }
            
            completion(tasks.tasks)
        }
        task.resume()
    }
    
    func addTask(task: Task, completion: @escaping () -> Void) {
        let registerURL = baseURL.appendingPathComponent("/add_task/")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let taskData = TaskData()
        taskData.phoneNumber = TasksViewController.phoneNumber
        taskData.name = task.name
        taskData.category = task.category
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(taskData)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            completion()
        }
        task.resume()
    }
    
    func getOpportunities(radius: Int = 5000, location: String, friendPhoneNumber: Int?, completion: @escaping (Results?) -> Void) {
        let registerURL = baseURL.appendingPathComponent("/get_opportunities/")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let activeTaskData = ActiveTaskData()
        activeTaskData.location = location
        if friendPhoneNumber == nil {
            activeTaskData.friendPhoneNumbers = []
        } else {
            activeTaskData.friendPhoneNumbers = [friendPhoneNumber!]
        }
        activeTaskData.phoneNumber = TasksViewController.phoneNumber
        activeTaskData.radius = radius
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(activeTaskData)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(#line, #function, "Couldn't get data")
                completion(nil)
                return
            }
            let jsonDecoder = JSONDecoder()
            guard let results = try? jsonDecoder.decode(Results.self, from: data) else {
                print(#line, #function, "Couldn't decode results")
                return completion(nil)
            }
            
            completion(results)
        }
        task.resume()
    }
    
    func getActiveTasks(radius: Int = 5000, location: String, friendPhoneNumber: Int?, completion: @escaping ([Task]?) -> Void) {
        let registerURL = baseURL.appendingPathComponent("/get_active_tasks/")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let activeTaskData = ActiveTaskData()
        activeTaskData.location = location
        if friendPhoneNumber == nil {
            activeTaskData.friendPhoneNumbers = []
        } else {
            activeTaskData.friendPhoneNumbers = [friendPhoneNumber!]
        }
        activeTaskData.phoneNumber = TasksViewController.phoneNumber
        activeTaskData.radius = radius
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(activeTaskData)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(#line, #function, "Couldn't get data")
                completion(nil)
                return
            }
            let jsonDecoder = JSONDecoder()
            guard let tasks = try? jsonDecoder.decode(Tasks.self, from: data) else {
                print(#line, #function, "Couldn't decode tasks")
                return completion(nil)
            }
            
            completion(tasks.tasks)
        }
        task.resume()
    }
    
    func getIcon(at urlString: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: urlString)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
//        components?.host = baseURL.host
        guard let imageURL = components?.url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
