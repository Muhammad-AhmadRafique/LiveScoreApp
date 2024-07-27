//
//  FinishedLiveScoreViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

protocol FinishedLiveScoreViewControllerDelegate: AnyObject {
    func updateFinishedButtonTitle(title: String)
}

class FinishedLiveScoreViewController: UIViewController, PageItem {

    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int = 0
    weak var parentNavigationController: UINavigationController? = nil
    var finishedScoreLeagueList = [LiveScoreLeagueModel]()
    
    weak var delegate: FinishedLiveScoreViewControllerDelegate? = nil
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
        return finishedScoreLeagueList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreHeaderView.view()
        view.configure(leagueLogo: finishedScoreLeagueList[section].leagueLogo, leagueName: finishedScoreLeagueList[section].leagueName)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finishedScoreLeagueList[section].matchList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreTableViewCell.className, for: indexPath) as! LiveScoreTableViewCell
        cell.configureCell(model: finishedScoreLeagueList[indexPath.section].matchList?[indexPath.row], isLive: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        Router.shared.openLiveScoreDetailViewController(controller: parentNavigationController)
    }
}

extension FinishedLiveScoreViewController {
    
    @objc private func getFinsishedMatches() {
        showProgressHud()
        
        let currentDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)?.getFormattedDateString() ?? ""
        let endDate = Calendar.current.date(byAdding: .hour, value: -10, to: currentDate)?.getFormattedDateString() ?? ""
        
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
                        let finishedScoreLeagueList = result.result ?? []
                        self.finishedScoreLeagueList = Helper.groupLiveScoreMatchesByLeagues(list: finishedScoreLeagueList)
                        self.delegate?.updateFinishedButtonTitle(title: "Finished (\(finishedScoreLeagueList.count))")
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
