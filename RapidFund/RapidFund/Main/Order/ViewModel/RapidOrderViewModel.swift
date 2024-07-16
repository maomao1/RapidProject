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
        case unpaind
        case under
        case failed
        case settled
        
        var titleName: String {
            switch self{
            case .unpaind:
                return "Unpaid Order"
            case .under:
                return "Under Review"
            case .failed:
                return "Failed Loan Funding"
            case .settled:
                return "Settled Order"
           
            }
        }
        
        var iconImage: UIImage {
            switch self{
            case .unpaind:
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
    var sections: [OrderType] = [.unpaind, .under, .failed, .settled]
}
