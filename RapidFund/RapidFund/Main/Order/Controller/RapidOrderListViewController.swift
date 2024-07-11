//
//  RapidOrderListViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/11.
//

import UIKit

class RapidOrderListViewController: RapidBaseViewController {
    
    struct CellID {
        static let cellId = "RapidOrderListCellIdentifier"
    }
    
    var viewModel: RapidOrderListViewModel = RapidOrderListViewModel()

    let backgroundImageView = UIImageView(image: .orderFullBg)
    let shadowImageView = UIImageView(image: .orderListShadowBg)
    let rightImageView = UIImageView(image: .orderListRightBg)
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60.rf
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        let footerView = UIView(frame: .zero)
        tableView.tableFooterView = footerView
        tableView.register(RapidOrderListCell.self, forCellReuseIdentifier: CellID.cellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavImageTitleWhite(isWhite: true)
        setupViews()
        // Do any additional setup after loading the view.
    }


}

extension RapidOrderListViewController {
    func setupViews(){
        self.titleNav.text = viewModel.pageTitle
        view.addSubview(backgroundImageView)
        view.addSubview(shadowImageView)
        view.addSubview(rightImageView)
        view.addSubview(tableView)
        view.bringSubviewToFront(self.customNavView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        shadowImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(self.customNavView.snp.bottom).offset(29.rf)
            make.width.equalTo(41.rf)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.customNavView.snp.bottom).offset(4.rf)

        }
    }
}

extension RapidOrderListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellId) as! RapidOrderListCell
        cell.setContentCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return RapidHomeProductCell.height()
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.rf
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.rf
    }
}

