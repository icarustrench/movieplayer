//
//  SeeAllTableViewCell.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 08/10/24.
//

import UIKit

class SeeAllTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.black
        
        titleLabel.textColor = UIColor.white
        shortDescriptionLabel.textColor = UIColor.lightGray
        
        movieImageView.layer.cornerRadius = 8
        movieImageView.clipsToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 4
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        shortDescriptionLabel.text = movie.shortDescription
        if let url = URL(string: movie.imageURL) {
            movieImageView.kf.setImage(with: url)
        }
    }
}
