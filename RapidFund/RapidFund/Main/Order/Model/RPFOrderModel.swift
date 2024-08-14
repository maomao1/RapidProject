//
//  RPFOrderModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/16.
//

import SwiftyJSON
//   状态1:逾期 180  : 
//   状态2:还款中 174 : 
//   状态3:申请中 120 待补充资料 0 待确认用款10:
//   状态4:审核中 21 或者 待放款 151:
//   状态5:已结清 200 ，
//   状态6:小黑屋110:

enum RPFOrderStatus: Int {
    case overdue = 180//
    case repayment = 174//
    case application = 120//
    case addInfo = 0
    case pendingConfirm = 10
    case underReview = 21
    case pendingLoan = 151
    case alreadySetted = 200
    case blackList = 110
    case unowned  = -1 // 未知
    
    var color: UIColor {
        switch self {
        case .overdue:
            return .c_FF5454
        case .repayment:
            return .c_FFA559
        case .application, .addInfo, .pendingConfirm:
            return .c_1C917A
       
        case .underReview, .pendingLoan:
            return .c_1C917A
        
        case .alreadySetted:
            return .c_1C917A
        case .blackList:
            return .c_111111
        case .unowned:
            return .c_FF5454
        }
    }
    var btnColor: UIColor {
        switch self {
        case .overdue:
            return .c_FF5454
        case .repayment:
            return .c_FFA559
        case .application, .addInfo, .pendingConfirm:
            return .c_1C917A
            
        case .underReview, .pendingLoan:
            return .c_1C917A
            
        case .alreadySetted:
            return .c_1C917A
        case .blackList:
            return .c_AEAEAE
        case .unowned:
            return .c_FF5454
        }
    }
}
struct RPFOrderModel {
    var honestly = ""
    var andthey = ""       // 
    var plate = ""       // 
    var pursed = ""       // 
    var decide = ""       // 
    var lamb = ""       // 
    var hebarked = ""       // 
    var spoke = ""        // 
    var mymorgan = ""       // 
    var song = ""    // 
    var sweet = ""       // 
    var singing = ""               // 
    var girlslistened = ""            // 
    var shewas = ""               // 
    var shoes = ""            // 
    var bare = ""            //
    var shirt = ""               // 
    var blouse = ""            // 
    var ablue = ""            // 
    var shorts = ""            // 
    var feed = ""            // 
    var pair = ""            // 
    var dirty = ""            // 
    var wore = ""            // 
    var apple = ""            // 
    var plates = ""            // 
    var orderStatus = RPFOrderStatus.unowned 
   
    init(json: JSON){
        self.honestly = json["honestly"].stringValue
        self.andthey = json["andthey"].stringValue
        self.plate = json["plate"].stringValue
        self.pursed = json["pursed"].stringValue
        self.decide = json["decide"].stringValue
        self.lamb = json["lamb"].stringValue
        self.orderStatus = RPFOrderStatus(rawValue: json["lamb"].intValue) ?? .unowned
        self.hebarked = json["hebarked"].stringValue
        self.spoke = json["spoke"].stringValue
        self.mymorgan = json["mymorgan"].stringValue
        self.song = json["song"].stringValue
        self.sweet = json["sweet"].stringValue
        self.singing = json["singing"].stringValue
        self.girlslistened = json["girlslistened"].stringValue
        self.shewas = json["shewas"].stringValue
        self.shoes = json["shoes"].stringValue
        self.bare = json["bare"].stringValue
        self.shirt = json["shirt"].stringValue
        self.blouse = json["blouse"].stringValue
        self.ablue = json["ablue"].stringValue
        self.shorts = json["shorts"].stringValue
        self.feed = json["feed"].stringValue
        self.pair = json["pair"].stringValue
        self.dirty = json["dirty"].stringValue
        self.wore = json["wore"].stringValue
        self.apple = json["apple"].stringValue
        self.plates = json["plates"].stringValue
        
    }
}

