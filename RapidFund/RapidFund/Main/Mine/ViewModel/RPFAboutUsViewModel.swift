//
//  RPFAboutUsViewModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/11.
//

import UIKit
import RxSwift
import RxCocoa

class RPFAboutUsViewModel {
    enum AboutType {
        case registration
        case authority
        case website
        case adress
        
        var titleName: String {
            switch self{
            
            case .registration:
                return "Loan Service Provider:"
            case .authority:
                return "SEC Registration Number:"
            case .website:
                return "Certificate of Authority (CA):"
            case .adress:
                return "Address:"
            }
        }
        
        var content: String {
            switch self{
            
            case .registration:
                return "Cashxpress South East Asia Lending Inc."
            case .authority:
                return "CS201951088"
            case .website:
                return "1309"
            case .adress:
                return "Eastwood Cyberpark Bagumbayan Metro Manila PH 1100"
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
    var sections: [AboutType] = [.registration, .authority, .website, .adress]
    let pageTitle = "About Us"
}
