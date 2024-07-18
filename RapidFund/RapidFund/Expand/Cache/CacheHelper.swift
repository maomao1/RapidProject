//
//  CacheHelper.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import Foundation

//信息写入本地
func SetInfo(_ key: String, value: String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

//信息从本地读取
func GetInfo(_ key: String) -> String {
    let str = UserDefaults.standard.object(forKey: key) as? String
    return str ?? ""
}

class RapidUserCache {
    
    static let `default` = RapidUserCache()
    
    //缓存用户sessionId
    func cacheUserInfo(session: String) {
        UserDefaults.standard.setValue(session, forKey: kRapidSession)
        print("===++++++++")
        print(session)
        UserDefaults.standard.synchronize()
    }
    
    func clearUserInfo() {
        UserDefaults.standard.setValue("", forKey: kRapidSession)
        print("------------------")
        UserDefaults.standard.synchronize()
    }
}
