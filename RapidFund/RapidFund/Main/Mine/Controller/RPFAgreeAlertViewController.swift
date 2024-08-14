//
//  RPFAgreeAlertViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/8/8.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RPFAgreeAlertViewController: RapidBaseViewController {
    typealias LoanProtocolCall = () -> ()
    typealias userProtocolCall = () -> ()
    // MARK: - Constants
    struct AutoLayout {
        static let agreeString = "Loan Agreement"
        static let privacyString = "Privacy Agreement"
    }
    
    let disposeBag = DisposeBag()
    var loanCall: LoanProtocolCall?
    var userCall: userProtocolCall?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate lazy var BgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.8)
        return view
    }()
    
    fileprivate lazy var containerImageView: UIImageView = {
        let container = UIImageView(image: UIImage.image(gradientDirection: .vertical,colors: [0xE5DEFA.color,0xFFFFFF.color]))
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 16.rf

        return container
    }()
    
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(.mineAgreementClose, for: .normal)
        btn.setImage(.mineAgreementClose, for: .selected)
        btn.contentHorizontalAlignment = .right
        btn.contentVerticalAlignment = .bottom
        return btn
    }()
    
    fileprivate lazy var agreeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.rf
        button.setBackgroundImage(.loginConfirmBtnImage, for: .normal)
        button.setBackgroundImage(.loginConfirmBtnImage, for: .selected)
        button.setBackgroundImage(.loginConfirmBtnImage, for: .highlighted)
        return button
    }()
    
    fileprivate lazy var agreeIcon: UIImageView = {
        let agree = UIImageView(image: .mineMyOrder)
        return agree
    }()
    
    fileprivate lazy var agreeTitle: UILabel = {
        let label = UILabel()
        label.font = .f_lightSys16
        label.textColor = .c_111111
        label.textAlignment = .left
        label.text = AutoLayout.agreeString
        return label
    }()
    
    fileprivate lazy var arrowBlack: UIImageView = {
        let image = UIImageView(image: .mineAgreementBlackArrow)
        return image
    }()
    
    fileprivate lazy var privacyBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.rf
        button.setBackgroundImage(.homeBtnBg, for: .normal)
        button.setBackgroundImage(.homeBtnBg, for: .selected)
        button.setBackgroundImage(.homeBtnBg, for: .highlighted)
        return button
    }()
    
    fileprivate lazy var privacyIcon: UIImageView = {
        let agree = UIImageView(image: .mineAgreementPrivacy)
        return agree
    }()
    
    fileprivate lazy var privacyTitle: UILabel = {
        let label = UILabel()
        label.font = .f_lightSys16
        label.textColor = .white
        label.textAlignment = .left
        label.text = AutoLayout.privacyString
        return label
    }()
    
    fileprivate lazy var arrowWhite: UIImageView = {
        let image = UIImageView(image: .mineAgreementWhiteArrow)
        return image
    }()

}

extension RPFAgreeAlertViewController{
    
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

extension RPFAgreeAlertViewController {
    
    func setUpViews() {
        view.addSubview(BgView)
        view.addSubview(containerImageView)
        view.addSubview(closeBtn)
        view.addSubview(agreeBtn)
        view.addSubview(privacyBtn)
        view.addSubview(agreeIcon)
        view.addSubview(agreeTitle)
        view.addSubview(arrowBlack)
        view.addSubview(privacyIcon)
        view.addSubview(privacyTitle)
        view.addSubview(arrowWhite)
        
        BgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.rf)
            make.centerY.equalToSuperview()
            make.height.equalTo(200.rf)
        }
        
        
        
        agreeBtn.snp.makeConstraints { make in
            make.left.equalTo(containerImageView.snp.left).offset(16.rf)
            make.top.equalTo(containerImageView.snp.top).offset(35.rf)
            make.right.equalTo(containerImageView.snp.right).offset(-16.rf)
            make.height.equalTo(68.rf)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.right.equalTo(containerImageView.snp.right).offset(-15.rf)
            make.top.equalTo(containerImageView)
            make.bottom.equalTo(agreeBtn.snp.top).offset(-8.rf)
            make.width.equalTo(50.rf)
        }
        
        agreeIcon.snp.makeConstraints { make in
            make.centerY.equalTo(agreeBtn)
            make.left.equalTo(agreeBtn.snp.left).offset(20.rf)
            make.size.equalTo(CGSize(width: 36.rf, height: 36.rf))
        }
        
        arrowBlack.snp.makeConstraints { make in
            make.right.equalTo(agreeBtn.snp.right).offset(-20.rf)
            make.centerY.equalTo(agreeBtn)
            make.width.equalTo(34.rf)
        }
        
        agreeTitle.snp.makeConstraints { make in
            make.centerY.equalTo(agreeBtn)
            make.left.equalTo(agreeIcon.snp.right).offset(20.rf)
            make.right.equalTo(arrowBlack.snp.left)
        }
        
        
        
        privacyBtn.snp.makeConstraints { make in
            make.left.right.height.equalTo(agreeBtn)
            make.top.equalTo(agreeBtn.snp.bottom).offset(12.rf)
        }
        
        privacyIcon.snp.makeConstraints { make in
            make.centerY.equalTo(privacyBtn)
            make.left.equalTo(privacyBtn.snp.left).offset(20.rf)
            make.size.equalTo(CGSize(width: 36.rf, height: 36.rf))
        }
        
        arrowWhite.snp.makeConstraints { make in
            make.right.equalTo(privacyBtn.snp.right).offset(-20.rf)
            make.centerY.equalTo(privacyBtn)
            make.width.equalTo(34.rf)
        }
        
        privacyTitle.snp.makeConstraints { make in
            make.centerY.equalTo(privacyBtn)
            make.left.equalTo(privacyIcon.snp.right).offset(20.rf)
            make.right.equalTo(arrowWhite.snp.left)
        }
        
        
        
    }
    
    func setupRx() {
       
        agreeBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                self.gotoAgreement()
           
            })
            .disposed(by: disposeBag)
        
        privacyBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                self.gotoPrivacy()
            })
            .disposed(by: disposeBag)
        
        closeBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
    func gotoAgreement() {
//        if let hanle = self.loanCall {
//            self.dismiss(animated: true)
//            hanle()
//        }
//        return
        let vc = RPFWebViewController()
        vc.viewModel = RPFWebViewModel(urlString: BaseH5Url + LoanProtocolUrl)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true)
        
//        DispatchQueue.main.async {
//            let agreeNVC = RapidBaseNavgationController(rootViewController: RPFWebViewController())
//            agreeNVC.modalPresentationStyle = .overFullScreen
//            agreeNVC.modalTransitionStyle = .crossDissolve
//            self.present(agreeNVC, animated: true, completion: nil)
//        }
        
    }
    
    func gotoPrivacy() {
//        if let hanle = self.userCall {
//            self.dismiss(animated: true)
//            hanle()
//        }
//        return
        let vc = RPFWebViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = RPFWebViewModel(urlString: BaseH5Url + UserProtocolUrl)
        self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
