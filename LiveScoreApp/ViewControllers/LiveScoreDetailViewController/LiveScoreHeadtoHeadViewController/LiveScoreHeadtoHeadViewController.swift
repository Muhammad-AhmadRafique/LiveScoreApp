//
//  LiveScoreHeadtoHeadViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

class LiveScoreHeadtoHeadViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var liveScoreModel : LiveScoreModel?

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: LiveScoreHeadToHeadTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreHeadToHeadTableViewCell.className)
    }

    func updateInformation(liveScoreModel : LiveScoreModel?) {
        self.liveScoreModel = liveScoreModel
    }

}

extension LiveScoreHeadtoHeadViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreHeadToHeadHeaderView.view()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreHeadToHeadTableViewCell.className, for: indexPath) as! LiveScoreHeadToHeadTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}
