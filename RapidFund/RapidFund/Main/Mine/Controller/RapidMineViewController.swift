//
//  RapidMineViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit

class RapidMineViewController: RapidBaseViewController {
    
    struct CellID {
        static let cellId = "RapidMineMenuCellIdentifier"
    }
    
    var viewModel: RapidMineViewModel = RapidMineViewModel()
    
    let backgroundImageView = UIImageView(image: .mineFullBg)
    let rapidImageView = UIImageView(image: .mineUserTopImg)
//    let rapidNameLabel = UILabel().withFont(.f_lightSys14)
//        .withTextColor(.c_111111)
//        .withTextAlignment(.center)
//        .withText("RapidFund")
    let centerImageView = UIImageView(image: .mineCenterBg)
    let menuBgImageView = UIImageView(image: .mineMenuBg)
    let rightBgImageView = UIImageView(image: .mineRightBg)
    
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
        tableView.register(RapidMineMenuCell.self, forCellReuseIdentifier: CellID.cellId)
        
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        setBackBtnHidden()
        setNavImageTitleWhite(isWhite: false)
        setupViews()
        // Do any additional setup after loading the view.
    }

}

extension RapidMineViewController {
    
    func setupViews() {
        self.titleNav.text = viewModel.pageTitle
        self.safeAreaBottomView.isHidden = false
        view.insertSubview(backgroundImageView, at: 0)
        view.addSubview(rapidImageView)
//        view.addSubview(rapidNameLabel)
        view.addSubview(centerImageView)
        view.addSubview(rightBgImageView)
        view.addSubview(menuBgImageView)
        view.addSubview(tableView)
        
        rightBgImageView.contentMode = .scaleAspectFit
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        
//        rapidNameLabel.snp.makeConstraints { make in
//            make.centerX.equalTo(rapidImageView)
//            make.top.equalTo(rapidImageView.snp.bottom).offset(15.rf)
//        }
        
        rightBgImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(-RapidMetrics.tabbarHeight - 21.5.rf)
            make.size.equalTo(CGSize(width: 80.5.rf, height: 419.rf))
        }
        
        rapidImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(rightBgImageView.snp.top)
            make.size.equalTo(CGSize(width: 155.rf, height: 115.rf))
        }
        
        centerImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 149.5.rf, height: 146.5.rf))
            make.top.equalTo(rightBgImageView.snp.top).offset(-67.5.rf)
            make.right.equalTo(rightBgImageView.snp.left).offset(13.rf)
        }
        
        
        
        menuBgImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(rightBgImageView.snp.left).offset(-30.rf)
            make.top.bottom.equalTo(rightBgImageView)
        }
        
        
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(menuBgImageView)
            make.top.equalTo(menuBgImageView.snp.top).offset(7.5.rf)
            make.bottom.equalTo(menuBgImageView.snp.bottom).offset(-13.5.rf)
        }
        
    }
    
    func alertShow(type: RapidCustomAlertViewController.AlertType){
        let vc = RapidCustomAlertViewController(type: type)
    
        present(vc, animated: true, completion: nil)
    }
    
    func alertAgreement() {
        let vc = RPFAgreeAlertViewController()
//        vc.loanCall = { [weak self] in
//            guard let self = self else {return}
//            let vc = RPFWebViewController()
//            vc.viewModel = RPFWebViewModel(urlString: BaseURl + LoanProtocolUrl)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        
//        vc.userCall = { [weak self] in
//            guard let self = self else {return}
//            let vc = RPFWebViewController()
//            vc.viewModel = RPFWebViewModel(urlString: BaseURl + UserProtocolUrl)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        present(vc, animated: true, completion: nil)

    }
}

extension RapidMineViewController: UITableViewDelegate, UITableViewDataSource{
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellId) as! RapidMineMenuCell
        let type = viewModel.sections[indexPath.row]
//        cell.nameLabel.text = type.titleName
        cell.selectionStyle = .none
        cell.setUpCell(type: type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = viewModel.sections[indexPath.row]

        switch type{
        case .order:
            self.tabBarController?.selectedIndex = 1
            print("click order")
        case .payment:
            print("click payment")
        case .agreement:
            print("click agreement")
            alertAgreement()
        case .aboutUs:
            let vc = RPFAboutUsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            print("click about us")
        case .logOut:
            alertShow(type: .logout)
        case .logOff:
            alertShow(type: .logoff)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RapidMineMenuCell.height()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
