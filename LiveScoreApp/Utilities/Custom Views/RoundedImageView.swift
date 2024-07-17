//
//  RoundedImageView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {
    
    //MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        clipsToBounds = true
        layer.masksToBounds = true
    }
}


class RoundedView: UIView {
    
    //MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        clipsToBounds = true
        layer.masksToBounds = true
    }
}


class CircularView: UIView {
    
    //MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        layer.masksToBounds = true
    }
}
