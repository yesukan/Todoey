//
//  Item.swift
//  Todoey
//
//  Created by Yesukan Kozok on 5.08.2018.
//  Copyright © 2018 yesukan. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    //connection of classes to do the relation
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
