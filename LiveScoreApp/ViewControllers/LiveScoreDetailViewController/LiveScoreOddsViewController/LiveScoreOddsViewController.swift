//
//  LiveScoreOddsViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

struct OddsModel {
    let sectionTitle: String
    let titleList: [String]
    let valueList : [String]
}

struct LiveScoreOddsMatchModel {
    static func == (lhs: LiveScoreOddsMatchModel, rhs: LiveScoreOddsMatchModel) -> Bool {
        return lhs.oddName == rhs.oddName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(oddName)
    }

    var oddName: String?
    var oddValue: LiveOddModel?
    
    init(oddName: String? = nil, oddValue: LiveOddModel? = nil) {
        self.oddName = oddName
        self.oddValue = oddValue
    }
}

class LiveScoreOddsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    private var itemList = [OddsModel]()
    private var oddsList : [LiveScoreOddsMatchModel] = []
    var liveScoreModel : LiveScoreModel?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: LiveScoreOddsTableViewCell.className, bundle: nil), forCellReuseIdentifier: LiveScoreOddsTableViewCell.className)
        setupData()
    }
    
    private func setupData() {
        let titleList = ["Type", "Value", "Suspended"]
        let valueList = ["Home", "501", "Yes"]
        let sectionTitle = "1x2 - 20 minutes"
        
        itemList.append(OddsModel(sectionTitle: sectionTitle, titleList: titleList, valueList: valueList))
        itemList.append(OddsModel(sectionTitle: sectionTitle, titleList: titleList, valueList: valueList))
        itemList.append(OddsModel(sectionTitle: sectionTitle, titleList: titleList, valueList: valueList))
        
        tableView.reloadData()
    }
    
    func updateInformation(liveScoreModel : LiveScoreModel?) {
        self.liveScoreModel = liveScoreModel
        getLiveOdds()
    }

}

extension LiveScoreOddsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return oddsList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreOddsHeaderView.view()
        view.configure(title: oddsList[section].oddName)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oddsList[section].oddValue == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreOddsTableViewCell.className, for: indexPath) as! LiveScoreOddsTableViewCell
        cell.configureCell(model: oddsList[indexPath.section].oddValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}

extension LiveScoreOddsViewController {
    private func getLiveOdds() {
        showProgressHud()
        
        let matchId = self.liveScoreModel?.eventKey ?? 0
        let url = API.Leagues.Football.liveOdds + "&matchId=\(matchId)"
        APIGeneric<LiveOddsResponseModel>.fetchRequest(apiURL: url) { [weak self] (response) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch response {
                case .success(let result):
                    let success = ResponseType(rawValue: result.success ?? ResponseType.error.rawValue)
                    switch success {
                    case .success:
                        let matchIdStr = "\(matchId)"
                        if let resultList = result.result, let list = resultList[matchIdStr] {
                            self.oddsList = Helper.groupOddsScoreMatchesByMatch(list: list)
                        }
                        self.noDataLabel.isHidden = !self.oddsList.isEmpty
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
