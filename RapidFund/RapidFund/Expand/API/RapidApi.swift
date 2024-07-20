//
//  RapidApi.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import Alamofire
import RxSwift
import SwiftyJSON

struct BinaryData {
    let data: Data
    let mimeType: String
    let ext: String
}

//网络请求拦截器
class RPFAPIInterceptor {
   
    init() { }
    
    static let shared = RPFAPIInterceptor()
    let needLogin = PublishSubject<Void>()//重新登录
   
    
}
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
        let serverTrustPolicies: [String : ServerTrustPolicy] = [
            "8.212.152.227": .disableEvaluation,
//            "172.16.0.159": .disableEvaluation,
            "loctestdtx.edocyun.com.cn": .disableEvaluation]
//        let serverTrustPolicies: [String : ServerTrustPolicy] = [String : ServerTrustPolicy]()
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
        let fullPath = path + getRapidUrlParam()
        let baseParams = getRapidUrlBaseParam()
        var components = URLComponents(url: path.url!, resolvingAgainstBaseURL: true)!
        components.queryItems = baseParams.map { URLQueryItem(name: $0.key, value: $0.value) }
       let finalURL = components.url 
        print(finalURL!.absoluteString)
        
        debugPrint("fullpath====\(fullPath)")
        debugPrint(parameters ?? [:])
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let `self` = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let dataRequest = self
                .request(finalURL!.absoluteString,
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
                        }else if json.needsLogin {
                            RPFAPIInterceptor.shared.needLogin.onNext(Void())
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
    
    //upload 请求
    func upload<T>(path: String,
                   parameters: Parameters,
                   method: HTTPMethod = .post,
                   completionHandler: @escaping ((JSON) -> T)) -> Observable<T> {
        let baseParams = getRapidUrlBaseParam()
        var components = URLComponents(url: path.url!, resolvingAgainstBaseURL: true)!
        components.queryItems = baseParams.map { URLQueryItem(name: $0.key, value: $0.value) }
       let finalURL = components.url 
        debugPrint(finalURL!.absoluteString)
        
        debugPrint("path====\(path)")
        debugPrint(parameters)
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let `self` = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            var uploadRequest: UploadRequest? = nil
            self.upload(
                multipartFormData: { (formData) in
                    parameters.forEach({ (key, value) in
                        if let images = value as? [UIImage] {
                            let imageDatas = images.compactMap { $0.resizedImage(length: 1280).jpegData(compressionQuality: 0.8)}
                            imageDatas.enumerated().forEach {
                                formData
                                    .append(
                                        $1,
                                        withName: key,
                                        fileName: "\(key).jpg",
                                        mimeType: "image/jpeg")
                            }
                        } else if let image = value as? UIImage {
                            formData
                                .append(
                                    image.resizedImage(length: 1280).jpegData(compressionQuality: 0.8) ?? Data(),
                                    withName: key,
                                    fileName: "\(key).jpg",
                                    mimeType: "image/jpeg")
                        } else if let datas = value as? [Data] {
                            datas.enumerated().forEach({ (index, data) in
                                formData
                                    .append(
                                        data,
                                        withName: "\(key)[\(index)]",
                                        fileName: "\(key)[\(index)]",
                                        mimeType: "application/octet-stream")
                            })
                        } else if let data = value as? Data {
                            formData.append(data, withName: key, fileName: "\(key)", mimeType: "application/octet-stream")
                        } else if let binaryDatas = value as? [BinaryData] {
                            binaryDatas.enumerated().forEach { (index, binaryData) in
                                formData
                                    .append(
                                        binaryData.data,
                                        withName: "\(key)[\(index)]",
                                        fileName: "\(key)[\(index)].\(binaryData.ext)",
                                        mimeType: binaryData.mimeType)
                            }
                        } else if let binaryData = value as? BinaryData {
                            formData.append(
                                binaryData.data,
                                withName: key,
                                fileName: "\(key).\(binaryData.ext)",
                                mimeType: binaryData.mimeType)
                        } else {
                            formData.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                    })
            },
                to: finalURL!.absoluteString,
                method: method,
                headers: nil,
                encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .success(let request, _, _):
                        uploadRequest = request.validate().responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let data):
                                let json = JSON(data)
                                debugPrint(json)
                                if json.isSuccessful {
                                    observer.onNext(completionHandler(json.resultData))
                                    observer.onCompleted()
                                } else if json.needsLogin {
                                    RPFAPIInterceptor.shared.needLogin.onNext(Void())
                                } else {
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
                                    if err.code == -1009 {
                                        let error = RapidError.noNetwork(message: err.localizedDescription)
                                        observer.onError(error)
                                    } else {
                                        let error = RapidError.other(message: response.response?.statusCode.description ?? error.localizedDescription)
                                        observer.onError(error)
                                    }
                                }
                            }
                        })
                    case .failure(let error):
                        observer.onError(error)
                    }
            })
            return Disposables.create {
                uploadRequest?.cancel()
            }
        })
    }
}
