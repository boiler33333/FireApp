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
            if let values = snapshot.value as? NSArray {
                for (i, value) in values.enumerated() {
                    let person = (value as! NSDictionary).toPerson(id: i)
                    people.append(person)
                }
            }
            completion(people)
        }
    }
    
    func delete(id: Int) {
        ref.child("\(id)").removeValue()
    }
    
    func search(name: String, completion: @escaping ([Person]?) -> Void) {
        
        var people: [Person] = []
        
        let fRef = ref.queryOrdered(byChild: "name").queryEqual(toValue: name)
        
        fRef.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let values = snapshot.value as? NSArray {
                for (i, value) in values.enumerated() {
                    let person = (value as! NSDictionary).toPerson(id: i)
                    people.append(person)
                }
            }
            completion(people)
        }
    }
}
