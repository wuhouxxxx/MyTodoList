//
//  Category.swift
//  MyTodoList
//
//  Created by mac on 2020/8/13.
//  Copyright © 2020 WuHouxuan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    
    let items = List<Item>()
}
