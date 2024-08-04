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
    private var allLeagueList = [LeagueModel]()
    private var topLeagueList = [LeagueModel]()
    private var countryLeagueList = [LeagueCountryModel]()
    private var headerView : LeaguesTableHeaderView?
    
    private var dataSource: UITableViewDiffableDataSource<LeagueCountryModel, LeagueModel>! = nil
    private var currentSnapshot: NSDiffableDataSourceSnapshot<LeagueCountryModel, LeagueModel>! = nil
    
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
       
        setupDatasource()
        getBasketballLeagues()
    }
    
    private func setupDatasource() {
        tableView.delegate = self
        tableView.rowHeight = 48
        tableView.estimatedRowHeight = 48
        
        self.dataSource = UITableViewDiffableDataSource<LeagueCountryModel, LeagueModel>(tableView: tableView) { [weak self] (tableView: UITableView, indexPath: IndexPath, rowModel: LeagueModel) -> UITableViewCell? in
            guard self != nil else { return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: LeagueMatchTableViewCell.className, for: indexPath) as! LeagueMatchTableViewCell
            cell.configureCell(league: rowModel)
            return cell
        }
    }
    
    private func updateUI() {
        currentSnapshot = NSDiffableDataSourceSnapshot<LeagueCountryModel, LeagueModel>()

        for countryLeagueModel in countryLeagueList {
            currentSnapshot.appendSections([countryLeagueModel])
            if countryLeagueModel.isOpen {
                currentSnapshot.appendItems(countryLeagueModel.leagueList ?? [], toSection: countryLeagueModel)
            } else {
                currentSnapshot.appendItems([], toSection: countryLeagueModel)
            }
        }

        self.dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    func reloadContentSection(section: Int) {
        
        currentSnapshot = self.dataSource.snapshot()
        currentSnapshot.deleteAllItems()

        for countryLeagueModel in countryLeagueList {
            currentSnapshot.appendSections([countryLeagueModel])
            if countryLeagueModel.isOpen {
                currentSnapshot.appendItems(countryLeagueModel.leagueList ?? [], toSection: countryLeagueModel)
            } else {
                currentSnapshot.appendItems([], toSection: countryLeagueModel)
            }
        }

        self.dataSource.apply(currentSnapshot, animatingDifferences: false)

    }
}

extension BasketballLeaguesViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LeaguesHeaderView.view()
        view.configure(section: section, countryLeague: countryLeagueList[section])
        view.leagueHeaderButtonTapped = {
            self.countryLeagueList[section].isOpen = !self.countryLeagueList[section].isOpen
//            self.reloadContentSection(section: section)
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 100 : 50
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
    
    private func setupHeader() {
        headerView?.configure(leagues: topLeagueList)
    }
}

extension BasketballLeaguesViewController {
    private func getBasketballLeagues() {
        
        showProgressHud()
        
        let url = API.Leagues.Baseball.allLeagues + "?met=Leagues&APIkey=\(API_KEY)"
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
                        self.updateUI()
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
            .filter { $0.leagueName?.isEmpty == false}
            .prefix(5)
            .map { $0 }
        
        self.topLeagueList = filteredList
    }
    
    func groupLeaguesByCountry() -> [LeagueCountryModel] {
        var countryDict = [Int: LeagueCountryModel]()
        
        let leagues = self.allLeagueList
        for league in leagues {
            guard let countryKey = league.countryKey,
                  let countryName = league.countryName else {
                continue
            }
            
            if var countryModel = countryDict[countryKey] {
                countryModel.leagueList?.append(league)
                countryDict[countryKey] = countryModel
            } else {
                let countryLogo = "https://apiv2.allsportsapi.com/logo/logo_country/\(countryKey)_\(countryName.lowercased()).png"
                let newCountryModel = LeagueCountryModel(countryKey: countryKey, countryName: countryName, countryLogo: countryLogo, leagueList: [league], isOpen: false)
                countryDict[countryKey] = newCountryModel
            }
        }
        
        return Array(countryDict.values)
    }
}
