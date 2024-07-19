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
    func saveLocation(){
        var param: [String : Any] = [String : Any]()
        param["aface"] = "省"
        param["curls"] = "国家code"
        param["untidy"] = "国家"
        param["creature"] = "街道"
        param["whichever"] = "经度"
        param["scampering"] = "维度"
        param["lambgambolling"] = "市"
        param["towards"] = getRPFRandom()
        param["skipping"] = getRPFRandom()
        
        RapidApi.shared.postLocationData(para: param)
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
        
        param["clutched"] = "市"
        param["pitch"] = getRPFRandom()
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
    
    func saveAdressBook(){
        var param: [String : Any] = [String : Any]()
        
        param["dismay"] = "3"
        param["trouble"] = "jsonstr"
        param["exclaiming"] = getRPFRandom()
        param["valley"] = getRPFRandom()
        
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
       "fearless": [//ios忽略
         {
           "probably": "39.22661",
           "thananyone": "5000",
           "wasan": "BMI120 Accelerometer",
           "worse": "0.18",
           "beentoo": "0.0023956299",
           "dismay": "1",
           "whole": "BOSCH",
           "enjoyedthis": "2062701"
         }
       ],
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
        var param: [String : Any] = [String : Any]()
     
        param["trouble"] = "jsonstr"
      
        RapidApi.shared.postDevicInfoData(para: param)
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

    func saveAnalysis(){
        var param: [String : Any] = [String : Any]()
        param["andthey"] = ""
        param["stones"] = ""
        param["risking"] = ""
        param["tolight"] = ""
        param["torch"] = ""
        param["scampering"] = ""
        param["whichever"] = ""
        param["naps"] = ""
        param["yawnedtoo"] = ""
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
