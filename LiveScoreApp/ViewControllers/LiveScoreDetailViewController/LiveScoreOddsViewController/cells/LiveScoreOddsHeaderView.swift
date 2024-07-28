//
//  LiveScoreOddsHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreOddsHeaderView: UIView {

    static func view() -> LiveScoreOddsHeaderView {
        let v = Bundle.main.loadNibNamed(LiveScoreOddsHeaderView.className, owner: nil, options: nil)?.first as! LiveScoreOddsHeaderView
        v.setup()
        return v
    }
    
    @IBOutlet weak var titleLabel: UILabel!

    func setup() {
    }
    
    func configure(title: String?) {
        titleLabel.text = title
    }
}
