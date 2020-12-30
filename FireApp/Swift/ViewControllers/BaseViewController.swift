//
//  BaseViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import UIKit
import Photos
import Firebase

class BaseViewController: UIViewController {

    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentUser = Auth.auth().currentUser
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        if currentUser == nil {
            let sb = UIStoryboard.init(name: "Login", bundle: nil)
            let vc = sb.instantiateInitialViewController()!
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
    }
    
    func showErrorDialog(title: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let dialog = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: handler)
        dialog.addAction(ok)
        present(dialog, animated: true, completion: nil)
    }
    
    func checkPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            completion()
        }
        else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
                else if status == .denied {
                    // TODO
                }
            }
        }
    }
}
