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
    let loginSuccessAction = PublishSubject<Void>()
    private let message = PublishSubject<String>()
    var newMessage: Driver<String> {
        return message.filter { !$0.isEmpty }.asDriver(onErrorJustReturn: "")
    }
    
    func getCodeData(){
        print("getCodeData")
    }
    
    func getLoginData(){
        var param: [String : Any] = [String : Any]()
        param["knows"] = "8111222251"
        param["weeks"] = "202406"
        param["scolded"] = "202406"
        
        RapidApi.shared.loginByPhone(para: param)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
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
