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

class LiveScoreOddsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var itemList : [OddsModel] = []
    
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

}

extension LiveScoreOddsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LiveScoreOddsHeaderView.view()
        view.configure(title: itemList[section].sectionTitle)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList[section].titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveScoreOddsTableViewCell.className, for: indexPath) as! LiveScoreOddsTableViewCell
        let title = itemList[indexPath.section].titleList[indexPath.row]
        let value = itemList[indexPath.section].valueList[indexPath.row]
        cell.configureCell(title: title, value: value)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
    }
}
