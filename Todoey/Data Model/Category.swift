//
//  Category.swift
//  Todoey
//
//  Created by Yesukan Kozok on 5.08.2018.
//  Copyright © 2018 yesukan. All rights reserved.
//


import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    //connection of classes to do the relation
    let items = List<Item>()
    
    
}
