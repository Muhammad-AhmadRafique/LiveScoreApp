//
//  Router.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import Foundation
import UIKit

class Router: NSObject {
    
    static let shared = Router()
    
    func openAboutUsViewController(controller:UIViewController) -> Void {
        let control = Storyboards.MAIN.instantiateViewController(withIdentifier: AboutUsViewController.className) as! AboutUsViewController
        controller.show(control, sender: nil)
    }
    
}
