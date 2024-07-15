//
//  RFContactModel.swift
//  RapidFund
//
//  Created by C on 2024/7/15.
//

import Foundation
class RFContactModel: HandyJSON {
    class __KneeModel: HandyJSON {
        var wasan: String = ""
        var dismay: String = ""
        required init() {}
    }

    var fany: String?
    var wasan: String?
    var bumped: String?
    var disappear: String?
    var falls: String?
    var knee: [__KneeModel]?
    required init() {}
}
