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
   
    init() {
        
    }
    
    let bag = DisposeBag()
    private let message = PublishSubject<String>()
    var newMessage: Driver<String> {
        return message.filter { !$0.isEmpty }.asDriver(onErrorJustReturn: "")
    }
    
    let pageTitle = "About Us"
}
