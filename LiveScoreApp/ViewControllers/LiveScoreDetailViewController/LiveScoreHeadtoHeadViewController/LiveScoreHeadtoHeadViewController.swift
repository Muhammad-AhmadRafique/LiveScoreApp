//
//  LiveScoreHeadtoHeadViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

enum LiveScoreH2HType : Int {
    case h2h = 0
    case home = 1
    case away = 2
}

struct LiveScoreH2HLeagueModel : Hashable {
    static func == (lhs: LiveScoreH2HLeagueModel, rhs: LiveScoreH2HLeagueModel) -> Bool {
        return lhs.leagueKey == rhs.leagueKey
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(leagueKey)
    }
    
    var leagueKey: Int?
    var leagueName: String?
    var matchList: [H2HModel]?
    var leagueLogo : String?
    
    init(leagueKey: Int? = nil, leagueName: String? = nil, matchList: [H2HModel]? = nil) {
        self.leagueKey = leagueKey
        self.leagueName = leagueName
        self.matchList = matchList
    }
}

class LiveScoreHeadtoHeadViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    var liveScoreModel : LiveScoreModel?
    private var h2hLeagueList = [LiveScoreH2HLeagueModel]()
    private var homeH2HLeagueList = [LiveScoreH2HLeagueModel]()
    private var awayH2HLeagueList = [LiveScoreH2HLeagueModel]()
    
    private var selectedType : LiveScoreH2HType = .h2h

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: LiveScoreHeadToHeadTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreHeadToHeadTableViewCell.className)
        noDataLabel.text = "no_data_available".localizedString().capitalized
        segmentControl.setTitle("h2h".localizedString().capitalized, forSegmentAt: 0)
        segmentControl.setTitle("home".localizedString().capitalized, forSegmentAt: 1)
        segmentControl.setTitle("away".localizedString().capitalized, forSegmentAt: 2)
        selectedType = .h2h
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        selectedType = LiveScoreH2HType(rawValue: sender.selectedSegmentIndex) ?? .h2h
        self.setupNoDataLabel()
        tableView.reloadData()
    }

    func updateInformation(liveScoreModel : LiveScoreModel?) {
        self.liveScoreModel = liveScoreModel
        getH2HDetail()
    }

}

extension LiveScoreHeadtoHeadViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedType {
        case .h2h:
            return self.h2hLeagueList.count
        case .home:
            return self.homeH2HLeagueList.count
        case .away:
            return self.awayH2HLeagueList.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreHeadToHeadHeaderView.view()
        var name = ""
        switch selectedType {
        case .h2h:
            name = self.h2hLeagueList[section].leagueName ?? ""
        case .home:
            name = self.homeH2HLeagueList[section].leagueName ?? ""
        case .away:
            name = self.awayH2HLeagueList[section].leagueName ?? ""
        }
        view.configure(name: name)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedType {
        case .h2h:
            return h2hLeagueList[section].matchList?.count ?? 0
        case .home:
            return homeH2HLeagueList[section].matchList?.count ?? 0
        case .away:
            return awayH2HLeagueList[section].matchList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreHeadToHeadTableViewCell.className, for: indexPath) as! LiveScoreHeadToHeadTableViewCell
        switch selectedType {
        case .h2h:
            cell.configureCell(model: h2hLeagueList[indexPath.section].matchList?[indexPath.row])
        case .home:
            cell.configureCell(model: homeH2HLeagueList[indexPath.section].matchList?[indexPath.row])
        case .away:
            cell.configureCell(model: awayH2HLeagueList[indexPath.section].matchList?[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}

extension LiveScoreHeadtoHeadViewController {
    private func setupNoDataLabel() {
        switch selectedType {
        case .h2h:
            noDataLabel.isHidden = !h2hLeagueList.isEmpty
        case .home:
            noDataLabel.isHidden = !homeH2HLeagueList.isEmpty
        case .away:
            noDataLabel.isHidden = !awayH2HLeagueList.isEmpty
        }
    }
    
    private func getH2HDetail() {
        showProgressHud()
        
        let firstTeamId = liveScoreModel?.homeTeamKey ?? 0
        let secondTeamId = liveScoreModel?.awayTeamKey ?? 0
        let url = API.Leagues.Football.h2h + "&firstTeamId=\(firstTeamId)&secondTeamId=\(secondTeamId)"
        APIGeneric<LiveScoreH2HResponseModel>.fetchRequest(apiURL: url) { [weak self] (response) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch response {
                case .success(let result):
                    let success = ResponseType(rawValue: result.success ?? ResponseType.error.rawValue)
                    switch success {
                    case .success:
                        let h2hList = result.result?.h2H ?? []
                        let homeList = result.result?.firstTeamResults ?? []
                        let awayList = result.result?.secondTeamResults ?? []
                        
                        self.h2hLeagueList = Helper.groupH2HScoreMatchesByLeagues(list: h2hList)
                        self.homeH2HLeagueList = Helper.groupH2HScoreMatchesByLeagues(list: homeList)
                        self.awayH2HLeagueList = Helper.groupH2HScoreMatchesByLeagues(list: awayList)
                        
                        self.setupNoDataLabel()
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
