//
//  DemoLoadDataVC.swift
//  BaseProject
//
//  Created by Tam Le on 8/23/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift
import RxDataSources
import GoogleMobileAds
import WebKit

class DemoLoadDataVC: BaseVC<DemoLoadDataVM> {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    private var refreshControl = UIRefreshControl()
    
    private var banner: GADBannerView = GADBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enablePopGestureRecognizer = false
        
        viewModel.fetchData(isRefresh: true)
    }
    
    override func initViews() {
        super.initViews()
        
        setupTableView()
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.clearAll()
                self.popVC()
            }).disposed(by: bag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else { return }
            })
            .disposed(by: bag)
        
        tableView.rx
            .modelSelected(ItemOrAd<Post>.self)
            .compactMap { item -> Post? in
                if case .item(let service) = item {
                    return service
                }
                return nil
            }
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                AdManager.shared.intersAd.showAd(self) {
                    self.viewModel.itemSelected(item)
                }
            })
            .disposed(by: bag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.postData.asObservable()
            .map { [SectionModel(model: (), items: $0)] }
            .bind(to: self.tableView.rx.items(dataSource: dataSource.getPostDataSource()))
            .disposed(by: bag)
        
        viewModel.indicatorLoading
            .drive(onNext: {[weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.showLoading() : self.hideLoading()
            })
            .disposed(by: bag)
        
        viewModel.errorTracker
            .drive(onNext: {[weak self] error in
            guard let self = self else { return }
                Logger.error(error.localizedDescription)
                AlertVC.showMessage(self, style: .error, message: "general_error_message".localized)
        }).disposed(by: bag)
        
        viewModel.subscriptionSucceed.subscribe(onNext: {[weak self] isPurchased in
            guard let self = self else { return }
            if isPurchased {
                self.banner.removeFromSuperview()
            }
        }).disposed(by: bag)
    }
    
    override func loadBannerAds() {
        super.loadBannerAds()
        if AdManager.canShowAds {
            banner = addAdmobBanner(topView: tableView)
        } else {
            removeBannerView(banner)
        }
    }
    
    private func setupTableView() {
        tableView.registerCellNib(MediumNativeTableViewCell.self)
        tableView.registerCellNib(DemoCell.self)
        tableView.registerCellNib(LoadmoreCell.self)
        
        //scroll tableview may be not smonth when add refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

extension DemoLoadDataVC {
    @objc func refresh(_ sender: AnyObject) {
        viewModel.fetchData(isRefresh: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.refreshControl.endRefreshing()
        })
    }
}
