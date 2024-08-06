//
//  NewsUpdatedViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 04/08/2024.
//

import UIKit

class NewsUpdatedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var liveScoreLeagueList = [LiveScoreModel]()

    private var maxHotMatchesCount = 5

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: NewsHotMatchesTableViewCell.className, bundle: nil), forCellReuseIdentifier: NewsHotMatchesTableViewCell.className)
        tableView.tableHeaderView = NewsTableHeaderView.view()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        getUpcomingMatches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
}

extension NewsUpdatedViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NewsHeaderView.view()
        view.configure(title: "hot_matches".localizedString(), font: .systemFont(ofSize: 20, weight: .bold))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsHotMatchesTableViewCell.className, for: indexPath) as! NewsHotMatchesTableViewCell
        cell.configureCell(liveScoreModelList: liveScoreLeagueList)
        cell.matchTapped = { match in
            Router.shared.openLiveScoreDetailViewController(model: match, controller: self.navigationController)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = liveScoreLeagueList.count
        if count % 2 == 0 {
            let perRowItems = count / 2
            return CGFloat(202 * perRowItems)
        } else {
            let perRowItems = (count / 2) + 1
            return CGFloat(202 * perRowItems)
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}

extension NewsUpdatedViewController {
    
    @objc private func getUpcomingMatches() {
        showProgressHud()
        
        let url = API.Leagues.Football.liveScore
        APIGeneric<LiveScoreResponseModel>.fetchRequest(apiURL: url) { [weak self] (response) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch response {
                case .success(let result):
                    let success = ResponseType(rawValue: result.success ?? ResponseType.error.rawValue)
                    switch success {
                    case .success:
                        var list = (result.result ?? []).filter({$0.eventStatus?.lowercased() != "finished"})
                        list = Array(list.prefix(self.maxHotMatchesCount))
                        let updatedList = Helper.groupLiveScoreMatchesByLeagues(list: list)
                        updatedList.forEach { model in
                            if let firstMatch = model.matchList?.first {
                                self.liveScoreLeagueList.append(firstMatch)
                            }
                        }
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
