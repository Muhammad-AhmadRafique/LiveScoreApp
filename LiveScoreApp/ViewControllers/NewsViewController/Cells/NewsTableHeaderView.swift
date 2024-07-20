//
//  NewsTableHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 18/07/2024.
//

import UIKit

class NewsTableHeaderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static func view() -> NewsTableHeaderView {
        let v = Bundle.main.loadNibNamed(NewsTableHeaderView.className, owner: nil, options: nil)?.first as! NewsTableHeaderView
        v.setup()
        return v
    }

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let imageList = [
        UIImage(named: "basketball_news1"),
        UIImage(named: "basketball_news2"),
        UIImage(named: "football_news1"),
        UIImage(named: "football_news2")
    ]
    private var timer: Timer?

    //MARK: - Helper Methods
    private func setup() {
        collectionView.register(UINib(nibName: NewsTableHeaderCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: NewsTableHeaderCollectionViewCell.className)
        setupTimer()
    }
        
    private func setupTimer() {
        pageControl.numberOfPages = imageList.count
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToIndex), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToIndex() {
        if let indexPath = self.collectionView.indexPathsForVisibleItems.first {
            var index = indexPath.row
            let section = indexPath.section
            if index >= self.imageList.count - 1 {
                index = 0
            } else {
                index += 1
            }
            
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: section), at: .left, animated: true)
            self.pageControl.currentPage = index
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsTableHeaderCollectionViewCell.className, for: indexPath) as! NewsTableHeaderCollectionViewCell
        cell.configureCell(image: imageList[indexPath.row]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size
        return CGSize(width: size.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        setupTimer()
    }
}
