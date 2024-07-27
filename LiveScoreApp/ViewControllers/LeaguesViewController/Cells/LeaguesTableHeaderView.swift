//
//  LeaguesTableHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 27/07/2024.
//

import UIKit

class LeaguesTableHeaderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static func view() -> LeaguesTableHeaderView {
        let v = Bundle.main.loadNibNamed(LeaguesTableHeaderView.className, owner: nil, options: nil)?.first as! LeaguesTableHeaderView
        v.setup()
        return v
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var leagueList = [LeagueModel]()
    
    func setup() {
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: 350)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(UINib(nibName: TopLeaguesCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: TopLeaguesCollectionViewCell.className)
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
        let size = CGSize(width: 130, height: 170)
        return size
    }
    
}
