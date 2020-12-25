//
//  PeopleViewModel.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import Foundation

class PeopleViewModel {
    
    private let peopleRepository: PeopleRepositoryProtocol
    
    private var people: [Person]
    
    init(people: [Person] = [], peopleRepository: PeopleRepositoryProtocol) {
        self.peopleRepository = peopleRepository
        self.people = people
    }
    
    func count() -> Int {
        return people.count
    }
    
    func downloadAllPeople(completion: @escaping () -> Void) {
        peopleRepository.all { (people) in
            if let people = people {
                self.people = people
                completion()
            }
        }
    }

    func findPersonByIndex(_ i: Int) -> Person {
        return self.people[i]
    }
    
    func search(name: String, completion: @escaping () -> Void) {
        peopleRepository.search(name: name) { (people) in
            if let people = people {
                self.people = people
                completion()
            }
        }
    }
}
