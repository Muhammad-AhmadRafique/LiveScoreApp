//
//  LiveScoreDetailViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 20/07/2024.
//

import UIKit

class LiveScoreDetailCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.roundSpecificCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 3)
    }
    
    func configureCell(name: String, isSelected: Bool) {
        nameLabel.text = name
        lineView.alpha = isSelected ? 1 : 0
    }
}

enum LiveScoreItem: String {
    case odds = "Odds"
    case stats = "Stats"
    case lineup = "Lineup"
    case H2H = "H2H"
    case standings = "Standings"
}

class LiveScoreDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    
    private let list : [LiveScoreItem] = [
        LiveScoreItem.odds,
        LiveScoreItem.stats,
        LiveScoreItem.lineup,
        LiveScoreItem.H2H,
        LiveScoreItem.standings
    ]
    private var selectedItem: LiveScoreItem?
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var viewControllerList = [UIViewController]()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        selectedItem = list.first
        setupPageController()
    }
    
    //MARK: - Helper Methods
    private func setupPageController() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.pageController!.view)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.frame = CGRect(x: mainView.frame.origin.x, y: self.mainView.frame.origin.y, width: self.mainView.frame.width, height: self.mainView.frame.height)
        
        pageController?.view.translatesAutoresizingMaskIntoConstraints  = false
        pageController?.view.topAnchor.constraint(equalTo: self.mainView.topAnchor).isActive = true
        pageController?.view.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor).isActive = true
        pageController?.view.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        pageController?.view.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        
        let control1 = Storyboards.MAIN.instantiateViewController(withIdentifier: LiveScoreOddsViewController.className) as! LiveScoreOddsViewController
        let control2 = Storyboards.MAIN.instantiateViewController(withIdentifier: LiveScoreStatsViewController.className) as! LiveScoreStatsViewController
        let control3 = Storyboards.MAIN.instantiateViewController(withIdentifier: LiveScoreLineupViewController.className) as! LiveScoreLineupViewController
        let control4 = Storyboards.MAIN.instantiateViewController(withIdentifier: LiveScoreHeadtoHeadViewController.className) as! LiveScoreHeadtoHeadViewController
        let control5 = Storyboards.MAIN.instantiateViewController(withIdentifier: LiveScoreStandingViewController.className) as! LiveScoreStandingViewController

//        control1.parentNavigationController = self.navigationController
//        control2.parentNavigationController = self.navigationController
//        control3.parentNavigationController = self.navigationController

        self.viewControllerList.append(control1)
        self.viewControllerList.append(control2)
        self.viewControllerList.append(control3)
        self.viewControllerList.append(control4)
        self.viewControllerList.append(control5)

        if let firstVC = viewControllerList.first as? LiveScoreOddsViewController {
            self.pageController?.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension LiveScoreDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveScoreDetailCollectionViewCell.className, for: indexPath) as! LiveScoreDetailCollectionViewCell
        let item = list[indexPath.row]
        cell.configureCell(name: item.rawValue, isSelected: selectedItem == item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 80, height: collectionView.frame.height)
        return size
    }
    
    func getCurrentItemIndex() -> Int {
        guard let index = list.firstIndex(where: {$0 == selectedItem}) else {
            return -1
        }
        return index
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if list[indexPath.row] == selectedItem {
            return
        }
        let direction : UIPageViewController.NavigationDirection = indexPath.row < getCurrentItemIndex()     ? .reverse : .forward
        let controller = viewControllerList[indexPath.row]
        self.pageController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
        selectedItem = list[indexPath.row]
        collectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
    }
}

extension LiveScoreDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func indexOf(_ controller : UIViewController) -> Int? {
        guard let index = viewControllerList.firstIndex(of: controller) else {
            return nil
        }
        return index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = indexOf(viewController) else {
            return nil
        }
        if viewControllerIndex <= 0 {
            return nil
        } else {
            return self.viewControllerList[viewControllerIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = indexOf(viewController) else {
            return nil
        }
        if (viewControllerIndex + 1 >= viewControllerList.count) {
            return nil
        }
        return self.viewControllerList[viewControllerIndex + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            
            guard let lastViewController = pageViewController.viewControllers?.first else {
                return
            }
            if lastViewController.isKind(of: LiveScoreOddsViewController.self) {
                selectedItem = list[0]
            } else if lastViewController.isKind(of: LiveScoreStatsViewController.self) {
                selectedItem = list[1]
            } else if lastViewController.isKind(of: LiveScoreLineupViewController.self) {
                selectedItem = list[2]
            } else if lastViewController.isKind(of: LiveScoreHeadtoHeadViewController.self) {
                selectedItem = list[3]
            } else if lastViewController.isKind(of: LiveScoreStandingViewController.self) {
                selectedItem = list[4]
            }
        
            let index = getCurrentItemIndex()
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
           
        }
    }
}
