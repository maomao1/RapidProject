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
            parameters: ["follows": getRPFRandom(), "herlamb": getRPFRandom() ],
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func getLogOffData() -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.logoff,
            parameters: ["hides": getRPFRandom()],
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
    
    func getRecommendData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.homeRecommendGetData,
            parameters: para,
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func getProductNextData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.homeProductNextPath,
            parameters: para,
            method: .post,
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
    
    func getIDUploadData(para: Parameters) -> Observable<JSON> {
        return upload(
        path: BaseURl + RapidApiConstantUrl.iDUpload,
        parameters: para,
        method: .post,
        completionHandler: { $0 })
    }
    
    func saveIDInfoData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.saveIDInfo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func uploadFaceUrl(para: Parameters) -> Observable<JSON> {
        return upload(
            path: BaseURl + RapidApiConstantUrl.uploadFaceUrl,
            parameters: para,
            method: .post,
//            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func getFaceUrl(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getFaceUrl,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func getTwoUserInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getUserDataTwo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func saveTwoUserInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.saveUserDataTwo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func getWorkInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getWorkInfo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func saveWorkInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.setWorkInfo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func getContactsInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getContactInfo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func saveContactInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.saveContactInfo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    // 绑卡信息
    func getBindCardInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getBindBankInfo,
            parameters: para,
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func commitBindCardInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.commitBankInfo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func bankList(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getBankList,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func changeBankCardInfo(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.changeBankInfo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func productDetail(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.productDetail,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func addressDetail(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.addressDetail,
            parameters: para,
            method: .get,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func idVerifyNext(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.idVerifyNext,
            parameters: para,
            method: .post,
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
    
    func getOrderProductWebAdress(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.getOrderProductWebUrl,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    //report
    func postLocationData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.updateLocation,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func postGoogleMarketData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.updateGoogleMarket,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func postDevicInfoData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.updateDeviceInfo,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func postAnalysisData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.uploadMaidian,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
    
    func postAdressBookData(para: Parameters) -> Observable<JSON> {
        return request(
            path: BaseURl + RapidApiConstantUrl.uploadAdressBook,
            parameters: para,
            method: .post,
            encoding: URLEncoding.default,
            completionHandler: { $0 })
    }
}
