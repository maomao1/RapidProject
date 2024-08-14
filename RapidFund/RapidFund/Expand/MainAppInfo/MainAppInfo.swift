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
import SystemConfiguration.CaptiveNetwork
import Darwin

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
 *  包名
 */
let AppProjectName: String = {
  
    if let bundleIdentifier = Bundle.main.bundleIdentifier {
        return bundleIdentifier
    } else {
        return "com.zhuanyong.test"
    }
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

//
var ScreenInch: String = {
    switch ModelName{
    
    case "iPhone 4","iPhone 4s":
        return "3.5"
    
    case "iPhone 5","iPhone 5s","iPhone 5c":
        return "4.0"
   
    case "iPhone 6","iPhone 6s","iPhone 7","iPhone 8","iPhone SE":
        return "4.7"
        
    case "iPhone 12 mini","iPhone 13 mini":
        return "5.4"
   
    case "iPhone 6 Plus","iPhone 6s Plus","iPhone 7 Plus","iPhone 8 Plus":
        return "5.5"
        
    case "iPhone X","iPhone XS","iPhone 11 Pro":
        return "5.8"
        
    case "iPhone 11","iPhone XR","iPhone 12","iPhone 13","iPhone 12 Pro","iPhone 13 Pro","iPhone 14","iPhone 14 Pro","iPhone 15","iPhone 15 Pro":
        return "6.1"
        
    case "iPhone XS Max ","iPhone 11 Pro Max":
        return "6.5"
        
    case "iPhone 12 Pro Max","iPhone 13 Pro Max","iPhone 14 Plus","iPhone 14 Pro Max","iPhone 15 Plus","iPhone 15 Pro Max":
        return "6.7"
        
    
    default:
        return "5.8"
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

let RapidIDFV: String = {
    return RapidSingleIdentifierManager.manager.getUUID()
}()

let RapidIDFA: String = {
    return RapidSingleIdentifierManager.manager.getIDFA()
}()

/**
 *  是否充电
 */
func isPhoneCharging() -> Bool {
    let device = UIDevice.current
    if device.batteryState == .unplugged {
        return false
    }
    let batteryLevel = device.batteryLevel
    if batteryLevel == 1 {
        return true
    }
    return false
}
//检测代理
func isUsedProxy() -> Bool {
    guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
    guard let dict = proxy as? [String: Any] else { return false }
    let isUsed = dict.isEmpty // 有时候未设置代理dictionary也不为空，而是一个空字典
    guard let HTTPProxy = dict["HTTPProxy"] as? String else { return false }
    if(HTTPProxy.count>0){
        return true;
    }
    return false;
}
func isVPNEnabled() -> Bool {
    var isVPNEnabled = false
    if let dict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: AnyObject] {
        if let proxies = dict[kCFNetworkProxiesHTTPProxy as String] as? [AnyHashable: Any] {
            isVPNEnabled = !(proxies[kCFNetworkProxiesHTTPEnable as String] as? Bool ?? false)
        }
    }
    return isVPNEnabled
}

/// 获取当前设备IP
func deviceIP() -> String? {
    var addresses = [String]()
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while (ptr != nil) {
            let flags = Int32(ptr!.pointee.ifa_flags)
            var addr = ptr!.pointee.ifa_addr.pointee
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String(validatingUTF8:hostname) {
                            addresses.append(address)
                        }
                    }
                }
            }
            ptr = ptr!.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
    }
    return addresses.first
}

/// WiFi获得的IP
var wifiIP:String?{
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    guard getifaddrs(&ifaddr) == 0 else {
        return nil
    }
    guard let firstAddr = ifaddr else {
        return nil
    }
     
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee
        // Check for IPV4 or IPV6 interface
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
            // Check interface name
            let name = String(cString: interface.ifa_name)
            if name == "en0" {
                // Convert interface address to a human readable string
                var addr = interface.ifa_addr.pointee
                var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(&addr,socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostName)
            }
        }
    }
     
    freeifaddrs(ifaddr)
    return address
}
//func getWIFISSID() -> String {
//        var wifiName = ""
//        let wifiInterfaces = CNCopySupportedInterfaces()
//        guard wifiInterfaces != nil else {
//            return wifiName
//        }
//
//        let interfaceArr = CFBridgingRetain(wifiInterfaces) as! [String]
//        if interfaceArr.count > 0 {
//            let interfaceName = interfaceArr[0] as CFString
//            let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
//
//            if ussafeInterfaceData != nil {
//                let interfaceData = ussafeInterfaceData as! [String: Any]
//                wifiName = interfaceData["SSID"]! as! String
//            }
//        }
//        return wifiName
//    }

