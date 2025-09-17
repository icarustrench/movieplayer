//
//  ViewController.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 04/10/24.
//

import UIKit
import SkeletonView

protocol NavigateToMovieDetailDelegate: AnyObject {
    func navigate(movie: Movie)
}

class ViewController: UIViewController, UITableViewDelegate, FilterViewControllerDelegate {
    
    var categories: [MovieCategory] = []
    var filteredMovies: [Movie] = []
    var isFiltering: Bool = false
    
    @IBOutlet weak var searchController: UISearchBar!
    func didSelectFilter(filter: MovieFilter) {
        if filter.rawValue == "All" {
                isFiltering = false
                self.title = "Movies"
        } else {
            filteredMovies = categories.flatMap { $0.movies }.filter { $0.filterTags.contains(filter.rawValue.lowercased()) }
            isFiltering = true
            self.title = filter.rawValue
        }
        
        movieTableView.reloadData()
    }
    
    @IBOutlet weak var movieTableView: UITableView!
    
    @IBAction func filterTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let filterVC = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController {
            filterVC.delegate = self
            self.navigationController?.pushViewController(filterVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.isSkeletonable = true
        movieTableView.showAnimatedGradientSkeleton()
    
        self.title = "Movies"
        self.view.backgroundColor = UIColor.black
        self.movieTableView.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.red
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        searchController.delegate = self
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        movieTableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nibBundle), forCellReuseIdentifier: "moviesTableViewCell")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NetworkManager.shared.fetchMovies { [weak self] categories in
                self?.categories = categories ?? []
                self?.movieTableView.stopSkeletonAnimation()
                self?.movieTableView.hideSkeleton()
                self?.movieTableView.reloadData()
            }
        }
    }
    
    private func navigateToSeeAllMovies(category: MovieCategory) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let seeAllVC = storyboard.instantiateViewController(withIdentifier: "SeeAllViewController") as? SeeAllViewController {
            seeAllVC.category = category  
            self.navigationController?.pushViewController(seeAllVC, animated: true)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            isFiltering = false
            filteredMovies.removeAll()
            movieTableView.reloadData()
            return
        }
        
        isFiltering = true
        filteredMovies = categories.flatMap { $0.movies }.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        movieTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        searchBar.text = ""
        filteredMovies.removeAll()
        movieTableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? 1 : categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        cell.selectionStyle = .none
        
        if isFiltering {
            let category = MovieCategory(title: "Filtered Movies", movies: filteredMovies)
            cell.configure(with: category)
            
            cell.onSeeAllMoviesTapped = { [weak self] in
                self?.navigateToSeeAllMovies(category: category)
            }
        } else {
            let category = categories[indexPath.row]
            cell.configure(with: category)
            
            cell.onSeeAllMoviesTapped = { [weak self] in
                self?.navigateToSeeAllMovies(category: category)
            }
        }
        
        cell.navigateMovieDetailDelegate = self
        
        return cell
    }
}

extension ViewController: NavigateToMovieDetailDelegate {
    func navigate(movie: Movie) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            movieDetailVC.movie = movie
            self.navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }
}
