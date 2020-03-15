//
//  ImageProperties.swift
//  Networking
//
//  Created by Lucky on 08/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit

struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
