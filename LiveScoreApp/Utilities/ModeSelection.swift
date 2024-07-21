//
//  ModeSelection.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import Foundation
import UIKit

class ModeSelection{
    
    static let instance = ModeSelection()
    
    func loginMode() -> Void {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let delegate = windowScene.delegate as? SceneDelegate {
                    if let window = delegate.window {
                        let rootVC = Storyboards.MAIN.instantiateViewController(withIdentifier: DashboardTabbarController.className) as! DashboardTabbarController
                        window.rootViewController = rootVC
                        window.makeKeyAndVisible()
                    }
                }
            }
        }
    }
    
}
    
