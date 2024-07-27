//
//  BasketballLeaguesViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

protocol PageItem {
    var pageIndex : Int { get set}
}

class BasketballLeaguesViewController: UIViewController, PageItem {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int = 1
    var toggleSwitchList : [LeagueToggleModel] = []
    var totalCount = 20

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: LeaguesTableViewCell.className, bundle: nil), forCellReuseIdentifier: LeaguesTableViewCell.className)
        tableView.register(UINib(nibName: TopLeaguesTableViewCell.className, bundle: nil), forCellReuseIdentifier: TopLeaguesTableViewCell.className)
        tableView.register(UINib(nibName: LeagueMatchTableViewCell.className, bundle: nil), forCellReuseIdentifier: LeagueMatchTableViewCell.className)
        
        tableView.sectionFooterHeight = 0
        for i in 0..<totalCount + 1 {
            toggleSwitchList.append(LeagueToggleModel(index: i, isOpen: false))
        }
    }

}

extension BasketballLeaguesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return toggleSwitchList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = NewsHeaderView.view()
            view.configure(title: "Top Leagues", font: .systemFont(ofSize: 25, weight: .bold))
            return view
        default:
            let view = LeaguesHeaderView.view()
            view.configure(section: section, countryLeague: nil)
            view.leagueHeaderButtonTapped = {
                self.toggleSwitchList[section].isOpen = !self.toggleSwitchList[section].isOpen
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                }
            }
            return view
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 60
        default:
            return section == 1 ? 100 : 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return toggleSwitchList[section].isOpen ? 5 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 170
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TopLeaguesTableViewCell.className, for: indexPath) as! TopLeaguesTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
            cell.selectionStyle = .none
            cell.configureCell(leagues: [])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: LeagueMatchTableViewCell.className, for: indexPath) as! LeagueMatchTableViewCell
            cell.separatorInset = tableView.separatorInset
            cell.configureCell(league: nil)
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}

