//
//  RFBankCardListVC.swift
//  RapidFund
//
//  Created by C on 2024/7/18.
//

import MBProgressHUD
import UIKit

class RFBankCardListVC: RapidBaseViewController {
    private let tb = UITableView(frame: .zero, style: .plain)
    private var dataSource: [RFBankListModel] = []
    private let order_id: String?
    private let productId:String
    init(orderId: String? = nil, productId:String) {
        self.order_id = orderId
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftBarButtonItem()
        setup()
        titleNav.text = "Select Account"
        self.rightBtn.isHidden = true
        self.view.bringSubviewToFront(customNavView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setup() {
        let bgView = UIImageView(image: "bankcard_list_bg".image)
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tb.backgroundColor = .clear
        tb.dataSource = self
        tb.delegate = self
        tb.register(RFBankCardListCell.self, forCellReuseIdentifier: "RFBankCardListCell")
        tb.rowHeight = 187.rf
        tb.contentInsetAdjustmentBehavior = .never
        tb.separatorStyle = .none
        tb.tableFooterView = createFooter()
        view.addSubview(tb)
        tb.snp.makeConstraints { make in
            make.top.equalTo(customNavView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(100.rf)
        }
        let nextBtn = RFNextBtn()
        nextBtn.text = "Submit Loan"
        nextBtn.nextImg = "bankcard_next".image
        nextBtn.addTapGesture {}
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-20.rf)
            make.centerX.equalToSuperview()
        }
    }
    
    private func createFooter() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 84.rf))
        let btnView = UIView()
        btnView.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.05)
        btnView.clipsCornerRadius(Float(10.rf))
        view.addSubview(btnView)
        btnView.snp.makeConstraints { make in
            make.left.equalTo(33.rf)
            make.right.equalTo(-15.rf)
            make.top.equalTo(15.rf)
            make.bottom.equalTo(-15.rf)
        }
        
        let lb = UILabel().text("Add other payment methods").font(14.font).textColor(0x111111.color)
        let icon = UIImageView(image: "bankcard_add".image)
        let stackView = UIStackView(arrangedSubviews: [lb, icon])
        stackView.spacing = 16
        stackView.alignment = .center
        btnView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        btnView.addTapGesture { [weak self] in
            guard let self = self else {
                return
            }
            self.getBankConfig()
        }
        return view
    }
    
    private func loadData() {
        RapidApi.shared.bankList(para: [:]).subscribe(onNext: { [weak self] obj in
            guard let army = obj.dictionaryObject?["army"] as? [Any], let models = [RFBankListModel].deserialize(from: army)?.compactMap({ $0 }) else { return }
            self?.dataSource.removeAll()
            self?.dataSource.append(contentsOf: models)
            self?.tb.reloadData()
        }, onError: { [weak self] err in
            MBProgressHUD.showError(err.localizedDescription)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
}

extension RFBankCardListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].forgot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RFBankCardListCell", for: indexPath) as! RFBankCardListCell
        let bank = dataSource[indexPath.section].forgot[indexPath.row]
        cell.fill(bank)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sec_view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 31.rf))
        let titLb = UILabel().font(16.font).textColor(0x111111.color).text(dataSource[section].ate)
        sec_view.addSubview(titLb)
        titLb.snp.makeConstraints { make in
            make.top.equalTo(15.5.rf)
            make.left.equalTo(24.rf)
        }
        return sec_view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 31.rf
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let card = dataSource[indexPath.section].forgot[indexPath.row]
        RapidApi.shared.changeBankCardInfo(para: ["nosing": card.nosing, "snapped": order_id ?? ""]).subscribe(onNext: { [weak self] obj in
            self?.refreshSelectedCard(card)
            guard let json = obj.dictionaryObject?["trouble"] as? [String: Any], let smelt = json["smelt"] as? String, smelt.isEmpty == false else { return }
            
            let vc = RPFWebViewController()
            vc.viewModel = RPFWebViewModel(urlString: smelt)
            self?.navigationController?.pushViewController(vc, animated: true)
        }, onError: { err in
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
    
    private func refreshSelectedCard(_ bank: RFBankListModel.__BankInfo) {
        self.dataSource.forEach { obj in
            obj.forgot.forEach { card in
                card.isSelected = false
            }
        }
        bank.isSelected = true
        tb.reloadData()
    }
    
    private func getBankConfig() {
//        RapidApi.shared.getBindCardInfo(para: ["whisked": "0", "frisked": getRPFRandom()]).subscribe(onNext: { [weak self] obj in
//            guard let model = RFBankCfg.deserialize(from: obj.dictionaryObject) else { return }
//            guard let self = self else { return }
//            let alert = RFBankMgrAlert(config: model, product_id: self.productId, orderId: self.order_id ?? "1")
//            alert.show(on: self.view)
//        }, onError: { err in
//            MBProgressHUD.showError(err.localizedDescription)
//        }).disposed(by: bag)
        requestBindBankInfo(productId, self)
    }
}
