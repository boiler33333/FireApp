//
//  PhotosViewModel.swift
//  FireApp
//
//  Created by boiler on 2020/12/29.
//

import UIKit
import Photos

let SELECTED_IMAGE: Notification.Name = Notification.Name.init(rawValue: "selected_image")

struct Photo {
    var album: PHAssetCollectionSubtype
    var index: Int
    var image: UIImage
    var rect: CGRect
    var scale: CGFloat
    var size: CGSize
}

class PhotosViewModel {
    
    private var assetsList = [PHAssetCollectionSubtype:PHFetchResult<PHAsset>?]()
    
    private let imageManager: PHImageManager = PHImageManager()
    
    private var selectedAlbum = PHAssetCollectionSubtype.smartAlbumUserLibrary
    
    private var selectedPhotos = [Photo]()
    
    init() {}
    
    func getSelectedCount() -> Int {
        return selectedPhotos.count
    }
    
    func findPhotoByIndex(_ index: Int) -> Photo? {
        return selectedPhotos.first(where: { $0.album == selectedAlbum && $0.index == index })
    }
    
    func removePhotoByIndex(_ index: Int) {
        if let i = selectedPhotos.firstIndex(where: { $0.album == selectedAlbum && $0.index == index }) {
            selectedPhotos.remove(at: i)
        }
    }
    
    func addPhoto(at i: Int, image: UIImage, rect: CGRect, scale: CGFloat, size: CGSize) {
        selectedPhotos.append(Photo(album: selectedAlbum, index: i, image: image, rect: rect, scale: scale, size: size))
    }
    
    func updatePhoto(at i: Int, rect: CGRect, scale: CGFloat, size: CGSize) {
        if let i = selectedPhotos.firstIndex(where: { $0.album == selectedAlbum && $0.index == i }) {
            selectedPhotos[i].rect = rect
            selectedPhotos[i].scale = scale
            selectedPhotos[i].size = size
        }
    }
    
    func getLastPhoto() -> Photo? {
        let xs = selectedPhotos.filter { $0.album == selectedAlbum }
        return xs.last
    }
    
    func postSelectedImages() {
        var xs: [UIImage] = []
        for p in selectedPhotos {
            // scrollView.contentSize の大きさの画像の CGRect(x, y, w, h) を計算
            var a: CGFloat = 0.0
            var x: CGFloat = 0.0
            var y: CGFloat = 0.0
            var w = p.image.size.width
            var h = p.image.size.height
            if w > h {
                a = w / p.size.width
                y = (w - h) * 0.5
            } else {
                a = h / p.size.height
                x = (h - w) * 0.5
            }
            x = x / a
            y = y / a
            w = w / a
            h = h / a
            x = p.rect.origin.x - x
            y = p.rect.origin.y - y
            let rect = CGRect(x: x, y: y, width: p.rect.size.width, height: p.rect.size.height)
            if let cropped = p.image.cropping(to: rect, imageViewSize: p.size) {
                xs.append(cropped)
            }
        }
        
        for x in xs {
            NotificationCenter.default.post(
                name: SELECTED_IMAGE,
                object: nil,
                userInfo: ["thumbnail": x])
        }
    }
    
    func change(subType: PHAssetCollectionSubtype, completion: (String?) -> Void) {
        selectedAlbum = subType
        let type = PHAssetCollectionType.smartAlbum
        let collections = PHAssetCollection.fetchAssetCollections(with: type, subtype: subType, options: nil)
        let collection = collections.object(at: 0)
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        assetsList[selectedAlbum] = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        completion(collection.localizedTitle)
    }
    
    func getImageCount() -> Int {
        guard let assets = assetsList[selectedAlbum] as? PHFetchResult<PHAsset> else { return 0 }
        
        return assets.count
    }
    
    func getImage(at i: Int, size: CGSize, completion: @escaping (UIImage) -> Void) {
        
        guard let assets = assetsList[selectedAlbum] as? PHFetchResult<PHAsset> else { return }
        
        var send = false
        
        imageManager.requestImage(for: assets.object(at: i),
                                  targetSize: size,
                                  contentMode: PHImageContentMode.aspectFill,
                                  options: nil) { (image, info) in
            // 複数回呼ばれることがあるため、１回呼ばれるようにする
            if !send {
                if let image = image {
                    completion(image)
                    send = true
                }
            }
        }
    }
    
    func isSelected(at i: Int) -> Bool {
        return findPhotoByIndex(i) != nil
    }
}
