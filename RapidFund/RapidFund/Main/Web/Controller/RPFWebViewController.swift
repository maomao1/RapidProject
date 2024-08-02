//
//  RPFWebViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/17.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import WebKit
import SwiftyJSON
import AVKit
import MBProgressHUD
import StoreKit

class RPFWebViewController: RapidBaseViewController {
    
    struct Constants {
        static let keyPaths: [String] = [
            "estimatedProgress",
            "canGoBack",
            "canGoForward",
            "title",
            "URL"
        ]
    }
    
    private let disBag = DisposeBag()
    var viewModel: RPFWebViewModel!
    private var bridge: WKWebViewJavascriptBridge!
    private var userContentController = WKUserContentController()
//    private var messageHandler: MessageHandler!
    private var isWebViewLoad: Bool = false
    
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .default
    
    // 重现statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = .c_5E9F7A
        return progressView
    }()
    
    lazy var webConfig: WKWebViewConfiguration = {
        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = userContentController
        webConfig.allowsInlineMediaPlayback = true
//        webConfig.applicationNameForUserAgent = ""
        // 设置偏好设置
        webConfig.preferences = WKPreferences()
        // 默认为0
        webConfig.preferences.minimumFontSize = 10
        // 默认认为YES
        webConfig.preferences.javaScriptEnabled = true
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        webConfig.preferences.javaScriptCanOpenWindowsAutomatically = false
        return webConfig
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: webConfig)
//        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true // 允许左滑返回
        return webView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(.homeNavWhiteBack, for: .normal)
        button.setBackgroundImage(.homeNavWhiteBack, for: .selected)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupViews()
        setupRx()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customNavView.isHidden = true
