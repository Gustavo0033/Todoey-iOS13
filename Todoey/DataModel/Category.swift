//
//  Category.swift
//  Todoey
//
//  Created by Gustavo Mendonca on 09/10/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    //the relationship if the Item class
    //like using coreData
    let items = List<Item>()
    
}
