//
//  RapidCustomAlertViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/9.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import MBProgressHUD
class RapidCustomAlertViewController: RapidBaseViewController {
   
    
    enum AlertType {
        case logout
        case logoff
        
        var titleName: String {
            switch self{
            case .logout:
                return "Log Out"
            case .logoff:
                return "Log Off"
            }
        }
        
        var iconImg: UIImage {
            switch self{
            case .logout:
                return .mineLogOutIcon
            case .logoff:
                return .mineLogOffIcon
            }
        }
        
        var content: String {
            switch self{
            case .logout:
                return "Are you sure you want to log out?"
            case .logoff:
                return "Are you sure you want to delete your account?"
            }
        }
        
        var contentDes: String {
            switch self{
            case .logout:
                return ""
            case .logoff:
                return "Once deleted, it cannot be recovered. All data will be cleared after account deletion. Please think carefully before deciding whether to delete your account."
            }
        } 
    }
    
    struct Metrics {
        static let sureWidth = (kScreenWidth - 69.rc) * 0.4
        static let cancelWidth = (kScreenWidth - 69.rc) * 0.6
        
        static let actionHeight = 60.rc
        static let msgBottomOffset = 32.rc
        private init() {}
    }
    
    // MARK: - Constants
    struct AutoLayout {
        static let sureString = "Yes"
        static let cancelString = "Cancel"
    }
    
    let disposeBag = DisposeBag()
    
    init(type: AlertType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
    }
    var type: AlertType = .logout
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var BgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.8)
        return view
    }()
    
    fileprivate lazy var containerImageView: UIImageView = {
        let container = UIImageView()
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 24.rf
        container.backgroundColor = .white
//        let image = UIImage(size: CGSize(width: kPortraitScreenW, height: type == .logout ? 300.rc : 400.rc), isHorizontal: false)
//        container.image = image
        container.contentMode = .scaleAspectFill
        return container
    }()
    
    fileprivate lazy var iconImageView: UIImageView = {
        let image = UIImageView(image: type.iconImg)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    fileprivate lazy var iconName: UILabel = {
        let label = UILabel()
        label.font = .f_lightSys12
        label.textColor = .c_111111
        label.textAlignment = .center
        label.text = type.titleName
        return label
    }()
    
    fileprivate lazy var content: UILabel = {
        let label = UILabel()
        label.font = .f_lightSys18
        label.textColor = .c_111111
        label.textAlignment = .center
        label.text = type.content
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var contentDes: UILabel = {
        let label = UILabel()
        label.font = .f_lightSys12
        label.textColor = .c_999999
        label.textAlignment = .center
        label.text = type.contentDes
        label.numberOfLines = 0
        return label
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
    
    lazy var confirmTitle: UILabel = {
        let label = UILabel()
        label.textColor = .c_232323
        label.textAlignment = .left
        label.font = .f_lightSys16
        label.text = AutoLayout.sureString
        return label
    }()
    
    lazy var confirmArrow: UIImageView = {
        let imageView = UIImageView(image: .loginSureArrowImage)
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .right
        return imageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.rf
//        button.backgroundColor = .c_FF942F
        button.setBackgroundImage(.homeBtnBg, for: .normal)
        button.setBackgroundImage(.homeBtnBg, for: .selected)
        button.setBackgroundImage(.homeBtnBg, for: .highlighted)
        return button
    }()
    
    lazy var cancleTitle: UILabel = {
        let label = UILabel()
        label.textColor = .c_FFFFFF
        label.textAlignment = .left
        label.font = .f_lightSys16
        label.text = AutoLayout.cancelString
        return label
    }()
    
    lazy var cancleArrow: UIImageView = {
        let imageView = UIImageView(image: .loginSureArrowImage)
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .right
        return imageView
    }()
    
    
   

}

extension RapidCustomAlertViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavViewHidden()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension RapidCustomAlertViewController {
    
    func setUpViews() {
//        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.addSubview(BgView)
        view.addSubview(containerImageView)
        view.addSubview(iconImageView)
        view.addSubview(iconName)
        view.addSubview(content)
        view.addSubview(contentDes)
        view.addSubview(confirmBtn)
        view.addSubview(confirmTitle)
        view.addSubview(confirmArrow)
        view.addSubview(cancelBtn)
        view.addSubview(cancleTitle)
        view.addSubview(cancleArrow)
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(32.rf)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32.rf)
            } else{
                make.top.equalTo(32.rf)
            }
            make.size.equalTo(CGSize(width: 62.rf, height: 62.rf))
        }
        
        BgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(10.rf)
            make.height.equalTo(14.rf)
        }
        
        content.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconName.snp.bottom).offset(32.rf)
            make.left.equalTo(RapidMetrics.LeftRightMargin)
        }
        
        if type == .logoff {
            contentDes.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.left.equalTo(content.snp.left).offset(9.5.rf)
                make.top.equalTo(content.snp.bottom).offset(10.rf)
            }
            
            confirmBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(RapidMetrics.LeftRightMargin)
                make.top.equalTo(contentDes.snp.bottom).offset(32.rf)
                make.size.equalTo(CGSize(width: Metrics.sureWidth, height: Metrics.actionHeight))
            }
            
            cancelBtn.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-RapidMetrics.LeftRightMargin)
                make.size.equalTo(CGSize(width: Metrics.cancelWidth, height: Metrics.actionHeight))
                make.centerY.equalTo(confirmBtn)
            }
        }else {
            confirmBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(RapidMetrics.LeftRightMargin)
                make.top.equalTo(content.snp.bottom).offset(32.rf)
                make.size.equalTo(CGSize(width: Metrics.sureWidth, height: Metrics.actionHeight))
            }
            
            cancelBtn.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-RapidMetrics.LeftRightMargin)
                make.size.equalTo(CGSize(width: Metrics.cancelWidth, height: Metrics.actionHeight))
                make.centerY.equalTo(confirmBtn)
            }
        }
        
        confirmTitle.snp.makeConstraints { make in
            make.centerY.equalTo(confirmBtn)
            make.left.equalTo(confirmBtn.snp.left).offset(20.rc)
        }
        
        confirmArrow.snp.makeConstraints { make in
            make.centerY.equalTo(confirmBtn)
            make.right.equalTo(confirmBtn.snp.right).offset(-20.rc)
            make.size.equalTo(CGSize(width: 24.rc, height: 24.rc))
        }
        
        cancleTitle.snp.makeConstraints { make in
            make.centerY.equalTo(cancelBtn)
            make.left.equalTo(cancelBtn.snp.left).offset(25.rc)
        }
        
        cancleArrow.snp.makeConstraints { make in
            make.centerY.equalTo(cancelBtn)
            make.right.equalTo(cancelBtn.snp.right).offset(-32.rc)
            make.size.equalTo(CGSize(width: 49.rc, height: 49.rc))
        }
        
        containerImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(confirmBtn.snp.bottom).offset(32.rc)
        }
        
