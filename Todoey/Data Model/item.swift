//
//  item.swift
//  Todoey
//
//  Created by Yesukan Kozok on 2.08.2018.
//  Copyright © 2018 yesukan. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title : String = ""
    var done : Bool = false
}
