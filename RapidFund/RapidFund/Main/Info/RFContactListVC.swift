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
    private let orderId: String
    private var nextModel: RFUploadResultModel? //下一步
    private var isCertified: Bool = false
    private var enterPageTime: String = ""

    init(productId: String, orderId: String) {
        self.productId = productId
        self.orderId = orderId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dataSource: [RFContactModel] = []
    private var isFirstReportAdress = true
    private let tb = UITableView(frame: .zero, style: .plain)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enterPageTime = getCurrentTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        view.bringSubviewToFront(self.customNavView)
        titleNav.text = "Contact Information"
        setNavImageTitleWhite(isWhite: true)
        rightBtn.isHidden = true
        loadData()
        removeLastVC()
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
        self.showLoading()
        RapidApi.shared.getContactsInfo(para: ["putit": productId, "bear": getRPFRandom()]).subscribe(onNext: { [weak self] obj in
            self?.hiddenLoading()
            guard let onto = obj.dictionaryObject?["onto"] as? [String: Any], let army = onto["army"] as? [Any], let models = [RFContactModel].deserialize(from: army)?.compactMap({ $0 }) else {
                return
            }
            self?.dataSource.removeAll()
            self?.dataSource.append(contentsOf: models)
            self?.tb.reloadData()
            
        }, onError: { [weak self] err in
            self?.hiddenLoading()
            MBProgressHUD.showError(err.localizedDescription)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
    
    private func reportAdress() {
        if isFirstReportAdress{
            RPFContactManager.shared.fetchContacts { item, error in
                RPFReportManager.shared.saveAdressBook(persons: item)
                self.isFirstReportAdress = false
            }
        }
    }
    
    private func jumpNext() {
 
        guard let model = self.nextModel else {
            self.navigationController?.popViewController(animated: true)
            return}
        guard let cur = model.recovered else { 
            self.navigationController?.popViewController(animated: true)
            return }
        
        let cls = cur.meet
        if cls == "public" || cls == "thinglike1" {
            
        }
        else  if cls == "personal" || cls == "thinglike2" {
            self.navigationController?.pushViewController(RFPInVC(route: .personal_info, productId: self.productId, orderId: self.orderId), animated: true)
        }
        else  if cls == "work" || cls == "thinglike3" {
            self.navigationController?.pushViewController(RFPInVC(route: .employment_info, productId: self.productId, orderId: self.orderId), animated: true)
        }
        else  if cls == "contacts" || cls == "thinglike4" {
            self.navigationController?.pushViewController(RFContactListVC(productId: self.productId, orderId: self.orderId), animated: true)
        }
        else  if cls == "bank" || cls == "thinglike5" {
            requestBindBankInfo(self.productId, self.orderId,self)
            
        }
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
        cell.reportBlock = { [weak self]  in
            self?.reportAdress()
        }
        return cell
    }
    
    private func saveAction() {
        var json: [[String: Any]] = []
        self.dataSource.forEach { obj in
            if obj.bumped?.isEmpty == false, obj.fany.isEmpty == false {
                json.append(["bumped": obj.bumped ?? "", "wasan": obj.wasan ?? "", "fany": obj.fany, "disappear": obj.disappear ?? ""])
            }
        }
        RapidApi.shared.saveContactInfo(para: ["putit": self.productId, "trouble": json.toJSONString ?? ""]).subscribe(onNext: { [weak self] obj in
            guard let model = RFUploadResultModel.deserialize(from: obj.dictionaryObject) else {
                return
            }
            guard let self = self else { return  }
            self.uploadAnalysis(type: .Contacts)
            self.nextModel = model
            self.tb.reloadData()
            self.jumpNext()
        }, onError: { [weak self] err in
            MBProgressHUD.showError(err.localizedDescription)
            
        }).disposed(by: bag)
    }
    
    private func uploadAnalysis(type: RFAnalysisScenenType){
        
        RPFLocationManager.manager.analysisHandle = { [weak self] (longitude,latitude) in
            guard let `self` = self else {return}
            RPFReportManager.shared.saveAnalysis(pId: self.productId, type: type, startTime: self.enterPageTime, longitude: longitude, latitude: latitude)
        }
    }
}
