//
//  RapidSingleIdentifierManager.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit
import AdSupport
import AppTrackingTransparency

class RapidSingleIdentifierManager: NSObject {
    
    static let manager = RapidSingleIdentifierManager()
    
    //获取 UUID 直接获取 UUID 每次卸载重新安装 app 后可能会导致 UUID 变化,为了获取唯一的 UUID,我们使用 keyChian 对 UUID 进行保存
    func getUUID() -> String {
        if let uuid = self.keyChainReadData(identifier: "key") as? String {
            return uuid
        } else {
            let uuid = UUID().uuidString
            if self.keyChainSaveData(data: uuid, withIdentifier: "key") {
                return uuid
            }
        }
        return "simulator"
    }
    
    func getIDFA() -> String {
        if #available(iOS 14, *) {
            var idfaStr = ""
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized {
                    // Tracking is authorized
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    idfaStr = idfa
                } else {
//                    return ""
                }
            }
            return idfaStr
        } else {
            // Fallback on earlier versions
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            
            return idfa
        }
       
        
    }
    
    func getIDFV() -> String {
        if let idfv = self.keyChainReadData(identifier: "idfvKey") as? String {
            return idfv
        } else {
             let idfv = UIDevice.current.identifierForVendor?.uuidString 
            if let idfa = idfv {
                if self.keyChainSaveData(data: idfa, withIdentifier: "idfvKey") {
                    return idfa
                }
            }
            
        }
        return "simulator"
    }
    
    //创建查询条件
    func createQuaryMutableDictionary(identifier: String)-> NSMutableDictionary{
        // 创建一个条件字典
        let keychainQuaryMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // 设置条件存储的类型
        keychainQuaryMutableDictionary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        // 设置存储数据的标记
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrService as String)
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrAccount as String)
        // 设置数据访问属性
        keychainQuaryMutableDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        // 返回创建条件字典
        return keychainQuaryMutableDictionary
    }

    //查询数据
    func keyChainReadData(identifier: String)-> Any {
        var idObject:Any?
        // 获取查询条件
        let keyChainReadmutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 提供查询数据的两个必要参数
        keyChainReadmutableDictionary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        keyChainReadmutableDictionary.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        // 创建获取数据的引用
        var queryResult: AnyObject?
        // 通过查询是否存储在数据
        let readStatus = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(keyChainReadmutableDictionary, UnsafeMutablePointer($0))}
        if readStatus == errSecSuccess {
        if let data = queryResult as! NSData? {
            idObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as Any
        }
        }
        return idObject as Any
    }
    
    //存储数据
    func keyChainSaveData(data: Any ,withIdentifier identifier:String)-> Bool {
        // 获取存储数据的条件
        let keyChainSaveMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 删除旧的存储数据
        SecItemDelete(keyChainSaveMutableDictionary)
        // 设置数据
        keyChainSaveMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // 进行存储数据
        let saveState = SecItemAdd(keyChainSaveMutableDictionary, nil)
        if saveState == noErr  {
            return true
        }
        return false
    }
    
    //更新数据
    func keyChainUpdata(data: Any ,withIdentifier identifier:String)->Bool {
        // 获取更新的条件
        let keyChainUpdataMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 创建数据存储字典
        let updataMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // 设置数据
        updataMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // 更新数据
        let updataStatus = SecItemUpdate(keyChainUpdataMutableDictionary, updataMutableDictionary)
        if updataStatus == noErr {
            return true
        }
        return false
    }
    
    //删除数据
    func keyChianDelete(identifier: String)->Void{
        // 获取删除的条件
        let keyChainDeleteMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 删除数据
        SecItemDelete(keyChainDeleteMutableDictionary)
    }
    
    
}
