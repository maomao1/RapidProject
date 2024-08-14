//
//  RFBankBindVC.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import JXSegmentedView
import MBProgressHUD
import UIKit

enum RFBankType:Int {
    case Wallet = 1
    case Bank = 2
    case CashPickup
}

class RFBankBindVC: RapidBaseViewController {
    private let category: RFBankType
    private let model: RFBankCfg.__RFMuchedModule
    private let productId: String
    private let orderId: String
    private let dismand:String
    private var isAddNewCard = false
    init(bankCategory: RFBankType, data: RFBankCfg.__RFMuchedModule, productId: String, dismad:String, orderId: String, isAddCard: Bool) {
        self.category = bankCategory
        self.model = data
        self.productId = productId
        self.dismand = dismad
        self.orderId = orderId
        self.isAddNewCard = isAddCard
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let container = UIView()
    private let scrollView = UIScrollView()
    private var enterPageTime: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNavViewHidden()
        if self.isAddNewCard {
            
        }else{
            removeLastVC() 
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enterPageTime = getCurrentTime()
    }

    private func setup() {
        scrollView.bounces = false
        scrollView.frame = self.view.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 100.rf, right: 0))
        }
        scrollView.addSubview(container)
        container.bounds = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 100.rf)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        var stackSubs: [UIView] = []
        for item in model.munched {
            if item.yourtoboggans == "bush" {
                let wallet = RFBankItem()
                wallet.model = item
                stackSubs.append(wallet)
            } else {
                let subView = RFBankEditItem()
                subView.model = item
                stackSubs.append(subView)
            }
        }
        let desItem = RFBankDesItem()
        desItem.fill("After your confirmation,this account will be used as receipt account to receive the funds")
        stackSubs.append(desItem)

        let stackView = UIStackView(arrangedSubviews: stackSubs)
        stackView.spacing = 16.rf
        stackView.alignment = .center
        stackView.axis = .vertical
        container.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-12.rf)
        }
        nextBtn.addTapGesture { [weak self] in
            self?.bindBankCard()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        scrollView.contentSize = CGSize(width: kScreenWidth, height: height)
    }

    
    private let nextBtn = RFNextBtn()
    var dismiss: (() -> Void)?
}

extension RFBankBindVC {
    private func bindBankCard() {
        var json:[String:Any] = ["putit":self.productId,"its":getRPFRandom(),"cardType":dismand]
        for item in self.model.munched {
            json[item.yourtoboggans] = item.snatch.isEmpty == true ? item.upthe : item.dismay
        }
        self.showLoading()
        RapidApi.shared.commitBindCardInfo(para: json).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            self.hiddenLoading()
            if self.isAddNewCard {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.uploadAnalysis(type: .BankCard, time: self.enterPageTime)
                self.jumpNext()
            }
            
        }, onError: { err in
            self.hiddenLoading()
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
    
    func jumpNext() {
        let oderTime = getCurrentTime()
        self.showLoading()
        RapidApi.shared.getOrderProductWebAdress(para: ["snapped": self.orderId,"leftover":getRPFRandom(),"poised":getRPFRandom(),"theway":getRPFRandom(),"stopping":getRPFRandom()]).subscribe(onNext: { [weak self] obj in
            self?.hiddenLoading()
            guard let url = obj.dictionaryObject?["littleroom"] as? String else {
                return
            }
            self?.uploadAnalysis(type: .StartApply, time: oderTime)
            self?.setRouter(url: url, pId: "")
//            let vc = RPFWebViewController()
//            vc.viewModel = RPFWebViewModel(urlString: url)
//            self?.navigationController?.pushViewController(vc, animated: true)
            
        }, onError: { err in
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
    
    private func uploadAnalysis(type: RFAnalysisScenenType, time: String){
        RPFReportManager.shared.saveAnalysis(pId: self.productId, type: type, startTime: time, longitude: "0", latitude: "0")
        return
        RPFLocationManager.manager.requestLocationAuthorizationStatus(isLocation: false)
        RPFLocationManager.manager.analysisHandle = { [weak self] (longitude,latitude) in
            guard let `self` = self else {return}
            RPFReportManager.shared.saveAnalysis(pId: self.productId, type: type, startTime: time, longitude: longitude, latitude: latitude)
        }
    }
}

extension RFBankBindVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
