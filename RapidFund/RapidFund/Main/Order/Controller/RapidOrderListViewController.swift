//
//  RapidOrderListViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/11.
//

import UIKit
import MBProgressHUD
import MJRefresh

class RapidOrderListViewController: RapidBaseViewController {
    
    struct CellID {
        static let cellId = "RapidOrderListCellIdentifier"
    }
    
    var viewModel: RapidOrderListViewModel!

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
        let header = MJRefreshNormalHeader(){ [weak self] in
            guard let `self` = self else { return }
            self.requestData()
        }
        header.setTitle("Pull down to refresh", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading more...", for: .refreshing)
        
        tableView.mj_header = header
        
        tableView.ly_emptyView = RPFEmpty.emptyDiyView(title: "No Data", detail: "", image: .RPFEmptyImg)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavImageTitleWhite(isWhite: true)
        self.rightBtn.isHidden = true
        setupViews()
        requestData()
        setUpRx()
        // Do any additional setup after loading the view.
    }


}

extension RapidOrderListViewController {
    func setupViews(){
        self.titleNav.text = viewModel.type.titleName
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
    
    func requestData(){
        viewModel.getData()
    }
    
    func setUpRx() {
     
        
        viewModel.orderModels.skip(1)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.tableView.reloadData()
            })
            .disposed(by: bag)
        
        viewModel.newMessage
            .drive(onNext: { message in
                MBProgressHUD.showMessage(message, toview: nil, afterDelay: 3)
            })
            .disposed(by: bag)
        
        viewModel.isLoading
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (isLoading) in
                self?.handleLoading(isLoading: isLoading)
            })
            .disposed(by: bag)
        
    }
    
    private func handleLoading(isLoading: Bool) {
        if isLoading {
            self.showLoading()
        } else {
            self.hiddenLoading()
            tableView.mj_header?.endRefreshing()
        }
    }
    
}

extension RapidOrderListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.orderModels.value.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellId) as! RapidOrderListCell
        let models =  viewModel.orderModels.value
        guard  models.count > 0  else {
            return cell
        }
        cell.setContentCell(model: models[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let models =  viewModel.orderModels.value
        guard  models.count > 0  else {
            return 
        }
        let model = models[indexPath.section]
        setRouter(url: model.singing, pId: "")
//        let vc = RPFWebViewController()
//        vc.viewModel = RPFWebViewModel(urlString: model.singing)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return RapidHomeProductCell.height()
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16.rf
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude 
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: kPortraitScreenW, height: 12.rf))
        header.backgroundColor = .clear
        return header
    }
}

