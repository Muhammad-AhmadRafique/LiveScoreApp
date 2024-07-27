//
//  FootballLeaguesViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

struct LeagueToggleModel {
    var index : Int
    var isOpen: Bool
}

struct LeagueCountryModel {
    var countryKey: Int?
    var countryName: String?
    var countryLogo: String?
    var leagueList: [LeagueModel]?
    var isOpen: Bool
}

class FootballLeaguesViewController: UIViewController, PageItem {

    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int = 0
    private var allLeagueList = [LeagueModel]()
    private var topLeagueList = [LeagueModel]()
    private var countryLeagueList = [LeagueCountryModel]()
    private var headerView : LeaguesTableHeaderView?
    var sectionScrollPositions: [Int: CGFloat] = [:] // Dictionary to store scroll positions for each section

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: LeaguesTableViewCell.className, bundle: nil), forCellReuseIdentifier: LeaguesTableViewCell.className)
        tableView.register(UINib(nibName: TopLeaguesTableViewCell.className, bundle: nil), forCellReuseIdentifier: TopLeaguesTableViewCell.className)
        tableView.register(UINib(nibName: LeagueMatchTableViewCell.className, bundle: nil), forCellReuseIdentifier: LeagueMatchTableViewCell.className)
        
        tableView.sectionFooterHeight = 0
        headerView = LeaguesTableHeaderView.view()
        headerView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 350)
        tableView.tableHeaderView = headerView
       
        getFootballLeagues()
    }
}

extension FootballLeaguesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countryLeagueList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LeaguesHeaderView.view()
        view.configure(section: section, countryLeague: countryLeagueList[section])
        view.leagueHeaderButtonTapped = {
            
            self.countryLeagueList[section].isOpen = !self.countryLeagueList[section].isOpen            
            
            let offset = tableView.contentOffset
            self.tableView.reloadSections(IndexSet(integer: section), with: .none)
            
            //            DispatchQueue.main.async {
            //                self.tableView.layoutIfNeeded()
            //                self.tableView.contentOffset = offset
            //            }
        }
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 100 : 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isOpen = countryLeagueList[section].isOpen
        let leaguesCount = countryLeagueList[section].leagueList?.count ?? 0
        return isOpen ? leaguesCount : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueMatchTableViewCell.className, for: indexPath) as! LeagueMatchTableViewCell
        cell.separatorInset = tableView.separatorInset
        let league = countryLeagueList[indexPath.section].leagueList?[indexPath.row]
        cell.configureCell(league: league)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
    
    private func setupHeader() {
        headerView?.configure(leagues: topLeagueList)
    }
}

extension FootballLeaguesViewController {
    private func getFootballLeagues() {
        
        showProgressHud()
        
        let url = API.Leagues.Football.allLeagues + "?met=Leagues&APIkey=\(API_KEY)"
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
                        self.countryLeagueList =  self.groupLeaguesByCountry()
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
        
        return Array(countryDict.values)
    }
}
