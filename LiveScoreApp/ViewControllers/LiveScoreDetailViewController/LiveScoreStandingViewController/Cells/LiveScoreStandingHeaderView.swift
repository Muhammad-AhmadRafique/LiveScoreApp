//
//  LiveScoreStandingHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreStandingHeaderView: UIView {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    
    static func view() -> LiveScoreStandingHeaderView {
        let v = Bundle.main.loadNibNamed(LiveScoreStandingHeaderView.className, owner: nil, options: nil)?.first as! LiveScoreStandingHeaderView
        v.setup()
        return v
    }
    
    func setup() {
//        numberLabel.text = "no".localizedString().capitalized
        teamLabel.text = "team".localizedString().capitalized
    }

}
