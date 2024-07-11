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
    
    //生成渐变色图片
    convenience init(gradientColors: [UIColor] = [.c_E5DEFA, .c_FFFFFF],
                     size: CGSize,
                     isHorizontal: Bool = true) {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = gradientColors.map{ return $0.cgColor}
        let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil)
        context?.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: isHorizontal ? size.width : 0, y: isHorizontal ? 0 : size.height), options: .init(rawValue: 0))
        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        UIGraphicsEndImageContext()
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
    
    

    
    //MARK: - login
    static let loginBgImage = UIImage(named: "login_bgImage")!
    static let loginRapidImage = UIImage(named: "login_rapidImage")!
    static let loginSureArrowImage = UIImage(named: "login_sure_arrow")!
    static let loginCountryImage = UIImage(named: "login_countryImage")!
    static let loginAgreeNormalImage = UIImage(named: "login_agree_normal")!
    static let loginAgreeSelectedImage = UIImage(named: "login_agree_selected")!
    static let loginConfirmBtnImage = UIImage(named: "login_confirm_btn")!
    
    //MARK: - home
    static let homeNavBlackRight = UIImage(named: "home_nav_black_right")!
    static let homeNavBlackBack  = UIImage(named: "home_nav_black_back")!
    static let homeNavWhiteRight = UIImage(named: "home_nav_white_right")!
    static let homeNavWhiteBack  = UIImage(named: "home_nav_white_back")!
    static let homeFullBg   = UIImage(named: "home_full_bg")!
    static let homeCircleLeft   = UIImage(named: "home_circle_left")!
    static let homeCircleTopRight   = UIImage(named: "home_circle_topRight")!
    static let homeCircleBottomRight   = UIImage(named: "home_circle_bottomRight")!
    static let homeUnloginBg   = UIImage(named: "home_unlogin_bg")!
    static let homeBtnBg   = UIImage(named: "home_btn_bg")!
    static let homeApplyArrow   = UIImage(named: "home_apply_arrow")!
    static let homeLimitIcon   = UIImage(named: "home_limit_icon")!
    static let homeSoundIcon   = UIImage(named: "home_sound_icon")!
    static let homeLoginTopBg   = UIImage(named: "home_login_topBg")!
    static let homeLoginBanner   = UIImage(named: "home_banner")!

    
    
    //MARK: - order
    static let orderFullBg   = UIImage(named: "order_full_bg")!
    static let orderMenuBg   = UIImage(named: "order_menu_bg")!
    static let orderTopBg   = UIImage(named: "order_top_bgImg")!
    static let orderUnpaidIcon   = UIImage(named: "order_unpaid_icon")!
    static let orderUnderIcon   = UIImage(named: "order_under_icon")!
    static let orderFailedIcon   = UIImage(named: "order_failed_icon")!
    static let orderSettedIcon   = UIImage(named: "order_setted_icon")!

    
    //MARK: - mine
    static let mineFullBg   = UIImage(named: "mine_full_bg")!
    static let mineCenterBg = UIImage(named: "mine_center_bg")!
    static let mineMenuBg  = UIImage(named: "mine_menu_bg")!
    static let mineRightBg  = UIImage(named: "mine_right_bg")!
    static let mineAboutUs  = UIImage(named: "mine_about_us")!
    static let mineAgreement  = UIImage(named: "mine_agreement")!
    static let mineLogOff  = UIImage(named: "mine_logoff")!
    static let mineLogOut  = UIImage(named: "mine_logout")!
    static let mineMyOrder  = UIImage(named: "mine_my_order")!
    static let mineMyPayment  = UIImage(named: "mine_my_payment")!
    static let mineCellArrow  = UIImage(named: "mine_set_arrow")!
    
    static let mineLogOutIcon  = UIImage(named: "mine_icon_logout")!
    static let mineLogOffIcon  = UIImage(named: "mine_icon_logoff")!
    

}