//        containerImageView.setNeedsLayout()
//        containerImageView.layoutIfNeeded()
//        
//        let height = containerImageView.frame.height
        
    }
    
    func setupRx() {
        
        confirmBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                if self.type == .logout {
                    self.LogOutData()
                }else if self.type == .logoff{
                    self.LogOffData()
                }
           
            })
            .disposed(by: disposeBag)
        
        cancelBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func LogOutData(){
        RapidApi.shared.getLogOutData()
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
//                self.loginSuccessAction.onNext(Void())
                NotificationCenter.default.post(name: .RapidLogoutSuccess, object: nil, userInfo: nil)

                self.dismiss(animated: true)
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
//                self.loginSuccessAction.onNext(Void())
                MBProgressHUD.showMessage(error.localizedDescription, toview: nil, afterDelay: 3)
            })
            .disposed(by: disposeBag)
    }
    
    func LogOffData(){
        RapidApi.shared.getLogOffData()
            .subscribe(onNext: { [weak self] json in
                guard let `self` = self else {return}
//                self.loginSuccessAction.onNext(Void())
                NotificationCenter.default.post(name: .RapidLogoffSuccess, object: nil, userInfo: nil)
                self.dismiss(animated: true)
            },
            onError: { [weak self] error in
                guard let `self` = self else {return}
//                self.loginSuccessAction.onNext(Void())
                MBProgressHUD.showMessage(error.localizedDescription, toview: nil, afterDelay: 3)
            })
            .disposed(by: disposeBag)
    }
}


