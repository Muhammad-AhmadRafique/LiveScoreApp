//
//  FootballLeaguesViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct LeagueCountryModel : Hashable {
    static func == (lhs: LeagueCountryModel, rhs: LeagueCountryModel) -> Bool {
        return lhs.countryKey == rhs.countryKey
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(countryKey)
    }
    
    var countryKey: Int?
    var countryName: String?
    var countryLogo: String?
    var leagueList: [LeagueModel]?
    var isOpen: Bool
}

protocol FootballLeaguesViewControllerDelegate : NSObject {
    func hideKeyboard()
}

class FootballLeaguesViewController: UIViewController, PageItem {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int = 0
    private var allLeagueList = [LeagueModel]()
    private var topLeagueList = [LeagueModel]()
    private var countryLeagueList = [LeagueCountryModel]()
    private var filteredList = [LeagueCountryModel]()
    private var headerView : LeaguesTableHeaderView?
    
    weak var delegate : FootballLeaguesViewControllerDelegate? = nil
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: LeaguesTableViewCell.className, bundle: nil), forCellReuseIdentifier: LeaguesTableViewCell.className)
        tableView.register(UINib(nibName: TopLeaguesTableViewCell.className, bundle: nil), forCellReuseIdentifier: TopLeaguesTableViewCell.className)
        tableView.register(UINib(nibName: LeagueMatchTableViewCell.className, bundle: nil), forCellReuseIdentifier: LeagueMatchTableViewCell.className)
        
        tableView.sectionFooterHeight = 0
        getFootballLeagues()
    }
}

extension FootballLeaguesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let isOpen = filteredList[section - 1].isOpen
            let leaguesCount = filteredList[section - 1].leagueList?.count ?? 0
            return isOpen ? leaguesCount + 1 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 230
        } else {
            if indexPath.section == 1 && indexPath.row == 0 {
                return 90
            }
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TopLeaguesTableViewCell.className, for: indexPath) as! TopLeaguesTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.configure(leagues: topLeagueList)
            return cell
        default:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: LeaguesTableViewCell.className, for: indexPath) as! LeaguesTableViewCell
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cell.configure(section: indexPath.section - 1, countryLeague: filteredList[indexPath.section - 1])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LeagueMatchTableViewCell.className, for: indexPath) as! LeagueMatchTableViewCell
                cell.separatorInset = tableView.separatorInset
                let league = filteredList[indexPath.section - 1].leagueList?[indexPath.row - 1]
                cell.configureCell(league: league)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        if indexPath.section > 0 && indexPath.row == 0 {
            self.filteredList[indexPath.section - 1].isOpen = !self.filteredList[indexPath.section - 1].isOpen
            tableView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.hideKeyboard()
    }
    
    private func setupHeader() {
        headerView?.configure(leagues: topLeagueList)
    }
}

extension FootballLeaguesViewController {
    private func getFootballLeagues() {
        
        showProgressHud()
        
        let url = API.Leagues.Football.allLeagues
        APIGeneric<LeaguesResponseModel>.fetchRequest(apiURL: url) { [weak self] (response) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch response {
                case .success(let result):
                    let success = ResponseType(rawValue: result.success ?? ResponseType.error.rawValue)
                    switch success {
                    case .success:
                        let leagues = result.result ?? []
                        self.allLeagueList = leagues
                        self.getTopFiveLeagues()
                        self.setupHeader()
                        self.countryLeagueList = self.groupLeaguesByCountry()
                        self.filteredList = self.countryLeagueList
                        self.tableView.reloadData()
                    default:
                        let err = CustomError(description: "Something went wrong, please try again")
                        self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                    }
                case .failure(let failure):
                    let err = CustomError(description: (failure as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
    
    private func getTopFiveLeagues() {
        let leagues = self.allLeagueList
        
        let filteredList = leagues
            .filter { $0.leagueName?.isEmpty == false && ($0.leagueLogo?.isValidURL() ?? false) }
            .prefix(5)
            .map { $0 }
        
        self.topLeagueList = filteredList
    }
    
    func groupLeaguesByCountry() -> [LeagueCountryModel] {
        var countryDict = [Int: LeagueCountryModel]()
        
        let leagues = self.allLeagueList
       
        for league in leagues {
            guard let countryKey = league.countryKey,
                  let countryName = league.countryName,
                  let countryLogo = league.countryLogo else {
                continue
            }
            
            if var countryModel = countryDict[countryKey] {
                countryModel.leagueList?.append(league)
                countryDict[countryKey] = countryModel
            } else {
                let newCountryModel = LeagueCountryModel(countryKey: countryKey, countryName: countryName, countryLogo: countryLogo, leagueList: [league], isOpen: false)
                countryDict[countryKey] = newCountryModel
            }
        }
        var resultLeagues = Array(countryDict.values)
        resultLeagues.sort { $0.countryName?.localizedCompare($1.countryName ?? "") == .orderedAscending }
        return resultLeagues
    }
}

extension FootballLeaguesViewController : LeaguesViewControllerDelegate {
    
    func searchFieldDidChange(str: String) {
        if str.isEmpty {
            filteredList = countryLeagueList
        } else {
            let list = countryLeagueList.filter({
                if $0.countryName?.lowercased().contains(str) ?? false {
                    return true
                } else {
                    var matchList = $0.leagueList ?? []
                    matchList = matchList.filter({
                        $0.leagueName?.lowercased().contains(str) ?? false
                    })
                    return matchList.count > 0
                }
            })
            filteredList = list
        }
        
        tableView.reloadData()
    }
}
