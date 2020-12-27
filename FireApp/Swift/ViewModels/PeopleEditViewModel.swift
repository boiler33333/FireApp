//
//  PeopleEditViewModel.swift
//  FireApp
//
//  Created by boiler on 2020/12/27.
//

import Foundation

class PeopleEditViewModel {
    
    private var person: Person
    private var peopleRepository: PeopleRepositoryProtocol
    
    init(person: Person?, peopleRepository: PeopleRepositoryProtocol?) throws {
        guard let person = person else {
            throw NSError.init(domain: "Person is nil.", code: -1, userInfo: nil)
        }
        guard let peopleRepository = peopleRepository else {
            throw NSError.init(domain: "peopleRepository is nil.", code: -1, userInfo: nil)
        }
        self.person = person
        self.peopleRepository = peopleRepository
    }
    
    func update(name: String?, mail: String?, age: String?) throws {
        let _name = name ?? person.name
        let _mail = mail ?? person.mail
        let _age = Int(age ?? "0") ?? person.age
        let _person = try Person(id: person.id, name: _name, mail: _mail, age: _age)
        peopleRepository.update(person: _person)
    }
}
