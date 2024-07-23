//
//  RFContactListVC.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import MBProgressHUD
import UIKit

class RFContactListVC: RapidBaseViewController {
    private let productId: String
    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dataSource: [RFContactModel] = []
    private let tb = UITableView(frame: .zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        view.bringSubviewToFront(self.customNavView)
        titleNav.text = "Contact Information"
        setNavImageTitleWhite(isWhite: true)
        rightBtn.isHidden = true
        loadData()
    }
    
    private func setup() {
        let bgView = UIImageView(image: "contact_bg".image)
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let topview = UIImageView(image: "contact_top".image)
        view.addSubview(topview)
        topview.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(303.rf)
        }
        tb.dataSource = self
        tb.delegate = self
        tb.register(RFContactCell.self, forCellReuseIdentifier: "RFContactCell")
        tb.backgroundColor = .clear
        tb.showsVerticalScrollIndicator = false
        tb.separatorStyle = .none
        tb.rowHeight = 168.rf
        view.addSubview(tb)
        tb.contentInsetAdjustmentBehavior = .never
        tb.contentInset = UIEdgeInsets(top: 268.rf, left: 0, bottom: 0, right: 0)
        tb.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 24.rf, bottom: 100.rf, right: 24.rf))
        }
        tb.contentOffset = CGPoint(x: 0, y: -268.rf)
        
        let nextBtn = RFNextBtn()
        nextBtn.text = "Next"
        nextBtn.addTapGesture { [weak self] in
            self?.saveAction()
        }
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-20.rf)
            make.centerX.equalToSuperview()
        }
    }

    private func loadData() {
        RapidApi.shared.getContactsInfo(para: ["putit": productId, "bear": getRPFRandom()]).subscribe(onNext: { [weak self] obj in
            guard let onto = obj.dictionaryObject?["onto"] as? [String: Any], let army = onto["army"] as? [Any], let models = [RFContactModel].deserialize(from: army)?.compactMap({ $0 }) else {
                return
            }
            self?.dataSource.removeAll()
            self?.dataSource.append(contentsOf: models)
            self?.tb.reloadData()
            
        }, onError: { [weak self] err in
            MBProgressHUD.showError(err.localizedDescription)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
}

extension RFContactListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.rf
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 48.rf, height: 12.rf))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section]
        model.indexPath = indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "RFContactCell", for: indexPath) as! RFContactCell
        cell.fill(model)
        return cell
    }
    
    private func saveAction() {
        var json: [[String: Any]] = []
        self.dataSource.forEach { obj in
            if obj.bumped?.isEmpty == false, obj.fany.isEmpty == false {
                json.append(["bumped": obj.bumped ?? "", "wasan": obj.wasan ?? "", "fany": obj.fany, "disappear": obj.disappear ?? ""])
            }
        }
        RapidApi.shared.saveContactInfo(para: ["putit": self.productId, "trouble": json.toJSONString ?? ""]).subscribe(onNext: { [weak self] _ in
            self?.tb.reloadData()
        }, onError: { [weak self] err in
            MBProgressHUD.showError(err.localizedDescription)
            
        }).disposed(by: bag)
    }
}
