//
//  RapidHomeModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/12.
//

import SwiftyJSON

struct RapidHomeModel {
    var anddishes = "" //是否显示关于我们
    var plates = "" //是否是假产品
    var cups = "" ///1表示需要弹定位权限，0表示不需要弹定位权益
    var banners: [RPFHomeBanner]?
    var products: [RPFHomeProduct]? 
    var hotmeals: [RPFHomeHotModel]?
    var reminder: [RPFHomeReminder]? 
    
    init(json: JSON) {
        self.anddishes = json["anddishes"].stringValue
        self.plates = json["plates"].stringValue
        self.cups = json["cups"].stringValue
        self.banners = json["womanwalked","forgot"].arrayValue.map{ RPFHomeBanner(json: $0)}
        
        self.products = json["titbits","forgot"].arrayValue.map{ RPFHomeProduct(json: $0)}
        
        self.hotmeals = json["hotmeals","forgot"].arrayValue.map{ RPFHomeHotModel(json: $0)} 
        
        self.reminder = json["knives","forgot"].arrayValue.map{ RPFHomeReminder(json: $0)}
    }
}


struct RPFHomeBanner {
    var littleroom = ""
    var imageUrl = ""
    var hastily = ""
    var salt = ""
    var passme = ""
    
    init(json: JSON){
        self.littleroom = json["littleroom"].stringValue
        self.imageUrl = json["obey"].stringValue
        self.hastily = json["hastily"].stringValue
        self.salt = json["salt"].stringValue
        self.passme = json["passme"].stringValue
    }
}

struct RPFHomeProduct {
    var disapproval = ""  
    var id = ""
    var productName = ""       // 产品名称
    var amountRange = ""       // 产品期限
    var productTags = ""       // 产品标签
    var productDesc = ""       // 产品描述
    var productLogo = ""       // 产品Logo
    var productCode = ""       // 产品编码
    var buttonText = ""        // 按钮文本
    var buttoncolor = ""       // 按钮颜色
    var amountRangeDes = ""    // 金额描述
    var loanRateDes = ""       // 利率描述
    var fed = ""               // 按钮状态
    var achair = ""            // 按钮说明
    var inside = ""            //inside是否内部
    var term = ""
    var productType = ""       // 产品类型
    var isCopyPhone = ""       // 是否复制手机号
    var loanRate = ""          // 年化利率
    var url = ""               // 跳转地址
    var termInfo = ""
    var todayClicked = ""      // 
    var demolish = ""          // 
    var inthis = ""            // 
    var todayApplyNum = ""     // 申请人数
    var amountMax = ""         //申请金额
    var loanTermText = ""          // 
    var orderCompletedCount = ""   // 
    var orderRefinancingText = ""    // 

    init(json: JSON){
        self.id = json["id"].stringValue
        self.disapproval = json["disapproval"].stringValue
        self.productName = json["productName"].stringValue
        self.amountRange = json["amountRange"].stringValue
        self.productTags = json["productTags"].stringValue
        self.productDesc = json["productDesc"].stringValue
        self.productLogo = json["productLogo"].stringValue
        self.productCode = json["product_code"].stringValue
        self.buttonText = json["buttonText"].stringValue
        self.buttoncolor = json["buttoncolor"].stringValue
        self.amountRangeDes = json["amountRangeDes"].stringValue
        self.loanRateDes = json["loanRateDes"].stringValue
        self.fed = json["fed"].stringValue
        self.achair = json["achair"].stringValue
        self.inside = json["inside"].stringValue
        self.term = json["term"].stringValue
        self.productType = json["productType"].stringValue
        self.isCopyPhone = json["isCopyPhone"].stringValue
        self.loanRate = json["loan_rate"].stringValue
        self.url = json["url"].stringValue
        self.todayClicked = json["todayClicked"].stringValue
        self.demolish = json["demolish"].stringValue
        self.inthis = json["inthis"].stringValue
        self.todayApplyNum = json["todayApplyNum"].stringValue
        self.amountMax = json["amountMax"].stringValue
        self.loanTermText = json["loanTermText"].stringValue
        self.orderCompletedCount = json["orderCompletedCount"].stringValue
        self.orderRefinancingText = json["orderRefinancingText"].stringValue
        
    }
}


struct RPFHomeHotModel {
    var aback = ""     
    var promiseto = ""     
    var sports = ""     
    var begged = ""     
    var mymorgan = ""     
    var disapproval = ""     
    var loanRateUnit = ""     
    var termInfoUnit = ""     
    var grown = ""     
    var pursed = ""     
    var beable = ""  
    
    var kinds = "" 
    var forks = "" 
    var decide = ""  
    
    init(json: JSON){
        self.aback = json["aback"].stringValue
        self.promiseto = json["promiseto"].stringValue
        self.sports = json["sports"].stringValue
        self.begged = json["begged"].stringValue
        self.mymorgan = json["mymorgan"].stringValue
        self.loanRateUnit = json["loanRateUnit"].stringValue
        self.disapproval = json["disapproval"].stringValue
        self.termInfoUnit = json["termInfoUnit"].stringValue
        self.grown = json["grown"].stringValue
        self.pursed = json["pursed"].stringValue
        self.beable = json["beable"].stringValue
        
        self.kinds = json["kinds"].stringValue
        self.forks = json["forks"].stringValue
        self.decide = json["decide"].stringValue
    }
}

struct RPFHomeReminder {
    var title = ""
    var titleBg = ""
    var message = ""
    var url = ""
    var icon = ""
    var repayAmount = ""
    
    init(json: JSON){
        self.title = json["title"].stringValue
        self.titleBg = json["titleBg"].stringValue
        self.message = json["message"].stringValue
        self.url = json["url"].stringValue
        self.icon = json["icon"].stringValue
        self.repayAmount = json["repayAmount"].stringValue
        
    }
}


struct RPFHomeNextModel {
    var littleroom = ""
    
    init(json: JSON) {
        self.littleroom = json["littleroom"].stringValue
    }
}
