//
//  RapidLoginViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SwiftyJSON
import MBProgressHUD
import IQKeyboardManagerSwift
class RapidLoginViewController: RapidBaseViewController {
    
    // MARK: - Constants
    struct AutoLayout {
        static let textString = "Reliable, Fast\n Professional"
        static let countryCode = "+63"
        static let phonePlaceHolder = "Phone Number(eg:9123456789)"
        static let phoneCodePlaceHolder = "Verification Code"
        
        static let confirmText = "Confirm"
        
        static let greyAgreementString = "Read and agree to the "
        static let agreementStr = RapidUserProtocol
        static let userPrivacyText = greyAgreementString + agreementStr
    }
    
    // MARK: - Properties
    private var enterPageTime: String = ""
    let disposeBag = DisposeBag()
    var timerDisposeBag = DisposeBag()
    var viewModel = RapidLoginViewModel()
    
    let backgroundImageView = UIImageView(image: .loginBgImage)
    let rapidImageView = UIImageView(image: .homeRapidIcon)
    
    let agreeMentTribute : NSMutableAttributedString = {
        let textAttribute = NSMutableAttributedString(string: AutoLayout.userPrivacyText)
        
        textAttribute.addAttributes([.font : UIFont.f_lightSys12,
                                     .foregroundColor : UIColor.c_CECECE], range: NSMakeRange(0, AutoLayout.userPrivacyText.count))
        textAttribute.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(AutoLayout.greyAgreementString.count, AutoLayout.agreementStr.count))
        textAttribute.addAttribute(.link, value: "rapidUserProtocol://", range: NSMakeRange(AutoLayout.greyAgreementString.count, AutoLayout.agreementStr.count))
        
        return textAttribute
    }()
    
    let welcomeLab = UILabel()
        .withFont(.f_lightSys33)
        .withTextColor(.white)
        .withText(AutoLayout.textString)
        .withTextAlignment(.center)
        .withNumberOfLines(0)
    
    lazy var phoneNumView: UIView = {
        let view = UIView()
        view.backgroundColor = .c_FFFFFF.withAlphaComponent(0.74)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16.rf
        return view
    }()
    
    lazy var countryImg: UIImageView = {
        let imageView = UIImageView(image: .loginCountryImage)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.text = AutoLayout.countryCode
        label.textColor = .black
        label.font = .f_lightSys14
        label.textAlignment = .right
        return label
    }()
    
    lazy var phoneLine: UIView = {
        let view = UIView()
        view.backgroundColor = .c_FFFFFF.withAlphaComponent(0.2)
        return view
    }()
    
    //手机号输入框
    lazy var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textColor = .black
        textField.font =  .f_lightSys14
        textField.keyboardType = .numberPad
        textField.attributedPlaceholder = AutoLayout.phonePlaceHolder.attributedPlaceholder(color: .c_000000.withAlphaComponent(0.3), font: .f_lightSys14)

        textField.borderStyle = .none
        
//        textField.attributedPlaceholder = AutoLayout.phonePlaceHolder.attributedPlaceholder(color: .c_CCCCCC, font: 0)
        return textField
    }()
    
    lazy var phoneCodeView: UIView = {
        let view = UIView()
        view.backgroundColor = .c_FFFFFF.withAlphaComponent(0.74)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16.rf
        return view
    }()
    
    lazy var codeTF: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textColor = .black
//            .c_000000.withAlphaComponent(0.3)
        textField.font =  .f_lightSys14
        textField.keyboardType = .numberPad
//        textField.placeholder = AutoLayout.phoneCodePlaceHolder
        textField.attributedPlaceholder = AutoLayout.phoneCodePlaceHolder.attributedPlaceholder(color: .c_000000.withAlphaComponent(0.3), font: .f_lightSys14)
//        textField.attributedPlaceholder = "输入验证码".attributedPlaceholder(color: .c_C1C1C1, font: isStandardFontModed ? .f_sys16 : .f_sys20)
        return textField
    }()
    
    lazy var getCodeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.c_111111, for: .normal)
        button.titleLabel?.font = .f_lightSys14
        button.titleLabel?.textAlignment = .center
        button.setTitle("Send", for: .normal)
        return button
    }()
    
    lazy var agreeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.loginAgreeNormalImage, for: .normal)
        button.setImage(.loginAgreeSelectedImage, for: .selected)
        button.isSelected = true
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    lazy var userAgreementLabel: UITextView = {
        let textV = UITextView()
        textV.delegate = self
        textV.backgroundColor = .clear
        textV.textContainerInset = .zero
        textV.attributedText = agreeMentTribute
        textV.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.c_FF942F]
        textV.isEditable = false
        textV.isScrollEnabled = false
        return textV
    }()
    
    
    lazy var confirmBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.rf
