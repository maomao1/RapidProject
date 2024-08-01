//
//  RFNetManager.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/30.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class RFNetManager {
    enum RFNetWorkType {
        case unknown
        case wifi
        case cellular
    }
    
    let bag = DisposeBag()
    static let manager = RFNetManager()
    
    let networkType = BehaviorRelay(value: RFNetWorkType.unknown)
    let reachability = NetworkReachabilityManager()
    init() {
        reachability?.listener = { [weak self] status in
            if status == .notReachable {
                self?.networkType.accept(.unknown)
            } else if case let .reachable(type) = status {
                if type == .ethernetOrWiFi {
                    self?.networkType.accept(.wifi)
                } else {
                    self?.networkType.accept(.cellular)
                }
            } else {
                self?.networkType.accept(.unknown)
            }
        }
        reachability?.startListening()
    }
}
