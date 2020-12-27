//
//  PeopleNewViewModel.swift
//  FireApp
//
//  Created by boiler on 2020/12/26.
//

import Foundation

class PeopleNewViewModel {
    
    private var peopleRepository: PeopleRepositoryProtocol!
    
    private let maxMailLength = 50
    
    private let maxNameLength = 10
    
    init(peopleRepository: PeopleRepositoryProtocol?) throws {
        guard let peopleRepository = peopleRepository else {
            throw NSError.init(domain: "peopleRepository is nil.", code: -1, userInfo: nil)
        }
        self.peopleRepository = peopleRepository
    }

    func create(name: String?, mail: String?, age: String?) throws {
        let _name = name ?? ""
        let _mail = mail ?? ""
        let _age = Int(age ?? "0") ?? 0
        let _person = try Person(name: _name, mail: _mail, age: _age)
        peopleRepository.create(person: _person)
    }
}
