//
//  LiveScoreStandingViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

class LiveScoreStandingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var liveScoreModel : LiveScoreModel?

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: LiveScoreStandingTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreStandingTableViewCell.className)

    }
    
    func updateInformation(liveScoreModel : LiveScoreModel?) {
        self.liveScoreModel = liveScoreModel
    }

}

extension LiveScoreStandingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreStandingHeaderView.view()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreStandingTableViewCell.className, for: indexPath) as! LiveScoreStandingTableViewCell
        cell.configureCell(place: "\(indexPath.row + 1)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}
