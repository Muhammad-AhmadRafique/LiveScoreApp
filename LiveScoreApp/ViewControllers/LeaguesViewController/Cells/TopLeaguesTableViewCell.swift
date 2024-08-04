//
//  TopLeaguesTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class TopLeaguesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var leagueList = [LeagueModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "top_leagues".localizedString().capitalized
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(UINib(nibName: TopLeaguesCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: TopLeaguesCollectionViewCell.className)
    }
    func setup() {
//        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: 350)
        
    }
    
    func configure(leagues: [LeagueModel]) {
        
        leagueList = leagues
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopLeaguesCollectionViewCell.className, for: indexPath) as! TopLeaguesCollectionViewCell
        cell.configureCell(league: leagueList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leagueList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 130, height: collectionView.frame.height)
        return size
    }
    
}
