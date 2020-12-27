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

    var person: Person? = nil
    
    var peopleRepository: PeopleRepositoryProtocol? = nil
    
    private var peopleEditViewModel: PeopleEditViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        do {
            peopleEditViewModel = try PeopleEditViewModel(person: person, peopleRepository: peopleRepository)
        } catch {
            super.showErrorDialog(title: error.localizedDescription) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = person!.name
        mailTextField.text = person!.mail
        ageTextField.text = "\(person!.age)"
    }
    
    @IBAction func doUpdate(_ sender: Any) {
        let name = nameTextField.text
        let mail = mailTextField.text
        let age = ageTextField.text
        
        do {
            try peopleEditViewModel.update(name: name, mail: mail, age: age)
            self.navigationController?.popViewController(animated: true)
        } catch {
            super.showErrorDialog(title: error.localizedDescription)
        }
    }
}
