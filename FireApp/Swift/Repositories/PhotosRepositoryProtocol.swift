//
//  PhotosRepositoryProtocol.swift
//  FireApp
//
//  Created by boiler on 2020/12/28.
//

import Foundation

protocol PhotosRepositoryProtocol {
    
    func deleteJpgImage(path: String)
    
    func downloadJpgImage(path: String, completion: @escaping (Data?, Error?) -> Void)
    
    func uploadJpgImage(data: Data) -> String
}
