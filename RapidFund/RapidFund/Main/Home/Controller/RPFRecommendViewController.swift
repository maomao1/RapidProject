//
//  RPFRecommendViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/8/2.
//


import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD
import MJRefresh

class RPFRecommendViewController: RapidBaseViewController {
    struct CellID {
        static let cellId = "RapidHomeProductCellIdentifier"
        
    }
    
    var viewModel: RPFRecommendViewModel = RPFRecommendViewModel()

    let backgroundImageView = UIImageView(image: .homeFullBg)
    let circleLeftImageView = UIImageView(image: .homeCircleLeft)
    let circleBottomRightImageView = UIImageView(image: .homeCircleBottomRight)
    let topImgView = UIImageView(image: .homeRecommendTopImg)
    let topTextImg = UIImageView(image: .homeRecommendTextImg)
    lazy var headerView: UIView = {
        let header = UIView()
        return header
    }()
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
        tableView.register(RapidHomeProductCell.self, forCellReuseIdentifier: CellID.cellId)
//        tableView.tableHeaderView = self.reminderView
        let header = MJRefreshNormalHeader(){ [weak self] in
            guard let `self` = self else { return }
            self.viewModel.getData()
        }
        header.setTitle("Pull down to refresh", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading more...", for: .refreshing)
        
        tableView.mj_header = header
        
        return tableView
    }()
}

extension RPFRecommendViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setUpRx()
      
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getData()
    }
}

extension RPFRecommendViewController {
    
    func setupViews(){
        self.titleNav.text = viewModel.pageTitle
        self.setNavImageTitleWhite(isWhite: false)
        self.rightBtn.isHidden = true
        self.titleNav.font = .f_lightSys24
        view.addSubview(backgroundImageView)
//        view.addSubview(circleLeftImageView)
        view.addSubview(circleBottomRightImageView)
        headerView.addSubview(topImgView)
        headerView.addSubview(topTextImg)
        headerView.addSubview(circleLeftImageView)
        view.addSubview(headerView)
        view.addSubview(tableView)
        self.view.bringSubviewToFront(self.customNavView)
        topImgView.contentMode = .scaleAspectFit
        
        self.customNavView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0.rf)
            } else {
                make.top.equalTo(0.rf)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(44.rf)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(235.rf)
        }
        
        topImgView.snp.makeConstraints { make in
            make.edges.equalTo(headerView)
        }
        circleLeftImageView.snp.makeConstraints { make in
            make.right.equalTo(headerView.snp.left).offset(84.rf)
            make.bottom.equalTo(headerView.snp.top).offset(70.5.rf)
        }
        
        topTextImg.snp.makeConstraints { make in
            make.right.equalTo(-22.5.rf)
            make.bottom.equalTo(-6.rf)
            
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
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                make.bottom.equalTo(0)
            }
        }
    }
    
    func setUpRx(){
        
        viewModel.products.skip(1)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.tableView.reloadData()
            })
            .disposed(by: bag)
        
        viewModel.nextAction 
            .subscribe(onNext: { [weak self] productId in
                guard let `self` = self else { return }
                self.nextPush(productId: productId)
                
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
    
    func nextPush(productId: String){
        guard let model = viewModel.nextModel.value else{
            return
        }
        self.setRouter(url: model.littleroom, pId: productId)

    }
}

extension RPFRecommendViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.viewModel.products.value.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellId) as! RapidHomeProductCell

        let models =  viewModel.products.value
        guard  models.count > 0  else {
            return cell
        }
        cell.updateCellContent(model: models[indexPath.section])

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = viewModel.products.value[indexPath.section]
//        guard let product = product else {
//            return
//        }
        self.viewModel.getNextData(productId: product.disapproval)

       
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
