//
//  Task.swift
//  RealmDemo
//
//  Created by qwer on 2018/3/13.
//Copyright © 2018年 qwer. All rights reserved.
//

import Foundation
import RealmSwift.Swift

class Task: Object {
    
    //所有的属性前面都加了 dynamic var 前缀，这使得属性可以被数据库读写。
    @objc dynamic var name = ""
    @objc dynamic var createdAt = NSDate()
    @objc dynamic var notes = ""
    @objc dynamic var isCompleted = false
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}

class TaskList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var createdAt = NSDate()
    @objc dynamic var isCompleted = false
    let tasks = List<Task>()
    
    //tasks.filter("isCompleted = true") filter函数根据相应的字段查询对应的对象数组；
//    tasks.filter("isCompleted = 'true' AND name BEGINSWITH 'M'")
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
//    声明让 Realm 忽略的属性（Realm 将不持有这些属性）
//    override class func ignoredProperties() -> [String] {
//
//        return ["address"]
//
//    }
    
    
}
