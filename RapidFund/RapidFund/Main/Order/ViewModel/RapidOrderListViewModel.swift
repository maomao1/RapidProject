//
//  RapidOrderListViewModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/11.
//

import UIKit
import RxSwift
import RxCocoa

enum OrderType: String {
    case all = "4"
    case settled = "5"
    case unpaid = "6"
    case review = "7"
    case failed = "8"
    
}

class RapidOrderListViewModel {
   
    init(type: OrderType) {
        self.type = type
    }
    
    let bag = DisposeBag()
    private let message = PublishSubject<String>()
    var newMessage: Driver<String> {
        return message.filter { !$0.isEmpty }.asDriver(onErrorJustReturn: "")
    }
    var type: OrderType = .all
    let pageTitle = "Order"
    let orderModels: BehaviorRelay<[RPFOrderModel]> = BehaviorRelay(value: [])

    
    func getData() {
        var para = [String : Any]()
//        para["gambolled"] = self.type.rawValue
        para["gambolled"] = "4"
        
        RapidApi.shared.getOrderData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                let datas = json["army"].arrayValue.map{ RPFOrderModel(json: $0)}
                self.orderModels.accept(datas)
//               
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}

                self.message.onNext(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
