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
    var cups = "" ////1表示需要弹定位权限，0表示不需要弹定位权益
    
    init(json: JSON) {
        
    }
}


struct RPFHomeBanner {
    var littleroom = ""
    var imageUrl = ""
    var hastily = ""
    var salt = ""
    var passme = ""
    
    init(json: JSON){
        
    }
}

struct RPFHomeProduct {
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
}

struct RPFHomeReminder {
    var title = ""
    var titleBg = ""
    var message = ""
    var url = ""
    var icon = ""
    var repayAmount = ""
}