//        hidesBottomBarWhenPushed = true
//        navigationController?.fd_fullscreenPopGestureRecognizer?.isEnabled = false
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        if isWebViewLoad {
            webView.stopLoading()
            Constants.keyPaths.forEach { (keyPath) in
                self.webView.removeObserver(self, forKeyPath: keyPath)
            }
        }
        NotificationCenter.default.removeObserver(self)
        print("ActivityViewController deallocated")
    }
    
    func setupProperties() {
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        
    }

    func setupViews() {
        
        initWebView()
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(backButton)
//        addPanGusture()
        
        webView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        progressView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalTo(3)
        }
        
        backButton.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(23.rf)
            } else {
                make.top.equalTo(23.rf)
            }
            make.left.equalTo(RapidMetrics.LeftRightMargin)
            make.size.equalTo(CGSize(width: 50.rf, height: 50.rf))
        }
        
        Constants.keyPaths.forEach { (keyPath) in
            self.webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
        
        
    }
    
    func setupRx() {
        backButton.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.backAction()
            })
            .disposed(by: bag)
        
        viewModel.goToHomeAction
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.gotoHomePage()
            }).disposed(by: bag)
        
        viewModel.closeSubject
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.back()
            }).disposed(by: bag)
        
        viewModel.gotoNewPageAction
            .subscribe(onNext: { [weak self] url in
                guard let `self` = self else { return }
                self.setRouter(url: url, pId: "")
            }).disposed(by: bag)
        
        viewModel.callPhoneNumberAction
            .subscribe(onNext: { [weak self] phoneNumber in
                guard let `self` = self else { return }
                self.nativeCallPhone(number: phoneNumber)
            }).disposed(by: bag)
        
        viewModel.goToAppGradeAction
            .subscribe(onNext: { [weak self]  in
                guard let `self` = self else { return }
                self.gotoAppStoreCommit()
            }).disposed(by: bag)
        
        viewModel.uploadRiskAction
            .subscribe(onNext: { [weak self] (pId, time) in
            guard let `self` = self else { return }
                self.uploadAnalysis(pId: pId, start: time)
        }).disposed(by: bag)
    
        
    }
    
     func backAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func uploadAnalysis(pId: String, start: String){
        RPFLocationManager.manager.analysisHandle = { (longitude,latitude) in
            RPFReportManager.shared.saveAnalysis(pId: pId, type: .EndApply, startTime: start, longitude: longitude, latitude: latitude)
        }
    }
    
    func gotoHomePage() {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func nativeCallPhone(number: String){
        let fullNumber = "tel://" + number
        guard let url = URL(string: fullNumber), UIApplication.shared.canOpenURL(url) else {
            print("无法拨打电话")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func gotoAppStoreCommit() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // 在iOS 10.3以下版本中无法直接打开评分界面，可以考虑使用URL打开应用商店页面
            if let url = URL(string: "https://itunes.apple.com/app/id你的应用程序ID") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

}

extension RPFWebViewController {
    // 初始化 WKWebView
    func initWebView() {
        switch viewModel.activityType {
        case .content:
            webView.loadHTMLString(viewModel.urlString, baseURL: nil)
        default:
            loadingRemoteLinks()
        }
    }
    
    
    /// 加载远程H5链接
    private func loadingRemoteLinks () {
        guard viewModel.urlString.hasPrefix("https") ||
                viewModel.urlString.hasPrefix("http") else { return }
        guard let urlStr = viewModel.urlString.url else { return }
        self.isWebViewLoad = true
        let urlRequest = URLRequest(url: urlStr)
        webView.load(urlRequest)
        WKWebViewJavascriptBridge.enableLogging()
        bridge = WKWebViewJavascriptBridge(for: webView);
        bridge.setWebViewDelegate(self);
        
        viewModel.registerHandler(bridge: bridge)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        switch keyPath {
        case "estimatedProgress":
            progressView.alpha = 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1 {
                UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finished) in
                    self.progressView.progress = 0
                })
            }
        case "canGoBack":
//            guard let vc = self.navigationController?.viewControllers.first else { return }
//            if !vc.isMember(of: RPFWebViewController.self) {
//                if webView.canGoBack {
//                    navigationItem.leftBarButtonItems = [backButton, closeButton]
//                }
//            }
            print("-----")
        case "title":
            let title = self.webView.title
//            switch viewModel.activityType {
//            case .hiddenNavigationBar:
//                self.navigationController?.title = ""
//            default:
//                self.navigationItem.title = title
//            }
        case "URL":
            guard let url = webView.url?.description else { return }
            print("webViewUrl===\(webView.url?.description)")
//            let isHomePage = url.contains("pages/home_page")
//            viewModel.isInHomePage.accept(isHomePage)
//            viewModel.allowsLeftPanGusture.accept(!isHomePage)
        default:
            break
        }
    }
}

extension RPFWebViewController {
    
    @objc func goBack(sender: Any?) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    typealias JSEvaluation = (javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)?)
    
    /// 注入js 与H5交互
    private func evaluateJavascript(js: JSEvaluation) {
        DispatchQueue.main.async {
            self.webView.evaluateJavaScript(js.javaScriptString, completionHandler: js.completionHandler)
        }
    }
    
    fileprivate func reloadView() {
        webView.reload()
    }
}

extension RPFWebViewController: WKNavigationDelegate, WKUIDelegate {
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
    }
    
    // 页面开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // 页面加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if url.scheme == "tel" {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    
    
    // MARK: - WKUIDelegate
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        // 判断服务器采用的验证方法
//        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//            if challenge.previousFailureCount == 0 {
//                // 如果没有错误的情况下 创建一个凭证，并使用证书
//                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//                DispatchQueue.main.async {
//                    completionHandler(.useCredential, credential)
//                }
//            } else {
//                // 验证失败，取消本次验证
//                DispatchQueue.main.async {
//                    completionHandler(.cancelAuthenticationChallenge, nil)
//                }
//            }
//        } else {
//            DispatchQueue.main.async {
//                completionHandler(.cancelAuthenticationChallenge, nil)
//            }
//        }
//    }
}
