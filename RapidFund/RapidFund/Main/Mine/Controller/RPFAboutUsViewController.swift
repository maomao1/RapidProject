//
//  RPFAboutUsViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/11.
//

import UIKit

class RPFAboutUsViewController: RapidBaseViewController {
    struct CellID {
        static let cellId = "RPFAboutUsCellIdentifier"
    }
    
    var viewModel: RPFAboutUsViewModel = RPFAboutUsViewModel()
    let backgroundImageView = UIImageView(image: .mineAboutUsBlackBg)
    let menuBgImageView = UIImageView(image: .mineAboutUsMenuBg)
    let logoImgView = UIImageView(image: .rapidFundLogoImg)

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60.rf
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        let footerView = UIView(frame: .zero)
        tableView.tableFooterView = footerView
        tableView.register(RPFAboutCell.self, forCellReuseIdentifier: CellID.cellId)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavImageTitleWhite(isWhite: true)
        setupViews()
    }

}

extension RPFAboutUsViewController {
    func setupViews(){
        self.titleNav.text = viewModel.pageTitle
        view.addSubview(backgroundImageView)
        view.addSubview(menuBgImageView)
        view.addSubview(tableView)
        view.addSubview(logoImgView)
        view.bringSubviewToFront(self.customNavView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImgView.snp.makeConstraints { make in
            make.right.equalTo(-RapidMetrics.LeftRightMargin)
            make.top.equalTo(self.customNavView.snp.bottom).offset(44.5.rf)
            make.size.equalTo(CGSize(width: 102.rf, height: 82.5.rf))
        }
        
        menuBgImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(48.rf)
            make.top.equalTo(logoImgView.snp.top).offset(38.5.rf)
            make.height.equalTo(475.rf)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(menuBgImageView)
        }
    }
}

extension RPFAboutUsViewController: UITableViewDelegate, UITableViewDataSource{
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellId) as! RPFAboutCell
        cell.setCellContent(type: viewModel.sections[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRect(x: 48.rf, y: 0, width: kPortraitScreenW , height: 85.rf))
        header.backgroundColor = .clear
        let nameLabel = UILabel().withFont(.f_lightSys24)
            .withTextColor(.c_111111)
            .withTextAlignment(.left)
        
        let versionLabel = UILabel().withFont(.f_lightSys12)
            .withTextColor(.c_000000)
            .withTextAlignment(.left)
        nameLabel.text = RPFAppName
        versionLabel.text = "V" + AppVersion
        header.addSubview(nameLabel)
        header.addSubview(versionLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(24.rf)
            make.top.equalTo(20.rf)
        }
        versionLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(11.5.rf)
        }
        
        return header
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 85.rf
    }
}
