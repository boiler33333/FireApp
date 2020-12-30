//
//  DocumentSnapshot+Extension.swift
//  FireApp
//
//  Created by boiler on 2020/12/30.
//

import Foundation
import Firebase

extension DocumentSnapshot {
    
    func toPerson() -> Person {
        let id = self.documentID
        let name = self.get("name") as! String
        let mail = self.get("mail") as! String
        let age = self.get("age") as! Int
        let path = self.get("path") as? String
        return try! Person.init(id: id, name: name, mail: mail, age: age, path: path)
    }
}
