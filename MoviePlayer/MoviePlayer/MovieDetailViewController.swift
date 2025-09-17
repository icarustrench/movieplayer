//
//  MovieDetailViewController.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 08/10/24.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.red
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        titleLabel.textColor = UIColor.white
        descriptionLabel.textColor = UIColor.lightGray
        
        movieImageView.layer.shadowColor = UIColor.black.cgColor
        movieImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        movieImageView.layer.shadowOpacity = 0.8
        movieImageView.layer.shadowRadius = 4
        
        if let movie = movie {
            titleLabel.text = movie.title
            descriptionLabel.text = movie.longSynopsis
            if let url = URL(string: movie.imageURL) {
                movieImageView.kf.setImage(with: url)
            }
        }
    }
}
