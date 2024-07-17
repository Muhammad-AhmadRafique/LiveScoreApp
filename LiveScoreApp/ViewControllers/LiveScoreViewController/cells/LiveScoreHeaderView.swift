//
//  LiveScoreHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class LiveScoreHeaderView: UIView {
    
    static func view() -> LiveScoreHeaderView {
        let v = Bundle.main.loadNibNamed(LiveScoreHeaderView.className, owner: nil, options: nil)?.first as! LiveScoreHeaderView
        return v
    }

    
}
