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
}
