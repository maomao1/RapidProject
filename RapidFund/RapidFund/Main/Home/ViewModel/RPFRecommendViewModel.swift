//
//  RPFRecommendViewModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/8/2.
//

import UIKit
import RxSwift
import RxCocoa

class RPFRecommendViewModel {
    init() {
        
    }
    
    let bag = DisposeBag()
    let pageTitle = "Recommended Products"
    private let message = PublishSubject<String>()
    var newMessage: Driver<String> {
        return message.filter { !$0.isEmpty }.asDriver(onErrorJustReturn: "")
    }
    let products: BehaviorRelay<[RPFHomeProduct]> = BehaviorRelay(value: [])
    let nextAction = PublishSubject<String>()
    let nextModel = BehaviorRelay<RPFHomeNextModel?>(value: nil)
    let isLoading = BehaviorRelay(value: false)


    func getData(){
        isLoading.accept(true)
        var para = [String : Any]()
        para["truant"] = getRPFRandom()
        para["sdaughter"] = getRPFRandom()
        RapidApi.shared.getRecommendData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                self.isLoading.accept(false)
                let datas = json["army"].arrayValue.map{ RPFHomeProduct(json: $0)}
                self.products.accept(datas)
                
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
                self.isLoading.accept(false)
                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    func getNextData(productId: String) {
        var para = [String : Any]()
        para["putit"] = productId
        para["cheerfulindeed"] = getRPFRandom()
        para["noseoutside"] = getRPFRandom()
        isLoading.accept(true)
        RapidApi.shared.getProductNextData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                self.nextModel.accept(RPFHomeNextModel(json: json))
                self.nextAction.onNext(productId)
                self.isLoading.accept(false)
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
                self.isLoading.accept(false)
                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
