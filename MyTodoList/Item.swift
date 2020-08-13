//
//  Item.swift
//  MyTodoList
//
//  Created by mac on 2020/8/13.
//  Copyright © 2020 WuHouxuan. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
