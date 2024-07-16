//
//  ShadowView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import Foundation
import UIKit

class ShadowView: UIView {
    override func draw(_ rect: CGRect) {
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height:1.5)
        clipsToBounds = false
        layer.cornerRadius = 8
        layer.masksToBounds = false
    }
}

public class CellCardBackgroundShadowedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() -> Void {
        
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 1, height: 3)
    }
    
    public func showBorder(color: UIColor = UIColor.black) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
    }
    
    public func hideBorder() {
        layer.borderWidth = 0
    }
    
    public func roundCornersWithRadius(_ corners:CACornerMask, radius: CGFloat = 8.0) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}

