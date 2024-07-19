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

class RFFlowVC: RapidBaseViewController {
    private let product_id: String
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
        self.titleNav.text = "Borrowing  Process"
        self.titleNav.textColor = .white
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
    private func setup() {
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.frame = self.view.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
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
            make.height.equalTo(426.rf)
        }

        let bottomImgV = UIImageView(image: "flow_bottom".image)
        contentView.addSubview(bottomImgV)
        bottomImgV.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
        
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.centerY.equalTo(topImgV.snp.bottom)
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.height.equalTo(117.rf)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        scrollView.contentSize = CGSize(width: kScreenWidth, height: height)
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        guard let cfgs = model?.hehad else { return }
        guard let cur = model?.recovered else { return }
        guard let curModel = cfgs.first(where: { $0.hastily == cur.hastily }) else {
            return
        }
        let index = cfgs.firstIndex(of: curModel)
    
        guard let index = index else { return }
        if index == 0 {
            navigationController?.pushViewController(RFIDDetailVC(), animated: true)
        } else if index == 1 {
            navigationController?.pushViewController(RFFRVC(), animated: true)
        } else if index == 2 {
            navigationController?.pushViewController(RFPInVC(route: .personal_info), animated: true)
        } else if index == 3 {
            navigationController?.pushViewController(RFPInVC(route: .employment_info), animated: true)
        } else if index == 4 {
            navigationController?.pushViewController(RFBankCardListVC(), animated: true)
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
        RapidApi.shared.productDetail(para: ["putit": self.product_id, "cheerfulindeed": getRPFRandom(), "noseoutside": getRPFRandom()]).subscribe(onNext: { [weak self] obj in
            guard let json = obj.dictionaryObject, let trouble = json["trouble"] as? [String: Any], let started = trouble["started"] as? [String: Any], let model = RFProductDetailModel.deserialize(from: started) else { return }
            self?.render(model)
        }, onError: { [weak self] err in
            MBProgressHUD.showError(err.localizedDescription)
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
            let item = RFFlowItem(bgImg: "flow_item_bg2".image, icon: cfgs[i].glorious, text: cfgs[i].hastily)
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
                    make.bottom.equalTo(contentView.snp.bottom).offset(-12.5.rf)
                }
            }
            
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:))))
        }
    }
}
