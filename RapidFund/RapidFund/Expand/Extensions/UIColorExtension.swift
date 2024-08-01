//
//  UIColorExtension.swift
// RapidFund
//
//  Created by 毛亚恒 on 2023/10/19.
//

import UIKit

extension UIColor {
    convenience init?(webColor: String) {
        let startIndex = webColor.index(webColor.startIndex, offsetBy: 1)
        let hexColor = webColor.hasPrefix("#") ? String(webColor[startIndex...]) : webColor
        guard let colorValue = Int(hexColor, radix: 16) else {
            return nil
        }
        let red = CGFloat((colorValue & 0xff0000) >> 16) / 255.0
        let green = CGFloat((colorValue & 0x00ff00) >> 8) / 255.0
        let blue = CGFloat((colorValue & 0x0000ff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00ff00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000ff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func from(hex: Int) -> UIColor {
        return UIColor(hex: hex)
    }
    
}

extension UIColor {
    static let c_FFFFFF = UIColor(hex: 0xFFFFFF) //
    static let c_000000 = UIColor(hex: 0x000000) //
    static let c_111111 = UIColor(hex: 0x111111) //
    static let c_E5DEFA = UIColor(hex: 0xE5DEFA) //
    static let c_999999 = UIColor(hex: 0x999999) //
    static let c_232323 = UIColor(hex: 0x232323)
    static let c_151515 = UIColor(hex: 0x151515)
    static let c_FF8000 = UIColor(hex: 0xFF8000)
    static let c_FF7E00 = UIColor(hex: 0xFF7E00)

    
    
    
    static let c_CECECE = UIColor(hex: 0xCECECE)
    static let c_FF942F = UIColor(hex: 0xCFF942F)
    static let c_FFDE8E = UIColor(hex: 0xFFDE8E)
    static let c_FCA338 = UIColor(hex: 0xFCA338)
    static let c_E9BF70 = UIColor(hex: 0xE9BF70)
    static let c_E79636 = UIColor(hex: 0xE79636)
    static let c_5E9F7A = UIColor(hex: 0x5E9F7A)
    static let c_666666 = UIColor(hex: 0x666666)
}
