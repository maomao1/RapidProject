//
//  RPFMineModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/15.
//

import SwiftyJSON

struct RPFMineModel {
    var disapproval = ""
    var hastily = ""       // 
    var madebread = ""       // 
    var picking = ""       // 
    var cheese = ""       // 
    var golly = ""       // 
    var littleroom = ""       // 
    var pie = ""        // 
    var salt = ""       // 
    var inand = ""    // 
    var fresher = ""       // 
    var comfortingly = ""               // 
    var mustn = ""            // 
    var herdog = ""               // 
    var coldwater = ""            // 
    var saidher = ""            //
    var tray = ""               // 
    var thearm = ""            // 
    
   
    init(json: JSON){
        self.disapproval = json["disapproval"].stringValue
        self.hastily = json["hastily"].stringValue
        self.madebread = json["madebread"].stringValue
        self.picking = json["picking"].stringValue
        self.cheese = json["cheese"].stringValue
        self.golly = json["golly"].stringValue
        self.littleroom = json["littleroom"].stringValue
        self.pie = json["pie"].stringValue
        self.salt = json["salt"].stringValue
        self.inand = json["inand"].stringValue
        self.fresher = json["fresher"].stringValue
        self.comfortingly = json["comfortingly"].stringValue
        self.mustn = json["mustn"].stringValue
        self.herdog = json["herdog"].stringValue
        self.coldwater = json["coldwater"].stringValue
        self.saidher = json["saidher"].stringValue
        self.tray = json["tray"].stringValue
        self.thearm = json["thearm"].stringValue
        
    }
}
