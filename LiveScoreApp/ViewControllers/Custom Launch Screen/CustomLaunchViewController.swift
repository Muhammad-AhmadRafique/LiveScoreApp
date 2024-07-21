//
//  CustomLaunchViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class CustomLaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTimer()
    }
    
    func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] t in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
//                Router.shared.openDashboardTabbarController(controller: self)
                ModeSelection.instance.loginMode()
            }
        }
    }

}
