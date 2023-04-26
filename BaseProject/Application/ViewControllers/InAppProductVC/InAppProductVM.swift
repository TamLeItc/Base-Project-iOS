//
//  InAppProductVM.swift
//  BaseProject
//
//  Created by Tam Le on 8/23/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit
import RxSwift
import RxCocoa
import RxDataSources

protocol InAppProductVMState {
    func didFetchData()
    func didBuyProduct()
    func didRestore()
}

class InAppProductVM: BaseVM {
    
    let inAppProductData = PublishData<[IAPProduct]>()
    let errorGetInAppMessage = PublishData<String>()
    let purchased = PublishData<String>()
    let loading = PublishData<Bool>()
    
    @Inject
    var eventLogger: EventLogger
    
    private var products = [IAPProduct]()
    private var skProducts = [IAPSKProduct]()
    
    private var selectedProduct: IAPProduct? = nil
    
    private func fetchData() {
        
        loading.accept(true)
        
        skProducts = [
            IAPSKProduct(name: "life_time".localized, id: Configs.InAppPurcharse.oneTime, type: .nonConsumable),
            IAPSKProduct(name: "month".localized, id: Configs.InAppPurcharse.monthly, type: .autoRenewable),
            IAPSKProduct(name: "year".localized, id: Configs.InAppPurcharse.yearly, type: .autoRenewable)
        ]
        
        let productIds = Set<String>(self.skProducts.map({$0.id}))
        SwiftyStoreKit.retrieveProductsInfo(productIds) { [weak self]  result in
            guard let self = self else { return }
            if let error = result.error{
                self.loading.accept(false)
                self.errorGetInAppMessage.accept(error.localizedDescription)
                Logger.error(error.localizedDescription)
                return
            }
            
            let retrievedProducts = result.retrievedProducts.sorted(by: { $0.price.compare($1.price) == .orderedAscending  })
            
            var haveFreeTrialProduct = false
            var haveLifeTimeProduct = false
            self.products.append(contentsOf: retrievedProducts.map{ (skProduct: SKProduct) -> IAPProduct in
                let product = skProduct.toProduct()
                let sku = self.skProducts.first(where: {$0.id == product.skProduct.productIdentifier})
                product.type = sku?.type
                product.name = sku?.name ?? ""
                
                if product.skProduct.introductoryPrice != nil && product.skProduct.introductoryPrice!.paymentMode  == .freeTrial {
                    haveFreeTrialProduct = true
                    product.index = 0
                }
                
                return product
            })
            
            for product in self.products {
                if product.type == .nonRenewing {
                    if haveFreeTrialProduct {
                        product.index = 1
                    } else {
                        product.index = 0
                    }
                    haveLifeTimeProduct = true
                    product.isSelected = true
                    self.selectedProduct = product
                } else if product.index == -1 {
                    product.index = 2
                }
            }
            
            self.products.sort(by: { $0.index < $1.index })
            if !haveLifeTimeProduct {
                self.products.first?.isSelected = true
                self.selectedProduct = self.products.first
            }
            
            self.loading.accept(false)
            self.inAppProductData.accept(self.products)
        }
    }
    
    func productSelected(_ product: IAPProduct) {
        selectedProduct = product
        products.forEach({item in
            if item.skProduct.productIdentifier == product.skProduct.productIdentifier {
                item.isSelected = true
            } else {
                item.isSelected = false
            }
        })
        inAppProductData.accept(products)
    }
    
    private func buyProduct() {
        guard let product = selectedProduct else {
            return
        }
        
        loading.accept(true)
        if product.type == .nonRenewing {
            IAPManager.shared().handlePurchase(product: product) { (message, purchaseResult) in
                self.loading.accept(false)
                switch purchaseResult {
                case .purchased?:
                    self.purchased.accept(message)
                    self.eventLogger.logEventInApp(product, type: .inapp)
                default:
                    self.messageData.accept(AlertMessage(type: .error, description: message))
                    break
                }
            }
        } else {
            IAPManager.shared().handleSubscription(product: product) { (message, purchaseResult) in
                self.loading.accept(false)
                switch purchaseResult {
                case .purchased?:
                    self.purchased.accept(message)
                    self.eventLogger.logEventInApp(product, type: .subcription)
                default:
                    self.messageData.accept(AlertMessage(type: .error, description: message))
                    break
                }
            }
        }
    }
    
    private func restore() {
        loading.accept(true)
        IAPManager.shared().purchaseRestore(){ (message, purchaseResult) in
            self.loading.accept(false)
            switch purchaseResult {
            case .purchased?:
                self.purchased.accept(message)
                self.eventLogger.logEventInApp(nil, type: .restore)
            default:
                self.messageData.accept(AlertMessage(type: .error, description: message))
                break
            }
        }
    }
}

extension InAppProductVM: InAppProductVMState {
    func didFetchData() {
        fetchData()
    }
    
    func didBuyProduct() {
        buyProduct()
    }
    
    func didRestore() {
        restore()
    }
}
