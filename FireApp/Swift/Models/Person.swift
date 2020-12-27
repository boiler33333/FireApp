//
//  Person.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import Foundation

class Person {
    
    var id: String { return _id }
    
    var name: String { return _name }
    
    var mail: String { return _mail }
    
    var age: Int { return _age }
    
    private var _id: String
    
    private var _name: String
    
    private var _mail: String
    
    private var _age: Int
    
    private static  let maxNameLength = 10
    
    private static  let maxMailLength = 100
    
    private static  let maxAge = 200
    
    init(id: String = "", name: String, mail: String, age: Int) throws {
        try Person.validate(name: name)
        try Person.validate(mail: mail)
        try Person.validate(age: age)
        _id = id
        _name = name
        _mail = mail
        _age = age
    }
    
    private static func validate(name: String) throws {
        
        if name.count <= 0 {
            throw NSError(domain: "This field is required.", code: ErrorCode.invalidName.rawValue, userInfo: nil)
        }
        
        if maxNameLength < name.count {
            throw NSError(domain: "Maximum \(maxNameLength) characters allowed.", code: ErrorCode.invalidName.rawValue, userInfo: nil)
        }
    }
    
    private static func validate(mail: String) throws {
        
        if mail.count <= 0 {
            throw NSError(domain: "This field is required.", code: ErrorCode.invalidMail.rawValue, userInfo: nil)
        }
        
        if maxMailLength < mail.count {
            throw NSError(domain: "Maximum \(maxNameLength) characters allowed.", code: ErrorCode.invalidMail.rawValue, userInfo: nil)
        }
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let ok = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: mail)
            
        if !ok {
            throw NSError.init(domain: "Invalid email address.", code: ErrorCode.invalidMail.rawValue, userInfo: nil)
        }
    }
    
    private static  func validate(age: Int) throws {
        if age < 0 || maxAge < age {
            throw NSError.init(domain: "Invalid age.", code: ErrorCode.invalidAge.rawValue, userInfo: nil)
        }
    }
}
