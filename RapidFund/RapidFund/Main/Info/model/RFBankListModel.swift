//
//  RFBankListModel.swift
//  RapidFund
//
//  Created by C on 2024/7/18.
//

import Foundation

class RFBankListModel: HandyJSON {
    var darkalmost = 1
    var ate = "Bank"
    var whoswallowed = ""
    var forgot: [__BankInfo] = []
    
    required init() {}

    class __BankInfo: HandyJSON {
        var nosing = ""
        var toy = ""
        var eager = ""
        var half = ""
        var juststood: __Juststood?
        var attempt = 1
        var dismay = 0
        
        var isSelected:Bool = false
        required init() {}
    }

    class __Juststood: HandyJSON {
        var child = ""
        var frozen = ""
        var beabsolutely = ""
        required init() {}
    }
    
    
}
