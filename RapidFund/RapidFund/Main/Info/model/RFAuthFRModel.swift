//
//  RFAuthFRModel.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import Foundation
@_exported import HandyJSON

class RFAuthFRModel: HandyJSON {
    var attop: [String: Any]?
    var carefully: RFCarefully?
    var tyou = 0 // 人脸是否完成 0、1
    var littleroom = "" // 人脸图片地址
    var smoke: [[String]]? // ocr 证件类型列表

    var dismay = 1 // 图片选择类型：1，相机+相册；2，相机

    required init() {}

    class RFCarefully: HandyJSON {
        var mustn = 1 // 证件是否完成 0、1
        var littleroom = "" // 证件图片地址
        var darkalmost:String? // 已选卡片类型
        var buck: RFBuck?

        required init() {}
    }

    class RFBuck: HandyJSON {
        var wasan = "" // "JOSE CRUZ SANTOS",
        var fold = "" // "G0199189373",
        var toput = "" // ""1969/11/03"
        required init() {}
    }
}
