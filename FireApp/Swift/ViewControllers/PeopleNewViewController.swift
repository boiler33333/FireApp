//
//  PeopleNewViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import UIKit

class PeopleNewViewController: BaseViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mainTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    var peopleRepository: PeopleRepositoryProtocol? = nil
    
    private var peopleNewViewModel: PeopleNewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        do {
            peopleNewViewModel = try PeopleNewViewModel(peopleRepository: peopleRepository)
        }
        catch {
            super.showErrorDialog(title: error.localizedDescription) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func doCreate(_ sender: Any) {
        let name = nameTextField.text
        let mail = mainTextField.text
        let age = ageTextField.text
        
        do {
            try peopleNewViewModel.create(name: name, mail: mail, age: age)
            self.navigationController?.popViewController(animated: true)
        }
        catch {
            super.showErrorDialog(title: error.localizedDescription)
        }
    }
}
