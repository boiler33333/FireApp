//
//  PhotosStorageRepository.swift
//  FireApp
//
//  Created by boiler on 2020/12/28.
//

import Foundation
import Firebase

class PhotosStrageRepository: PhotosRepositoryProtocol {
    
    init() {
    }
    
    func deleteJpgImage(path: String) {
        Storage.storage().reference(withPath: path).delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func downloadJpgImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let MAX_SIZE: Int64 = 1024 * 1024
        Storage.storage().reference(withPath: path).getData(maxSize: MAX_SIZE) { (data, error) in
            completion(data, error)
        }
    }
    
    func uploadJpgImage(data: Data) -> String {
        let path = UUID().uuidString + ".jpg"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        Storage.storage().reference(withPath: path).putData(data, metadata: metaData)
        return path
    }
}
