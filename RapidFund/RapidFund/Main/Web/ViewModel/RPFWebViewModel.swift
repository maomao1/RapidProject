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
        self.urlString = urlString
        self.activityType = activityType
//        self.setUpRx()
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
    /// 弹出登录页面
    let visitorsLoginSubject = PublishSubject<((String)-> Void)?>()
    /// 返回
    let backSubject = PublishSubject<(Bool)>()
    
    /// 注册web事件
    func registerHandler(bridge: WKWebViewJavascriptBridge) {
        
    }
    
    
}