//        button.backgroundColor = .c_FF942F
        button.setBackgroundImage(.loginConfirmBtnImage, for: .normal)
        button.setBackgroundImage(.loginConfirmBtnImage, for: .selected)
        button.setBackgroundImage(.loginConfirmBtnImage, for: .highlighted)
        return button
    }()
    
    lazy var btnTitle: UILabel = {
        let label = UILabel()
        label.textColor = .c_151515
        label.textAlignment = .left
        label.font = .f_lightSys16
        label.text = AutoLayout.confirmText
        return label
    }()
    
    lazy var btnArrow: UIImageView = {
        let imageView = UIImageView(image: .loginSureArrowImage)
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .right
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
        setUpViews()
        setupRx() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.judgeIOSSystem()
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.placeholderFont = .f_boldSys15
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"


        self.enterPageTime = getCurrentTime()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

}

extension RapidLoginViewController {
    
    func setUpViews() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.addSubview(rapidImageView)
        view.addSubview(welcomeLab)
        
        phoneNumView.addSubview(countryImg)
        phoneNumView.addSubview(countryLabel)
        phoneNumView.addSubview(phoneLine)
        phoneNumView.addSubview(phoneNumTF)
        view.addSubview(phoneNumView)
        
        phoneCodeView.addSubview(codeTF)
        phoneCodeView.addSubview(getCodeBtn)
        view.addSubview(phoneCodeView)
        
        view.addSubview(agreeBtn)
        view.addSubview(userAgreementLabel)
        
