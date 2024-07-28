//
//  NewsHoteMatchesCollectionViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class NewsHotMatchesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var leagueNameLabel: UILabel!
    
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
    
    func configureCell(model: LiveScoreModel?) {
        countryNameLabel.text = model?.countryName
        leagueNameLabel.text = model?.leagueName
        
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
        let components = score.components(separatedBy: "-")
        if let first = components.first {
            homeTeamGoalsLabel.text = first
        }
        if let last = components.last {
            awayTeamGoalsLabel.text = last
        }
        
        setupTimeDateLabelForNonLiveMatches(model: model)
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
