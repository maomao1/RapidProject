//
//  RapidMainApi.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import RxSwift
import SwiftyJSON
import Alamofire

extension RapidApi {
    //获取登录/注册短信验证码
    func getLoginPhoneCode(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getPhoneCode,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    //
    func loginByPhone(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.loginByPhone,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    //
    func getLogOutData() -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.logout,
            parameters: ["follows": RapidRandom, "herlamb": RapidRandom ],
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func getLogOffData() -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.logoff,
            parameters: ["hides": RapidRandom],
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    //
    func getHomeData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.homeGetData,
            parameters: para,
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    //
    func getMineData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getMineData,
            parameters: para,
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func getAuthOneData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getAuthInfo1Data,
            parameters: para,
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    
}

extension RapidApi {
    //order
    func getOrderData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getOrderListData,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
}
