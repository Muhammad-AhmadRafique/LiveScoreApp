//
//  TopLeaguesTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class TopLeaguesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(UINib(nibName: TopLeaguesCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: TopLeaguesCollectionViewCell.className)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopLeaguesCollectionViewCell.className, for: indexPath) as! TopLeaguesCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 130, height: collectionView.frame.height)
        return size
    }
    
}
