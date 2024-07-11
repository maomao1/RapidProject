//
//  RFFlowItem.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import UIKit

class RFFlowItem: UIView {
    private let bgImg: UIImage?
    private let icon: UIImage?
    private let text: String?
    init(bgImg: UIImage?, icon: UIImage?, text: String?) {
        self.bgImg = bgImg
        self.icon = icon
        self.text = text
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let bgImgV = UIImageView()
    private let iconImgV = UIImageView()
    private let textLb = UILabel().textColor(0x111111.color).font(12.font)
    private func setup() {
        addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(36.rf)
            make.top.equalTo(30.rf)
        }
        addSubview(textLb)
        textLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgV.snp.bottom).offset(14.rf)
        }
        
        bgImgV.image = bgImg
        iconImgV.image = icon
        textLb.text = text
    }
}
