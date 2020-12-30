//
//  PeopleViewModel.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import UIKit

class PeopleViewModel {
    
    private var people: [Person]
    
    private let peopleRepository: PeopleRepositoryProtocol
    
    private let photosRepository: PhotosRepositoryProtocol
    
    init(people: [Person] = [],
         peopleRepository: PeopleRepositoryProtocol,
         photosRepository: PhotosRepositoryProtocol) {
        
        self.people = people
        self.peopleRepository = peopleRepository
        self.photosRepository = photosRepository
    }
    
    func count() -> Int {
        return people.count
    }
    
    func delete(row i: Int) {
        peopleRepository.delete(id: people[i].id)
    }
    
    func downloadAllPeople(completion: @escaping () -> Void) {
        peopleRepository.all { (people) in
            if let people = people {
                self.people = people
            }
            completion()
        }
    }
    
    func downloadPersonImage(path: String, completion: @escaping (UIImage) -> Void) {
        photosRepository.downloadJpgImage(path: path) { (data, error) in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
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
