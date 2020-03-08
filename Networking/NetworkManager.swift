//
//  NetworkManager.swift
//  Networking
//
//  Created by Lucky on 08/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func getRequest(url: String) {
        
        guard let url = URL(string: url)
            else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard
                let response = response,
                let data = data
                else { return }
            print(response, data)
            
            // Serialize JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func postRequest(url: String) {
        
        guard let url = URL(string: url)
            else { return }
        
        let userData = ["Course" : "Networking",
                        "Lesson" : "Get and Post Requests"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: [])
            else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard
                let response = response,
                let data = data
                else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        
        // Validation url address
        guard let url = URL(string: url)
            else { return }
        
        let urlSession = URLSession.shared
        urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        } .resume()
    }
    
    static func fetchData(url: String, completionHandler: @escaping (_ course: [Course]) -> ()) {
        
        // Check validation url-address
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            // Trying to get data
            guard let data = data else { return }
            
            // Realization JSON-Decoder
            do {
                
                // Converter format snakeCase / camelCase
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let courses = try decoder.decode([Course].self, from: data)
                completionHandler(courses)
                print(courses[3].name ?? "Courses/part4/name is not available")
            } catch let error {
                print("Error serialization JSON", error)
            }
        }.resume()
    }
}
