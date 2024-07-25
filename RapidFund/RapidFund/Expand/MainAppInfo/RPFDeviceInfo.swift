//
//  RPFDeviceInfo.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/24.
//

import CoreTelephony
import SystemConfiguration

class RPFDeviceManager: NSObject {
    
    ///获取运营商
    class func getDeviceSupplier() -> String {
        return rf_deviceSupplier()
    }
    
    class func getNetWorkType() -> String {
        return rf_networkType()
    }
    
    class func getTimeZone() -> String {
        let timeZone = TimeZone.current
        let timeZoneName = timeZone.identifier // 时区的名称，例如："Europe/Paris"
        let timeZoneOffset = timeZone.secondsFromGMT() 
        return timeZoneName + "\(timeZoneOffset)"
    }
    
    class func getPhoneRunTime() -> String {
        let startTime = Int(ProcessInfo.processInfo.systemUptime * 1000)
        let runtime = Int(Date().timeIntervalSince1970 * 1000)
        let currentMillis = startTime + runtime
        return "\(currentMillis)"
    }
    
    class func getWiFiName() -> [NetworkInfo]? {
         if let interfaces: NSArray = CNCopySupportedInterfaces() {
             var networkInfos = [NetworkInfo]()
             for interface in interfaces {
                 let interfaceName = interface as! String
                 var networkInfo = NetworkInfo(interface: interfaceName,
                                               success: false,
                                               ssid: nil,
                                               bssid: nil)
                 if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                     networkInfo.success = true
                     networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                     networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                 }
                 networkInfos.append(networkInfo)
             }
             return networkInfos
         }
         return nil
     }
    
    
    /// 无网络返回字样
    private static var notReachable: String {
        get {
            return "notReachable"
        }
    }

    
    


}

extension RPFDeviceManager {
    ///获取运营商
    private class func rf_deviceSupplier() -> String {
        let info = CTTelephonyNetworkInfo()
        var supplier:String = ""
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.count == 0 {
                    return "无手机卡"
                } else { //获取运营商信息
                    for (index, carrier) in carriers.values.enumerated() {
                        guard carrier.carrierName != nil else { return "无手机卡" }
                        //查看运营商信息 通过CTCarrier类
                        if index == 0 {
                            supplier = carrier.carrierName!
                        } else {
                            supplier = supplier + "," + carrier.carrierName!
                        }
                    }
                    return supplier
                }
            } else{
                return "无手机卡"
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                guard carrier.carrierName != nil else { return "无手机卡" }
                return carrier.carrierName!
            } else{
                return "无手机卡"
            }
        }
    }
    
    /// 获取网络类型
    private class func rf_networkType() -> String {
        var zeroAddress = sockaddr_storage()
        bzero(&zeroAddress, MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_len = __uint8_t(MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { address in
                SCNetworkReachabilityCreateWithAddress(nil, address)
            }
        }
        guard let defaultRouteReachability = defaultRouteReachability else {
            return notReachable
        }
        var flags = SCNetworkReachabilityFlags()
        let didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        
        guard didRetrieveFlags == true,
              (flags.contains(.reachable) && !flags.contains(.connectionRequired)) == true
        else {
            return notReachable
        }
        if flags.contains(.connectionRequired) {
            return notReachable
        } else if flags.contains(.isWWAN) {
            return self.rf_cellularType()
        } else {
            return "WiFi"
        }
    }
    
    /// 获取蜂窝数据类型
    private class func rf_cellularType() -> String {
        let info = CTTelephonyNetworkInfo()
        var status: String
        
        if #available(iOS 12.0, *) {
            guard let dict = info.serviceCurrentRadioAccessTechnology,
                  let firstKey = dict.keys.first,
                  let statusTemp = dict[firstKey] else {
                return notReachable
            }
            status = statusTemp
        } else {
            guard let statusTemp = info.currentRadioAccessTechnology else {
                return notReachable
            }
            status = statusTemp
        }
        
        if #available(iOS 14.1, *) {
            if status == CTRadioAccessTechnologyNR || status == CTRadioAccessTechnologyNRNSA {
                return "5G"
            }
        }
        
        switch status {
        case CTRadioAccessTechnologyGPRS,
            CTRadioAccessTechnologyEdge,
        CTRadioAccessTechnologyCDMA1x:
            return "2G"
        case CTRadioAccessTechnologyWCDMA,
            CTRadioAccessTechnologyHSDPA,
            CTRadioAccessTechnologyHSUPA,
            CTRadioAccessTechnologyeHRPD,
            CTRadioAccessTechnologyCDMAEVDORev0,
            CTRadioAccessTechnologyCDMAEVDORevA,
        CTRadioAccessTechnologyCDMAEVDORevB:
            return "3G"
        case CTRadioAccessTechnologyLTE:
            return "4G"
        default:
            return notReachable
        }
    }
        
}
