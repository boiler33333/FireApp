//
//  PeopleNewViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import UIKit

class PeopleNewViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mainTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    // TODO: PeopleNewViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func doCreate(_ sender: Any) {
        // TODO: create Person
    }
}
