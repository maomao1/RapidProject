//
//  RFFlowItem.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import UIKit

class RFFlowItem: UIView {
    private let bgImg: UIImage?
    private let icon: String?
    private let text: String?
    private var isFinish: Bool = false
    init(bgImg: UIImage?, icon: String?, text: String?, isFinish: Bool = false) {
        self.bgImg = bgImg
        self.icon = icon
        self.text = text
        self.isFinish = isFinish
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
    private let finishImg = UIImageView(image: "flow_item_finish".image)
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
        
        addSubview(finishImg)
        finishImg.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 50.rf, height: 50.rf))
        }
        finishImg.isHidden = !isFinish
        bgImgV.image = isFinish ? "flow_item_bg1".image : "flow_item_bg2".image
        iconImgV.sd_setImage(with: URL(string: self.icon ?? ""))
        textLb.text = text
    }
}
