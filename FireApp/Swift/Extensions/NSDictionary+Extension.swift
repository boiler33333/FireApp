//
//  NSDictionary+Extension.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import Foundation

extension NSDictionary {
    
    func toPerson(id: Int) -> Person {
        let name = self.value(forKey: "name") as! String
        let mail = self.value(forKey: "mail") as! String
        let age = self.value(forKey: "age") as! Int
        return Person(id: id, name: name, mail: mail, age: age)
    }
}
