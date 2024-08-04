//
//  NewsHoteMatchesTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class NewsHotMatchesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    var liveScoreModelList: [LiveScoreModel] = []
    
    var matchTapped: ((LiveScoreModel) -> ())?
        
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
    
    func configureCell(liveScoreModelList: [LiveScoreModel]) {
        self.liveScoreModelList = liveScoreModelList
        self.noDataLabel.isHidden = !liveScoreModelList.isEmpty
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveScoreModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsHotMatchesCollectionViewCell.className, for: indexPath) as! NewsHotMatchesCollectionViewCell
        cell.configureCell(model: liveScoreModelList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 10
        let size = CGSize(width: width, height: 202)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = liveScoreModelList[indexPath.item]
        matchTapped?(item)
    }
}
