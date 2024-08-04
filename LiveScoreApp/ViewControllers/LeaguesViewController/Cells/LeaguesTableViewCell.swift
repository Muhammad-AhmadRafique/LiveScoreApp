//
//  LeaguesTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

class LeaguesTableViewCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leaguesCountLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(section: Int, countryLeague: LeagueCountryModel?) {
        headingLabel.isHidden = section != 0
        guard let countryLeague = countryLeague else { return }
        
        titleLabel.text = countryLeague.countryName
        let totalLeagueCount = countryLeague.leagueList?.count ?? 0
        leaguesCountLabel.text = "\(totalLeagueCount)"
        
        if let url = URL(string: countryLeague.countryLogo ?? ""){
            countryImageView.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
        } else {
            countryImageView.image = Icons.RECTANGLE_PLACEHOLDER
        }
    }
    
}
