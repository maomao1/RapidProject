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
    let nextModel = BehaviorRelay<RPFHomeNextModel?>(value: nil)
    let refreshAction = PublishSubject<Void>()
    let nextAction = PublishSubject<String>()

    func getData(){
        var para = [String : Any]()
        para["truant"] = getRPFRandom()
        para["sdaughter"] = getRPFRandom()
        RapidApi.shared.getHomeData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                self.homeModel.accept(RapidHomeModel(json: json))
                self.refreshAction.onNext(Void())

            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    func getNextData(productId: String) {
        var para = [String : Any]()
        para["putit"] = productId
        para["cheerfulindeed"] = getRPFRandom()
        para["noseoutside"] = getRPFRandom()
        RapidApi.shared.getProductNextData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                self.nextModel.accept(RPFHomeNextModel(json: json))
                self.nextAction.onNext(productId)
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
