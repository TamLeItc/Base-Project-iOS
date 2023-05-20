//
//  DemoLoadDataVM.swift
//  BaseProject
//
//  Created by Tam Le on 8/23/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMobileAds

class DemoLoadDataVM: BaseVM {
    
    let postData = PublishData<[ItemOrAd<Post>]>()
    
    private var posts: [Post] = []
    
    private let postRelay = BehaviorRelay<[Post]>(value: [])
    
    override init() {
        super.init()
        
        subcriptionMergeAds(
            withDataRelay: postRelay,
            offset: MergeOffset(pad: 6, phone: 4)
        )
        .subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.posts.append(contentsOf: data.items)
            self.postData.accept(data.mergeList)
        }).disposed(by: bag)
    }
    
    func fetchData(isRefresh: Bool){
        if isRefresh {
            self.posts.removeAll()
        }
        
        remoteRepository.getPosts()
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .bind(to: postRelay)
            .disposed(by: bag)
    }
    
    func itemSelected(_ item: Post) {
        print(">>>>>> Selected: \(item.title)")
    }
}
