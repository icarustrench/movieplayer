//
//  MovieCollectionViewCell.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 04/10/24.
//

import UIKit
import Kingfisher
import SkeletonView

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        contentView.isSkeletonable = true
        
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        clipsToBounds = false
        
        self.backgroundColor = UIColor.black
        
        self.movieImageView.layer.cornerRadius = 8
        self.movieImageView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 4
    }
    
    func configure(with movie: Movie) {
        if let imageURL = URL(string: movie.imageURL), !movie.imageURL.isEmpty {
            movieImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderImage"))
        } else {
            movieImageView.image = UIImage(named: "placeholderImage")
        }
    }
}
