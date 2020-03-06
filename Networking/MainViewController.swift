//
//  MainViewController.swift
//  Networking
//
//  Created by Lucky on 06/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    @IBAction func getRequest(_ sender: UIButton) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
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
    
    @IBAction func postRequest(_ sender: UIButton) {
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
