//
//  MainAppInfo.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import Foundation
import UIKit
import AdSupport
import CoreTelephony

let OsPlatform: String = {
    return "ios"
}()

/**
 *  获取APP版本号
 */
let AppVersion: String = {
   let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    return version
}()

/**
 *  市场
 */
let AppMarket: String = {
   return "lucky"
}()

/**
 *  设备型号名字
 */

var ModelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce(""){ identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    switch identifier {
    //IPhone
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
    case "iPhone4,1":                               return "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
    case "iPhone7,2":                               return "iPhone 6"
    case "iPhone7,1":                               return "iPhone 6 Plus"
    case "iPhone8,1":                               return "iPhone 6s"
    case "iPhone8,2":                               return "iPhone 6s Plus"
    case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
    case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
    case "iPhone8,4":                               return "iPhone SE"
    case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
    case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
    case "iPhone10,3", "iPhone10,6":                return "iPhone X"
    case "iPhone11,8":                              return "iPhone XR"
    case "iPhone11,2":                              return "iPhone XS"
    case "iPhone11,6":                              return "iPhone XS Max"
    case "iPhone12,1":                              return "iPhone 11"
    case "iPhone12,3":                              return "iPhone 11 Pro"
    case "iPhone12,5":                              return "iPhone 11 Pro Max"
    case "iPhone13,1":                              return "iPhone 12 mini"
    case "iPhone13,2":                              return "iPhone 12"
    case "iPhone13,3":                              return "iPhone 12 Pro"
    case "iPhone13,4":                              return "iPhone 12 Pro Max"
    case "iPhone14,4":                              return "iPhone 13 mini"
    case "iPhone14,5":                              return "iPhone 13"
    case "iPhone14,2":                              return "iPhone 13 Pro"
    case "iPhone14,3":                              return "iPhone 13 Pro Max"
    case "iPhone14,6":                              return "iPhone SE 3. Generation"
    case "iPhone14,7":                              return "iPhone 14"
    case "iPhone14,8":                              return "iPhone 14 Plus"
    case "iPhone15,2":                              return "iPhone 14 Pro"
    case "iPhone15,3":                              return "iPhone 14 Pro Max"
    case"iPhone15,4":                               return"iPhone 15"
    case"iPhone15,5":                               return"iPhone 15 Plus"
    case"iPhone16,1":                               return"iPhone 15 Pro"
    case"iPhone16,2":                               return"iPhone 15 Pro Max"

   
    case "i386", "x86_64":                          return "Simulator"
    default:                                        return identifier
    }
}()

/**
 *  系统版本
 */
let RapidSystemVersion: String = {
    let version = UIDevice.current.systemVersion
    return version
}()

/**
 *  设备唯一标识
 */
let DeviceID: String = {
    var deviceID = GetInfo(kDeviceId)
    if deviceID.isEmpty {
        deviceID = UUID().uuidString
        SetInfo(kDeviceId, value: deviceID)
    }
    return deviceID
}()

/**
 *  IDFA设备唯一标识
 */
let RapidSingleUUID: String = {
    return RapidSingleIdentifierManager.manager.getUUID()
}()

/**
 *  混淆随机数字符串
 */
let RapidRandom: String = {
//    return "eikskjeoifj345245"
    var randomString: String = ""
    for _ in 0..<20 {
        randomString += String(Int.random(in: 0...9))
    }
    return randomString
}()
/**
 *  sessionid
 */
let RapidSession: String = {
    return GetInfo(kRapidSession)
}()


let RapidUrlParam: String = {
   

    var para: [String : Any] = [String : Any]()
    para["bittengeorge"]     = OsPlatform
    para["wobblyagain"]      = AppVersion
    para["sick"]             = ModelName
    para["wall"]             = DeviceID
    para["leaning"]          = RapidSystemVersion
    para["graze"]            = AppMarket
    para["muchmore"]         = RapidSession
    para["teeth"]            = RapidSingleUUID
    para["boyfine"]          = RapidRandom
   
    return para.compentUrl()
}()

/**
 *  app name
 */
let RPFAppName: String = {
    if let name = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
        return name
    }
    if let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
        return name
    }
    if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
        return name
    }
    return "App"
}()

