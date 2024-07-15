//
//  RFUploadResultModel.swift
//  RapidFund
//
//  Created by C on 2024/7/15.
//

import Foundation

class RFUploadResultModel: HandyJSON {
    /// 身份证正面type=11
    var wasan: String?
    var fold: String?
    var anddisappeared: String?
    var toput: String?
    
    var reasonthat: String?
    var themboth: String?
    var cuddled: String?
    
    // type=12 上传身份证反面
    
    var considered: String?
    var dadda: String?
    var frowned: String?
    var understood: String?
    var ican: String?
    var boyscouldn: String?
    
    var littleroom: String? // 图片地址，共用
    
    // type=10 上传人脸响应
    
    var speech: Int?
    
    var type:Int = 11
    
    required init() {}
}
