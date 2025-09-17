//
//  MoviesTableViewCell.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 08/10/24.
//

import UIKit
import SkeletonView

class MoviesTableViewCell: UITableViewCell, UICollectionViewDelegate {

    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var navigateMovieDetailDelegate: NavigateToMovieDetailDelegate?
    var onSeeAllMoviesTapped: (() -> Void)?
    var movies: [Movie] = []
    
    private struct Constants {
        static let maxVisibleMovies = 5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.isSkeletonable = true
        
        self.backgroundColor = UIColor.black
        titleMovieLabel.textColor = UIColor.white
        collectionView.backgroundColor = UIColor.black
        allButton.setTitleColor(UIColor.white, for: .normal)
        allButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        collectionView.isSkeletonable = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "movieCollectionViewCell")
    }
    
    func configure(with category: MovieCategory) {
        self.movies = category.movies
        self.titleMovieLabel.text = category.title
        collectionView.reloadData()
    }

    @IBAction func onTapSeeAllButton(_ sender: Any) {
        onSeeAllMoviesTapped?()
    }
}

extension MoviesTableViewCell: UICollectionViewDataSource, SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "movieCollectionViewCell"
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.isEmpty ? 5 : min(movies.count, Constants.maxVisibleMovies)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        if movies.isEmpty {
            cell.showSkeleton(usingColor: .lightGray)
        } else {
            let movie = movies[indexPath.row]
            cell.configure(with: movie)
            cell.hideSkeleton()
        }
        return cell
    }

    func animateCellSelection(for collectionView: UICollectionView, at indexPath: IndexPath, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            collectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                collectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform.identity
            }, completion: { _ in
                completion()
            })
        })
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        animateCellSelection(for: collectionView, at: indexPath) {
            self.navigateMovieDetailDelegate?.navigate(movie: selectedMovie)
        }
    }
}

extension MoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
