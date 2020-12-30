//
//  PeopleNewViewModel.swift
//  FireApp
//
//  Created by boiler on 2020/12/26.
//

import UIKit

class PeopleNewViewModel {
    
    private var peopleRepository: PeopleRepositoryProtocol!
    
    private var photosRepository: PhotosRepositoryProtocol!
    
    private let maxMailLength = 50
    
    private let maxNameLength = 10
    
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

    func create(name: String?, mail: String?, age: String?, image: UIImage?) throws {
        if let image = image,
           let data = image.jpegData(compressionQuality: 1) {
            let path = photosRepository.uploadJpgImage(data: data)
            try create(name: name, mail: mail, age: age, path: path)
        }
        else {
            try create(name: name, mail: mail, age: age)
        }
    }
    
    private func create(name: String?, mail: String?, age: String?, path: String? = nil) throws {
        let _name = name ?? ""
        let _mail = mail ?? ""
        let _age = Int(age ?? "0") ?? 0
        let _path = path
        let _person = try Person(name: _name, mail: _mail, age: _age, path: _path)
        peopleRepository.create(person: _person)
    }
}
