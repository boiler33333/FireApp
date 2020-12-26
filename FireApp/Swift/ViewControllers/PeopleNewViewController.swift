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
    
    private var peopleNewViewModel: PeopleNewViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let peopleRepository = peopleRepository {
            peopleNewViewModel = PeopleNewViewModel(peopleRepository: peopleRepository)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func doCreate(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let mail = mainTextField.text ?? ""
        let age = Int(ageTextField.text ?? "") ?? 0
        
        do {
            try peopleNewViewModel!.create(name: name, mail: mail, age: age) {
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            super.showErrorDialog(title: error.localizedDescription)
        }
    }
}
