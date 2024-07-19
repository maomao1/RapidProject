//
//  RFBankCfg.swift
//  RapidFund
//
//  Created by C on 2024/7/19.
//

import Foundation

class RFBankCfg: HandyJSON {
    class __SnatchItem: HandyJSON {
        var dismay = ""
        var wasan = ""
        var toy = ""
        
        required init() {}
    }
    
    class __MunchedModel: HandyJSON {
        var hastily = ""
        var yourtoboggans = ""
        var sounding = ""
        var marking = ""
        var snatch: [__SnatchItem] = []
        var talked = 0
        var mustn = 0
        var getdark = ""
        var upthe = "" // 下拉的value值
        var dismay = "" // 下拉的key值
        var gambolling = ""
        var theboys = 0
        var retreat = 0
        required init() {}
    }
    
    class __RFMuchedModule: HandyJSON {
        var hastily = ""
        var yourtoboggans = ""
        var sounding = ""
        var marking = ""
        var munched:[__MunchedModel] = []
        var talked = 0
        var mustn = 0
        var getdark = ""
        var upthe = "" // 下拉的value值
        var dismay = "" // 下拉的key值
        var gambolling = ""
        var theboys = 0
        var retreat = 0
        required init() {}
        
        
        func getCardType()->RFBankType {
            if self.hastily == "RFBankType" {
                return .Wallet
            }
            if self.hastily == "Bank" {
                return .Bank
            }
            return .CashPickup
        }
        
    }
    
    var munched: [__RFMuchedModule] = []
    var handful: [Int] = []
    required init() {}
}
