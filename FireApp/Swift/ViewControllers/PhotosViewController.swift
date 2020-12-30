//
//  PhotosViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/29.
//

import UIKit
import Photos

class PhotosViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var trimImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedItem = 0;
    
    var max = 1;
    
    private var photosRepository = PhotosStrageRepository()
    
    private var photosViewModel: PhotosViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosViewModel = PhotosViewModel()
        
        navigationItem.rightBarButtonItem
            = UIBarButtonItem.init(barButtonSystemItem: .done,
                                   target: self,
                                   action: #selector(done))
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 1
            flowLayout.minimumLineSpacing = 2
        }
        
        imageView.backgroundColor = .white
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewDoubleTapped(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        
        scrollView.addGestureRecognizer(doubleTapGesture)
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        
        setup()
    }
    
    @objc func done() {
        photosViewModel.postSelectedImages()
        navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        self.change(subType: .smartAlbumUserLibrary, reload: false)
    }
    
    func change(subType: PHAssetCollectionSubtype, reload: Bool) {
        
        photosViewModel.change(subType: subType) { (title) in
            self.navigationItem.title = title
        }
        
        if let photo = photosViewModel.getLastPhoto() {
            imageView.image = photo.image
            scrollView.setZoomScale(photo.scale, animated: false)
            scrollView.setContentOffset(photo.rect.origin, animated: false)
            selectedItem = photo.index
        }
        else {
            selectedItem = 0
            let l = UIScreen.main.bounds.size.width
            let size = CGSize(width: l, height: l)
            photosViewModel.getImage(at: 0, size: size) { (image) in
                self.imageView.image = image
            }
        }
        
        if reload {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    @objc func scrollViewDoubleTapped(_ sender: UITapGestureRecognizer) {
        
        scrollView.setZoomScale(1, animated: true)
        
        let i = selectedItem
        
        if photosViewModel.isSelected(at: i) {
            let l = UIScreen.main.bounds.size.width
            let size = CGSize(width: l, height: l)
            photosViewModel.getImage(at: i, size: size) { (image) in
                self.imageView.image = image
                self.photosViewModel.updatePhoto(at: i,
                                                 rect: self.trimImageView.frame,
                                                 scale: 1.0,
                                                 size: self.trimImageView.frame.size)
            }
        }
    }
}



extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return photosViewModel.getImageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        let i = indexPath.item
        let cellImageView = cell.viewWithTag(1) as! UIImageView
        let checkImageView = cell.viewWithTag(2) as! UIImageView
        
        cellImageView.image = nil
        
        let l = UIScreen.main.bounds.size.width
        photosViewModel.getImage(at: i, size: CGSize(width: l, height: l)) { (image) in
            cellImageView.image = image
        }
        
        if photosViewModel.isSelected(at: i) {
            checkImageView.image = UIImage(named: "check_on")
        } else {
            checkImageView.image = UIImage(named: "check_off")
        }
        
        return cell
    }
}



extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if let cell = collectionView.cellForItem(at: indexPath) {
            let checkImageView = cell.viewWithTag(2) as! UIImageView
            let i = indexPath.item
            if let photo = photosViewModel.findPhotoByIndex(i) {
                if i == selectedItem {
                    checkImageView.image = UIImage(named: "check_off")
                    photosViewModel.removePhotoByIndex(i)
                }
                else {
                    checkImageView.image = UIImage(named: "check_on")
                    self.imageView.image = photo.image
                    self.scrollView.setZoomScale(photo.scale, animated: false)
                    DispatchQueue.main.async {
                        self.scrollView.setContentOffset(photo.rect.origin, animated: false)
                    }
                }
            }
            else {
                let l = UIScreen.main.bounds.size.width
                let size = CGSize(width: l, height: l)
                photosViewModel.getImage(at: i, size: size) { (image) in
                    self.imageView.image = image
                    if self.photosViewModel.getSelectedCount() < self.max {
                        checkImageView.image = UIImage(named: "check_on")
                        self.scrollView.setZoomScale(1.0, animated: false)
                        self.scrollView.setContentOffset(.zero, animated: false)
                        self.photosViewModel.addPhoto(at: i,
                                                      image: image,
                                                      rect: self.trimImageView.frame,
                                                      scale: 1.0,
                                                      size: self.trimImageView.frame.size)
                    }
                }
            }
            selectedItem = i
        }
    }
}



extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let l = floor((UIScreen.main.bounds.size.width - 2) / 3)
        return CGSize(width: l, height: l)
    }
}



extension PhotosViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        guard scrollView == self.scrollView else { return }
        
        let i = selectedItem
        
        if photosViewModel.isSelected(at: i) {
            photosViewModel.updatePhoto(at: i, rect: scrollView.bounds, scale: scrollView.zoomScale ,size: scrollView.contentSize)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard scrollView == self.scrollView else { return }
        
        let i = selectedItem
        
        if photosViewModel.isSelected(at: i) {
            photosViewModel.updatePhoto(at: i, rect: scrollView.bounds, scale: scrollView.zoomScale, size: scrollView.contentSize)
        }
    }
}
