//
//  LeagueMatchTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class LeagueMatchTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImageLabel: UILabel!
    @IBOutlet weak var matchNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell() {
        countryImageLabel.text = "AR".countryFlag()
    }
    
}