        view.addSubview(confirmBtn)
        view.addSubview(btnTitle)
        view.addSubview(btnArrow)
        self.view.bringSubviewToFront(self.customNavView)
        self.rightBtn.isHidden = true
        self.setNavImageTitleWhite(isWhite: true)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rapidImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundImageView.snp.top).offset(166.rf)
            make.size.equalTo(CGSize(width: 93.rf, height: 100.rf))
        }
        
        welcomeLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rapidImageView.snp.bottom).offset(29.rf)
            make.height.equalTo(100.rf)
        }
        
        phoneNumView.snp.makeConstraints { make in
            make.left.equalTo(RapidMetrics.LeftRightMargin)
            make.right.equalTo(-RapidMetrics.LeftRightMargin)
            make.height.equalTo(49.5.rf)
            make.top.equalTo(welcomeLab.snp.bottom).offset(38.rf)
        }
        
        countryImg.snp.makeConstraints { make in
            make.centerY.equalTo(phoneNumView)
            make.left.equalTo(phoneNumView.snp.left).offset(RapidMetrics.LeftRightMargin)
            make.size.equalTo(CGSize(width: 29.rf, height: 14.5.rf))
        }
        
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(countryImg.snp.right).offset(8.5.rf)
            make.centerY.equalTo(countryImg)
            
        }
        
        phoneLine.snp.makeConstraints { make in
            make.left.equalTo(countryImg.snp.right).offset(42.rf)
            make.centerY.equalTo(countryImg)
            make.size.equalTo(CGSize(width: 1, height: 12.rf))
        }
        
        phoneNumTF.snp.makeConstraints { make in
            make.left.equalTo(phoneLine.snp.right).offset(8.rf)
            make.centerY.equalTo(phoneNumView)
            make.right.equalTo(phoneNumView)
            make.height.equalTo(30.rf)
        }
        
        phoneCodeView.snp.makeConstraints { make in
            make.left.height.right.equalTo(phoneNumView)
            make.top.equalTo(phoneNumView.snp.bottom).offset(16.rf)
        }
        
        getCodeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(phoneCodeView)
            make.right.equalTo(phoneCodeView.snp.right).offset(-18.rf)
            make.height.equalTo(phoneCodeView)
            make.width.equalTo(40.rf)
        }
        
        codeTF.snp.makeConstraints { make in
            make.centerY.equalTo(phoneCodeView)
            make.left.equalTo(phoneCodeView.snp.left).offset(18.rf)
            make.right.equalTo(getCodeBtn.snp.left).offset(-5.rf)
            make.height.equalTo(phoneCodeView)
        }
        
        agreeBtn.snp.makeConstraints { make in
            make.top.equalTo(phoneCodeView.snp.bottom).offset(10.rf)
            make.left.equalTo(phoneCodeView.snp.left).offset(44.5.rf)
            make.size.equalTo(CGSize(width: 25.rf, height: 25.rf))
        }
        
        userAgreementLabel.snp.makeConstraints { make in
            make.left.equalTo(agreeBtn.snp.right).offset(3.rf)
            make.right.equalToSuperview()
            make.centerY.equalTo(agreeBtn)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.left.right.equalTo(phoneNumView)
            make.top.equalTo(phoneCodeView.snp.bottom).offset(55.rf)
            make.height.equalTo(60.5.rf)
        }
        
        btnTitle.snp.makeConstraints { make in
            make.left.equalTo(confirmBtn.snp.left).offset(51.5.rf)
            make.centerY.equalTo(confirmBtn)
        }
        
        btnArrow.snp.makeConstraints { make in
            make.centerY.equalTo(confirmBtn)
            make.right.equalTo(confirmBtn.snp.right).offset(-48.5.rf)
        }
        
    }
    
    func setupRx() {
//        get mobile code
        getCodeBtn.rx
            .tap
            .throttle(.seconds_1, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.viewModel.getCodeData(phone: self.phoneNumTF.text?.trim() ?? "")
            })
            .disposed(by: disposeBag)
        
        agreeBtn.rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                self?.changeAgreementEvent()
            })
            .disposed(by: disposeBag)
        
        confirmBtn.rx
            .tap
            .throttle(.seconds_1, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.viewModel.getLoginData(phone: self.phoneNumTF.text?.trim() ?? "", codeStr: self.codeTF.text?.trim() ?? "")
            })
            .disposed(by: disposeBag)
        
        viewModel.newMessage
            .drive(onNext: { message in
                MBProgressHUD.showMessage(message, toview: nil, afterDelay: 3)
            })
            .disposed(by: disposeBag)
        
        viewModel.loginModel
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
//                self.cacheLoginInfo()
            })
            .disposed(by: bag)
        
        viewModel.loginSuccessAction 
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.cacheLoginInfo()
                self.uploadLocation()
                
            })
            .disposed(by: disposeBag)
        
        viewModel.sendSuccessAction 
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.startCountDown()
                self.codeTF.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.sendCodeIsEnable
            .subscribe(onNext: { [weak self] isAble in 
                guard let `self` = self else { return }
                self.getCodeBtn.isUserInteractionEnabled = isAble
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoad in 
                guard let `self` = self else { return }
                if isLoad {
                    self.showLoading()
                }else{
                    self.hiddenLoading()
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    //获取验证码倒计时
    func startCountDown() {
        //多次触发时成功执行倒计时，以最后一次执行为准，重新倒计时
        timerDisposeBag = DisposeBag()
        let timeout = 60
        Observable<Int>
            .timer(.seconds_0, period: .seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (timeElapse) in
                let time = timeout - timeElapse
                if time < 1 {
                    self?.timerDisposeBag = DisposeBag()
                    self?.getCodeBtn.setTitle("Send", for: .normal)
//                    self?.getCodeBtn.isUserInteractionEnabled = true
                    self?.viewModel.sendCodeIsEnable.accept(true)
                } else {
                    self?.getCodeBtn.setTitle("\(time)s", for: .normal)
                }
            }, onDisposed:  {
                print("timer disposed")
            }).disposed(by: timerDisposeBag)
    }
}

extension RapidLoginViewController {
    
    func cacheLoginInfo(){
        let model = viewModel.loginModel.value
     
        RapidUserCache.default.cacheUserInfo(session: model?.session ?? "")
        NotificationCenter.default.post(name: .RapidLoginSuccess, object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func changeAgreementEvent() {
        self.agreeBtn.isSelected = !self.agreeBtn.isSelected
        viewModel.isAccept.accept(self.agreeBtn.isSelected)
    }
    
    func uploadLocation() {
        
        RPFLocationManager.manager.requestLocationAuthorizationStatus()
        RPFLocationManager.manager.locationInfoHandle = { (country, code, province, city,street,latitude,longitude, item) in
            var param: [String : Any] = [String : Any]()
            param["aface"] = province
            param["curls"] = code
            param["untidy"] = country
            param["creature"] = street
            param["whichever"] = longitude
            param["scampering"] = latitude
            param["lambgambolling"] = city
            param["towards"] = getRPFRandom()
            param["skipping"] = getRPFRandom()
            RPFReportManager.shared.saveLocation(para: param)
            RPFReportManager.shared.saveDeviceInfo()
            RPFReportManager.shared.saveAnalysis(pId: "", type: .Register, startTime: self.enterPageTime, longitude: longitude, latitude: latitude)
        }
    }
}

extension RapidLoginViewController: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == phoneNumTF {
            if textField.markedTextRange == nil {
                if let text = textField.text, text.count > 10 {
                    textField.text = String(text.prefix(10))
                }
            }
        }else if textField == codeTF {
            if textField.markedTextRange == nil {
//                if let text = textField.text, text.count > 6 {
//                    textField.text = String(text.prefix(6))
//                }
                if let text = textField.text, text.count == 6 {
                    textField.text = String(text.prefix(6))
                    self.viewModel.getLoginData(phone: self.phoneNumTF.text?.trim() ?? "", codeStr: textField.text?.trim() ?? "")
                }
                
                
            }
        }
    }
    
    ///
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "rapidUserProtocol" {
          
            return false
        }

        return true
    }
    
}




