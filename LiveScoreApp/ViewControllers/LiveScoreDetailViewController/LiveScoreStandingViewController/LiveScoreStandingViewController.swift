//
//  LiveScoreStandingViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

enum LiveScoreStandingType : Int {
    case all = 0
    case home = 1
    case away = 2
}

class LiveScoreStandingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    var liveScoreModel : LiveScoreModel?
    private var allStandingList = [LiveScoreStandingModel]()
    private var homeStandingList = [LiveScoreStandingModel]()
    private var awayStandingList = [LiveScoreStandingModel]()
    private var selectedItem : LiveScoreStandingType = .all

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: LiveScoreStandingTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreStandingTableViewCell.className)
        selectedItem = .all
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        selectedItem = LiveScoreStandingType(rawValue: sender.selectedSegmentIndex) ?? .home
        tableView.reloadData()
    }

    func updateInformation(liveScoreModel : LiveScoreModel?) {
        self.liveScoreModel = liveScoreModel
        getStandingDetail()
    }

    
}

extension LiveScoreStandingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreStandingHeaderView.view()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch selectedItem {
        case .all:
            return allStandingList.count == 0 ? 0 : 30
        case .home:
            return homeStandingList.count == 0 ? 0 : 30
        case .away:
            return awayStandingList.count == 0 ? 0 : 30
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedItem {
        case .all:
            return allStandingList.count
        case .home:
            return homeStandingList.count
        case .away:
            return awayStandingList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreStandingTableViewCell.className, for: indexPath) as! LiveScoreStandingTableViewCell
        switch selectedItem {
        case .all:
            cell.configureCell(model: allStandingList[indexPath.row])
        case .home:
            cell.configureCell(model: homeStandingList[indexPath.row])
        case .away:
            cell.configureCell(model: awayStandingList[indexPath.row])
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}

extension LiveScoreStandingViewController {
    private func getStandingDetail() {
        showProgressHud()
        
        let leagueId = liveScoreModel?.leagueKey ?? 0
        let url = API.Leagues.Football.standings + "&leagueId=\(leagueId)"
        APIGeneric<LiveScoreStandingResponseModel>.fetchRequest(apiURL: url) { [weak self] (response) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch response {
                case .success(let result):
                    let success = ResponseType(rawValue: result.success ?? ResponseType.error.rawValue)
                    switch success {
                    case .success:
                        self.allStandingList = result.result?.total ?? []
                        self.homeStandingList = result.result?.home ?? []
                        self.awayStandingList = result.result?.away ?? []
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
