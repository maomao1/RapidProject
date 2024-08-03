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
import FSPagerView
import MJRefresh

class RapidHomeViewController: RapidBaseViewController {
    // MARK: - Constants
    struct AutoLayout {
        static let applyText = "Apply for a Loan"
        
    }
    
    struct CellID {
        static let cellId = "RapidHomeProductCellIdentifier"
        static let bannerCell = "FSPagerViewCellIdentifier"
        static let reminderCell = "RPFHomeReminderCellIdentifier"
        static let hotCellId = "RapidHomeHotCellIdentifier"
    }
    // MARK: - Properties
    
    
    var viewModel: RapidHomeViewModel = RapidHomeViewModel()
    
    let backgroundImageView = UIImageView(image: .homeFullBg)
    let circleLeftImageView = UIImageView(image: .homeCircleLeft)
    let circleTopRightImageView = UIImageView(image: .homeCircleTopRight)
    let circleBottomRightImageView = UIImageView(image: .homeCircleBottomRight)
//    let rapidImageView = UIImageView(image: .homeRapidIcon)
//    let rapidNameLabel = UILabel().withFont(.f_lightSys12)
//        .withTextColor(.c_111111)
//        .withTextAlignment(.center)
//        .withText("")
//    let unLoginImgBg  = UIImageView(image: .homeUnloginBg)
    let LoginTopImgBg  = UIImageView(image: .homeLoginTopBg)
//    let homeMoneyView = HomeMoneyView()
//    let homeMoneyRateView = HomeMoneyRateView()
     
    
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
    
//    lazy var applyBtn: UIButton = {
//        let button = UIButton(type: .custom)
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 20.rf
//        button.setBackgroundImage(.homeBtnBg, for: .normal)
//        button.setBackgroundImage(.homeBtnBg, for: .selected)
//        button.setBackgroundImage(.homeBtnBg, for: .highlighted)
//        return button
//    }()
    
//    lazy var applyTitle: UILabel = {
//        let label = UILabel()
//        label.textColor = .c_FFFFFF
//        label.textAlignment = .left
//        label.font = .f_lightSys16
//        label.text = AutoLayout.applyText
//        return label
//    }()
//    
//    lazy var applyArrow: UIImageView = {
//        let imageView = UIImageView(image: .homeApplyArrow)
//        imageView.isUserInteractionEnabled = false
//        imageView.contentMode = .right
//        return imageView
//    }()
    
    //
    lazy var banner: FSPagerView = {
        let pager = FSPagerView()
        pager.delegate = self
        pager.dataSource = self
        pager.automaticSlidingInterval = 2.0
        pager.isInfinite = false
        pager.transformer = FSPagerViewTransformer(type: .depth)
        pager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: CellID.bannerCell)
        return pager
    }()
    
    lazy var reminderView: FSPagerView = {
        let reminder = FSPagerView(frame: CGRect(x: 0, y: 0, width: kPortraitScreenW, height: 81.rf))
        reminder.scrollDirection = .vertical
        reminder.delegate = self
        reminder.dataSource = self
        reminder.automaticSlidingInterval = 3.0
        reminder.isInfinite = false
        reminder.transformer = FSPagerViewTransformer(type: .depth)
        reminder.register(RPFReminderCell.self, forCellWithReuseIdentifier: CellID.reminderCell)
        return reminder
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
        tableView.tableHeaderView = self.reminderView
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
    
    lazy var hotTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60.rf
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        let footerView = UIView(frame: .zero)
        tableView.tableFooterView = footerView
        tableView.register(RapidHomeHotCell.self, forCellReuseIdentifier: CellID.hotCellId)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    
}

extension RapidHomeViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
//        viewModel.getData()
        setBackBtnHidden()
        setUpRx()
      
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getData()
    }
    
    
    
}

extension RapidHomeViewController {
    
