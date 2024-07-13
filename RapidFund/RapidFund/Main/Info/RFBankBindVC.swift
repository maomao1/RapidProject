//
//  RFBankBindVC.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import UIKit
import JXSegmentedView


enum RFBankType {
    case Wallet
    case Bank
    case CashPickup
}

class RFBankBindVC: RapidBaseViewController {
    private let category:RFBankType
    init(bankCategory:RFBankType) {
        self.category = bankCategory
        super.init(nibName: nil, bundle: nil)
    }
    
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
        let stackSubs:[UIView]
        if category == .Bank {
            stackSubs = [walletItem, accountItem, numItem, walletDesItem]
        } else {
            stackSubs = [walletItem, accountItem, numItem, walletDesItem, name1Item, name2Item, name3Item, nameDesItem]
        }
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
    }

    private let walletItem = RFBankItem()
    private let accountItem = RFBankEditItem()
    private let numItem = RFBankEditItem()
    private let walletDesItem = RFBankDesItem()
    private let name1Item = RFBankEditItem()
    private let name2Item = RFBankEditItem()
    private let name3Item = RFBankEditItem()
    private let nameDesItem = RFBankDesItem()
    private let nextBtn = RFNextBtn()
}


extension RFBankBindVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
