//
//  LeaguesViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

protocol LeaguesViewControllerDelegate : UIViewController {
    func searchFieldDidChange(str: String)
}

class LeaguesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var footballButton: UIButton!
    @IBOutlet weak var footballLineView: UIView!
    
    @IBOutlet weak var basketballButton: UIButton!
    @IBOutlet weak var basketballLineView: UIView!
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var viewControllerList = [UIViewController]()
        
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.addBorder(with: .systemGray3, width: 1.0)
        setupPageController()
        
        footballLineView.roundedCorners(radius: 2)
        basketballLineView.roundedCorners(radius: 2)
        updateTopButtons(footballSelected: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Helper Methods
    private func updateTopButtons(footballSelected: Bool) {
        footballButton.setTitleColor(footballSelected ? Colors.selectedColor : Colors.darkGray, for: .normal)
        basketballButton.setTitleColor(footballSelected ? Colors.darkGray : Colors.selectedColor, for: .normal)
        footballLineView.backgroundColor = footballSelected ? Colors.selectedColor : Colors.lightGray
        basketballLineView.backgroundColor = footballSelected ? Colors.lightGray : Colors.selectedColor

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
        
        let control1 = Storyboards.MAIN.instantiateViewController(withIdentifier: FootballLeaguesViewController.className) as! FootballLeaguesViewController
        control1.delegate = self
//        let control2 = Storyboards.MAIN.instantiateViewController(withIdentifier: BasketballLeaguesViewController.className) as! BasketballLeaguesViewController

        self.viewControllerList.append(control1)
//        self.viewControllerList.append(control2)
        if let firstVC = viewControllerList.first as? FootballLeaguesViewController {
            self.pageController?.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextPage() {
        guard let currentIndex = (pageController?.viewControllers?.first as? PageItem)?.pageIndex else { return }
        let nextIndex = currentIndex + 1
        guard nextIndex < viewControllerList.count else { return }
        let nextVC = viewControllerList[nextIndex]
        self.pageController?.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        updateTopButtons(footballSelected: false)
    }
    
    // Navigate to the previous page
    @IBAction func previousPage() {
        guard let currentIndex = (pageController?.viewControllers?.first as? PageItem)?.pageIndex else { return }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return }
        let previousVC = viewControllerList[previousIndex]
        self.pageController?.setViewControllers([previousVC], direction: .reverse, animated: true, completion: nil)
        updateTopButtons(footballSelected: true)
    }
    
    @IBAction func searchFieldDidChange(_ sender: UITextField) {
        if let vc = pageController?.viewControllers?.first as? LeaguesViewControllerDelegate {
            vc.searchFieldDidChange(str: sender.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
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
        return (viewControllerIndex <= 0) ? nil : self.viewControllerList[viewControllerIndex - 1]
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
            
            guard let lastViewController = previousViewControllers.first else {
                return
            }
            if lastViewController.isKind(of: FootballLeaguesViewController.self) {
                updateTopButtons(footballSelected: false)
            } else {
                updateTopButtons(footballSelected: true)
            }
        }
    }
}

extension LeaguesViewController : FootballLeaguesViewControllerDelegate {
    func hideKeyboard() {
        searchField.resignFirstResponder()
    }
}
