//
//  ProfileViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit
import MessageUI

class ProfileViewController: UITableViewController {
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0, height: CGFloat.leastNormalMagnitude)))

    }
    
    //MARK: - Helper Methods
    private func openAppStoreConnect() {
        if let url = URL(string: "https://appstoreconnect.apple.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            Router.shared.openAboutUsViewController(controller: self)
        case 2:
            openShareSheet(text: nil, image: nil, link: "https://appstoreconnect.apple.com", controller: self)
        case 3:
            sendEmail()
        case 4:
            openAppStoreConnect()
        default:
            break
        }
    }
}

extension ProfileViewController : MFMailComposeViewControllerDelegate {
    func sendEmail() {
        // Check if the device can send email
        guard MFMailComposeViewController.canSendMail() else {
            // Show an alert informing the user
            self.alertMessage(title: "Error", alertMessage: "This device cannot send email.", action: nil)
            return
        }
        
        // Configure the mail composer
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["example@example.com"])
        mailComposeViewController.setSubject("Subject")
        mailComposeViewController.setMessageBody("Email body text.", isHTML: false)
        
        // Present the mail composer
        self.present(mailComposeViewController, animated: true, completion: nil)
    }
}
