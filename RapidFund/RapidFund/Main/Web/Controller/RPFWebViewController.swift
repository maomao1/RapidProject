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
import MessageUI

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
        button.setBackgroundImage(.homeNavBlackBack, for: .normal)
        button.setBackgroundImage(.homeNavBlackBack, for: .selected)
        button.backgroundColor = .white.withAlphaComponent(0.3)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15.rf
        button.contentHorizontalAlignment = .left
//        button.isHidden = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupViews()
        showCustomNav(show: viewModel.urlString.contains(BaseH5Api))
        setupRx()
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.customNavView.isHidden = true
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
        self.customNavView.isHidden = true
        self.customNavView.backgroundColor = .white
        self.setNavImageTitleWhite(isWhite: false)
        self.rightBtn.isHidden = true
        
        initWebView()
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(backButton)
        
        self.customNavView.snp.remakeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10.rf)
            } else {
                make.top.equalTo(10.rf)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(50.rf)
        }
        
        webView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.customNavView.snp.bottom)
            maker.left.right.bottom.equalToSuperview()
        }
        progressView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalTo(3)
        }
        
        backButton.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10.rf)
            } else {
                make.top.equalTo(10.rf)
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
        
        viewModel.showNavAction
            .subscribe(onNext: { [weak self] show in
                guard let `self` = self else { return }
//                self.showCustomNav(show: show)
            }).disposed(by: bag)
        
    }
    
    override func back() {
        self.backAction()
    }
    
     func backAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            if let navigationController = self.navigationController {
                
                for (index, vc) in navigationController.viewControllers.enumerated() {
                    if vc is RFBankCardListVC {
                        let v = navigationController.viewControllers[index - 1] 
                        if v is RPFWebViewController {
                            navigationController.viewControllers.remove(at: index - 1) 
                        }
                    }
                    if vc is RFFlowVC  || vc is RFBankCardListVC{
                        navigationController.viewControllers.remove(at: index) 
                    }
                    
                    if vc is RFBankMgrVc  {
                        navigationController.viewControllers.remove(at: index) 
                    }
                }
                
                navigationController.popViewController(animated: true)
 
            }else {
                self.dismiss(animated: true)
            }
            
            
        }
    }
    
    func showCustomNav(show: Bool) {
        if show  {
            self.backButton.isHidden = false
            self.customNavView.isHidden = true
            webView.snp.remakeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
        }else {
            self.backButton.isHidden = true
            self.customNavView.isHidden = false
            self.titleNav.font = .f_lightSys24
            self.view.bringSubviewToFront(self.customNavView)
            webView.snp.remakeConstraints { (maker) in
                maker.top.equalTo(self.customNavView.snp.bottom)
                maker.left.right.bottom.equalToSuperview()
            }
        }
    }
    
    
    func uploadAnalysis(pId: String, start: String){
        
        RPFLocationManager.manager.analysisBackList.append { (longitude,latitude) in
            RPFReportManager.shared.saveAnalysis(pId: pId, type: .EndApply, startTime: start, longitude: longitude, latitude: latitude)
        }
        RPFLocationManager.manager.requestLocationAuthorizationStatus(isLocation: false)
//        RPFLocationManager.manager.analysisHandle = { (longitude,latitude) in
//            RPFReportManager.shared.saveAnalysis(pId: pId, type: .EndApply, startTime: start, longitude: longitude, latitude: latitude)
//        }
    }
    
    
    func gotoHomePage() {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func nativeCallPhone(number: String){
        if number.contains("mailto") {
            let mail = number.components(separatedBy: "//").last ?? ""
            if MFMailComposeViewController.canSendMail() {
                let mailComposeViewController = MFMailComposeViewController()
                mailComposeViewController.mailComposeDelegate = self
                
                mailComposeViewController.setToRecipients([mail])
                mailComposeViewController.setSubject("")
                mailComposeViewController.setMessageBody("Fast Peso Account:" + GetInfo(kRapidMobileNumber), isHTML: false)
                
                present(mailComposeViewController, animated: true, completion: nil)
                return
            } else {
                // 提示用户设备没有配置邮箱
                print("No email account found")
            }
            
        }
        guard let url = URL(string: number), UIApplication.shared.canOpenURL(url) else {
            print("无法拨打电话")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
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
            self.titleNav.text = title
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
        
//        showCustomNav(show: viewModel.urlString.contains(BaseH5Api))
        self.hiddenLoading()
    }
    
    // 页面开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showLoading()
        guard let url = webView.url?.absoluteString else {return}
        showCustomNav(show: url.contains(BaseH5Api))
    }
    
    // 页面加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.hiddenLoading()
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
    
}
extension RPFWebViewController: MFMailComposeViewControllerDelegate {
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
