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
//        Observable.merge(
//            AdManager.shared.nativeAd.nativeAds$,
//            subscriptionSucceed.map { isPurchased in
//                if isPurchased {
//                    return [GADNativeAd]()
//                } else {
//                    return AdManager.shared.nativeAd.nativeAds
//                }
//            }
//        ).asObservable()
//        .subscribe({ads in
//            self.postData.accept(mergeData(self.posts, with: AdManager.shared.nativeAd.nativeAds))
//        }).disposed(by: bag)
    }
    
    
    func fetchData(isRefresh: Bool){
        
//        subcriptionMergeAds(
//            withDataRelay: remoteRepository.getPosts().asObservable(),
//            offset: MergeOffset(pad: 6, phone: 4))
//        .subscribe(onNext: {[weak self] data in
//            guard let self = self else { return }
//            self.passwords = data.items
//            self.loadingData.accept(false)
//            self.passwordData.accept(data.mergeList)
//            self.emptyData.accept(data.mergeList.isEmpty)
//        }).disposed(by: bag)
//        
//        remoteRepository.getPosts()
//            .do(onSuccess: {response in
//                if isRefresh {
//                    self.posts.removeAll()
//                }
//                self.posts.append(contentsOf: response)
//                self.postData.accept(mergeData(self.posts, with: AdManager.shared.nativeAd.nativeAds))
//            })
//            .trackError(errorTracker)
//            .trackActivity(indicatorLoading)
//            .subscribe()
//            .disposed(by: bag)
    }
    
    func itemSelected(_ item: Post) {
        print(">>>>>> Selected: \(item.title)")
    }
}
