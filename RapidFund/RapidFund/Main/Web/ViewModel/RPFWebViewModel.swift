//
//  RPFWebViewModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/18.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import MBProgressHUD

import SwiftyJSON
import RxKeyboard
import IQKeyboardManagerSwift
//import Action
class RPFWebViewModel {
    enum ActivityType {
        case content // HTML字符串
        case `default`
    }
    
    init(urlString: String, activityType: ActivityType = .default){
        let basePara = getRapidUrlParam().replacingOccurrences(of: "?", with: "")
        let fullPath = urlString + "&" + basePara
        self.urlString = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.activityType = activityType
        self.setUpRx()
    }
    
    private let bag = DisposeBag()
    private let loadingFlag = BehaviorRelay(value: 0)
    private let message = PublishSubject<String>()
    
    var urlString: String = ""
    var activityType: ActivityType = .default

    var isLoading: Driver<Bool> {
        return loadingFlag.asDriver().map { $0 != 0 }.distinctUntilChanged()
    }
    
    var newMessage: Driver<String> {
        return message.asDriver(onErrorJustReturn: "")
    }
    
    /// 返回
    let backSubject = PublishSubject<Void>()
    
    let goToHomeAction = PublishSubject<Void>()
    
    let goToAppGradeAction = PublishSubject<Void>()
    
    /// 注册web事件
    func registerHandler(bridge: WKWebViewJavascriptBridge) {
        //回到 App 首页
        bridge.registerHandler("newBaked", handler: { [weak self] data, responseCallback in
            guard let `self` = self else { return }
            
        })
        //风控埋点
        bridge.registerHandler("getplaying", handler: { [weak self] data, responseCallback in
            guard let `self` = self else { return }
            
        })
        //跳转scheme
        bridge.registerHandler("preparations", handler: { [weak self] data, responseCallback in
            guard let `self` = self else { return }
            
        })
        //closeSyn
        bridge.registerHandler("acomplete", handler: { [weak self] data, responseCallback in
            guard let `self` = self else { return }
            
        })
        
        //评分
        bridge.registerHandler("wheels", handler: { [weak self] data, responseCallback in
            guard let `self` = self else { return }
            
        })
        
        //页面里的拨打电话  
        bridge.registerHandler("trulywellProvided", handler: { [weak self] data, responseCallback in
            guard let `self` = self else { return }
            
        })
    }
    
    func setUpRx() {
        
    }
}

/**风控埋点
混淆前：uploadRiskLoan([productId,startTime])  
混淆后：getplaying([andthey,naps])  

//跳转原生或者H5 
混淆前：openUrl([url])  
混淆后：preparations([littleroom]) 

//关闭当前 H5  
混淆前：closeSyn()  
混淆后：acomplete()  

//回到 App 首页  
混淆前：jumpToHome()  
混淆后：newBaked()  

//H5 页面里的拨打电话  
混淆前：callPhoneMethod([phoneNumber])  
混淆后：trulywellProvided([shepherd])  

//调用 App 应用评分  
混淆前：toGrade()  
混淆后：wheels()
*/
