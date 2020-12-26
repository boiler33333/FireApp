//
//  PeopleNewViewModel.swift
//  FireApp
//
//  Created by boiler on 2020/12/26.
//

import Foundation

class PeopleNewViewModel {
    
    private let peopleRepository: PeopleRepositoryProtocol
    
    private let maxMailLength = 50
    
    private let maxNameLength = 10
    
    init(peopleRepository: PeopleRepositoryProtocol) {
        
        self.peopleRepository = peopleRepository
    }
    
    

    private func validate(mail: String) throws {
        
        if mail.count <= 0 {
            throw NSError(domain: "This field is required.",
                          code: ErrorCode.invalidMail.rawValue,
                          userInfo: nil)
        }
        
        if maxMailLength < mail.count {
            throw NSError(domain: "Maximum \(maxNameLength) characters allowed.",
                          code: ErrorCode.invalidMail.rawValue,
                          userInfo: nil)
        }
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let ok = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: mail)
            
        if !ok {
            throw NSError.init(domain: "Invalid email address.",
                               code: ErrorCode.invalidMail.rawValue,
                               userInfo: nil)
        }
    }
    
    
    
    private func validate(name: String) throws {
        
        if name.count <= 0 {
            throw NSError(domain: "This field is required.",
                          code: ErrorCode.invalidName.rawValue,
                          userInfo: nil)
        }
        
        if maxNameLength < name.count {
            throw NSError(domain: "Maximum \(maxNameLength) characters allowed.",
                          code: ErrorCode.invalidName.rawValue,
                          userInfo: nil)
        }
    }
    
    
    
    private func validate(age: Int) throws {
        if age < 0 || 200 < age {
            throw NSError.init(domain: "Invalid age.",
                               code: ErrorCode.invalidAge.rawValue,
                               userInfo: nil)
        }
    }
    
    

    func create(name: String, mail: String, age: Int, completion: () -> Void) throws {
        
        try validate(name: name)
        
        try validate(mail: mail)
        
        try validate(age: age)
        
        peopleRepository.create(name: name, mail: mail, age: age, completion: completion)
    }
}
