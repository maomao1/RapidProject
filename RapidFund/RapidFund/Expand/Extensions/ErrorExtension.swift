//
//  RapidError.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import SwiftyJSON

enum RapidError: LocalizedError {
   
    case tokenUnused //token失效
//    case haveAlreadyRegistered //手机号已注册
    case other(message: String)
    case iapAlreadyServed(message: String) //苹果内购
    case noNetwork(message: String) //断网
    
    var errorDescription: String? {
        switch self {
        
        case .tokenUnused:
            return "重新登录"

        case .other(let message):
            return message
        case .iapAlreadyServed(message: let message):
            return message
        case .noNetwork(let message):
            return message
        }
    }
}

extension Error {
    
    var iapAlreadyServed: Bool {
        guard let error = self as? RapidError else { return false }
        if case .iapAlreadyServed = error {
            return true
        } else {
            return false
        }
    }
    
    var isNoNetwork: Bool {
        guard let error = self as? RapidError else { return false }
        if case .noNetwork = error {
            return true
        } else {
            return false
        }
    }
    
}

