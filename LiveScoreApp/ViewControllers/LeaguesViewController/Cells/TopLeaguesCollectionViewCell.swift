//
//  TopLeaguesCollectionViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class TopLeaguesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(league: LeagueModel) {
        leagueNameLabel.text = league.leagueName
        if let url = URL(string: league.leagueLogo ?? ""){
            leagueImageView.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
        } else {
            leagueImageView.image = Icons.RECTANGLE_PLACEHOLDER
        }
    }
    
}
