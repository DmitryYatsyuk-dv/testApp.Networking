//
//  CoursesViewController.swift
//  Networking
//
//  Created by Lucky on 07/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
    func fetchData() {
        
        // We create a session for downloading this at URL-address
        let jsonUrl = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
        
        // Validation url-address
        guard let url = URL(string: jsonUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Trying to get data
            guard let data = data else { return }
            
            // Realization JSON-Decoder
            do {
                let course = try JSONDecoder().decode(Course.self, from: data)
                print(course.name)
                
            } catch let error{
                print("Error serialization JSON", error)
            }
            
        }.resume()
    }
    
}

// MARK: TableViewDataSource

extension CoursesViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        return cell
    }
    
// MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
