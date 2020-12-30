//
//  PeopleCloudFirestoreRepository.swift
//  FireApp
//
//  Created by boiler on 2020/12/28.
//

import Foundation
import Firebase

class PeopleCloudFirestoreRepository: PeopleRepositoryProtocol {
    
    private var db: Firestore!
    
    private var ref: CollectionReference!
    
    init() {
        db = Firestore.firestore()
        ref = db.collection("people")
    }
    
    func all(completion: @escaping ([Person]?) -> Void) {
        ref.getDocuments { (querySnapshot, error) in
            var people: [Person]? = nil
            if let querySnapshot = querySnapshot {
                people = []
                for document in querySnapshot.documents {
                    let person = document.toPerson()
                    people!.append(person)
                }
            }
            completion(people)
        }
    }
    
    func getPersonById(id: String, completion: @escaping (Person?) -> Void) {
        ref.document(id).getDocument { (document, error) in
            if let document = document {
                let person = document.toPerson()
                completion(person)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func create(person: Person) {
        var data: [String:Any] = [:]
        data["name"] = person.name
        data["mail"] = person.mail
        data["age"] = person.age
        if let path = person.path {
            data["path"] = path
        }
        ref.addDocument(data: data)
    }
    
    func delete(id: String) {
        ref.document(id).delete()
    }
    
    func search(name: String, completion: @escaping ([Person]?) -> Void) {
        ref.whereField("name", isEqualTo: name).getDocuments { (querySnapshot, error) in
            var people: [Person]? = nil
            if let querySnapshot = querySnapshot {
                people = []
                for document in querySnapshot.documents {
                    let person = document.toPerson()
                    people!.append(person)
                }
            }
            completion(people)
        }
    }
    
    func update(person: Person) {
        var data: [String:Any] = [:]
        data["name"] = person.name
        data["mail"] = person.mail
        data["age"] = person.age
        if let path = person.path {
            data["path"] = path
        }
        ref.document(person.id).setData(data)
    }
}
