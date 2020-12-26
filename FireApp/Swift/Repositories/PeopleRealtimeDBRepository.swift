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
                
                if let dict = value as? NSDictionary {
                    let person = dict.toPerson(id: key)
                    people.append(person)
                }
            }
            completion(people)
        }
    }
    
    func create(name: String, mail: String, age: Int, completion: () -> Void) {
        
        let data = [
            "name": name,
            "mail": mail,
            "age": age,
        ] as [String: Any]
        
        let newRef = ref.childByAutoId()
        newRef.setValue(data)
        
        completion()
    }
    
    func delete(id: Int) {
        ref.child("\(id)").removeValue()
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
}
