//
//  LiveScoreLinupHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreLinupHeaderView: UIView {

    static func view() -> LiveScoreLinupHeaderView {
        let v = Bundle.main.loadNibNamed(LiveScoreLinupHeaderView.className, owner: nil, options: nil)?.first as! LiveScoreLinupHeaderView
        v.setup()
        return v
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup() {
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
