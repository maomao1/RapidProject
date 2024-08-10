//
//  RapidOrderViewModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/10.
//

import UIKit
import RxSwift
import RxCocoa

class RapidOrderViewModel {
    
    enum OrderType {
        case all
        case unpaind
        case under
        case failed
        case settled
        
        var titleName: String {
            switch self{
            case .all:
                return "All Orders"
            case .unpaind:
                return "Pending Repayment"
            case .under:
                return "In Progress"
            case .failed:
                return "Payment Fail"
            case .settled:
                return "Settled Order"
           
            }
        }
        
        var iconImage: UIImage {
            switch self{
            case .unpaind, .all:
                return .orderUnpaidIcon
            case .under:
                return .orderUnderIcon
            case .failed:
                return .orderFailedIcon
            case .settled:
                return .orderSettedIcon
           
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
    
    let pageTitle = "Order"
    var sections: [OrderType] = [.all,.unpaind, .under, .failed, .settled]
}
