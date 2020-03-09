//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Lucky on 09/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        // Network request with Alamofire
        AF.request(url, method: .get).responseJSON { (response) in
            print(response)
            
        }
    }
}
