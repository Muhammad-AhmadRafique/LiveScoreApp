//
//  UITableView+Extension.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import Foundation
import UIKit

extension UITableView{
    func removeSelection() -> Void {
        if let indexs = self.indexPathsForSelectedRows{
            indexs.forEach({ (indexPath) in
                self.deselectRow(at: indexPath, animated: true)
            })
        }
    }
}
