//
//  RFNextBtn.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import UIKit

class RFNextBtn: UIView {

    var bgImg:UIImage? {
        didSet {
            nextimgV.image = bgImg
        }
    }
    
    var text:String? {
        didSet {
            nextLb.text = text
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nextimgV = UIImageView(image: "face_next_bg".image)
    private let nextLb = UILabel().font(16.font).text("Next").textColor(0xffffff.color)
    private func setup() {
        
        self.addSubview(nextimgV)
        nextimgV.snp.makeConstraints { make in
            make.width.equalTo(294.rf)
            make.height.equalTo(60.rf)
            make.edges.equalToSuperview()
        }
        
        
        nextimgV.addSubview(nextLb)
        nextLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(35.rf)
        }
        
        let next_arr = UIImageView(image: "face_next".image)
        nextimgV.addSubview(next_arr)
        next_arr.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-32.rf)
        }
    }
}
