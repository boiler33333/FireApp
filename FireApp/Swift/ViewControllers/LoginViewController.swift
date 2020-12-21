//
//  LoginViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/19.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var changed: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changed = Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(changed)
    }
    
    @IBAction func doLogin(_ sender: Any) {
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showErrorDialog(title: error.localizedDescription)
                }
            }
        }
    }
    
    private func showErrorDialog(title: String) {
        let dialog = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        dialog.addAction(ok)
        present(dialog, animated: true, completion: nil)
    }
}

