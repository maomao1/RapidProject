//
//  RapidBaseViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import RxCocoa
import RxSwift
import UIKit

@_exported import SnapKit
@_exported import XYZKit

class RapidBaseViewController: UIViewController {
    // MARK: - Properties

    let bag = DisposeBag()
    
    private(set) lazy var customNavView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) lazy var safeAreaBottomView = UIView()
    
    lazy var titleNav: UILabel = {
        let label = UILabel()
        label.font = .f_lightSys32
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var backBtn: UIButton = {
        let button = UIButton(type: .custom)
//        button.setBackgroundImage(.homeNavBlackBack, for: .normal)
//        button.setBackgroundImage(.homeNavBlackBack, for: .selected)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private(set) lazy var rightBtn: UIButton = {
        let button = UIButton(type: .custom)
//        button.setBackgroundImage(.homeNavBlackRight, for: .normal)
//        button.setBackgroundImage(.homeNavBlackRight, for: .selected)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isTranslucent = false
        setBottomView()
        setCustomNav()
        setNavImageTitleWhite(isWhite: false)
        setBaseUpRx()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        setUpNoNetworkView()
    }
    
    func setNavImageTitleWhite(isWhite: Bool) {
        backBtn.setBackgroundImage(isWhite ? .homeNavWhiteBack : .homeNavBlackBack, for: .normal)
        backBtn.setBackgroundImage(isWhite ? .homeNavWhiteBack : .homeNavBlackBack, for: .selected)
        rightBtn.setBackgroundImage(isWhite ? .homeNavWhiteRight : .homeNavBlackRight, for: .normal)
        rightBtn.setBackgroundImage(isWhite ? .homeNavWhiteRight : .homeNavBlackRight, for: .selected)
        titleNav.textColor = isWhite ? .c_FFFFFF : .c_111111
        titleNav.font = isWhite ? .f_lightSys24 : .f_lightSys32
    }
    
    func setNavViewHidden() {
        self.customNavView.isHidden = true
    }
    
    func setBackBtnHidden() {
        backBtn.snp.remakeConstraints { make in
            make.left.equalTo(customNavView.snp.left).offset(RapidMetrics.LeftRightMargin)
            make.centerY.equalTo(customNavView)
            make.size.equalTo(CGSize(width: 0.rf, height: 0.rf))
        }
        
        titleNav.snp.remakeConstraints { make in
            make.left.equalTo(backBtn.snp.right).offset(0.rf)
            make.centerY.equalTo(customNavView)
            make.right.equalToSuperview()
        }
    }
    
    func setCustomNav() {
        view.addSubview(customNavView)
        customNavView.addSubview(backBtn)
        customNavView.addSubview(rightBtn)
        customNavView.addSubview(titleNav)
        
        customNavView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11.5.rf)
            } else {
                make.top.equalTo(11.5.rf)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(73.rf)
        }
        
        rightBtn.snp.makeConstraints { make in
            make.right.equalTo(customNavView.snp.right).offset(-RapidMetrics.LeftRightMargin)
            make.centerY.equalTo(customNavView)
            make.size.equalTo(CGSize(width: 50.rf, height: 50.rf))
        }
        
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(customNavView.snp.left).offset(RapidMetrics.LeftRightMargin)
            make.centerY.equalTo(customNavView)
            make.size.equalTo(CGSize(width: 50.rf, height: 50.rf))
        }
        
        titleNav.snp.makeConstraints { make in
            make.left.equalTo(backBtn.snp.right).offset(12.rf)
            make.centerY.equalTo(customNavView)
            make.right.equalToSuperview()
        }
    }
    
    func setBottomView() {
        safeAreaBottomView.backgroundColor = .white
        view.addSubview(safeAreaBottomView)
        safeAreaBottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(IPHONE_X ? 34 : 0)
        }
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1
            {
                safeAreaBottomView.isHidden = true
            } else {
                safeAreaBottomView.isHidden = false
            }
        } else {
            safeAreaBottomView.isHidden = true
        }
    }
    
    // 设置LeftBarButtonItem

    func setLeftBarButtonItem(image: UIImage = .homeNavBlackBack) {
        let backButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        backButton.width = 50
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setRightBarButtonItem(image: UIImage = .homeNavBlackRight) {
//        let rightButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarEvent))
//        navigationItem.rightBarButtonItem = rightButton
        let rightButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(rightBarEvent))
        rightButton.width = 50
        navigationItem.rightBarButtonItem = rightButton
    }

    func setBaseUpRx() {
        backBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.back()
            })
            .disposed(by: bag)
        
        rightBtn.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.rightBarEvent()
            })
            .disposed(by: bag)
        
        NotificationCenter.default
            .rx.notification(.RapidLoginSuccess)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.loginSuccessAction()
            })
            .disposed(by: bag)
    }
    
    //
    func loginSuccessAction() {}
    
    @objc func rightBarEvent() {}

    // 返回
    @objc func back() {
        if let vcCount = navigationController?.viewControllers.count,
           vcCount > 1
        {
            navigationController?.popViewController(animated: true)
        } else {
            if navigationController != nil {
                navigationController?.dismiss(animated: true, completion: {})
            } else {
                dismiss(animated: true) {}
            }
        }
    }
    
    func adjustNavTitleCenter() {
        titleNav.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
