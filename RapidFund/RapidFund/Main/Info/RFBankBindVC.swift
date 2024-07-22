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
        let stackSubs: [UIView]

        if category == .Wallet {
            let wallet = self.model.munched.first(where: { $0.yourtoboggans == "bush" })
            stackSubs = [walletItem, accountItem, numItem, walletDesItem, name1Item, name2Item, name3Item, nameDesItem]
            walletItem.model = wallet
            if let iconCfg = wallet?.snatch.first(where: { $0.dismay == self.model.dismay }) {
                walletItem.fill(iconCfg)
            }
            let accCfg = self.model.munched.first(where: { $0.yourtoboggans == "peeping" })
            accountItem.fill(accCfg?.sounding ?? "")
            let acc2Cfg = self.model.munched.first(where: { $0.yourtoboggans == "hid" })
            numItem.fill(acc2Cfg?.sounding ?? "")
            walletDesItem.fill("Ensure that the account informations are correct,other the tranfer may fail.")
            let name1Cfg = self.model.munched.first(where: { $0.yourtoboggans == "child" })
            name1Item.fill(name1Cfg?.sounding)
            let name2Cfg = self.model.munched.first(where: { $0.yourtoboggans == "frozen" })
            name2Item.fill(name2Cfg?.sounding)
            let name3Cfg = self.model.munched.first(where: { $0.yourtoboggans == "beabsolutely" })
            name3Item.fill(name3Cfg?.sounding)
            nameDesItem.fill("After your confirmation,this account will be used as receipt account to receive the funds")
            self.walletItem.block = { [weak self] in
                guard let self = self else { return }

                guard let list = wallet?.snatch.map({ $0.wasan }).compactMap({ $0 }) else {
                    return
                }
                let alert = RFBankAlert(strings: list)
                alert.selectedBlock = { index in
                    guard let it = wallet?.snatch[index] else { return }
                    self.walletItem.fill(it)
                }
                let appDel = UIApplication.shared.delegate as! AppDelegate
                alert.show(on: appDel.window!)
            }

        } else {
            stackSubs = [walletItem, accountItem, numItem, walletDesItem]
            walletItem.isHiddenIcon = true
            let cfg1 = self.model.munched.first(where: { $0.yourtoboggans == "bush" })
            walletItem.textLb.text = cfg1?.sounding
            let cfg2 = self.model.munched.first(where: { $0.yourtoboggans == "peeping" })
            accountItem.fill(cfg2?.sounding)
            let cfg3 = self.model.munched.first(where: { $0.yourtoboggans == "hid" })
            numItem.fill(cfg3?.sounding)
            walletDesItem.fill("After your confirmation,this account will be used as receipt account to receive the funds")
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
        nextBtn.addTapGesture { [weak self] in
            self?.bindBankCard()
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
    var dismiss: (() -> Void)?
}

extension RFBankBindVC {
    private func bindBankCard() {
        RapidApi.shared.commitBindCardInfo(para: ["putit": self.productId, "peeping": self.accountItem.value, "darkalmost": category == .Wallet ? "1" : "2", "bush": self.walletItem.textLb.text ?? "", "hid": "", "child": name1Item.value, "frozen": name2Item.value, "beabsolutely": name3Item.value, "its": getRPFRandom()]).subscribe(onNext: { [weak self] _ in
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
