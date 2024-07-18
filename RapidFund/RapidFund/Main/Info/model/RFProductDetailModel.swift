//
//  RFProductDetailModel.swift
//  RapidFund
//
//  Created by C on 2024/7/18.
//

import Foundation

class RFProductDetailModel: HandyJSON {
    required init() {}

    // 产品信息
    
    var goneand: [String]? // 额度范围
    var soothingly: String = "" // 金额
    var cannot: [Int] = [] // 借款期限
    var sometime: String = "" // 借款金额文案
    var dogsattacking = "" // 借款期限文案
    var disapproval = "" // 产品id
    var pursed: String = "" // 产品名称
    var risking = "" // 订单号
    var honestly = 0 // 订单id
    var sucha: [__Sucha]?
    
    class __Sucha: HandyJSON {
        var determinedly: __SuchaItem?
        var decided: __SuchaItem?
        required init() {}
    }
    
    class __SuchaItem: HandyJSON {
        var hastily: String = ""
        var falls: String = ""
        required init() {}
    }

    var mymorgan = "" // 按钮
    var girlslistened = ""
    var feed: String = ""
    var marvellously = ""
    var littleroom = ""
    var described: __Described?
    
    class __Described: HandyJSON {
        var upthe: String = ""
        required init() {}
    }

    var ha = ""
    var spread = 1 // 使用epoch 1 or 0
  
    class __Chairs: HandyJSON {
        var lonely = ""
        var mostcomfortable = ""
        var wasan = ""
        required init() {}
    }
    
    var chairs: __Chairs? // 用户信息
    
    class __Hehad:NSObject, HandyJSON {
        var hastily = "" // 标题
        var sounding = ""
        var dismay = ""
        var littleroom = ""
        var mustn = 1 // 是否已完成
        var getdark = ""
        var meet = ""
        var thankfully = 1
        var talked = 0
        var tonight = 1
        var aboutit = ""
        var glorious = "" // logo
        required override init() {}
    }
    
    var hehad: [__Hehad]?
    // 认证项
    
    class __Recovered:NSObject, HandyJSON {
        var has = ""
        var littleroom = ""
        var dismay = 0
        var hastily = ""
        required override init() {}
    }

    var recovered: __Recovered? // 下一步
      
    class __Longed: HandyJSON {
        var andthey = "1"
        var breath = 1
        var werequite = "1"
        var honestly = ""
        var hastily = ""
        required init() {}
    }
    
    var longed: __Longed? // 借款协议
}
