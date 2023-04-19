//
//  BasePageVM.swift
//  RepostInsta
//
//  Created by Tam Le on 22/09/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation

class BasePageVM: BaseVM {
    
    let changePage = PublishData<Int>()
    
    override func registerLisenBusEvent() {
        super.registerLisenBusEvent()
        
        RxBus.shared
            .asObservable(event: BusEvents.ChangePage.self)
            .subscribe(onNext: {[weak self] event in
                guard let self = self else { return }
                self.changePage.accept(event.page)
            }).disposed(by: bag)
    }
}
