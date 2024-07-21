//
//  LiveScoreStandingTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreStandingTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(place: String) {
        placeLabel.text = place
    }
    
}
