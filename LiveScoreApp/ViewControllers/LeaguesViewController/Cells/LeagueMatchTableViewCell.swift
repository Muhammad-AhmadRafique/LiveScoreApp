//
//  LeagueMatchTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class LeagueMatchTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var matchNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(league: LeagueModel?) {
        guard let league = league else { return }
        if let url = URL(string: league.leagueLogo ?? ""){
            leagueImageView.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
        } else {
            leagueImageView.image = Icons.RECTANGLE_PLACEHOLDER
        }
        
        matchNameLabel.text = league.leagueName
    }
    
}
