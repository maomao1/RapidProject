//
//  RapidApiConstantUrl.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

struct RapidApiConstantUrl {
    //公共参数
    
    //MARK: - login
    static let loginByPhone = "/rfapi/theboys/listen/absolutely"
    static let getPhoneCode = "/rfapi/place/hidden/every"
    static let logout       = "/rfapi/morgan/tears/theres"
    static let logoff       = "/rfapi/shadows/anenormous/taste"
    
    //MARK: - home
    static let homeGetData  = "/rfapi/hardly/passed/getting"
    
    //MARK: - order
    static let getOrderListData  = "/rfapi/truth/enormous/small"
    //MARK: - mine
    static let getMineData  = "/rfapi/dream/shall/smiled"
    
    //获取用户身份证/活体信息（第一项）
    static let getAuthInfo1Data  = "/rfapi/handkerchief/quite/against"
    
    
    
    //数据上报
    static let updateLocation  = "/rfapi/salttimmy/upset/pointing"
    
//    static let updateLocation  = "/rfapi/julian/suddenlyyes/mountain-hut" // 埋点
//    static let updateLocation  = "/rfapi/salttimmy/upset/pointing"
//    static let updateLocation  = "/rfapi/salttimmy/upset/pointing"
//    static let updateLocation  = "/rfapi/salttimmy/upset/pointing"

    
    //获取用户身份证/活体信息（第一项）
    static let iDUpload  = "/rfapi/shepherd/illgood/thebits"
    //保存用户身份证信息（第一项）
    static let saveIDInfo = "/rfapi/wereeveryone/feeling/tried"
    
    //上传face人脸认证
    static let uploadFaceUrl = "/v3/personal-center/save-audit-face"
    
    //获取人脸图片
    static let getFaceUrl = "/v3/personal-center/get-audit-face"

    //获取用户信息
    static let getUserDataTwo = "/rfapi/mymorgan/snarling/taken"
    //保存用户信息（第二项）
    static let saveUserDataTwo = "/rfapi/shebut/began/george"
    
    //获取工作信息（第三项）
    static let getWorkInfo = "/rfapi/lookedout/northpolewhew/tomorrow"
    
    // 保存工作信息（第三项）
    static let setWorkInfo = "/rfapi/heregosh/children/barking"
    
    //获取联系人信息（第四项）
    static let getContactInfo = "/rfapi/after/before/couldnt"
    
    //保存联系人信息（第四项）
    static let saveContactInfo = "/rfapi/biscuits/front/other"
    
    //获取绑卡信息（第五项）
    static let getBindBankInfo = "/rfapi/toboggan/everythingthe/school"
    
    //提交绑卡（第五项）
    static let commitBankInfo = "/rfapi/itaffect/george/opened"
    //用户银行卡列表
    static let getBankList = "/rfapi/completely/after/about"
    
    //更换银行卡（会触发重新打款）
    static let changeBankInfo = "/rfapi/could/expect/pursed"
}
