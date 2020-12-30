//
//  PeopleEditViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/27.
//

import UIKit

class PeopleEditViewController: BaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectImageButton: UIButton!
    
    var id: String = ""
    
    var peopleRepository: PeopleRepositoryProtocol? = nil
    
    var photosRepository: PhotosRepositoryProtocol? = nil
    
    private var peopleEditViewModel: PeopleEditViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        do {
            peopleEditViewModel = try PeopleEditViewModel(peopleRepository: peopleRepository,
                                                          photosRepository: photosRepository)
        } catch {
            super.showErrorDialog(title: error.localizedDescription) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        peopleEditViewModel.getPersonWithId(id) { (person, image) in
            if let person = person {
                self.nameTextField.text = person.name
                self.mailTextField.text = person.mail
                self.ageTextField.text = "\(person.age)"
                if let image = image {
                    self.imageView.image = image
                }
            }
            else {
                super.showErrorDialog(title: "not found.") { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func doUpdate(_ sender: Any) {
        let name = nameTextField.text
        let mail = mailTextField.text
        let age = ageTextField.text
        let image = imageView.image
        
        do {
            try peopleEditViewModel.update(name: name, mail: mail, age: age, image: image)
            self.navigationController?.popViewController(animated: true)
        } catch {
            super.showErrorDialog(title: error.localizedDescription)
        }
    }
    
    
    @IBAction func toPhotos(_ sender: Any) {
        super.checkPhotoLibraryAuthorization {
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
}
