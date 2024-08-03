//
//  RFFlowVC.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//
import HandyJSON
import MBProgressHUD
import RxSwift
import UIKit
import MJRefresh

class RFFlowVC: RapidBaseViewController {
    private let product_id: String
    private var order_id: String = ""
    init(product_id: String) {
        self.product_id = product_id
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleNav.text = ""
//        adjustNavTitleCenter()
        titleNav.font = 24.font
        self.rightBtn.isHidden = true
        setup()
        self.view.bringSubviewToFront(self.customNavView)
    }

    private var items: [RFFlowItem] = []
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let progressView = RFLoadProgressView()
    private let textLabel = UILabel().font(.f_lightSys10).textColor(.c_000000).numberOfLines(0).text("To ensure the security and smoothness of your transactions, we require you to provide authentic and valid information for identity verification and credit assessment. We pledge to keep your information strictly confidential and will never disclose it to any third party. Thank you for your trust and cooperation!")
    let textImg = UIImageView(image: "flow_item_bottom".image)
    private func setup() {
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.frame = self.view.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
        let header = MJRefreshNormalHeader(){ [weak self] in
            guard let `self` = self else { return }
            self.loadData()
        }
        header.setTitle("Pull down to refresh", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading more...", for: .refreshing)
        
        scrollView.mj_header = header
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let bgImgV = UIImageView(image: "em_in_bg".image)
        contentView.bounds = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let topImgV = UIImageView(image: "flow_top".image)
        contentView.addSubview(topImgV)
        topImgV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(175.5.rf)
        }

        let bottomImgV = UIImageView(image: "flow_bottom".image)
        contentView.addSubview(bottomImgV)
        bottomImgV.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
        
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(topImgV.snp.bottom).offset(-45.rf)
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.height.equalTo(117.rf)
        }
        
        let nextBtn = RFNextBtn()
        nextBtn.text = "Continue to submit"
        nextBtn.addTapGesture { [weak self] in
            self?.jumpNext()
        }
        contentView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-20.rf)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(textImg)
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(41.rf)
            make.right.equalTo(-40.rf)
            make.bottom.equalTo(nextBtn.snp.top).offset(-42.rf)
        }
        
        
        textImg.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.bottom.equalTo(textLabel.snp.bottom).offset(16.rf)
            make.top.equalTo(textLabel.snp.top).offset(-18.rf)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        scrollView.contentSize = CGSize(width: kScreenWidth, height: max(kScreenHeight, height))
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        
        guard let cfgs = model?.hehad else { return }
        let curModel = cfgs[sender.view!.tag]
        var cls = curModel.meet
        if curModel.mustn == 1 {
             cls = curModel.meet
            
        }else{
            guard let cur = model?.recovered else { return }
             cls = cur.meet
        }
        if cls == "public" || cls == "thinglike1" {
            self.navigationController?.pushViewController(RFIDDetailVC(productId: product_id, orderId: order_id), animated: true)
        }
        else  if cls == "personal" || cls == "thinglike2" {
            self.navigationController?.pushViewController(RFPInVC(route: .personal_info, productId: product_id, orderId: order_id), animated: true)
        }
        else  if cls == "work" || cls == "thinglike3" {
            self.navigationController?.pushViewController(RFPInVC(route: .employment_info, productId: product_id, orderId: order_id), animated: true)
        }
        else  if cls == "contacts" || cls == "thinglike4" {
            self.navigationController?.pushViewController(RFContactListVC(productId: product_id, orderId: order_id), animated: true)
        }
        else  if cls == "bank" || cls == "thinglike5" {
            requestBindBankInfo(product_id, order_id,self)
            
        }
    }
    
    private func jumpNext() {
       
        guard let cur = model?.recovered else { 
            guard let cfgs = model?.hehad else { return }
            let finishCount = cfgs.filter { $0.mustn == 1 }.count
            let oderTime = getCurrentTime()
            RapidApi.shared.getOrderProductWebAdress(para: ["snapped": self.order_id,"leftover":getRPFRandom(),"poised":getRPFRandom(),"theway":getRPFRandom(),"stopping":getRPFRandom()]).subscribe(onNext: { [weak self] obj in
                guard let url = obj.dictionaryObject?["littleroom"] as? String else {
                    return
                }
                self?.uploadAnalysis(type: .StartApply, time: oderTime)
                let vc = RPFWebViewController()
                vc.viewModel = RPFWebViewModel(urlString: url)
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }, onError: { err in
                MBProgressHUD.showError(err.localizedDescription)
            }).disposed(by: bag)
            return 
        }
        let  cls = cur.meet
        if cls == "public" || cls == "thinglike1" {
            self.navigationController?.pushViewController(RFIDDetailVC(productId: product_id, orderId: order_id), animated: true)
        }
        else  if cls == "personal" || cls == "thinglike2" {
            self.navigationController?.pushViewController(RFPInVC(route: .personal_info, productId: product_id, orderId: order_id), animated: true)
        }
        else  if cls == "work" || cls == "thinglike3" {
            self.navigationController?.pushViewController(RFPInVC(route: .employment_info, productId: product_id, orderId: order_id), animated: true)
        }
        else  if cls == "contacts" || cls == "thinglike4" {
            self.navigationController?.pushViewController(RFContactListVC(productId: product_id, orderId: order_id), animated: true)
        }
        else  if cls == "bank" || cls == "thinglike5" {
            requestBindBankInfo(product_id, order_id,self)
            
        }
    }
    
    
    private var model: RFProductDetailModel?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
}

