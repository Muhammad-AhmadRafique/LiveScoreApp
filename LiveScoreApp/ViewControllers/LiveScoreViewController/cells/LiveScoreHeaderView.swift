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

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configure(leagueLogo: String?, leagueName: String?) {
        if let url = URL(string: leagueLogo ?? ""){
            imageView.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
        } else {
            imageView.image = Icons.RECTANGLE_PLACEHOLDER
        }
        
        nameLabel.text = leagueName
    }
    
}
