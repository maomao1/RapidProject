//
//  RapidLoginModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/9.
//

import SwiftyJSON

struct RapidLoginModel {
    var uid = ""
//    var blackberry = ""
//    var donewith = ""
    var session = ""
//    var 28i3qqgr = ""
//    var nest = ""
//    var isReview = ""
    var knows = ""
    
    init(json: JSON) {
        self.uid = json["uid"].stringValue
        self.session = json["muchmore"].stringValue
        self.knows = json["knows"].stringValue
    }
}
