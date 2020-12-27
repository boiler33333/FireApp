//
//  PeopleViewController.swift
//  FireApp
//
//  Created by boiler on 2020/12/20.
//

import UIKit

class PeopleViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let peopleRepository = PeopleRealtimeDBRepository()
    
    private var peopleViewModel: PeopleViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "People"
        
        self.peopleViewModel = PeopleViewModel(peopleRepository: peopleRepository)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentUser != nil {
            peopleViewModel.downloadAllPeople {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func toPeopleNew(_ sender: Any) {
        let sb = UIStoryboard.init(name: "PeopleNew", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PeopleNewViewController
        vc.peopleRepository = peopleRepository
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

extension PeopleViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let text = (searchBar.text ?? "").lowercased()
        
        peopleViewModel.search(name: text) {
            self.tableView.reloadData()
            self.searchBar.resignFirstResponder()
        }
    }
}

extension PeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleViewModel.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = peopleViewModel.findPersonByIndex(indexPath.row)
        cell.textLabel?.text = "\(person.name) : \(person.mail) : \(person.age)"
        return cell
    }
}

extension PeopleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            peopleViewModel.delete(row: indexPath.row)
        }
    }
}
