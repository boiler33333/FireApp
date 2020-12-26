//
//  BaseViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import UIKit
import Firebase

class BaseViewController: UIViewController {

    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        currentUser = Auth.auth().currentUser
        
        if currentUser == nil {
            let sb = UIStoryboard.init(name: "Login", bundle: nil)
            let vc = sb.instantiateInitialViewController()!
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
    }
    
    func showErrorDialog(title: String) {
        let dialog = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        dialog.addAction(ok)
        present(dialog, animated: true, completion: nil)
    }
}