func isJailbroken() -> Bool {
    let fileManager = FileManager.default
    let paths = [
        "/Applications/Cydia.app",
        "/private/var/lib/apt/",
        "/usr/bin/ssh",
        "/usr/sbin/sshd",
        "/etc/apt",
        "/usr/bin/cycript",
        "/usr/bin/dpkg",
        "/usr/bin/lzma",
        "/bin/bash",
        "/bin/sh",
        "/etc/ssh/sshd_config",
        "/etc/apt/sources.list",
        "/etc/apt/sources.list.d/",
        "/private/var/lib/cydia",
        "/private/var/lib/dpkg/",
    ]
 
    for path in paths {
        if fileManager.fileExists(atPath: path) {
            return true
        }
    }
 
    return false
}

func isRunningOnSimulator() -> Bool {
    let isSimulator = TARGET_OS_SIMULATOR
    return isSimulator != 0
}


/// 获取当前语言
func deviceLanguage() -> String {
    return Locale.preferredLanguages[0]
}


/// 获取总内存大小
func totalRAM() -> Int64 {
    var fs = blankof(type: statfs.self)
    if statfs("/var",&fs) >= 0{
        return Int64(UInt64(fs.f_bsize) * fs.f_blocks)
    }
    return -1
}


func getMemoryInfo(total: Bool) -> Int64 {
    var size = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
    var vmStats = vm_statistics_data_t()
    let hostPort: mach_port_t = mach_host_self()
    let kernelReturn: kern_return_t = withUnsafeMutablePointer(to: &vmStats) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_statistics(hostPort, HOST_VM_INFO, $0, &size)
        }
    }
    
    if kernelReturn != KERN_SUCCESS {
        return 0
    }
    
    // 活动页数 * 页大小 = 活动内存大小
    let activeMemory = Int(vmStats.active_count) * Int(getpagesize())
    // 在活动内存中，未使用的内存大小可以通过活动内存减去活跃或者在使用中的内存来计算
    let freeMemory = Int(vmStats.free_count) * Int(getpagesize())
    
    return Int64(total ? activeMemory : freeMemory)
}



func  getDiskSpace(total: Bool) -> Int64 {
    let fileManager = FileManager.default
     
    if let systemAttributes = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
       let systemSize = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value,
       let systemFreeSize = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
        print("Total Disk Space: \(systemSize) bytes")
        print("Available Disk Space: \(systemFreeSize) bytes")
        return total ? systemSize : systemFreeSize
    } else {
        print("Unable to retrieve disk space information.")
        return 0
    }
}
/// 获取当前可用内存
func availableRAM() -> Int64 {
    var fs = blankof(type: statfs.self)
    if statfs("/var",&fs) >= 0{
        return Int64(UInt64(fs.f_bsize) * fs.f_bavail)
    }
    return -1
}
/// 私有方法
private func blankof<T>(type:T.Type) -> T {
    let ptr = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
    let val = ptr.pointee
    ptr.deinitialize(count: 0)
    return val
}

func getRPFRandom()-> String{
    var randomString: String = ""
    for _ in 0..<20 {
        randomString += String(Int.random(in: 0...9))
    }
    return randomString
}
/**
 *  sessionid
 */
var RapidSession: String = {
    return GetInfo(kRapidSession)
}()

func getCurrentTime() -> String{
    return "\(Int(Date().timeIntervalSince1970) * 1000)"
}

func  getRapidUrlBaseParam()-> [String: String]  {
    var para: [String : String] = [String : String]()
    para["bittengeorge"]     = OsPlatform
    para["wobblyagain"]      = AppVersion
    para["sick"]             = ModelName
    para["wall"]             = RapidSingleUUID
    para["leaning"]          = RapidSystemVersion
    para["graze"]            = AppMarket
    para["muchmore"]         = GetInfo(kRapidSession)
    para["teeth"]            = RapidSingleUUID
    para["boyfine"]          = getRPFRandom()
    return para
}
func  getRapidUrlParam()-> String  {
    var para: [String : Any] = [String : Any]()
    para["bittengeorge"]     = OsPlatform
    para["wobblyagain"]      = AppVersion
    para["sick"]             = ModelName
    para["wall"]             = RapidSingleUUID
    para["leaning"]          = RapidSystemVersion
    para["graze"]            = AppMarket
    para["muchmore"]         = GetInfo(kRapidSession)
    para["teeth"]            = RapidSingleUUID
    para["boyfine"]          = getRPFRandom()
    return para.compentUrl()
//    return para
}

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

