//
//  Item.swift
//  Todoey
//
//  Created by Gustavo Mendonca on 09/10/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    //the relationship with category class
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
