//
//  RapidMineViewModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/9.
//

import UIKit
import RxSwift
import RxCocoa

class RapidMineViewModel {

    init() {
        
    }
    
    let bag = DisposeBag()
    private let message = PublishSubject<String>()
    var newMessage: Driver<String> {
        return message.filter { !$0.isEmpty }.asDriver(onErrorJustReturn: "")
    }
    
    let title = "Personal Center"
    
    func getData() {
        var para = [String : Any]()
//        para["truant"] = RapidRandom
        para["pot"] = RapidRandom
        
        RapidApi.shared.getMineData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
//                self.loginSuccessAction.onNext(Void())
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
//                self.loginSuccessAction.onNext(Void())
                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
