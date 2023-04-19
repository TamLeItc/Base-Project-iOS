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
    
    override func registerLisenBusEvent() {
        super.registerLisenBusEvent()
        Observable.merge(
            AdsHelper.shared.nativeAd.nativeAds$,
            subscriptionSucceed.map { isPurchased in
                if isPurchased {
                    return [GADNativeAd]()
                } else {
                    return AdsHelper.shared.nativeAd.nativeAds
                }
            }
        ).asObservable()
        .subscribe({ads in
            self.postData.accept(mergeData(self.posts, with: AdsHelper.shared.nativeAd.nativeAds))
        }).disposed(by: bag)
    }
    
    
    func fetchData(isRefresh: Bool){
        remoteRepository.getPosts()
            .do(onSuccess: {response in
                if isRefresh {
                    self.posts.removeAll()
                }
                self.posts.append(contentsOf: response)
                self.postData.accept(mergeData(self.posts, with: AdsHelper.shared.nativeAd.nativeAds))
            })
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .subscribe()
            .disposed(by: bag)
    }
    
    func itemSelected(_ item: Post) {
        print(">>>>>> Selected: \(item.title)")
    }
}
