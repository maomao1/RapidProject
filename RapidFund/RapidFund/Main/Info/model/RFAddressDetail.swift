//
//  RFAddressDetail.swift
//  RapidFund
//
//  Created by C on 2024/7/19.
//

import Foundation

class RFAddressDetail: HandyJSON {
    
    class __ShedidSubItem:HandyJSON {
        var wasan = ""
        var disapproval = ""
        required init() {}
    }
    
    class __ShedidItem: HandyJSON {
        var wasan = ""
        var disapproval = ""
        var army:[__ShedidSubItem] = []
        required init() {}
    }
    
    var yourtoboggans = ""
    var army: [__ShedidItem] = []
    var wasan = ""
    var disapproval = 0
    
    required init() {}
}
