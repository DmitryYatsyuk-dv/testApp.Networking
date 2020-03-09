//
//  MainCollectionViewController.swift
//  Networking
//
//  Created by Lucky on 08/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit
import UserNotifications

enum Actions: String, CaseIterable {
    
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
    case alamofireCourses = "Our Courses (Alamofire)"
    case responseData = "responseData"
    case responseString = "responseString"
    case response = "response"
    case downloadLargeImage = "Download Large Image"
}

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"
private let uploadImage = "https://api.imgur.com/3/image"
private let swiftbookApi = "https://swiftbook.ru//wp-content/uploads/api/api_courses"



class MainCollectionVC: UICollectionViewController {
    
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    private var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()
        
        dataProvider.fileLocation = { (location) in
            
            // Save the file for future use
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false)
            self.postNotification()
        }
    }
    
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dataProvider.stopDownload()
        }
        
        // Constraint for height AlertController
        let height = NSLayoutConstraint(item: alert.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        alert.view.addConstraint(height)
        
        
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            
            // Add: ActivityIndicator
            let sizeAI = CGSize(width: 40, height: 40)
            let pointCenterAC = CGPoint(x: self.alert.view.frame.width / 2 - sizeAI.width / 2,
                                        y: self.alert.view.frame.height / 2 - sizeAI.height / 2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: pointCenterAC, size: sizeAI))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            // Add: ProgressView
            let progressView = UIProgressView(frame: CGRect(x: 0,
                                                            y: self.alert.view.frame.height - 44,
                                                            width: self.alert.view.frame.width,
                                                            height: 2))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress = { (progress) in
                
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
                
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.label.text = actions[indexPath.row].rawValue
        
        
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "showImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .ourCourses:
            performSegue(withIdentifier: "ourCourses", sender: self)
        case .uploadImage:
            NetworkManager.uploadImage(url: uploadImage)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .alamofireCourses:
            performSegue(withIdentifier: "OurCoursesWithAlamofire", sender: self)
        case .responseData:
            performSegue(withIdentifier: "responseData", sender: self)
            AlamofireNetworkRequest.responseData(url: swiftbookApi)
        case .responseString:
            AlamofireNetworkRequest.responseString(url: swiftbookApi)
        case .response:
            AlamofireNetworkRequest.response(url: swiftbookApi)
        case .downloadLargeImage:
            performSegue(withIdentifier: "LargeImage", sender: self)
            
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let coursesVC = segue.destination as? CoursesViewController
        let imageVC = segue.destination as? ViewController
        
        switch segue.identifier {
        case "ourCourses":
            coursesVC?.fetchData()
        case "OurCoursesWithAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "showImage":
            imageVC?.fetchImage()
        case "responseData":
            imageVC?.fetchDataWithAlamofire()
        case "LargeImage" :
            imageVC?.downloadImageWithProgress()
        default:
            break
        }
    }
}

extension MainCollectionVC {
    
    // Сreate a request for the user to send notifications
    
    private func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download Complete!"
        content.body = "Your background transfer has completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
