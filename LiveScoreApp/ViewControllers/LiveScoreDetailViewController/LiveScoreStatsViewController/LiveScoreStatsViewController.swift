//
//  LiveScoreStatsViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

enum SelectedTeam : Int {
    case home = 0
    case away = 1
}

class LiveScoreStatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var liveScoreModel : LiveScoreModel?
    private var selectedTeam : SelectedTeam = .home
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: LiveScoreStatsTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreStatsTableViewCell.className)
        segmentControl.selectedSegmentIndex = 0
        selectedTeam = .home
    }

    func updateInformation(liveScoreModel : LiveScoreModel?) {
        self.liveScoreModel = liveScoreModel
        self.segmentControl.setTitle(liveScoreModel?.eventHomeTeam, forSegmentAt: SelectedTeam.home.rawValue)
        self.segmentControl.setTitle(liveScoreModel?.eventAwayTeam, forSegmentAt: SelectedTeam.away.rawValue)
        
        noDataLabel.isHidden = !((liveScoreModel?.statistics?.count ?? 0) == 0)
        tableView.reloadData()
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        selectedTeam = SelectedTeam(rawValue: sender.selectedSegmentIndex) ?? .home
        tableView.reloadData()
    }
    
}

extension LiveScoreStatsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveScoreModel?.statistics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreStatsTableViewCell.className, for: indexPath) as! LiveScoreStatsTableViewCell
        cell.configureCell(model: liveScoreModel?.statistics?[indexPath.row], selectedTeam: selectedTeam)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
    
}
