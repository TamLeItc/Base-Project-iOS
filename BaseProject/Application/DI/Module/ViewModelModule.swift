//
//  ViewModelModule.swift
//  i270-locksafe
//
//  Created by Tam Le on 30/03/2023.
//

import Foundation
import Swinject

final class ViewModelModule{
    
    func register(container: Container) {
        container.register(BaseVM.self) { _ in BaseVM()}
        container.register(BasePageVM.self) { _ in BasePageVM()}
        container.register(MainVM.self) { _ in MainVM()}
        container.register(SplashVM.self) { _ in SplashVM()}
        container.register(WebviewVM.self) { _ in WebviewVM()}
        container.register(InAppProductVM.self) { _ in InAppProductVM()}
        
        //Demo
        container.register(DemoSettingVM.self) { _ in DemoSettingVM()}
        container.register(DemoLoadDataVM.self) { _ in DemoLoadDataVM()}
        container.register(DemoMainVM.self) { _ in DemoMainVM()}
        container.register(DemoHomeVM.self) { _ in DemoHomeVM()}
    }
}
