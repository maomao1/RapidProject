//
//  RapidOrderViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on  2024/7/8.
//

import UIKit

class RapidOrderViewController: RapidBaseViewController {
    
    struct CellID {
        static let cellId = "RapidOrderMenuCellIdentifier"
    }
    
    var viewModel: RapidOrderViewModel = RapidOrderViewModel()
   
    let backgroundImageView = UIImageView(image: .orderFullBg)
    let topImageView = UIImageView(image: .orderTopBg)
    let menuBgImageView = UIImageView(image: .orderMenuBg)
   
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
        tableView.register(RapidOrderMenuCell.self, forCellReuseIdentifier: CellID.cellId)
        return tableView
    }()
    
}

extension RapidOrderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtnHidden()
        setNavImageTitleWhite(isWhite: true)
        setupViews()

    }
}

extension RapidOrderViewController {
    
    func setupViews(){
        self.titleNav.text = viewModel.pageTitle
        self.titleNav.font = .f_lightSys32
        view.insertSubview(backgroundImageView, at: 0)
        view.insertSubview(topImageView, at: 1)
        view.addSubview(menuBgImageView)
        view.addSubview(tableView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(391.rc)
        }
        
        menuBgImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(backgroundImageView.snp.left).offset(33.rc)
            make.top.equalTo(topImageView.snp.bottom).offset(-86.rc)
            make.height.equalTo(300.rc)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(menuBgImageView)
            make.top.equalTo(menuBgImageView.snp.top).offset(16.rf)
            make.bottom.equalTo(menuBgImageView.snp.bottom).offset(-12.rf)
        }
        
    }
}


extension RapidOrderViewController: UITableViewDelegate, UITableViewDataSource{
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellId) as! RapidOrderMenuCell
        let type = viewModel.sections[indexPath.row]
        cell.selectionStyle = .none
        cell.setUpCell(type: type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = RapidOrderListViewController()
        let type = viewModel.sections[indexPath.row]
        switch type{
        case .unpaind:
            vc.viewModel = RapidOrderListViewModel(type: .unpaid)
           
        case .under:
            vc.viewModel = RapidOrderListViewModel(type: .review)
        case .failed:
            vc.viewModel = RapidOrderListViewModel(type: .failed)
        case .settled:
            vc.viewModel = RapidOrderListViewModel(type: .settled)
       
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RapidOrderMenuCell.height()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

