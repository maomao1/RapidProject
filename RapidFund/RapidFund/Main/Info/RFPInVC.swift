//
//  RFPInVC.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import UIKit

class RFPInVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private let genderItem = RFGengerItem()
    private let relaItem = RFInfoItem("Marriage Status")
    private let passportItem = RFInfoItem("Passport")
    private let addressItem = RFInfoItem("Address")
    
    private func setup() {
        let bottV = UIImageView(image: "info_bg".image)
        view.addSubview(bottV)
        bottV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let bgImgV = UIImageView(image: "info_top".image)
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(303.rf)
        }
        
        let bgView = UIView()
        bgView.clipsCornerRadius(Float(24.rf))
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.top.equalTo(bgImgV.snp.bottom).offset(-40.rf)
        }
        
        let stackView = UIStackView(arrangedSubviews: [genderItem,relaItem,passportItem,addressItem])
        stackView.spacing = 24.rf
        stackView.axis = .vertical
        stackView.distribution = .fill
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
        
    }
    
    @objc private func nextAction() {
        
    }
}
