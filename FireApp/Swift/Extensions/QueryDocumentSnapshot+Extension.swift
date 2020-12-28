//
//  QueryDocumentSnapshot+Extension.swift
//  FireApp
//
//  Created by boiler on 2020/12/28.
//

import Foundation
import Firebase

extension QueryDocumentSnapshot {
    
    func toPerson() -> Person {
        let id = self.documentID
        let name = self.get("name") as! String
        let mail = self.get("mail") as! String
        let age = self.get("age") as! Int
        let person = try! Person.init(id: id, name: name, mail: mail, age: age)
        return person
    }
}
