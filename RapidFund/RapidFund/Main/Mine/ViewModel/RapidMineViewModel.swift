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
    
    enum MenuType {
        case order
        case payment
        case agreement
        case aboutUs
        case logOut
        case logOff
        var titleName: String {
            switch self{
            case .order:
                return "Loan Recoder"
            case .payment:
                return "Payment"
            case .agreement:
                return "Agreement"
            case .aboutUs:
                return "About Us"
            case .logOut:
                return "Log Out"
            case .logOff:
                return "Log Off"
            }
        }
        
        var iconImage: UIImage {
            switch self{
            case .order:
                return .mineMyOrder
            case .payment:
                return .mineMyPayment
            case .agreement:
                return .mineAgreement
            case .aboutUs:
                return .mineAboutUs
            case .logOut:
                return .mineLogOut
            case .logOff:
                return .mineLogOff
            }
        }
        
    }

    init() {
        
    }
    
    let bag = DisposeBag()
    private let message = PublishSubject<String>()
    var newMessage: Driver<String> {
        return message.filter { !$0.isEmpty }.asDriver(onErrorJustReturn: "")
    }
    
    let pageTitle = "Personal Center"
    var sections: [MenuType] = [.order, .agreement, .aboutUs, .logOut, .logOff]

    let mineModels: BehaviorRelay<[RPFMineModel]> = BehaviorRelay(value: [])

    func getData() {
        var para = [String : Any]()
        para["pot"] = getRPFRandom()
        
        RapidApi.shared.getMineData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
//                json["andcream"].
                let datas = json["andcream"].arrayValue.map{ RPFMineModel(json: $0)}
                self.mineModels.accept(datas)
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
