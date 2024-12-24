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
    case odds = "odds"
    case stats = "stats"
    case lineup = "lineup"
    case H2H = "h2h"
    case standings = "standings"
}

class LiveScoreDetailViewController: UIViewController {

    @IBOutlet weak var leagueNameLabel: UILabel!
    
    @IBOutlet weak var homeTeamIcon: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamGoalsLabel: UILabel!
    
    @IBOutlet weak var awayTeamGoalsLabel: UILabel!
    @IBOutlet weak var awayTeamIcon: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    
    var liveScoreModel : LiveScoreModel?
    var apiLiveScoreModel: LiveScoreModel?
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
        navigationItem.title = "match_details".localizedString().capitalized
        let backButton = UIBarButtonItem()
        backButton.title = "back".localizedString().capitalized
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        selectedItem = list.first
        setupPageController()
        getLiveScoreDetail()
    }
    
    //MARK: - Helper Methods
    private func updateInformation() {
        if let model = self.apiLiveScoreModel {
            leagueNameLabel.text = model.leagueName
            
            homeTeamNameLabel.text = model.eventHomeTeam
            awayTeamNameLabel.text = model.eventAwayTeam
            
            let score = model.eventFinalResult ?? ""
            let goalStats = score.getGoalsStats()
            homeTeamGoalsLabel.text = goalStats.home
            awayTeamGoalsLabel.text = goalStats.away
            
            if let url = URL(string: model.homeTeamLogo ?? ""){
                homeTeamIcon.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
            } else {
                homeTeamIcon.image = Icons.RECTANGLE_PLACEHOLDER
            }
            
            if let url = URL(string: model.awayTeamLogo ?? ""){
                awayTeamIcon.sd_setImageWithURLWithFade(url: url, placeholderImage:Icons.RECTANGLE_PLACEHOLDER)
            } else {
                awayTeamIcon.image = Icons.RECTANGLE_PLACEHOLDER
            }
            
        }
    }
    
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
    
    func updateChildData(index: Int) {
        switch index {
        case 0:
            if let vc = self.pageController?.viewControllers?.first as? LiveScoreOddsViewController {
                vc.updateInformation(liveScoreModel: self.apiLiveScoreModel)
            }
        case 1:
            if let vc = self.pageController?.viewControllers?.first as? LiveScoreStatsViewController {
                vc.updateInformation(liveScoreModel: self.apiLiveScoreModel)
            }
        case 2:
            if let vc = self.pageController?.viewControllers?.first as? LiveScoreLineupViewController {
                vc.updateInformation(liveScoreModel: self.apiLiveScoreModel)
            }
        case 3:
            if let vc = self.pageController?.viewControllers?.first as? LiveScoreHeadtoHeadViewController {
                vc.updateInformation(liveScoreModel: self.apiLiveScoreModel)
            }
        case 4:
            if let vc = self.pageController?.viewControllers?.first as? LiveScoreStandingViewController {
                vc.updateInformation(liveScoreModel: self.apiLiveScoreModel)
            }
        default:
            break
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
        cell.configureCell(name: item.rawValue.localizedString().capitalized, isSelected: selectedItem == item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat = 0.0
        switch indexPath.item {
        case 0:
            width = 100
        case 1:
            width = 120
        case 2:
            width = 80
        case 3:
            width = 60
        case 4:
            width = 120
        default:
            width = 0
        }
        let size = CGSize(width: width, height: collectionView.frame.height)
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
        let direction : UIPageViewController.NavigationDirection = indexPath.row < getCurrentItemIndex() ? .reverse : .forward
        let controller = viewControllerList[indexPath.row]
        self.pageController?.setViewControllers([controller], direction: direction, animated: true, completion: {_ in 
            self.updateChildData(index: indexPath.row)
        })
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
            self.updateChildData(index: index)
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
           
        }
    }
}

extension LiveScoreDetailViewController {
    private func getLiveScoreDetail() {
        showProgressHud()
        
        let countryId = liveScoreModel?.eventCountryKey ?? 0
        let leagueId = liveScoreModel?.leagueKey ?? 0
        let matchId = liveScoreModel?.eventKey ?? 0
        let url = API.Leagues.Football.fixtures + "&countryId=\(countryId)&leagueId=\(leagueId)&matchId=\(matchId)"
        APIGeneric<LiveScoreResponseModel>.fetchRequest(apiURL: url) { [weak self] (response) in
            guard let `self`  = self else { return }
            DispatchQueue.main.async {
                self.hideProgressHud()
                switch response {
                case .success(let result):
                    let success = ResponseType(rawValue: result.success ?? ResponseType.error.rawValue)
                    switch success {
                    case .success:
                        let liveScoreLeagueList = result.result ?? []
                        self.apiLiveScoreModel = liveScoreLeagueList.first
                        self.updateInformation()
                        self.updateChildData(index: 0)
//                        (self.pageController?.viewControllers?[1] as? LiveScoreStatsViewController)?.liveScoreModel = liveScoreLeagueList.first
//                        self.pageController.re
//                        self.tableView.reloadData()
                    default:
                        let err = CustomError(description: "Something went wrong, please try again")
                        self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                    }
                case .failure(let failure):
                    let err = CustomError(description: (failure as? CustomError)?.description ?? "")
                    self.alertMessage(title: K.ERROR, alertMessage: err.description ?? "", action: nil)
                }
            }
        }
    }
}
