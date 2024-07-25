//
//  RFPInVC.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import MBProgressHUD
import RxSwift
import UIKit

enum RFRoute {
    case personal_info
    case employment_info
}

class RFPInVC: RapidBaseViewController {
    private var models: [RFTwoUserDataModel] = []
    private let route: RFRoute
    private let productId: String
    private let orderId: String
    private var nextModel: RFUploadResultModel? //下一步
    init(route: RFRoute, productId: String, orderId: String) {
        self.route = route
        self.productId = productId
        self.orderId = orderId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleNav.text = route == .personal_info ? "Personal Information" : "Employment Information"
        self.titleNav.textColor = .white
        adjustNavTitleCenter()
        titleNav.font = 24.font
        self.rightBtn.isHidden = true
        setup()
        self.view.bringSubviewToFront(self.customNavView)
        removeLastVC()
    }

    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView(arrangedSubviews: [])
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
        
        let bottV = UIImageView(image: getResourceConfig().0)
        contentView.addSubview(bottV)
        bottV.contentMode = .scaleToFill
        bottV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
        let bgImgV = UIImageView(image: getResourceConfig().1)
        bgImgV.isUserInteractionEnabled = true
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(303.rf)
        }
        
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .vertical, colors: [0xE5DEFA.color, 0xFFFFFF.color]))
        bgView.clipsCornerRadius(Float(24.rf))
        bgView.isUserInteractionEnabled = true
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.top.equalTo(bgImgV.snp.bottom).offset(-40.rf)
            make.bottom.equalTo(contentView.snp.bottom).offset(-77.rf)
        }
        
        stackView.spacing = 24.rf
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        bgView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 20.rf, left: 16.rf, bottom: 55.rf, right: 16.rf))
        }
        
        let btn = UIButton(type: .custom)
        btn.setImage("info_next".image, for: .normal)
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        contentView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(bgView.snp.bottom)
        }
        if route == .personal_info {
            loadUserData()
        } else {
            loadOtherData()
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        scrollView.contentSize = CGSize(width: kScreenWidth, height: max(kScreenHeight, height))
    }
    
    private func getResourceConfig() -> (UIImage?, UIImage?) {
        if route == .personal_info {
            return ("info_bg".image, "info_top".image)
        }
        
        return ("em_in_bg".image, "em_in_top".image)
    }
    
    private func loadUserData() {
        RapidApi.shared.getTwoUserInfo(para: ["putit": productId]).subscribe(onNext: { [weak self] obj in
            guard let list = obj.dictionaryObject?["munched"] as? [Any], let models = [RFTwoUserDataModel].deserialize(from: list)?.compactMap({ $0 }) else {
                return
            }
            self?.models = models
            self?.render()
        }, onError: { [weak self] err in
            print(err)
            MBProgressHUD.showError(err.localizedDescription)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
    
    private func loadOtherData() {
        RapidApi.shared.getWorkInfo(para: ["putit": productId]).subscribe(onNext: { [weak self] obj in
            guard let list = obj.dictionaryObject?["munched"] as? [Any], let models = [RFTwoUserDataModel].deserialize(from: list)?.compactMap({ $0 }) else {
                return
            }
            self?.models = models
            self?.render()
        }, onError: { [weak self] err in
            print(err)
            MBProgressHUD.showError(err.localizedDescription)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
    
    private func render() {
        for item in models {
            if item.hastily == "Gender" {
                let gender = RFGengerItem()
                stackView.addArrangedSubview(gender)
                gender.model = item
                gender.isMale = item.theboys == "1"
            } else {
                let other = RFInfoItem(item.hastily, placeholder: item.sounding)
                other.model = item
                stackView.addArrangedSubview(other)
                other.btnBlock = { [weak self] in
                    guard let self = self else { return }
                    if item.marking == "boyswent3" {
                        self.getAddressCfgs(other)
                    } else {
                        let strings = item.snatch.map { $0.wasan }
                        guard strings.isEmpty == false else { return }
                        let alert = RFBankAlert(strings: strings)
                        alert.selectedBlock = { index in
                            item.dismay = item.snatch[index].dismay
                            item.upthe = item.snatch[index].wasan
                            other.update(strings[index])
                        }
                        alert.show(on: self.view)
                    }
                }
            }
        }
    }
    
    @objc private func nextAction() {
        if route == .employment_info {
            self.saveWorkInfo()
            return
        }
        var param = [String: Any]()
        param["putit"] = productId
        param["aily"] = getRPFRandom()
        
        models.forEach {
            if let keyStr = $0.yourtoboggans {
                if keyStr == "neatly" {
                    param[keyStr] = $0.theboys
                } else {
                    param[keyStr] = $0.snatch.count > 0 ? $0.dismay : $0.upthe
                }
            }
        }
       
        RapidApi.shared.saveTwoUserInfo(para: param).subscribe(onNext: { [weak self] obj in
            guard let model = RFUploadResultModel.deserialize(from: obj.dictionaryObject) else {
                return
            }
            guard let self = self else { return  }
            self.nextModel = model
            self.jumpNext()
        }, onError: { err in
            print("\(err)")
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
    
    private func saveWorkInfo() {
        var param = [String: Any]()
        param["putit"] = productId
        param["snuffling"] = getRPFRandom()
        param["hesitatingsteps"] = getRPFRandom()
        
        models.forEach {
            if let keyStr = $0.yourtoboggans {
                param[keyStr] = $0.snatch.count > 0 ? $0.dismay : $0.upthe
            }
        }
        RapidApi.shared.saveWorkInfo(para: param).subscribe(onNext: { [weak self] obj in
            guard let model = RFUploadResultModel.deserialize(from: obj.dictionaryObject) else {
                return
            }
            guard let self = self else { return  }
            self.nextModel = model
            self.jumpNext()
        }, onError: { err in
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
    
    private func jumpNext() {
//        if route == .personal_info {
//            navigationController?.pushViewController(RFPInVC(route: .employment_info, productId: productId, orderId: orderId), animated: true)
//        } else {
//            navigationController?.pushViewController(RFBankCardListVC(orderId: nil, productId: productId), animated: true)
//        }
        
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
            self.navigationController?.pushViewController(RFBankCardListVC(productId: self.productId), animated: true)
        }
    }
    
    
    private func getAddressCfgs(_ item: RFInfoItem) {
        RapidApi.shared.addressDetail(para: [:]).subscribe(onNext: { [weak self] obj in
            guard let army = obj.dictionaryObject?["army"] as? [Any], let models = [RFAddressDetail].deserialize(from: army)?.compactMap({ $0 }) else { return }
            guard let self = self else { return }
            let alert = RFAddressAlert(address: models)
            alert.updateBlock = { md, twoIndex, threeIndex in
                // model 一级
                let twoModel = md.army[twoIndex]
                let threeModel = twoModel.army[threeIndex]
                let text = md.wasan + twoModel.wasan + threeModel.wasan
                item.model?.upthe = text
                item.update(text)
                alert.dismiss(withAnimation: true)
            }
            alert.show(on: self.view)
        }, onError: { err in
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
}
