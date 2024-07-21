//
//  LiveScoreStandingHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreStandingHeaderView: UIView {

    static func view() -> LiveScoreStandingHeaderView {
        let v = Bundle.main.loadNibNamed(LiveScoreStandingHeaderView.className, owner: nil, options: nil)?.first as! LiveScoreStandingHeaderView
        v.setup()
        return v
    }
    
    func setup() {
        
    }

}
