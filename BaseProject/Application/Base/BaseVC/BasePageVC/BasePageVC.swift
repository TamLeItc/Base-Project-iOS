//
//  BasePageVC.swift
//  BaseProject
//
//  Created by Tam Le on 15/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import GoogleMobileAds

class BasePageVC<VM: BasePageVM>: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let bag = DisposeBag()
    
    lazy var pages: [UIViewController] = []
    
    @Inject
    var viewModel: VM!
    
    var keyboardIsShow = false
    var currentPageIndex = -1
    
    private var autoChangePage = false
    private var timeRepeat: TimeInterval = 4
    
    private let isLoading = BehaviorRelay(value: false)
    
    private var timer: Timer?
    
    var enablePopGestureRecognizer = true
    
    var isLightForegroundStatusBar = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightForegroundStatusBar ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLightForegroundStatusBar = AppDelegate.shared().isLightForegroundStatusBar
        
        view.isUserInteractionEnabled = true
        dataSource = self
        delegate = self
        
        createDataSource()
        initViews()
        addEventForViews()
        binViewModel()
        
        if pages.isNotEmpty {
            handleUIChangePage(page: 0)
        }
        
        print("viewDidLoad :: >>>> \(String(describing: self)) <<<<")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setupAutoChangePage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Disable/Enable swipe left to back
        navigationController?.interactivePopGestureRecognizer?.isEnabled = enablePopGestureRecognizer
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        timer?.invalidate()
    }
    
    func createDataSource() { }
    
    /**
     base setup views
     setup background, foreground corner, border, shadow
     setup textColor, tintColor
     register cell
     e.t.c
     */
    func initViews() { }
    
    /**
     setup rx action
     setup gesture
     e.t.c
     */
    func addEventForViews() { }
    
    /**
     Listener Rx from ViewModel
     */
    func binViewModel() {
        viewModel.indicatorLoading.asObservable().bind(to: isLoading).disposed(by: bag)
        
        isLoading.subscribe(onNext: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = $0
        }).disposed(by: bag)
        
        viewModel.changePage
            .subscribe(onNext: {[weak self] page in
                guard let self = self else { return }
                self.handleUIChangePage(page: page)
                self.setupAutoChangePage()
            }).disposed(by: bag)
    }
    
    func pageChanged(index: Int) {
        
    }
    
    /**
     When VC cannot deinit
     You should use this function when dismiss or popBack Viewcontroller to clear references, data,...
    */
    func clearAll() {
        
    }
    
    @objc func keyboardWillHide() {
        keyboardIsShow = true
    }
    
    @objc func keyboardWillShow() {
        keyboardIsShow = false
    }
    
    deinit {
        print("deinit :: >>>> \(String(describing: self)) <<<<")
    }
    
    //MARK: -- Handle page VC
    func handleUIChangePage(page: Int) {
        
        if page == currentPageIndex { return }
        
        var direction = NavigationDirection.forward
        if page < currentPageIndex {
            direction = .reverse
        }
        
        self.setViewControllers(
            [self.pages[page]],
            direction: direction,
            animated: false)
        
        currentPageIndex = page
        
    }

    //MARK: -- Page VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        guard pages.indices ~= previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        
        guard pages.indices ~= nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: viewController) {
            currentPageIndex = index
            
            pageChanged(index: currentPageIndex)
        }
    }
    
    //MARK: -- auto change page
    private func setupAutoChangePage() {
        if autoChangePage == false {
            return
        }
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: timeRepeat, target: self, selector: #selector(gotoNextPage), userInfo: nil, repeats: true)
    }
    
    @objc private func gotoNextPage() {
        var page = currentPageIndex + 1
        if page >= self.pages.count {
            page = 0
        }
        handleUIChangePage(page: page)
    }
}

extension BasePageVC {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for recognizer in self.gestureRecognizers {
                isEnabled = recognizer.isEnabled
            }
            return isEnabled
        }
        set {
            for recognizer in self.gestureRecognizers {
                recognizer.isEnabled = newValue
            }
        }
    }
}
