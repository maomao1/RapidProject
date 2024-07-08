//
//  RapidApi.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import Alamofire
import RxSwift
import SwiftyJSON

class RapidApi: SessionManager {
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
     
//        configuration.httpAdditionalHeaders?["app_version"] = versionBuild//app_version，必传
//        configuration.httpAdditionalHeaders?["platformType"] = "iOS"
//        configuration.httpAdditionalHeaders?["deviceId"] = YDYSingleUUID//设备唯一标识，必传
//        //其他
//       
////        configuration.httpAdditionalHeaders?["device_flag"] = DeviceID //UUID
//        configuration.httpAdditionalHeaders?["device_type"] = ModelName
//        configuration.httpAdditionalHeaders?["system_version"] = SystemVersion
//        configuration.httpAdditionalHeaders?["device_system"] = UIDevice.current.systemName
//        let serverTrustPolicies: [String : ServerTrustPolicy] = [
//            "172.16.0.158": .disableEvaluation,
//            "172.16.0.159": .disableEvaluation,
//            "loctestdtx.edocyun.com.cn": .disableEvaluation]
        let serverTrustPolicies: [String : ServerTrustPolicy] = [String : ServerTrustPolicy]()
        super.init(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }
    
    static let shared = RapidApi()
    
    //REQUEST 请求
    func request<T>(path: String,
                    parameters: Parameters? = nil,
                    signPara: String = "",
                    method: HTTPMethod = .post,
                    encoding: ParameterEncoding = JSONEncoding.default,
                    completionHandler: @escaping ((JSON) -> T)) -> Observable<T> {
        var fullPath = path + RapidUrlParam
        debugPrint("fullpath====\(fullPath)")
        debugPrint(parameters ?? [:])

        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let `self` = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let dataRequest = self
                .request(fullPath,
                         method: method,
                         parameters: parameters,
                         encoding: encoding,
                         headers: nil)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        debugPrint(json)
                        if json.isSuccessful {
                            observer.onNext(completionHandler(json.resultData))
                            observer.onCompleted()
                        }
                        else {
                            let error = RapidError.other(message: json.YaloMsg)
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let _ = error as? AFError,
                           let json = try? JSON(data: response.data ?? Data()) {
                            let error = RapidError.other(message: json.YaloMsg)
                            observer.onError(error)
                        } else {
                            let err = error as NSError
//                            if err.code == -1009 {
//                                let error = YDYError.noNetwork(message: err.localizedDescription)
//                                observer.onError(error)
//                            } else {
                                let error = RapidError.other(message: response.response?.statusCode.description ?? error.localizedDescription)
                                observer.onError(error)
//                            }
                        }
                    }
                })
            return Disposables.create {
                dataRequest.cancel()
            }
        })
    }
}
