//
//  SeeAllViewController.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 08/10/24.
//

import UIKit

class SeeAllViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var category: MovieCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category?.title ?? "Movies"
        
        self.view.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.black
        
        self.navigationController?.navigationBar.tintColor = UIColor.red
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SeeAllTableViewCell", bundle: nil), forCellReuseIdentifier: "SeeAllTableViewCell")
    }
}

extension SeeAllViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.movies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllTableViewCell", for: indexPath) as! SeeAllTableViewCell
        if let movie = category?.movies[indexPath.row] {
            cell.configure(with: movie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMovie = category?.movies[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
                movieDetailVC.movie = selectedMovie
                self.navigationController?.pushViewController(movieDetailVC, animated: true)
            }
        }
    }
}
