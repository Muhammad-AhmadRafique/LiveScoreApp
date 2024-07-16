//
//  NewsTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage : UIImageView!
    @IBOutlet weak var headingLabel : UILabel!
    @IBOutlet weak var detailLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsImage.roundSpecificCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        
    }
    
}
