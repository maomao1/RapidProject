//
//  RapidBaseViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import RxCocoa
import RxSwift
import UIKit

@_exported import SnapKit
@_exported import XYZKit



class RapidBaseViewController: UIViewController {
    // MARK: - Properties

    let bag = DisposeBag()
    
    private(set) lazy var customNavView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) lazy var safeAreaBottomView = UIView()
    
    lazy var titleNav: UILabel = {
        let label = UILabel()
        label.font = .f_lightSys32
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var backBtn: UIButton = {
        let button = UIButton(type: .custom)
       
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private(set) lazy var rightBtn: UIButton = {
        let button = UIButton(type: .custom)
       
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isTranslucent = false
        setBottomView()
        setCustomNav()
        setNavImageTitleWhite(isWhite: true)
        setBaseUpRx()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        setUpNoNetworkView()
    }
    
    func setNavImageTitleWhite(isWhite: Bool) {
        backBtn.setBackgroundImage(isWhite ? .homeNavWhiteBack : .homeNavBlackBack, for: .normal)
        backBtn.setBackgroundImage(isWhite ? .homeNavWhiteBack : .homeNavBlackBack, for: .selected)
        rightBtn.setBackgroundImage(isWhite ? .homeNavWhiteRight : .homeNavBlackRight, for: .normal)
        rightBtn.setBackgroundImage(isWhite ? .homeNavWhiteRight : .homeNavBlackRight, for: .selected)
        titleNav.textColor = isWhite ? .c_FFFFFF : .c_111111
        titleNav.font = isWhite ? .f_lightSys24 : .f_lightSys32
    }
    
    func setNavViewHidden() {
        self.customNavView.isHidden = true
    }
    
    func setBackBtnHidden() {
        backBtn.snp.remakeConstraints { make in
            make.left.equalTo(customNavView.snp.left).offset(RapidMetrics.LeftRightMargin)
            make.centerY.equalTo(customNavView)
            make.size.equalTo(CGSize(width: 0.rf, height: 0.rf))
        }
        
        titleNav.snp.remakeConstraints { make in
            make.left.equalTo(backBtn.snp.right).offset(0.rf)
            make.centerY.equalTo(customNavView)
            make.right.equalToSuperview()
        }
    }
    
    func setCustomNav() {
        view.addSubview(customNavView)
        customNavView.addSubview(backBtn)
        customNavView.addSubview(rightBtn)
        customNavView.addSubview(titleNav)
        
        customNavView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11.5.rf)
            } else {
                make.top.equalTo(11.5.rf)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(73.rf)
        }
//        customNavView.snp.makeConstraints { make in
//            if #available(iOS 11.0, *) {
//                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0.rf)
//            } else {
//                make.top.equalTo(0.rf)
//            }
//            make.left.right.equalToSuperview()
//            make.height.equalTo(44.rf)
//        }
        
        rightBtn.snp.makeConstraints { make in
            make.right.equalTo(customNavView.snp.right).offset(-RapidMetrics.LeftRightMargin)
            make.centerY.equalTo(customNavView)
            make.size.equalTo(CGSize(width: 50.rf, height: 50.rf))
        }
        
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(customNavView.snp.left).offset(RapidMetrics.LeftRightMargin)
            make.centerY.equalTo(customNavView)
            make.size.equalTo(CGSize(width: 50.rf, height: 50.rf))
        }
        
        titleNav.snp.makeConstraints { make in
            make.left.equalTo(backBtn.snp.right).offset(12.rf)
            make.centerY.equalTo(customNavView)
            make.right.equalToSuperview()
        }
    }
    
    func removeLastVC(){
        if let navigationController = self.navigationController {
            let count = navigationController.viewControllers.count
            if navigationController.viewControllers[count - 2] is RFFlowVC { return}
            navigationController.viewControllers.remove(at: (count - 2))
        }
    }
    
    func removeFlowVC(){
        if let navigationController = self.navigationController {
            guard let first = navigationController.viewControllers.first(where: { $0 is RFFlowVC}),
                    let index = navigationController.viewControllers.firstIndex(of: first) else { return }
            navigationController.viewControllers.remove(at: index)
        }
    }
    
    func removeBindVC(){
        if let navigationController = self.navigationController {
            guard let first = navigationController.viewControllers.first(where: { $0 is RFBankMgrVc}),
                    let index = navigationController.viewControllers.firstIndex(of: first) else { return }
            navigationController.viewControllers.remove(at: index)
        }
    }
    
    func removeCardListVC(){
        if let navigationController = self.navigationController {
            guard let first = navigationController.viewControllers.first(where: { $0 is RFBankCardListVC}),
                    let index = navigationController.viewControllers.firstIndex(of: first) else { return }
            navigationController.viewControllers.remove(at: index)
        }
    }
    
    func removeFrontWebVC(){
        if let navigationController = self.navigationController {
            guard let first = navigationController.viewControllers.first(where: { $0 is RPFWebViewController}),
                    let index = navigationController.viewControllers.firstIndex(of: first) else { return }
            navigationController.viewControllers.remove(at: index)
        }
    }
    
    
    func setBottomView() {
        safeAreaBottomView.backgroundColor = .white
        view.addSubview(safeAreaBottomView)
        safeAreaBottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(IPHONE_X ? 34 : 0)
        }
        safeAreaBottomView.isHidden = true
    }
    
    // 设置LeftBarButtonItem

    func setLeftBarButtonItem(image: UIImage = .homeNavBlackBack) {
        let backButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        backButton.width = 50
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setRightBarButtonItem(image: UIImage = .homeNavBlackRight) {
//        let rightButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarEvent))
//        navigationItem.rightBarButtonItem = rightButton
        let rightButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(rightBarEvent))
        rightButton.width = 50
        navigationItem.rightBarButtonItem = rightButton
    }

    func setBaseUpRx() {
        backBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.back()
            })
            .disposed(by: bag)
        
        rightBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.rightBarEvent()
            })
            .disposed(by: bag)
        
        NotificationCenter.default
            .rx.notification(.RapidLoginSuccess)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.loginSuccessAction()
            })
            .disposed(by: bag)
    }
    
    //
    func loginSuccessAction() {}
    
    @objc func rightBarEvent() {
       let url = GetInfo(kRapidServiceCenter)
        if !url.isEmpty {
            let vc = RPFWebViewController()
            vc.viewModel = RPFWebViewModel(urlString: url)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // 返回
    @objc func back() {
        if let vcCount = navigationController?.viewControllers.count,
           vcCount > 1
        {
            navigationController?.popViewController(animated: true)
        } else {
            if navigationController != nil {
                navigationController?.dismiss(animated: true, completion: {})
            } else {
                dismiss(animated: true) {}
            }
        }
    }
    
    func adjustNavTitleCenter() {
        titleNav.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

extension RapidBaseViewController {
    
    func setRouter(url: String, pId: String) {
        if url.isEmpty{
            let vc = RFFlowVC(product_id: pId)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if url.hasPrefix("https") || url.hasPrefix("http"){
                let vc = RPFWebViewController()
                vc.viewModel = RPFWebViewModel(urlString: url)
                self.navigationController?.pushViewController(vc, animated: true)
               
            }else {
                let schemeUrls = url.components(separatedBy: "?")
                let scheme = schemeUrls.first
                let paraStr = schemeUrls.last 
                var param: [String: String]? = [:]
                if let requireStr = paraStr {
                    param = self.parseQueryString(queryString: requireStr)
                }
                if scheme?.contains(RPFRouterSet) == true {
                    self.tabBarController?.selectedIndex = 2
                    self.navigationController?.popToRootViewController(animated: false)
                }
                else if scheme?.contains(RPFRouterHome) == true{
                    self.tabBarController?.selectedIndex = 0
                    self.navigationController?.popToRootViewController(animated: false)
                }
                else if  scheme?.contains(RPFRouterLogin) == true{
                    let vc = RapidLoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(vc, animated: true)
                }
                else if  scheme?.contains(RPFRouterOrder) == true{
                    let vc = RapidOrderListViewController()
                    if let requirePara = param{
                        if let orderType =  requirePara[RPFOrderKey]{
                            if orderType == "4"{
                                vc.viewModel = RapidOrderListViewModel(type: .all)
                            }
                            else if orderType == "5"{
                                vc.viewModel = RapidOrderListViewModel(type: .settled)
                            }
                            else if orderType == "6"{
                                vc.viewModel = RapidOrderListViewModel(type: .unpaid)
                            }
                            else if orderType == "7"{
                                vc.viewModel = RapidOrderListViewModel(type: .review)
                            }
                            else if orderType == "8"{
                                vc.viewModel = RapidOrderListViewModel(type: .failed)
                            }else{
                                vc.viewModel = RapidOrderListViewModel(type: .all)
                            }
                        }else{
                            vc.viewModel = RapidOrderListViewModel(type: .all) 
                        }
                    }else{
                        vc.viewModel = RapidOrderListViewModel(type: .all)
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)

                }
                else if  scheme?.contains(RPFRouterProductDetail) == true{
                    if let requirePara = param{
                        if let pId =  requirePara[RPFOrderDetailKey]{
                            let vc = RFFlowVC(product_id: pId)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                else if  scheme?.contains(RPFRouterContact) == true{
                    let vc = RapidOrderListViewController()
                    vc.viewModel = RapidOrderListViewModel(type: .settled)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if  scheme?.contains(RPFRouterBank) == true{
                    
                    if let requirePara = param{
                        if let pId =  requirePara[RPFChangeBankProductKey], let orderId = requirePara[RPFChangeBankOrderKey]{
                            self.navigationController?.pushViewController(RFBankCardListVC(orderId: orderId, productId: pId), animated: true)
                            
                        }

                    }
                }else if  scheme?.contains(RPFRouterRecommend) == true{
                    let vc  = RPFRecommendViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }        
    }
    
    func parseQueryString(queryString: String) -> [String: String]? {
        var pairs: [String: String] = [:]
        queryString.components(separatedBy: "&").forEach { pair in
            let keyValue = pair.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            if keyValue.count == 2 {
                let key = keyValue[0].removingPercentEncoding
                let value = keyValue[1].removingPercentEncoding
                if let key = key, let value = value {
                    pairs[key] = value
                }
            }
        }
        return pairs.isEmpty ? nil : pairs
    }
    
    
}

/**
 scheme: rfapi://com.rapidfund.app/

 混淆前：setting 设置页（scheme + /setting）  
 混淆后：terrified 设置页（scheme + /terrified）  

 混淆前：main 首页（scheme + /main）  
 混淆后：loudest 首页（scheme + /loudest）  

 混淆前：login 登录页（scheme + /login）  
 混淆后：examined 登录页（scheme + /examined）

 混淆前：order 订单列表页 （scheme + /order?tab=1）  
 混淆后：laughing 订单列表页 （scheme + /laughing?hiscollar=1）  

 混淆前：productDetail 产品详情 （scheme + /productDetail?product_id=1）  
 混淆后：andfollowed 产品详情 （scheme + /andfollowed?putit=1）

 混淆前：contact 客服首页（scheme + /contact）  
 混淆后：absolutelysound 客服首页（scheme + /absolutelysound）

 混淆前：changeAccount 更换银行卡（scheme + /changeAccount?product_id=1&orderId=91）  
 混淆后：amarvellous 更换银行卡（scheme + /amarvellous?putit=1&honestly=91）

 */

