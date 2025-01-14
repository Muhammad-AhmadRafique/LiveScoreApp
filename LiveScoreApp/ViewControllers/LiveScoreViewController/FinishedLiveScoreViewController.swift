//
//  FinishedLiveScoreViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class FinishedLiveScoreViewController: UIViewController, PageItem {

    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int = 0
    weak var parentNavigationController: UINavigationController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionFooterHeight = 0
        tableView.register(UINib(nibName: LiveScoreTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreTableViewCell.className)
    }

}

extension FinishedLiveScoreViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreHeaderView.view()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreTableViewCell.className, for: indexPath) as! LiveScoreTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        Router.shared.openLiveScoreDetailViewController(controller: parentNavigationController)
    }
}
