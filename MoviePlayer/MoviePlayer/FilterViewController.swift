//
//  FilterViewController.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 08/10/24.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectFilter(filter: MovieFilter)
}

class FilterViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FilterViewControllerDelegate?
    
    let filters = MovieFilter.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose a Filter"
        
        self.view.backgroundColor = UIColor.black
        tableView.backgroundColor = UIColor.black
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        let filter = filters[indexPath.row]
        cell.textLabel?.text = filter.rawValue
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilter = filters[indexPath.row]
        delegate?.didSelectFilter(filter: selectedFilter)
        self.navigationController?.popViewController(animated: true)
    }
}
