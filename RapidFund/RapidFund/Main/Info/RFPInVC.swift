//
//  RFPInVC.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import UIKit

enum RFRoute {
    case personal_info
    case employment_info
}

class RFPInVC: RapidBaseViewController {
    private var model:RFTwoUserDataModel?
    private let route:RFRoute
    init(route: RFRoute) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }
    
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
    private let passportItem = RFInfoItem("Passport",placeholder: "12-12-2024")
    private let addressItem = RFInfoItem("Address",placeholder: "Address")
    private let phoneItem = RFInfoItem("Phone Number",placeholder: "1234567", hiddenNext: true)
    private let inomeItem = RFInfoItem("Monthly Income",placeholder: "aaaaa")
    
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
        
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .vertical, colors: [0xE5DEFA.color,0xffffff.color]))
        bgView.clipsCornerRadius(Float(24.rf))
        bgView.isUserInteractionEnabled = true
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.top.equalTo(bgImgV.snp.bottom).offset(-40.rf)
        }
        
        let stackViews:[UIView]
        if route == .personal_info {
            stackViews = [genderItem, relaItem, passportItem, addressItem]
        } else {
            stackViews = [phoneItem,inomeItem]
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
    }
    
    private func getResourceConfig()->(UIImage?, UIImage?) {
        if route == .personal_info {
            return ("info_bg".image,"info_top".image)
        }
        
        return ("em_in_bg".image,"em_in_top".image
        )
    }
    
    
    private func loadData() {
        RapidApi.shared.getTwoUserInfo(para: ["putit":"putit"]).subscribe (onNext: { [weak self] obj in
            guard let json = obj.dictionaryObject?["trouble"] as? [String:Any], let list = json["munched"] as? [Any], let models = [RFTwoUserDataModel].deserialize(from: list)?.compactMap({ $0 }) else {
                return
            }
            guard let m = models.first else {
                return
            }
            self?.render(m)
        },onError:{ err in
            print(err)
        }).disposed(by: bag)
        
        
    }
    
    private func render(_ item:RFTwoUserDataModel) {
        self.model = item
        if item.theboys == "1" {
            genderItem
        }
        
        
    }
    
    @objc private func nextAction() {
        navigationController?.pushViewController(RFPInVC(route: .employment_info), animated: true)
    }
}
