//
//  Course.swift
//  Networking
//
//  Created by Lucky on 07/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import Foundation

struct Course: Decodable {
    
    let id: Int
    let name: String
    let link: String
    let imageUrl: String
    let number_of_lessons: Int
    let number_of_test: Int
}
