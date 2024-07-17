//
//  NewsDetailViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News Detail"
        tableView.register(UINib(nibName: NewsDetailTableViewCell.className, bundle: nil), forCellReuseIdentifier: NewsDetailTableViewCell.className)
    }

}

extension NewsDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsDetailTableViewCell.className, for: indexPath) as! NewsDetailTableViewCell
        return cell
    }
}
