//
//  UIImageExtension.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2023/10/18.
//

import UIKit

extension UIImage {
    
    static func imageWith(color: UIColor,
                          scaleFactor: CGFloat = UIScreen.main.scale,
                          size: CGSize = CGSize(width: SeparatorThickness, height: SeparatorThickness)) -> UIImage? {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scaleFactor)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    //MARK: - tabbar
    static let rapidHomeNormal = UIImage(named: "rapidTabbarHome")!
    static let rapidHomeSelected = UIImage(named: "rapidTabbarHomeSelected")!
    static let rapidOrderNormal = UIImage(named: "rapidTabbarOrder")!
    static let rapidOrderSelected = UIImage(named: "rapidTabbarOrderSelected")!
    static let rapidMineNormal = UIImage(named: "rapidTabbarMine")!
    static let rapidMineSelected = UIImage(named: "rapidTabbarMineSelected")!
    
    //MARK: - mine
//    static let yaloMineHelp = UIImage(named: "yalo_mine_help")!
//    static let yaloMineXieYi = UIImage(named: "yalo_mine_xieyi")!
//    static let yaloMineYinSi = UIImage(named: "yalo_mine_yinsi")!
//    static let yaloMineSet = UIImage(named: "yalo_mine_set")!
//    static let yaloMineKefu = UIImage(named: "yalo_mine_kefu")!
    
    //MARK: - login
    static let loginBgImage = UIImage(named: "login_bgImage")!
    static let loginRapidImage = UIImage(named: "login_rapidImage")!
    static let loginSureArrowImage = UIImage(named: "login_sure_arrow")!
    static let loginCountryImage = UIImage(named: "login_countryImage")!
    static let loginAgreeNormalImage = UIImage(named: "login_agree_normal")!
    static let loginAgreeSelectedImage = UIImage(named: "login_agree_selected")!
    
    //MARK: - home
    static let homeNavRight = UIImage(named: "home_nav_right")!
    static let homeNavBack  = UIImage(named: "home_nav_back")!

}
