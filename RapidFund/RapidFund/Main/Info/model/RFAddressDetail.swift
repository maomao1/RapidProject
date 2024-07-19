//
//  RFAddressDetail.swift
//  RapidFund
//
//  Created by C on 2024/7/19.
//

import Foundation

class RFAddressDetail: HandyJSON {
    class __ShedidItem: HandyJSON {
        var yourtoboggans = ""
        var keeping = ""
        var wasan = ""
        var disapproval = ""
        required init() {}
    }
    
    var yourtoboggans = ""
    var shedid: [__ShedidItem] = []
    var wasan = ""
    var disapproval = 0
    
    required init() {}
}
