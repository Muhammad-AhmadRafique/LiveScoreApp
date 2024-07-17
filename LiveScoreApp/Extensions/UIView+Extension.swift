//
//  UIView+Extensino.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import Foundation
import UIKit

extension UIView {
    func roundSpecificCorners(_ corners:CACornerMask, radius: CGFloat = 8.0) {
        self.clipsToBounds = false
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
        self.layer.masksToBounds = true
    }
    
    func roundedCorners(radius: CGFloat = 8.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = false
        self.layer.masksToBounds = true
    }
}
