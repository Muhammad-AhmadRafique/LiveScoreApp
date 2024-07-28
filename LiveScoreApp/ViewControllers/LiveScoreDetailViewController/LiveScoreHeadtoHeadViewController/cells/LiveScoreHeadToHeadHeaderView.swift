//
//  LiveScoreHeadToHeadHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreHeadToHeadHeaderView: UIView {

    static func view() -> LiveScoreHeadToHeadHeaderView {
        let v = Bundle.main.loadNibNamed(LiveScoreHeadToHeadHeaderView.className, owner: nil, options: nil)?.first as! LiveScoreHeadToHeadHeaderView
        v.setup()
        return v
    }
    
    @IBOutlet weak var leagueNameLabel: UILabel!
    
    func setup() {
        
    }
    
    func configure(name: String) {
        leagueNameLabel.text = name
    }

}
