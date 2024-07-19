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
    init(route: RFRoute, productId: String) {
        self.route = route
        self.productId = productId
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
    }

    private let genderItem = RFGengerItem()
    private let relaItem = RFInfoItem("Marriage Status", placeholder: "Ralationship")
    private let passportItem = RFInfoItem("Passport", placeholder: "12-12-2024")
    private let addressItem = RFInfoItem("Address", placeholder: "Address")
    private let phoneItem = RFInfoItem("Phone Number", placeholder: "1234567", hiddenNext: true)
    private let inomeItem = RFInfoItem("Monthly Income", placeholder: "aaaaa")
    
    private func setup() {
        let bottV = UIImageView(image: getResourceConfig().0)
        view.addSubview(bottV)
        bottV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let bgImgV = UIImageView(image: getResourceConfig().1)
        bgImgV.isUserInteractionEnabled = true
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(303.rf)
        }
        
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .vertical, colors: [0xE5DEFA.color, 0xFFFFFF.color]))
        bgView.clipsCornerRadius(Float(24.rf))
        bgView.isUserInteractionEnabled = true
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.top.equalTo(bgImgV.snp.bottom).offset(-40.rf)
        }
        
        let stackViews: [UIView]
        if route == .personal_info {
            stackViews = [genderItem, relaItem, passportItem, addressItem]
        } else {
            stackViews = [phoneItem, inomeItem]
        }
        let stackView = UIStackView(arrangedSubviews: stackViews)
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
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(bgView.snp.bottom)
        }
        if route == .personal_info {
            loadData()
        }
        
        addressItem.btnBlock = { [weak self] in
            self?.getAddressCfgs()
        }
        passportItem.btnBlock = { [weak self] in
            guard let self = self else { return }
            let alert = RFDateSelAlert()
            alert.saveBlock = { date in
                let format = DateFormatter()
                format.dateFormat = "dd-MM-yyyy"
                self.passportItem.update(format.string(from: date))
            }
            alert.show(on: self.view)
        }
    }
    
    private func getResourceConfig() -> (UIImage?, UIImage?) {
        if route == .personal_info {
            return ("info_bg".image, "info_top".image)
        }
        
        return ("em_in_bg".image, "em_in_top".image)
    }
    
    private func loadData() {
        RapidApi.shared.getTwoUserInfo(para: ["putit": productId]).subscribe(onNext: { [weak self] obj in
            guard let json = obj.dictionaryObject?["trouble"] as? [String: Any], let list = json["munched"] as? [Any], let models = [RFTwoUserDataModel].deserialize(from: list)?.compactMap({ $0 }) else {
                return
            }
            self?.models = models
            self?.render()
        }, onError: { err in
            print(err)
        }).disposed(by: bag)
    }
    
    private func render() {
        let genderItem = models.first(where: { $0.hastily == RFKeyValue.gender.rawValue })
        if let genderItem = genderItem {
            self.genderItem.isMale = genderItem.theboys == "1"
        }
        let marryItem = models.first(where: { $0.hastily == RFKeyValue.marry.rawValue })
        if let marryItem = marryItem {
            self.relaItem.update(marryItem.snatch.first(where: { $0.dismay == marryItem.dismay })?.wasan ?? "")
        }
        let passport = models.first(where: { $0.hastily == RFKeyValue.passpord.rawValue })
        if let passport = passport {
            passportItem.update(passport.marking ?? "")
        }
        let address = models.first(where: { $0.hastily == RFKeyValue.address.rawValue })
        if let address = address {
            addressItem.update(address.upthe ?? "")
        }
    }
    
    @objc private func nextAction() {
        /*
         
         "watchful": "hvfhbgd",
         "smiledsuddenly": "53285697",
         "laughter": "1",
         "burst": "1",
         "inhis": "1",
         "neatly": "1"
         */
        // 参数不知道咋填
        RapidApi.shared.saveTwoUserInfo(para: ["aily": getRPFRandom(), "putit": productId, "hare": genderItem.isMale ? "1" : "0", "youand": addressItem.value]).subscribe(onNext: { [weak self] _ in
            self?.jumpNext()
        }, onError: { err in
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
    
    private func jumpNext() {
        if route == .personal_info {
            navigationController?.pushViewController(RFPInVC(route: .employment_info, productId: productId), animated: true)
        } else {
            navigationController?.pushViewController(RFBankCardListVC(orderId: nil, productId: productId), animated: true)
        }
    }
    
    private func getAddressCfgs() {
        RapidApi.shared.addressDetail(para: [:]).subscribe(onNext: { [weak self] obj in
            guard let json = obj.dictionaryObject, let trouble = json["trouble"] as? [String: Any], let army = trouble["army"] as? [Any], let models = [RFAddressDetail].deserialize(from: army)?.compactMap({ $0 }) else { return }
            guard let self = self else { return }
            let alert = RFAddressAlert(address: models)
            alert.show(on: self.view)
        }, onError: { err in
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
}
