//
//  NewsHoteMatchesTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class NewsHotMatchesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var liveScoreModelList: [LiveScoreModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: NewsHotMatchesCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: NewsHotMatchesCollectionViewCell.className)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(liveScoreModelList: [LiveScoreModel]?) {
        let totalCount = liveScoreModelList?.count ?? 0
        if totalCount > 5 {
            for i in 0..<5 {
                if let model = liveScoreModelList?[i] {
                    self.liveScoreModelList?.append(model)
                }
            }
        } else {
            self.liveScoreModelList = liveScoreModelList
        }
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveScoreModelList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsHotMatchesCollectionViewCell.className, for: indexPath) as! NewsHotMatchesCollectionViewCell
        cell.configureCell(model: liveScoreModelList?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 200, height: collectionView.frame.height)
        return size
    }
}
