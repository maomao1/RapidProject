//
//  RFPRCIDView.swift
//  RapidFund
//
//  Created by C on 2024/7/10.
//

import UIKit

class RFPRCIDView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let textLb = UILabel().font(14.font).textColor(0x000000.color)
    private func setup() {
        let bgImgV = UIImageView(image: "PRCID_bg".image)
        addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(327.rf)
            make.height.equalTo(49.rf)
        }
        addSubview(textLb)
        textLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(24.rf)
        }

        let btn = UIButton(type: .custom)
        btn.setImage("PRCID_Next".image, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-18.rf)
            make.left.equalToSuperview()
        }
    }

    func fill(_ text:String?) {
        textLb.text = text
    }
    var block:(()->Void)?
    @objc private func btnClick() {
        self.block?()
    }
    var value:String {
        return textLb.text ?? ""
    }
}
