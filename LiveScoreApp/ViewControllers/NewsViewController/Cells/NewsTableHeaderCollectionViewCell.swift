//
//  NewsTableHeaderCollectionViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 18/07/2024.
//

import UIKit

class NewsTableHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(image: UIImage) {
        imgView.image = image
    }

}
