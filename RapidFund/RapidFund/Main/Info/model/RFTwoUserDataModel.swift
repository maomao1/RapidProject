//
//  RFTwoUserDataModel.swift
//  RapidFund
//
//  Created by C on 2024/7/15.
//

import Foundation

class RFTwoUserDataModel: HandyJSON {
    class __Snatch: HandyJSON {
        var wasan: String = ""
        var dismay = "1"
        
        required init() {}
    }

    var disapproval: Int?
    var hastily: String = ""
    var sounding: String = ""
    var yourtoboggans: String?
    var marking: String?
    var retreat: Int?
    var snatch: [__Snatch] = []
    var talked: Int = 0
    var mustn = 1
    var getdark: String?
    var patient: Bool = false
    var upthe: String?
    var dismay: String = "0" // 下拉的key值
    var theboys: String = "1"
        
    required init() {}
}

enum RFKeyValue: String {
    case gender = "Gender"
    case marry = "Marital state"
    case passpord
    case address = "Residential Address"
}
