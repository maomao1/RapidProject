//
//  
//  RapidFund
//
//  Created by 毛亚恒 on  2024/7/8.
//

import UIKit


let SeparatorThickness = 1 / UIScreen.main.scale
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

let kPortraitScreenW = UIScreen.main.fixedCoordinateSpace.bounds.width
let kPortraitScreenH = UIScreen.main.fixedCoordinateSpace.bounds.height
let Ratio = kPortraitScreenW / 375
let ScaledRatio = Ratio * Scale
let Scale = UIScreen.main.scale
let InvertedScale = 1 / Scale

//屏幕分辨率
let kScreenWidthResolution = kScreenWidth * Scale
let kScreenHeightResolution = kScreenHeight * Scale


//MARK: - cache
let kDeviceId = "kDeviceId"
let kRapidSession = "kRapid_loginSession"



struct RapidMetrics {
    
    static let tabbarHeight: CGFloat = IPHONE_X ? 83 : 49
    //状态条高度
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    //导航栏高度
    static let navigationBarHeight = 44.f
    //导航栏和状态条总高度
    static let navBarHeight: CGFloat = (statusBarHeight + navigationBarHeight)
    static let homeBarHeight: CGFloat = IPHONE_X ? 34 : 0
    static let separatorThickness = 2 / UIScreen.main.scale
    
    static let LeftRightMargin = 24.rf
    private init() {}
}

var IPHONE_X:Bool {
    if #available(iOS 10.0, *) {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0 > 0.f
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    return false
}
