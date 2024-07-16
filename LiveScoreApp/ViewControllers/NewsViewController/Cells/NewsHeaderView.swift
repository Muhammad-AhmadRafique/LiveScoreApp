//
//  NewsHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

class NewsHeaderView: UIView {

    @IBOutlet weak var headingLabel: UILabel!
    
    static func view() -> NewsHeaderView {
        let v = Bundle.main.loadNibNamed(NewsHeaderView.className, owner: nil, options: nil)?.first as! NewsHeaderView
        return v
    }
    
    func configure() {
        headingLabel.text = "Lates Updates"
    }

}
