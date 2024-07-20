//
//  NewsViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: NewsHotMatchesTableViewCell.className, bundle: nil), forCellReuseIdentifier: NewsHotMatchesTableViewCell.className)
        tableView.register(UINib(nibName: NewsTableViewCell.className, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.className)
        tableView.tableHeaderView = NewsTableHeaderView.view()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

extension NewsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NewsHeaderView.view()
        switch section {
        case 0:
            view.configure(title: "Hot Matches", font: .systemFont(ofSize: 25, weight: .bold))
        default:
            view.configure(title: "Latest Updates", font: .systemFont(ofSize: 25, weight: .bold))
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 9
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsHotMatchesTableViewCell.className, for: indexPath) as! NewsHotMatchesTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.className, for: indexPath) as! NewsTableViewCell
            return cell
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 202
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeSelection()
        if indexPath.section == 1 {
            Router.shared.openNewsDetailViewController(controller: self)
        }
    }
}
