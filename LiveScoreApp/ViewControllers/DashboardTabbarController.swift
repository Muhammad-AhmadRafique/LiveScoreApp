//
//  DashboardTabbarController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class DashboardTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let viewControllers = viewControllers {
            // Assuming you have two tabs: Home and Profile
            viewControllers[0].tabBarItem.title = "news".localizedString().capitalized
            viewControllers[1].tabBarItem.title = "live".localizedString().capitalized
            viewControllers[2].tabBarItem.title = "leagues".localizedString().capitalized
            viewControllers[3].tabBarItem.title = "profile".localizedString().capitalized
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
