//
//  LiveScoreLineupViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

struct NameNumberModel {
    let name: String?
    let number : String?
}

struct LineupModel {
    let sectionTitle: String
    let list : [NameNumberModel]
}

class LiveScoreLineupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    private var selectedTeam : SelectedTeam = .home
    var liveScoreModel : LiveScoreModel?
    private var homeTeamLineupList = [LineupModel]()
    private var awayTeamLineupList = [LineupModel]()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: LiveScoreLinupTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreLinupTableViewCell.className)
        selectedTeam = .home
        segmentControl.selectedSegmentIndex = 0
    }

    //MARK: - Helper Methods
    func updateInformation(liveScoreModel : LiveScoreModel?) {
        self.liveScoreModel = liveScoreModel
        
        self.segmentControl.setTitle(liveScoreModel?.eventHomeTeam, forSegmentAt: SelectedTeam.home.rawValue)
        self.segmentControl.setTitle(liveScoreModel?.eventAwayTeam, forSegmentAt: SelectedTeam.away.rawValue)
        
        homeTeamLineupList.removeAll()
        awayTeamLineupList.removeAll()
        
        if let lineup = liveScoreModel?.lineups {
            if let homeTeam = lineup.homeTeam {
                homeTeamLineupList = getModels(team: homeTeam)
            }
            
            if let awayTeam = lineup.awayTeam {
                awayTeamLineupList = getModels(team: awayTeam)
            }
        }
        
        switch selectedTeam {
        case .home:
            noDataLabel.isHidden = !homeTeamLineupList.isEmpty
        case .away:
            noDataLabel.isHidden = !awayTeamLineupList.isEmpty
        }
        tableView.reloadData()
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        selectedTeam = SelectedTeam(rawValue: sender.selectedSegmentIndex) ?? .home
        tableView.reloadData()
    }
    
    private func getModels(team: Team?) -> [LineupModel] {
        if let team = team {
            var resultList = [LineupModel]()
            var nameNumberList = [NameNumberModel]()
            
            let startingLineups = team.startingLineups ?? []
            let substitutes = team.substitutes ?? []
            let coaches = team.coaches ?? []
            
            nameNumberList.removeAll()
            startingLineups.forEach { lineup in
                nameNumberList.append(NameNumberModel(name: lineup.player, number: "\(lineup.playerNumber ?? 0)"))
            }
            if nameNumberList.count > 0 {
                resultList.append(LineupModel(sectionTitle: "Starting Lineups", list: nameNumberList))
            }
            
            nameNumberList.removeAll()
            substitutes.forEach { substitute in
                nameNumberList.append(NameNumberModel(name: substitute.player, number: "\(substitute.playerNumber ?? 0)"))
            }
            if nameNumberList.count > 0 {
                resultList.append(LineupModel(sectionTitle: "Substitutes", list: nameNumberList))
            }
            
            nameNumberList.removeAll()
            coaches.forEach { coach in
                nameNumberList.append(NameNumberModel(name: coach.coache, number: ""))
            }
            if nameNumberList.count > 0 {
                resultList.append(LineupModel(sectionTitle: "Coaches", list: nameNumberList))
            }
            
            
            return resultList
        }
        return []
    }

}

extension LiveScoreLineupViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedTeam == .home ? homeTeamLineupList.count : awayTeamLineupList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreLinupHeaderView.view()
        view.configure(title: selectedTeam == .home ? homeTeamLineupList[section].sectionTitle : awayTeamLineupList[section].sectionTitle)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTeam == .home ? homeTeamLineupList[section].list.count : awayTeamLineupList[section].list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreLinupTableViewCell.className, for: indexPath) as! LiveScoreLinupTableViewCell
        let model =  selectedTeam == .home ? homeTeamLineupList[indexPath.section].list[indexPath.row] : awayTeamLineupList[indexPath.section].list[indexPath.row]
        cell.configureCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}
