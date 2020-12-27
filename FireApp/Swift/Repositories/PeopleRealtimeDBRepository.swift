//
//  PeopleRepository.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import Foundation
import Firebase

class PeopleRealtimeDBRepository: PeopleRepositoryProtocol {
    
    private let ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference().child("people")
    }
    
    func all(completion: @escaping ([Person]?) -> Void) {
        
        var people: [Person] = []
        
        ref.observe(DataEventType.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                
                /* snapshot が更新前＋更新後の場合は、更新前を削除する */
                if people.first(where: { $0.id == key }) != nil {
                    people.removeAll()
                }
                
                if let dict = value as? NSDictionary {
                    let person = dict.toPerson(id: key)
                    people.append(person)
                }
            }
            completion(people)
        }
    }
    
    func create(person: Person) {
        
        let data = [
            "name": person.name,
            "mail": person.mail,
            "age": person.age,
        ] as [String: Any]
        
        let newRef = ref.childByAutoId()
        newRef.setValue(data)
    }
    
    func delete(id: String) {
        ref.child(id).removeValue()
    }
    
    func search(name: String, completion: @escaping ([Person]?) -> Void) {
        
        var people: [Person] = []
        
        let fRef = ref.queryOrdered(byChild: "name").queryEqual(toValue: name)
        
        fRef.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                
                if let dict = value as? NSDictionary {
                    let person = dict.toPerson(id: key)
                    people.append(person)
                }
            }
            completion(people)
        }
    }
    
    func update(person: Person) {
        let data = [
            "name": person.name,
            "mail": person.mail,
            "age": person.age,
        ] as [String: Any]
        
        let newRef = ref.child(person.id)
        newRef.setValue(data)
    }
}
