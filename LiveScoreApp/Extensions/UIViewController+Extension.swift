//
//  UIViewController+Extension.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    func openShareSheet(text:String?,image:UIImage?,link:String?, controller:UIViewController?) -> Void {
        
        var shareAll = Array<Any>()
        if let message = text{
            shareAll.append(message)
        }
        if let img = image {
            shareAll.append(img)
        }
        if let lnk = link{
            if let url = NSURL(string: lnk){
                shareAll.append(url)
            }
        }
        
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
        }
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    func alertMessage(title: String, alertMessage:String, action: (() -> Void)?)
    {
        DispatchQueue.main.async {
            
            self.hideProgressHud()
            if alertMessage.lowercased().contains("cancelled") || alertMessage.lowercased().contains("caused connection abort") {
                return
            }
            
            let myAlert = UIAlertController(title:title, message:alertMessage, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                UIAlertAction in
                action?()
            }
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion:nil)
        }
    }
    
    func showProgressHud() -> Void {
        DispatchQueue.main.async {
            let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHud.mode = .indeterminate
            progressHud.isUserInteractionEnabled = true
            progressHud.label.text = "Loading..."
        }
    }
    
    func showCustomProgressHud(str: String) -> Void {
        DispatchQueue.main.async {
            let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHud.label.text = str
        }
    }
    
    func hideProgressHud() -> Void {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view , animated: true)
        }
    }
}
