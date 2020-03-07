//
//  CoursesViewController.swift
//  Networking
//
//  Created by Lucky on 07/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    func fetchData() {
        
        // We create a session for downloading this at URL-address
        
        let jsonUrl = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
        //        let jsonUrl = "https://swiftbook.ru//wp-content/uploads/api/api_course"
        //        let jsonUrl = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
        //        let jsonUrl = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
        
        // Check validation url-address
        guard let url = URL(string: jsonUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Trying to get data
            guard let data = data else { return }
            
            // Realization JSON-Decoder
            do {
                
                // Converter format snakeCase / camelCase
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                self.courses = try decoder.decode([Course].self, from: data)
                print(self.courses[3].name ?? "Courses/part4/name is not available")
                // print(websiteDescription.websiteName ?? "Website Name : Error")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization JSON", error)
            }
            
        }.resume()
    }
    
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        cell.courseOfName.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
        
        // Check validation url-address
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourse = courseName
        
        if let url = courseURL {
            webViewController.courseURL = url
        }
    }
}

// MARK: TableViewDataSource

extension CoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    // MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    // The method allows you to fix the cell by which tap user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        courseURL = course.link
        courseName = course.name
        
        // Go to VC on identifier
        performSegue(withIdentifier: "Description", sender: self )
    }
}
