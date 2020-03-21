//
//  NetworkManager.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init() {}
    
    let baseURL = URL(string: "https://mega-dasha.herokuapp.com")!
    
    func login(phoneNumber: Int, completion: @escaping ([Task]?) -> Void) {
        let registerURL = baseURL.appendingPathComponent("/get_tasks/")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        let data: [String: Any] = ["me": phoneNumber, "users": [132]]
        let data = AuthData()
        data.me = phoneNumber
        data.users = [774, 233, 89516827825]
        
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
            let tasks = try? jsonDecoder.decode(Tasks.self, from: data)
            
            completion(tasks?.tasks)
        }
        task.resume()
    }
    
    func addTask(phoneNumber: Int, task: Task, completion: @escaping () -> Void) {
        let registerURL = baseURL.appendingPathComponent("/add_task/")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let taskData = TaskData()
        taskData.phoneNumber = phoneNumber
        taskData.name = task.name
        taskData.category = task.category
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(taskData)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(#line, #function, "Couldn't get data")
                completion()
                return
            }
//            let jsonDecoder = JSONDecoder()
//            let tasks = try? jsonDecoder.decode(Tasks.self, from: data)
            completion()
        }
        task.resume()
    }
    
    //    func checkLogin(for username: String, with password: String, completion: @escaping (User?) -> Void) {
    //        let loginURL = baseURL.appendingPathComponent("login/basic")
    //
    //        var request = URLRequest(url: loginURL)
    //
    //        request.httpMethod = "GET"
    //
    //        let loginString = String(format: "\(username):\(password)")
    //        guard let loginData = loginString.data(using: .utf8) else {
    //            print(#line, #function, "Can't encode login string to data using utf8")
    //            return completion(nil)
    //        }
    //        let base64LoginString = loginData.base64EncodedString()
    //        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    //
    //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //            guard let data = data else {
    //                print(#line, #function, "Couldn't get data")
    //                return completion(nil)
    //            }
    //
    //            let jsonDecoder = JSONDecoder()
    //            guard let user = try? jsonDecoder.decode(User.self, from: data) else {
    //                print(#line, #function, "Can't decode data from \(data)")
    //                return completion(nil)
    //            }
    //
    //            completion(user)
    //        }
    //
    //        task.resume()
    //    }
}
