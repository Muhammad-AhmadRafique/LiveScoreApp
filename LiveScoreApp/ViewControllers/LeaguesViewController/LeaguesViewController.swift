//
//  LeaguesViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

class LeaguesViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topStackView: UIStackView!
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var viewControllerList = [UIViewController]()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
    
    //MARK: - Helper Methods
    private func setupPageController() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.pageController!.view)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.frame = CGRect(x: 0,y: self.mainView.frame.origin.y, width: self.mainView.frame.width,height: self.mainView.frame.height)
        
        pageController?.view.translatesAutoresizingMaskIntoConstraints  = false
        pageController?.view.topAnchor.constraint(equalTo: self.mainView.topAnchor).isActive = true
        pageController?.view.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor).isActive = true
        pageController?.view.leftAnchor.constraint(equalTo: topStackView.leftAnchor).isActive = true
        pageController?.view.rightAnchor.constraint(equalTo: topStackView.rightAnchor).isActive = true
        
        let control1 = Storyboards.MAIN.instantiateViewController(withIdentifier: FootballLeaguesViewController.className) as! FootballLeaguesViewController
        let control2 = Storyboards.MAIN.instantiateViewController(withIdentifier: BasketballLeaguesViewController.className) as! BasketballLeaguesViewController

        self.viewControllerList.append(control1)
        self.viewControllerList.append(control2)
        if let firstVC = viewControllerList.first as? FootballLeaguesViewController {
            self.pageController?.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
//        self.pageController?.didMove(toParent: self)
    }
    
    @IBAction func nextPage() {
        guard let currentIndex = (pageController?.viewControllers?.first as? PageItem)?.pageIndex else { return }
        let nextIndex = currentIndex + 1
        guard nextIndex < viewControllerList.count else { return }
        let nextVC = viewControllerList[nextIndex]
        self.pageController?.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
    
    // Navigate to the previous page
    @IBAction func previousPage() {
        guard let currentIndex = (pageController?.viewControllers?.first as? PageItem)?.pageIndex else { return }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return }
        let previousVC = viewControllerList[previousIndex]
        self.pageController?.setViewControllers([previousVC], direction: .reverse, animated: true, completion: nil)
    }
    
}

extension LeaguesViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func indexOf(_ controller : UIViewController) -> Int? {
        if let index = viewControllerList.firstIndex(of: controller) {
            return index
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = indexOf(viewController) else {
            return nil
        }
        
//        let previousIndex = viewControllerIndex - 1
//        
//        guard previousIndex >= 0 else {
//            return nil
//        }
//        
//        guard viewControllerList.count > previousIndex else {
//            return nil
//        }
//        
//        return viewControllerList[previousIndex]
//        let index = (viewController as? PageViewControllerItem)?.pageIndex ?? 0
        return (viewControllerIndex <= 0) ? nil : self.viewControllerList[viewControllerIndex - 1] as? UIViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = indexOf(viewController) else {
            return nil
        }
        
//        let nextIndex = viewControllerIndex + 1
//        let orderedViewControllersCount = viewControllerList.count
//        
//        guard orderedViewControllersCount != nextIndex else {
//            return nil
//        }
//        
//        guard orderedViewControllersCount > nextIndex else {
//            return nil
//        }
//        
//        return viewControllerList[nextIndex]
        
        if (viewControllerIndex + 1 >= viewControllerList.count) {
            return nil
        }
        return self.viewControllerList[viewControllerIndex + 1] as? UIViewController
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        guard let firstViewController = viewControllerList.first,
//              let firstViewControllerIndex = indexOf(firstViewController) else {
//            return 0
//        }
//        
//        return firstViewControllerIndex
//    }
}
