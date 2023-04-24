//
//  UIViewController.swift
//  BaseProject
//
//  Created by Tam Le on 8/27/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import MKProgress
import Loaf
import AVFoundation
import Photos

extension UIViewController {
    func showLoading() {
        MKProgress.show()
    }
    
    func hideLoading() {
        MKProgress.hide()
    }
    
    func showToast(
        message: String
    ) {
        Loaf(message, location: .top, sender: self).show()
    }
    
    func showError(_ message: String = "general_error_message".localized, onClick: (() -> Void)? = nil) {
        AlertVC.showMessage(self, style: .error, message: message, onClick: onClick)
    }
    
    func addChildToView(_ child: UIViewController, toView view: UIView) {
        addChild(child)
        child.view.frame = view.bounds
        view.addSubview(child.view)
        
        child.didMove(toParent: self)
    }
    
    func removeOutParent() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
    
    var previousViewController:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers, controllersOnNavStack.count >= 2 {
            let n = controllersOnNavStack.count
            return controllersOnNavStack[n - 2]
        }
        return nil
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentVC(_ vc: UIViewController, completion: (() -> Void)? = nil) {
        present(vc, animated: true, completion: completion)
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismissVC() {
        dismiss(animated: true)
    }
    
    func showInAppVC() {
        if !IAPManager.shared().isSubscribed() && Configs.InAppPurcharse.enableShowInApp {
            let inAppVC = InAppProductVC()
            inAppVC.modalTransitionStyle = .crossDissolve
            inAppVC.modalPresentationStyle = .custom
            presentVC(inAppVC)
        }
    }
    
    func showWebviewVC(url: String) {
        let webviewVC = WebviewVC()
        webviewVC.urlString = url
        webviewVC.modalPresentationStyle = .fullScreen
        webviewVC.presentVC(webviewVC)
        presentVC(webviewVC)
    }
}

extension UIViewController {
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
