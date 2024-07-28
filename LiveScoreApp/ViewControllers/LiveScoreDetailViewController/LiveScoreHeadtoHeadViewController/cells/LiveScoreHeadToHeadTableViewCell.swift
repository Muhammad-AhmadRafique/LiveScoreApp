//
//  LiveScoreHeadToHeadTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreHeadToHeadTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var homeTeamIcon: UIImageView!
    @IBOutlet weak var awayTeamIcon: UIImageView!
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    @IBOutlet weak var homeTeamGoalsLabel: UILabel!
    @IBOutlet weak var awayTeamGoalsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: H2HModel?) {
        if let model = model {
            
            timeLabel.text = model.eventTime
            dayLabel.text = model.eventDate?.getH2HDateString()
            
            homeTeamNameLabel.text = model.eventHomeTeam
            awayTeamNameLabel.text = model.eventAwayTeam
            
            let score = model.eventFinalResult ?? ""
            let goalStats = score.getGoalsStats()
            homeTeamGoalsLabel.text = goalStats.home
            awayTeamGoalsLabel.text = goalStats.away
            
            if let url = URL(string: model.homeTeamLogo ?? ""){
                homeTeamIcon.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
            } else {
                homeTeamIcon.image = Icons.RECTANGLE_PLACEHOLDER
            }
            
            if let url = URL(string: model.awayTeamLogo ?? ""){
                awayTeamIcon.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
            } else {
                awayTeamIcon.image = Icons.RECTANGLE_PLACEHOLDER
            }
            
        }
    }
    
}
