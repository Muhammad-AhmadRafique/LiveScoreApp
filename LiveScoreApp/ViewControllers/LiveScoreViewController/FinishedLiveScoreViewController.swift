//
//  FinishedLiveScoreViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class FinishedLiveScoreViewController: UIViewController, PageItem {

    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int = 0
    weak var parentNavigationController: UINavigationController? = nil
    weak var delegate : LiveScoreChildViewControllerDelegate? = nil

    private var finishedScoreLeagueList = [LiveScoreLeagueModel]()
    private var filteredList = [LiveScoreLeagueModel]()
    let refreshControl = UIRefreshControl()

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionFooterHeight = 0
        tableView.register(UINib(nibName: LiveScoreTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreTableViewCell.className)
        setupRefreshControl()
        getFinsishedMatches()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(getFinsishedMatches), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

}

extension FinishedLiveScoreViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreHeaderView.view()
        view.configure(leagueLogo: filteredList[section].leagueLogo, leagueName: filteredList[section].leagueName)
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
        cell.configureCell(model: filteredList[indexPath.section].matchList?[indexPath.row], isLive: false)
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
}

extension FinishedLiveScoreViewController {
    
    @objc private func getFinsishedMatches() {
        showProgressHud()
        
        let currentDate = Date()
        let startDate = Calendar.current.date(byAdding: .hour, value: -8, to: currentDate)?.getFormattedDateString() ?? ""
        let endDate = Calendar.current.date(byAdding: .hour, value: -1, to: currentDate)?.getFormattedDateString() ?? ""
        
        let url = API.Leagues.Football.fixtures + "&from=\(startDate)&to=\(endDate)"
        APIGeneric<LiveScoreResponseModel>.fetchRequest(apiURL: url) { [weak self] (response) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                self.refreshControl.endRefreshing()

                switch response {
                case .success(let result):
                    let success = ResponseType(rawValue: result.success ?? ResponseType.error.rawValue)
                    switch success {
                    case .success:
                        let finishedScoreLeagueList = (result.result ?? []).filter({$0.eventStatus?.lowercased() == "finished"})
                        self.finishedScoreLeagueList = Helper.groupLiveScoreMatchesByLeagues(list: finishedScoreLeagueList)
                        self.filteredList = self.finishedScoreLeagueList
                        self.delegate?.updateButtonTitle(title: "Finished (\(self.filteredList.count))", type: .finished)
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

extension FinishedLiveScoreViewController : LiveScoreViewControllerDelegate {
    func searchFieldDidChange(str: String) {
        if str.isEmpty {
            filteredList = finishedScoreLeagueList
        } else {
            let list = finishedScoreLeagueList.filter({
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
        
        self.delegate?.updateButtonTitle(title: "Finished (\(filteredList.count))", type: .finished)
        tableView.reloadData()
    }
}
