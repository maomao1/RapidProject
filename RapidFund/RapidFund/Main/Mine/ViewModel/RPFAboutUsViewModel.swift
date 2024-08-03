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
                return "SEC Registration"
            case .authority:
                return "Certificate Authorit"
            case .website:
                return "Website"
            case .adress:
                return "Address"
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
