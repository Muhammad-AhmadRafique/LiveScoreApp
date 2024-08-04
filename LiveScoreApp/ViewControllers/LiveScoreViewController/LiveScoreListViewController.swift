//
//  LIveScoreListViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

struct LiveScoreLeagueModel : Hashable {
    static func == (lhs: LiveScoreLeagueModel, rhs: LiveScoreLeagueModel) -> Bool {
        return lhs.leagueKey == rhs.leagueKey
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(leagueKey)
    }
    
    var leagueKey: Int?
    var leagueName: String?
    var matchList: [LiveScoreModel]?
    var leagueLogo : String?
    
    init(leagueKey: Int? = nil, leagueName: String? = nil, matchList: [LiveScoreModel]? = nil, leagueLogo: String? = nil) {
        self.leagueKey = leagueKey
        self.leagueName = leagueName
        self.matchList = matchList
        self.leagueLogo = leagueLogo
    }
}


class LiveScoreListViewController: UIViewController, PageItem {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int = 1
    weak var parentNavigationController: UINavigationController? = nil
    weak var delegate : LiveScoreChildViewControllerDelegate? = nil

    let refreshControl = UIRefreshControl()
    var liveScoreLeagueList = [LiveScoreLeagueModel]()
    private var filteredList = [LiveScoreLeagueModel]()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionFooterHeight = 0
        tableView.register(UINib(nibName: LiveScoreTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreTableViewCell.className)
        setupRefreshControl()
        getLiveScores()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(getLiveScores), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

}

extension LiveScoreListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreHeaderView.view()
        let leagueInfo = filteredList[section]
        view.configure(leagueLogo: leagueInfo.leagueLogo, leagueName: leagueInfo.leagueName)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList[section].matchList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreTableViewCell.className, for: indexPath) as! LiveScoreTableViewCell
        cell.configureCell(model: filteredList[indexPath.section].matchList?[indexPath.row], isLive: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        delegate?.hideKeyboard()
        Router.shared.openLiveScoreDetailViewController(model: filteredList[indexPath.section].matchList?[indexPath.row], controller: parentNavigationController)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.hideKeyboard()
    }
}

extension LiveScoreListViewController {
    @objc private func getLiveScores() {
        showProgressHud()
        
        let url = API.Leagues.Football.liveScore
        APIGeneric<LiveScoreResponseModel>.fetchRequest(apiURL: url) { [weak self] (response) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.hideProgressHud()
                switch response {
                case .success(let result):
                    let success = ResponseType(rawValue: result.success ?? ResponseType.error.rawValue)
                    switch success {
                    case .success:
                        let liveScoreLeagueList = (result.result ?? []).filter({$0.eventStatus?.lowercased() != "finished"})
                        self.liveScoreLeagueList = Helper.groupLiveScoreMatchesByLeagues(list: liveScoreLeagueList)
                        self.filteredList = self.liveScoreLeagueList
                        self.delegate?.updateButtonTitle(title: "Live (\(self.filteredList.count))", type: .live)
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
}

extension LiveScoreListViewController : LiveScoreViewControllerDelegate {
    func searchFieldDidChange(str: String) {
        if str.isEmpty {
            filteredList = liveScoreLeagueList
        } else {
            let list = liveScoreLeagueList.filter({
                if $0.leagueName?.lowercased().contains(str) ?? false {
                    return true
                } else {
                    var matchList = $0.matchList ?? []
                    matchList = matchList.filter({
                        ($0.eventHomeTeam?.lowercased().contains(str) ?? false) ||
                        ($0.eventAwayTeam?.lowercased().contains(str) ?? false)
                    })
                    return matchList.count > 0
                }
            })
            filteredList = list
        }
        
        self.delegate?.updateButtonTitle(title: "Live (\(filteredList.count))", type: .live)
        tableView.reloadData()
    }
}
