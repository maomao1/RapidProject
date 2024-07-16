//
//  RapidLoginViewModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on  2024/7/8.
//

import UIKit
import RxSwift
import RxCocoa


class RapidLoginViewModel {
    
    init() {
        
    }
    
    let bag = DisposeBag()
    private let message = PublishSubject<String>()
    var newMessage: Driver<String> {
        return message.filter { !$0.isEmpty }.asDriver(onErrorJustReturn: "")
    }
    
    let loginSuccessAction = PublishSubject<Void>()
    let loginModel = BehaviorRelay<RapidLoginModel?>(value: nil)
    let isAccept = BehaviorRelay(value: false)
    let sendSuccessAction = PublishSubject<Void>()
    let sendCodeIsEnable = BehaviorRelay(value: true)



    
    func getCodeData(phone: String){
        
        guard !phone.isEmpty else {
            self.message.onNext("Please input phoneNumber")
            return
        }
        var param: [String : Any] = [String : Any]()
        param["lonely"] = phone
        param["thanksmost"] = RapidRandom
        self.sendCodeIsEnable.accept(false)
        RapidApi.shared.getLoginPhoneCode(para: param)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                self.sendSuccessAction.onNext(Void())
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
//                self.loginSuccessAction.onNext(Void())
                self.sendCodeIsEnable.accept(true)
                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    func getLoginData(phone: String, codeStr: String){
        guard !phone.isEmpty else {
            self.message.onNext("Please input phoneNumber")
            return
        }
        guard !codeStr.isEmpty else {
            self.message.onNext("Please input verification code")
            return
        }
        if self.isAccept.value == false {
            self.message.onNext("Please read and agree to the User Agreement Privacy Policy")
            return
        }
        //
        //8111222251 202406
        var param: [String : Any] = [String : Any]()
//        param["knows"] = phone
//        param["weeks"] = codeStr
        param["knows"] = "8111222251"
        param["weeks"] = "202406"
        param["scolded"] = RapidRandom
        
        RapidApi.shared.loginByPhone(para: param)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                self.loginModel.accept(RapidLoginModel(json: json))
                self.loginSuccessAction.onNext(Void())
    
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
//                self.loginSuccessAction.onNext(Void())
                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
