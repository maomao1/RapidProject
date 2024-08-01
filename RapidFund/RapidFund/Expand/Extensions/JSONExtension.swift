//
//  JSONExtension.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import SwiftyJSON

extension JSON {
    
    var YaloCode: Int {
        return self["yourtoboggans"].intValue
    }
    
    var YaloMsg: String {
        return self["thedogs"].stringValue
    }
    
    var isSuccessful: Bool {
        return YaloCode == 0
    }
    
    var upLoadSuccessful: Bool {
        return YaloCode == 0 || YaloCode == -1
    }
    
    var forbidden: Bool {
        return YaloCode == 1100008
    }
    
    var needsLogin: Bool {
        return YaloCode == -2
    }
    var tokenUnused: Bool {
        return YaloCode == -2
    }
    
    var resultData: JSON {
        return self["trouble"]
    }
}
