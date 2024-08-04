//
//  ProfileViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit
import MessageUI

class ProfileImageCollectionCell : UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var aboutUsLabel: UILabel!
    @IBOutlet weak var tellFriendLabel: UILabel!
    @IBOutlet weak var shareFeedbackLabel: UILabel!
    @IBOutlet weak var rateAppstoreLabel: UILabel!
    
    private let imageList = [UIImage(named: "football"), UIImage(named: "basketball")]
    private var timer: Timer?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0, height: CGFloat.leastNormalMagnitude)))
        
        aboutUsLabel.text = "about_us".localizedString()
        tellFriendLabel.text = "tell_a_friend".localizedString()
        shareFeedbackLabel.text = "share_feedback".localizedString()
        rateAppstoreLabel.text = "rate_on_appstore".localizedString()
        setupTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Helper Methods
    private func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToIndex), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToIndex() {
        if let indexPath = self.collectionView.indexPathsForVisibleItems.first {
            var index = indexPath.row
            let section = indexPath.section
            if index >= self.imageList.count - 1 {
                index -= 1
            } else {
                index += 1
            }
            
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: section), at: .left, animated: true)
            self.pageControl.currentPage = index
        }
    }
    
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

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionCell.className, for: indexPath) as! ProfileImageCollectionCell
        cell.imgView.image = imageList[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size
        return CGSize(width: size.width, height: size.height)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        setupTimer()
    }
    
}
