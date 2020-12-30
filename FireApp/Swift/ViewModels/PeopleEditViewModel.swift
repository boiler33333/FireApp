//
//  PeopleEditViewModel.swift
//  FireApp
//
//  Created by boiler on 2020/12/27.
//

import UIKit

class PeopleEditViewModel {
    
    private var peopleRepository: PeopleRepositoryProtocol
    
    private var person: Person?
    
    private var photosRepository: PhotosRepositoryProtocol
    
    init(peopleRepository: PeopleRepositoryProtocol?,
         photosRepository: PhotosRepositoryProtocol?) throws {
        
        guard let peopleRepository = peopleRepository else {
            throw NSError.init(domain: "peopleRepository is nil.", code: -1, userInfo: nil)
        }
        
        guard let photosRepository = photosRepository else {
            throw NSError.init(domain: "photosRepository is nil.", code: -1, userInfo: nil)
        }
        
        self.peopleRepository = peopleRepository
        self.photosRepository = photosRepository
    }
    
    func getPersonWithId(_ id: String, completion: @escaping (Person?, UIImage?) -> Void) {
        peopleRepository.getPersonById(id: id) { (person) in
            self.person = person

            if let person = person,
               let path = person.path {
                self.photosRepository.downloadJpgImage(path: path) { (data, error) in
                    if let data = data,
                       let image = UIImage(data: data) {
                        completion(person, image)
                    }
                    else {
                        completion(person, nil)
                    }
                }
            }
            else {
                completion(person, nil)
            }
        }
    }
    
    func update(name: String?, mail: String?, age: String?, image: UIImage?) throws {
        let _id = person!.id
        let _name = name ?? person!.name
        let _mail = mail ?? person!.mail
        let _age = Int(age ?? "") ?? person!.age
        var _path: String? = nil
        
        if let image = image,
           let data = image.jpegData(compressionQuality: 1) {
            if let path = person!.path {
                photosRepository.deleteJpgImage(path: path)
            }
            _path = photosRepository.uploadJpgImage(data: data)
        }
        
        let _person = try Person(id: _id, name: _name, mail: _mail, age: _age, path: _path)
        peopleRepository.update(person: _person)
    }
}
