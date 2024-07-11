//
//  RapidHomeViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD
class RapidHomeViewController: RapidBaseViewController {
    // MARK: - Constants
    struct AutoLayout {
        static let applyText = "Apply for a Loan"
    }
    
    struct CellID {
        static let cellId = "RapidHomeProductCellIdentifier"
    }
    // MARK: - Properties
    
    
    var viewModel: RapidHomeViewModel = RapidHomeViewModel()
    
    let backgroundImageView = UIImageView(image: .homeFullBg)
    let circleLeftImageView = UIImageView(image: .homeCircleLeft)
    let circleTopRightImageView = UIImageView(image: .homeCircleTopRight)
    let circleBottomRightImageView = UIImageView(image: .homeCircleBottomRight)
    let rapidImageView = UIImageView(image: .loginRapidImage)
    let unLoginImgBg  = UIImageView(image: .homeUnloginBg)
    let LoginTopImgBg  = UIImageView(image: .homeLoginTopBg)
    let homeMoneyView = HomeMoneyView()
    let homeMoneyRateView = HomeMoneyRateView()
     
    
    fileprivate lazy var loginContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    fileprivate lazy var unLoginContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var applyBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.rf
        button.setBackgroundImage(.homeBtnBg, for: .normal)
        button.setBackgroundImage(.homeBtnBg, for: .selected)
        button.setBackgroundImage(.homeBtnBg, for: .highlighted)
        return button
    }()
    
    lazy var applyTitle: UILabel = {
        let label = UILabel()
        label.textColor = .c_FFFFFF
        label.textAlignment = .left
        label.font = .f_lightSys16
        label.text = AutoLayout.applyText
        return label
    }()
    
    lazy var applyArrow: UIImageView = {
        let imageView = UIImageView(image: .homeApplyArrow)
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .right
        return imageView
    }()
    
    //
    lazy var banner: UIImageView = {
        let image = UIImageView(image: .homeLoginBanner)
        return image
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60.rf
        tableView.rowHeight = 66.rf
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        let footerView = UIView(frame: .zero)
        tableView.tableFooterView = footerView
        tableView.register(RapidHomeProductCell.self, forCellReuseIdentifier: CellID.cellId)
        
        return tableView
    }()
   
    
}

extension RapidHomeViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.getData()
        setBackBtnHidden()
        setUpRx()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.navigationController?.pushViewController(RFFlowVC(), animated: true)
        }
        
    }
    
    
}

extension RapidHomeViewController {
    
    func setupViews(){
        self.titleNav.text = viewModel.pageTitle
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.addSubview(circleLeftImageView)
        backgroundImageView.addSubview(circleTopRightImageView)
//        view.insertSubview(circleBottomRightImageView, aboveSubview: backgroundImageView)
        backgroundImageView.addSubview(circleBottomRightImageView)
        view.addSubview(unLoginContainer)
        backgroundImageView.addSubview(loginContainer)
        
        backgroundImageView.isUserInteractionEnabled = true
        loginContainer.isUserInteractionEnabled = true
        
        unLoginContainer.addSubview(rapidImageView)
        unLoginContainer.addSubview(unLoginImgBg)
        unLoginContainer.addSubview(applyBtn)
        unLoginContainer.addSubview(applyTitle)
        unLoginContainer.addSubview(applyArrow)
        unLoginContainer.addSubview(homeMoneyView)
        unLoginContainer.addSubview(homeMoneyRateView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        circleTopRightImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(self.customNavView.snp.bottom).offset(48.rc)
            make.size.equalTo(CGSize(width: 84.rc, height: 165.rc))
        }
        
        circleLeftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(circleTopRightImageView.snp.bottom).offset(80.rc)
        }
        
        circleBottomRightImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 60.rc, height: 117.rc))
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(41.5)
            } else {
                make.bottom.equalTo(41.5)
            }
        }
        
        unLoginContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.customNavView.snp.bottom)
        }
        
        rapidImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(unLoginContainer.snp.top).offset(5.5.rf)
            make.size.equalTo(CGSize(width: 63.rc, height: 88.rc))
        }
        
        unLoginImgBg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rapidImageView.snp.bottom).offset(14.5.rf)
            make.left.equalTo(63.5.rf)
        }
        
        homeMoneyView.snp.makeConstraints { make in
            make.left.equalTo(unLoginImgBg.snp.left).offset(29.rf)
            make.right.equalTo(unLoginImgBg.snp.right).offset(-29.rf)
            make.top.equalTo(unLoginImgBg.snp.top).offset(105.rf)
            make.height.equalTo(HomeMoneyView.height())
        }
        
        homeMoneyRateView.snp.makeConstraints { make in
            make.left.equalTo(unLoginImgBg.snp.left).offset(29.rf)
            make.right.equalTo(unLoginImgBg.snp.right).offset(-29.rf)
            make.top.equalTo(homeMoneyView.snp.bottom).offset(11.rf)
            make.height.equalTo(HomeMoneyRateView.height())
        }
        
        applyBtn.snp.makeConstraints { make in
            make.left.equalTo(unLoginImgBg.snp.left).offset(-23.rc)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(unLoginImgBg.snp.bottom).offset(30.rc)
            make.height.equalTo(60.rc)
        }
        
        applyTitle.snp.makeConstraints { make in
            make.centerY.equalTo(applyBtn)
            make.left.equalTo(applyBtn.snp.left).offset(32.rc)
            
        }
        
        applyArrow.snp.makeConstraints { make in
            make.centerY.equalTo(applyBtn)
            make.right.equalTo(applyBtn.snp.right).offset(-32.rc)
        }
        //
        
        loginContainer.addSubview(LoginTopImgBg)
        loginContainer.addSubview(banner)
        loginContainer.addSubview(tableView)
        
        loginContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        LoginTopImgBg.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(276.rf)
        }
        banner.snp.makeConstraints { make in
            make.top.equalTo(self.customNavView.snp.bottom).offset(13.rf)
            make.left.right.equalToSuperview().inset(25.rf)
            make.height.equalTo(220.rf)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(LoginTopImgBg.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                make.bottom.equalTo(0)
            }
        }
        self.unLoginContainer.isHidden = true
        self.loginContainer.isHidden = true
    }
    
    func loginSuccessEvent() {
        self.reloadHomeData()
    }
    
    func reloadHomeData() {
        viewModel.getData()
    }
    
    
    func setUpRx() {
     
        NotificationCenter.default
            .rx.notification(.RapidLoginSuccess)
            .subscribe(onNext: { [weak self] (notification) in
                guard let `self` = self else {return}
                self.loginSuccessEvent()
            })
            .disposed(by: bag)
    }
    
    
}

extension RapidHomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellId) as! RapidHomeProductCell
//        let type = viewModel.sections[indexPath.row]
////        cell.nameLabel.text = type.titleName
//        cell.selectionStyle = .none
//        cell.setUpCell(type: type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RapidHomeProductCell.height()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

