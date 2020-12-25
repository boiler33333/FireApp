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
    
    private let peopleViewModel = PeopleViewModel(peopleRepository: PeopleRealtimeDBRepository())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "People"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if currentUser != nil {
            peopleViewModel.downloadAllPeople {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func toPeopleNew(_ sender: Any) {
        let sb = UIStoryboard.init(name: "PeopleNew", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
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
    
}
