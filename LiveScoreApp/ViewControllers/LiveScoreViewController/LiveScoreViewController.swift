//
//  LiveScoreViewController.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 16/07/2024.
//

import UIKit

protocol LiveScoreViewControllerDelegate : UIViewController {
    func searchFieldDidChange(str: String)
}

class LiveScoreViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var footballImageView: UIImageView!
    @IBOutlet weak var footballLabel: UILabel!
    @IBOutlet weak var basketballImageView: UIImageView!
    @IBOutlet weak var basketballLabel: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var finishLineView: UIView!
    
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var liveLineView: UIView!
    
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var upcomingLineView: UIView!
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var viewControllerList = [UIViewController]()
    private var selectedIndex = 0
        
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.addBorder(with: .systemGray3, width: 1.0)
        setupPageController()
        
        finishLineView.roundedCorners(radius: 2)
        liveLineView.roundedCorners(radius: 2)
        upcomingLineView.roundedCorners(radius: 2)

        searchField.placeholder = "search".localizedString().capitalized
        updateButtonTitle(title: "finished".localizedString().capitalized, type: .finished)
        updateButtonTitle(title: "live".localizedString().capitalized, type: .live)
        updateButtonTitle(title: "upcoming".localizedString().capitalized, type: .upcoming)
        
        updateTopButtons()
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
    private func updateTopButtons() {
        finishButton.setTitleColor(selectedIndex == 0 ? Colors.selectedColor : Colors.darkGray, for: .normal)
        liveButton.setTitleColor(selectedIndex == 1 ? Colors.selectedColor : Colors.darkGray, for: .normal)
        upcomingButton.setTitleColor(selectedIndex == 2 ? Colors.selectedColor : Colors.darkGray, for: .normal)

        finishLineView.backgroundColor = selectedIndex == 0 ? Colors.selectedColor : Colors.lightGray
        liveLineView.backgroundColor = selectedIndex == 1 ? Colors.selectedColor : Colors.lightGray
        upcomingLineView.backgroundColor = selectedIndex == 2 ? Colors.selectedColor : Colors.lightGray
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
        
        let control1 = Storyboards.MAIN.instantiateViewController(withIdentifier: FinishedLiveScoreViewController.className) as! FinishedLiveScoreViewController
        control1.delegate = self
        let control2 = Storyboards.MAIN.instantiateViewController(withIdentifier: LiveScoreListViewController.className) as! LiveScoreListViewController
        control2.delegate = self
        let control3 = Storyboards.MAIN.instantiateViewController(withIdentifier: UpcomingLiveScoreViewController.className) as! UpcomingLiveScoreViewController
        control3.delegate = self

        control1.parentNavigationController = self.navigationController
        control2.parentNavigationController = self.navigationController
        control3.parentNavigationController = self.navigationController

        self.viewControllerList.append(control1)
        self.viewControllerList.append(control2)
        self.viewControllerList.append(control3)
        if let firstVC = viewControllerList.first as? FinishedLiveScoreViewController {
            self.pageController?.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: - IBActions
    @IBAction func searchFieldDidChange(_ sender: UITextField) {
        if let vc = pageController?.viewControllers?.first as? LiveScoreViewControllerDelegate {
            vc.searchFieldDidChange(str: sender.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
    @IBAction func footballButtonWasPressed(_ sender: Any) {
        footballLabel.textColor = Colors.yellow
        footballImageView.tintColor = Colors.yellow
        
        basketballLabel.textColor = .white
        basketballImageView.tintColor = .white
    }
    
    @IBAction func basketballButtonWasPressed(_ sender: Any) {
        footballLabel.textColor = .white
        footballImageView.tintColor = .white
        
        basketballLabel.textColor = Colors.yellow
        basketballImageView.tintColor = Colors.yellow
    }
    
    @IBAction func finishedButtonWasPressed() {
        if selectedIndex == 0 {
            return
        }
        let controller = viewControllerList[0]
        self.pageController?.setViewControllers([controller], direction: .reverse, animated: true, completion: nil)
        selectedIndex = 0
        updateTopButtons()
    }
    
    // Navigate to the previous page
    @IBAction func liveButtonWasPressed() {
        if selectedIndex == 1 {
            return
        }
        let controller = viewControllerList[1]
        self.pageController?.setViewControllers([controller], direction: selectedIndex == 0 ? .forward : .reverse, animated: true, completion: nil)
        selectedIndex = 1
        updateTopButtons()
    }
    
    @IBAction func upcomingButtonWasPressed() {
        if selectedIndex == 2 {
            return
        }
        let controller = viewControllerList[2]
        self.pageController?.setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        selectedIndex = 2
        updateTopButtons()
    }
    
}

extension LiveScoreViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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
            
            guard let lastViewController = pageViewController.viewControllers?.first else {
                return
            }
            if lastViewController.isKind(of: FinishedLiveScoreViewController.self) {
                selectedIndex = 0
            } else if lastViewController.isKind(of: LiveScoreListViewController.self) {
                selectedIndex = 1
            } else {
                selectedIndex = 2
            }
            updateTopButtons()
        }
    }
}

extension LiveScoreViewController : LiveScoreChildViewControllerDelegate {
    
    func updateButtonTitle(title: String, type: LiveScoreChildType) {
        switch type {
        case .finished:
            finishButton.setTitle(title.capitalized, for: .normal)
        case .live:
            liveButton.setTitle(title.capitalized, for: .normal)
        case .upcoming:
            upcomingButton.setTitle(title.capitalized, for: .normal)
        }
    }

    func hideKeyboard() {
        view.endEditing(true)
    }
}
