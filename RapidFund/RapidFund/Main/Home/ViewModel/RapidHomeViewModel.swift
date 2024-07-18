//
//  RapidHomeViewModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/9.
//

import UIKit
import RxSwift
import RxCocoa

class RapidHomeViewModel {

    init() {
        
    }
    
    let bag = DisposeBag()
    let pageTitle = "Hello User"
    private let message = PublishSubject<String>()
    var newMessage: Driver<String> {
        return message.filter { !$0.isEmpty }.asDriver(onErrorJustReturn: "")
    }
    let homeModel = BehaviorRelay<RapidHomeModel?>(value: nil)

    
    func getData(){
        var para = [String : Any]()
        para["truant"] = getRPFRandom()
        para["sdaughter"] = getRPFRandom()
        RapidApi.shared.getHomeData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                self.homeModel.accept(RapidHomeModel(json: json))

            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
