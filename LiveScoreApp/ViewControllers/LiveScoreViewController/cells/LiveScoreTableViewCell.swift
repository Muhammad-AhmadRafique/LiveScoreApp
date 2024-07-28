//
//  LiveScoreTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class LiveScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTimeView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var homeTeamIcon: UIImageView!
    @IBOutlet weak var awayTeamIcon: UIImageView!
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    @IBOutlet weak var homeTeamGoalsLabel: UILabel!
    @IBOutlet weak var awayTeamGoalsLabel: UILabel!
    
    @IBOutlet weak var liveScoreMinuteLabel: UILabel!
    @IBOutlet weak var liveScoreMinuteLabelWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(model: LiveScoreModel?, isLive : Bool = false) {
        if let url = URL(string: model?.homeTeamLogo ?? ""){
            homeTeamIcon.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
        } else {
            homeTeamIcon.image = Icons.RECTANGLE_PLACEHOLDER
        }
        homeTeamNameLabel.text = model?.eventHomeTeam
        
        
        if let url = URL(string: model?.awayTeamLogo ?? "") {
            awayTeamIcon.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
        } else {
            awayTeamIcon.image = Icons.RECTANGLE_PLACEHOLDER
        }
        awayTeamNameLabel.text = model?.eventAwayTeam
        
        let score = model?.eventFinalResult ?? ""        
        let goalStats = score.getGoalsStats()
        homeTeamGoalsLabel.text = goalStats.home
        awayTeamGoalsLabel.text = goalStats.away
        
        dateTimeView.isHidden = isLive
        liveScoreMinuteLabel.isHidden = !isLive
        
        if !isLive {
            setupTimeDateLabelForNonLiveMatches(model: model)
        } else {
            let eventStatus = model?.eventStatus ?? ""
            if eventStatus.contains(" ") {
                let words = eventStatus.split(separator: " ")
                let firstLetters = words.compactMap { (word) -> String? in
                    guard let firstLetter = word.first else { return nil }
                    return String(firstLetter)
                }
                liveScoreMinuteLabel.text = firstLetters.joined()
            } else {
                liveScoreMinuteLabel.text = eventStatus + "`"
            }
        }
    }
    
    private func setupTimeDateLabelForNonLiveMatches(model: LiveScoreModel?) {
        if let dayMonth = model?.eventDate?.getNonLiveScoreDayMonth() {
            dayLabel.text = dayMonth
        } else {
            dayLabel.text = "-"
        }
        
        timeLabel.text = model?.eventTime
    }
}
