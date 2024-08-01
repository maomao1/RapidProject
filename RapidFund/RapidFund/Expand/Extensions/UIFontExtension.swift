//
//  UIFontExtension.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2023/10/18.
//

import UIKit

extension UIFont {
    
    static func scFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SourceHanSansCN-Regular", size: size) ?? self.systemFont(ofSize: size)
    }
    
    static func boldScFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SourceHanSansCN-Bold", size: size) ?? self.boldSystemFont(ofSize: size)
    }
    
    static func RegularPingFangFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size) ?? self.systemFont(ofSize: size)
    }
    
    static func LightPingFangFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: size) ?? self.systemFont(ofSize: size)
    }
    
    static func MediumPingFangFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size) ?? self.systemFont(ofSize: size)
    }
    
    static func BoldPingFangFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size) ?? self.systemFont(ofSize: size)
    }
}

//MARK: - app bold font
extension UIFont {
    static let f_boldSys14 = UIFont.BoldPingFangFont(ofSize: 14.rf)
    static let f_boldSys15 = UIFont.BoldPingFangFont(ofSize: 15.rf)
    static let f_boldSys16 = UIFont.BoldPingFangFont(ofSize: 16.rf)
    static let f_boldSys17 = UIFont.BoldPingFangFont(ofSize: 17.rf)
    static let f_boldSys18 = UIFont.BoldPingFangFont(ofSize: 18.rf)
    static let f_boldSys19 = UIFont.BoldPingFangFont(ofSize: 19.rf)
    static let f_boldSys20 = UIFont.BoldPingFangFont(ofSize: 20.rf)
    static let f_boldSys32 = UIFont.BoldPingFangFont(ofSize: 32.rf)
    
}

extension UIFont {
    static let f_lightSys10 = UIFont.LightPingFangFont(ofSize: 10.rf)
    static let f_lightSys11 = UIFont.LightPingFangFont(ofSize: 11.rf)
    static let f_lightSys12 = UIFont.LightPingFangFont(ofSize: 12.rf)
    static let f_lightSys14 = UIFont.LightPingFangFont(ofSize: 14.rf)
    static let f_lightSys15 = UIFont.LightPingFangFont(ofSize: 15.rf)
    static let f_lightSys16 = UIFont.LightPingFangFont(ofSize: 16.rf)
    static let f_lightSys17 = UIFont.LightPingFangFont(ofSize: 17.rf)
    static let f_lightSys18 = UIFont.LightPingFangFont(ofSize: 18.rf)
    static let f_lightSys19 = UIFont.LightPingFangFont(ofSize: 19.rf)
    static let f_lightSys20 = UIFont.LightPingFangFont(ofSize: 20.rf)
    static let f_lightSys24 = UIFont.LightPingFangFont(ofSize: 24.rf)
    static let f_lightSys32 = UIFont.LightPingFangFont(ofSize: 32.rf)
    static let f_lightSys33 = UIFont.LightPingFangFont(ofSize: 33.rf)
    
}

extension UIFont {
    
    static let f_regSys15 = UIFont.RegularPingFangFont(ofSize: 15.rf)
    static let f_regSys16 = UIFont.RegularPingFangFont(ofSize: 16.rf)
    static let f_regSys17 = UIFont.RegularPingFangFont(ofSize: 17.rf)
    static let f_regSys18 = UIFont.RegularPingFangFont(ofSize: 18.rf)
    static let f_regSys19 = UIFont.RegularPingFangFont(ofSize: 19.rf)
    static let f_regSys20 = UIFont.RegularPingFangFont(ofSize: 20.rf)
    
}
