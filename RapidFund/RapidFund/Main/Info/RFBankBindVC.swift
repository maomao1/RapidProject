//
//  RFBankBindVC.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import JXSegmentedView
import MBProgressHUD
import UIKit

enum RFBankType {
    case Wallet
    case Bank
    case CashPickup
}

class RFBankBindVC: RapidBaseViewController {
    private let category: RFBankType
    private let model: RFBankCfg.__RFMuchedModule
    private let productId: String
    init(bankCategory: RFBankType, data: RFBankCfg.__RFMuchedModule, productId: String) {
        self.category = bankCategory
        self.model = data
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let container = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNavViewHidden()
    }

    private func setup() {
        container.clipsCornerRadius(Float(24.rf))
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

        container.backgroundColor = .white
        view.backgroundColor = .clear
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        let stackView = UIStackView(arrangedSubviews: stackSubs)
        stackView.spacing = 16.rf
        stackView.alignment = .center
        stackView.axis = .vertical
        container.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        container.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32.rf)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-12.rf)
        }
        nextBtn.addTapGesture { [weak self] in
            self?.bindBankCard()
        }
    }

    
    private let nextBtn = RFNextBtn()
    var dismiss: (() -> Void)?
}

extension RFBankBindVC {
    private func bindBankCard() {
        RapidApi.shared.commitBindCardInfo(para: ["putit": self.productId, "peeping": "", "darkalmost": category == .Wallet ? "1" : "2", "bush": "", "hid": "", "child": "", "frozen": "", "beabsolutely": "", "its": getRPFRandom()]).subscribe(onNext: { [weak self] _ in
            self?.dismiss?()
        }, onError: { err in
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
}

extension RFBankBindVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