    func setupViews(){
        self.titleNav.text = viewModel.pageTitle
        self.safeAreaBottomView.isHidden = false
        view.addSubview(backgroundImageView)
        view.addSubview(circleLeftImageView)
        view.addSubview(circleTopRightImageView)
        view.addSubview(circleBottomRightImageView)
        view.addSubview(unLoginContainer)
        view.addSubview(loginContainer)
        self.view.bringSubviewToFront(self.customNavView)
        self.view.bringSubviewToFront(self.safeAreaBottomView)
        
        backgroundImageView.isUserInteractionEnabled = true
        loginContainer.isUserInteractionEnabled = true
                
        unLoginContainer.addSubview(hotTableView)        
        
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
        
        hotTableView.snp.makeConstraints { make in
            make.edges.equalTo(unLoginContainer)
        }


        
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
            make.bottom.equalTo(LoginTopImgBg)
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
    
    func updateUIData(){
        guard let model = self.viewModel.homeModel.value else {
            return
        }
        self.setNavImageTitleWhite(isWhite: model.products?.count ?? 0 > 0)
        
        if  model.products?.count ?? 0 > 0 {
            self.unLoginContainer.isHidden = true
            self.loginContainer.isHidden = false
            self.rightBtn.isHidden = true
            self.titleNav.font = .f_lightSys32
            self.tableView.reloadData()
            self.banner.reloadData()
            
        }else{
            self.unLoginContainer.isHidden = false
            self.loginContainer.isHidden = true
            self.rightBtn.isHidden = false
        }
        if model.reminder?.count ?? 0 > 0 {
            self.reminderView.reloadData()
        }
        
        guard let hotModels = model.hotmeals, hotModels.count > 0, let hotModel = hotModels.first else {
            return
        }
        self.hotTableView.reloadData()        
    }
    
    func loginSuccessEvent() {
        self.reloadHomeData()
    }
    
    func reloadHomeData() {
        viewModel.getData()
    }
    
    func presentLogin(){
        let vc = RapidLoginViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    func requestNext() {
        
        if GetInfo(kRapidSession).isEmpty {
            self.presentLogin()
           return 
        }

        guard let model = viewModel.homeModel.value else {
            return
        }
        guard let hotModels = model.hotmeals, hotModels.count > 0, let hotModel = hotModels.first else {
            return
        }
        self.viewModel.getNextData(productId: hotModel.disapproval)
    }
    
    func nextPush(productId: String){
        guard let model = viewModel.nextModel.value else{
            return
        }
        self.setRouter(url: model.littleroom, pId: productId)

    }
    
    
    func setUpRx() {
        RFNetManager.manager
            .networkType
            .skip(1)
            .subscribe(onNext: { [weak self] type in
                guard let `self` = self else {return}
                if type == .unknown{
                    
                } else {
                    self.viewModel.getData()
                }
            })
            .disposed(by: bag)
     
        NotificationCenter.default
            .rx.notification(.RapidLoginSuccess)
            .subscribe(onNext: { [weak self] (notification) in
                guard let `self` = self else {return}
                self.loginSuccessEvent()
            })
            .disposed(by: bag)
        
//        applyBtn.rx
//            .tap
//            .throttle(.seconds_1, latest: false, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] (_) in
//                guard let `self` = self else { return }
//                self.requestNext()
//
//            })
//            .disposed(by: bag)
        
//        viewModel.homeModel.skip(1)
//            .subscribe(onNext: { [weak self] (_) in
//                guard let `self` = self else { return }
//                self.updateUIData()
//            })
//            .disposed(by: bag)
        
        viewModel.newMessage
            .drive(onNext: { message in
                MBProgressHUD.showMessage(message, toview: nil, afterDelay: 3)
            })
            .disposed(by: bag)
        
        viewModel.refreshAction 
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.updateUIData()
                
            })
            .disposed(by: bag)
        
        viewModel.nextAction 
            .subscribe(onNext: { [weak self] productId in
                guard let `self` = self else { return }
                self.nextPush(productId: productId)
                
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
            hotTableView.mj_header?.endRefreshing()
        }
    }
    
    
}

extension RapidHomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let model = viewModel.homeModel.value else {
            return 0
        }
        if tableView == hotTableView {
            return model.hotmeals?.count ?? 0 > 0 ? 1 : 0
//            guard let hotModels = model.hotmeals, hotModels.count > 0, let hotModel = hotModels.first else{
//                return 0
//            }
//            return 1
        }
        return model.products?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == hotTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.hotCellId) as! RapidHomeHotCell
            cell.applyBlock = { [weak self] in
                self?.requestNext()
            }
            guard let model = self.viewModel.homeModel.value else {
                return cell
            }
            guard let hotModels = model.hotmeals, hotModels.count > 0, let hotModel = hotModels.first else {
                return cell
            }
            cell.updateCellContent(model: hotModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellId) as! RapidHomeProductCell

            guard let model = self.viewModel.homeModel.value else {
                return cell
            }
            guard model.products?[indexPath.section] != nil else {
                return cell
            }
            cell.updateCellContent(model: model.products![indexPath.section])

            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == hotTableView {
            return
        }
        let product = self.viewModel.homeModel.value?.products?[indexPath.section]
        guard let product = product else {
            return
        }
        self.viewModel.getNextData(productId: product.disapproval)
//        let vc = RFFlowVC(product_id: product.disapproval)
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.viewModel.getNextData(productId: product.disapproval)

       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == hotTableView {
            return UITableView.automaticDimension
        }
        return RapidHomeProductCell.height()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}


extension RapidHomeViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let model = viewModel.homeModel.value else {
            return 0
        }
        if pagerView == self.banner {
            return model.banners?.count ?? 0
        }else{
            return model.reminder?.count ?? 0
        }
        
    }
//    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView  == self.banner {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellID.bannerCell, at: index)
            guard let model = self.viewModel.homeModel.value else {
                return cell
            }
            guard model.banners?[index] != nil else {
                return cell
            }
            let bannerModel = model.banners![index]
            cell.imageView?.sd_setImage(with: bannerModel.imageUrl.url, placeholderImage: .homeLoginBanner, options: .allowInvalidSSLCertificates)

            return cell
        }
        else{
            
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellID.reminderCell, at: index) as! RPFReminderCell
            guard let model = self.viewModel.homeModel.value else {
                return cell
            }
            guard model.reminder?[index] != nil else {
                return cell
            }
            let reminderModel = model.reminder![index]
            cell.setContent(model: reminderModel)

            return cell
        }
        

    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard let model = self.viewModel.homeModel.value else {
            return 
        }
        if pagerView == self.banner {
            guard model.banners?[index] != nil else {
                return 
            }
            let bannerModel = model.banners![index]
            if !bannerModel.littleroom.isEmpty{
                let vc  = RPFWebViewController()
                vc.viewModel = RPFWebViewModel(urlString: bannerModel.littleroom)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            guard model.reminder?[index] != nil else {
                return 
            }
            let reminderModel = model.reminder![index]
            if !reminderModel.url.isEmpty{
                let vc  = RPFWebViewController()
                vc.viewModel = RPFWebViewModel(urlString: "https://www.baidu.com")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}


