//
//  RPFOrderModel.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/16.
//

import SwiftyJSON

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
    
   
    init(json: JSON){
        self.honestly = json["honestly"].stringValue
        self.andthey = json["andthey"].stringValue
        self.plate = json["plate"].stringValue
        self.pursed = json["pursed"].stringValue
        self.decide = json["decide"].stringValue
        self.lamb = json["lamb"].stringValue
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