extension RFFlowVC {
    private func loadData() {
        self.showLoading()
        RapidApi.shared.productDetail(para: ["putit": self.product_id, "interrupted": getRPFRandom(), "means": getRPFRandom()]).subscribe(onNext: { [weak self] obj in
            self?.hiddenLoading()
            self?.scrollView.mj_header?.endRefreshing()
            guard let model = RFProductDetailModel.deserialize(from: obj.dictionaryObject) else {
                return
            }
            self?.render(model)
            
        }, onError: { [weak self] err in
            MBProgressHUD.showError(err.localizedDescription)
            self?.hiddenLoading()
            self?.scrollView.mj_header?.endRefreshing()
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
    
    private func render(_ data: RFProductDetailModel) {
        self.model = data
        guard let cfgs = data.hehad else { return }
        items.forEach { obj in
            obj.removeFromSuperview()
        }
        items.removeAll()
        for i in 0 ..< cfgs.count {
            let item = RFFlowItem(bgImg: "flow_item_bg2".image, icon: cfgs[i].glorious, text: cfgs[i].hastily, isFinish: cfgs[i].mustn == 1)
            item.tag = i
            contentView.addSubview(item)
            items.append(item)
            let offset = CGFloat(i / 2) * (121.rf + 12.rf)
            item.snp.makeConstraints { make in
                make.width.equalTo(142.rf)
                make.height.equalTo(121.rf)
                make.left.equalTo(i % 2 == 1 ? 208.rf : 24.rf)
                make.top.equalTo(progressView.snp.bottom).offset(20.rf + offset)
                
                if i == cfgs.count - 1 {
                    make.bottom.equalTo(textImg.snp.top).offset(-5.rf)
                }
            }
            
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:))))
        }
        let finishCount = cfgs.filter { $0.mustn == 1 }.count
        progressView.fill(finishCount: finishCount, totalCount: cfgs.count)
        guard let started = data.started else { return }
        self.order_id = started.risking
        
    }
    
    private func uploadAnalysis(type: RFAnalysisScenenType, time: String){
        RPFLocationManager.manager.requestLocationAuthorizationStatus()
        RPFLocationManager.manager.analysisHandle = { [weak self] (longitude,latitude) in
            guard let `self` = self else {return}
            RPFReportManager.shared.saveAnalysis(pId: self.product_id, type: type, startTime: time, longitude: longitude, latitude: latitude)
        }
    }
}
