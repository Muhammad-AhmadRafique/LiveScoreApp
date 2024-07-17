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
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: NewsTableViewCell.className, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.className)
    }
    
}

extension NewsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NewsHeaderView.view()
        view.configure(title: "Latest updates", font: .systemFont(ofSize: 25, weight: .bold))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.className, for: indexPath) as! NewsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
