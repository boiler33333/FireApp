//
//  PeopleNewViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import UIKit
import Photos

class PeopleNewViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mainTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    var peopleRepository: PeopleRepositoryProtocol? = nil
    
    var photosRepository: PhotosRepositoryProtocol? = nil
    
    private var peopleNewViewModel: PeopleNewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        do {
            peopleNewViewModel = try PeopleNewViewModel(peopleRepository: peopleRepository,
                                                        photosRepository: photosRepository)
        }
        catch {
            super.showErrorDialog(title: error.localizedDescription) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func toPhotos(_ sender: Any) {
        super.checkPhotoLibraryAuthorization() {
            self.setNotification()
            self.showPhotos()
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(uploadImageListener),
            name: SELECTED_IMAGE,
            object: nil);
    }
    
    @objc func uploadImageListener(notificaton: Notification) {
        if let userInfo = notificaton.userInfo,
           let image = userInfo["thumbnail"] as? UIImage {
            imageView.image = image
        }
    }
    
    private func showPhotos() {
        let sb = UIStoryboard(name: "Photos", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func doCreate(_ sender: Any) {
        let name = nameTextField.text
        let mail = mainTextField.text
        let age = ageTextField.text
        let image = imageView.image
        
        do {
            try peopleNewViewModel.create(name: name, mail: mail, age: age, image: image)
            self.navigationController?.popViewController(animated: true)
        }
        catch {
            super.showErrorDialog(title: error.localizedDescription)
        }
    }
}
