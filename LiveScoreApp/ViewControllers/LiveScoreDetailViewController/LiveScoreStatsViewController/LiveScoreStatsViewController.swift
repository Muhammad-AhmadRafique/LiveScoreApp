//
//  LiveScoreStatsViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

class LiveScoreStatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var titleList = ["Total Shots", "Shots On Target", "Shots Off Target", "Blocked Shots"]
    private var countList = ["5","8","4","10"]
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: LiveScoreStatsTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreStatsTableViewCell.className)
    }

}

extension LiveScoreStatsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreStatsTableViewCell.className, for: indexPath) as! LiveScoreStatsTableViewCell
        cell.configureCell(title: titleList[indexPath.row], count: countList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
    
}
