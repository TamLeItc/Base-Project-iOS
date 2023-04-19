//
//  WebviewVC.swift
//  BaseProject
//
//  Created by Tam Le on 11/09/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit
import WebKit

class WebviewVC: BaseVC<WebviewVM>, WKUIDelegate {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func initViews() {
        super.initViews()
        
        indicatorView.startAnimating()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let insets = view.safeAreaInsets
        webView.scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: insets.bottom + 10, right: 0)
        
        loadWebView()
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        closeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.dismissVC()
            }).disposed(by: bag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }
    
    private func loadWebView() {
        guard let url = URL(string: urlString) else { return }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.path = ""
        titleLabel.text = components.url?.absoluteString
    }
}

extension WebviewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            webView.load(navigationAction.request)
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicatorView.isHidden = true
        AlertVC.showMessage(self, style: .error, message: "general_error_message".localized)
    }
}

extension WebviewVC {
    static func showPolicy(_ vc: UIViewController) {
        let webviewVC = WebviewVC()
        webviewVC.urlString = Configs.InfoApp.policyUrl
        webviewVC.modalPresentationStyle = .fullScreen
        vc.presentVC(webviewVC)
    }
    
    static func showTermOfUse(_ vc: UIViewController) {
        let webviewVC = WebviewVC()
        webviewVC.urlString = Configs.InfoApp.termOfUseUrl
        webviewVC.modalPresentationStyle = .fullScreen
        vc.presentVC(webviewVC)
    }
}
