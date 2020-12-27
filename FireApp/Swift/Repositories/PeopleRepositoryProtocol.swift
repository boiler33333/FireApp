//
//  PeopleRepositoryProtocol.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

protocol PeopleRepositoryProtocol {
    
    func all(completion: @escaping ([Person]?) -> Void)
    
    func create(name: String, mail: String, age: Int, completion: () -> Void)
    
    func delete(id: String)
    
    func search(name: String, completion: @escaping ([Person]?) -> Void)
}
