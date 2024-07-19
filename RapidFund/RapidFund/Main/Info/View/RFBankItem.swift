//
//  RFBankItem.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import UIKit

class RFBankItem: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    var canEditing = false
    var model:RFBankCfg.__MunchedModel?
    var snatch:RFBankCfg.__SnatchItem?
    func fill(_ data:RFBankCfg.__SnatchItem) {
        self.snatch = data
        iconImgV.sd_setImage(with: URL(string: data.toy))
        textLb.text = data.wasan
    }
    
    var isHiddenIcon:Bool = false {
        didSet {
            if isHiddenIcon {
                iconImgV.removeFromSuperview()
                
                textLb.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(16.rf)   
                }
                
            }
            
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let iconImgV = UIImageView()
    let textLb = UITextField()
    private func setup() {
        self.clipsCornerRadius(Float(10.rf))
        self.backgroundColor = UIColor(rgbHex: 0x000000,alpha: 0.05)
        textLb.delegate = self
        textLb.font = 14.font
        textLb.textColor = 0x111111.color
        addSubview(iconImgV)
        addSubview(textLb)
        iconImgV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(16.rf)
            make.width.height.equalTo(30.rf)
        }
        textLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImgV.snp.right).offset(12.rf)
        }
        
        let nextBtn = UIButton(type: .custom)
        nextBtn.setImage("info_item_next".image, for: .normal)
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16.rf)
        }
        self.snp.makeConstraints { make in
            make.width.equalTo(327.rf)
            make.height.equalTo(54.rf)
        }
    }
    
    var block:(()->Void)?
    
    @objc private func nextAction() {
        self.block?()
    }
}

extension RFBankItem:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return canEditing
    }
    
}

class RFBankEditItem:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var value:String {
        return tf.text ?? ""
    }
    private let tf = UITextField()
    private func setup() {
        self.snp.makeConstraints { make in
            make.width.equalTo(327.rf)
            make.height.equalTo(54.rf)
        }
        self.clipsCornerRadius(Float(10.rf))
        self.backgroundColor = UIColor(rgbHex: 0x000000,alpha: 0.05)
        tf.font = 14.font
            tf.textColor = 0x111111.color
        addSubview(tf)
        tf.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(16.rf)
            
        }
        
        
        let nextBtn = UIButton(type: .custom)
        nextBtn.setImage("bank_edit".image, for: .normal)
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16.rf)
        }
    }
    
    func fill(_ text:String?) {
        guard let text = text else { return  }
        tf.attributedPlaceholder = NSAttributedString(string: text, attributes: [.font:14.font,.foregroundColor:0x111111.color])
    }
    
    @objc private func nextAction() {
        
    }
}

class RFBankDesItem:UIView {
    
    func fill(_ text:String) {
        textLb.text = text
    }
    private let textLb = UILabel().font(12.font).textColor(0x151515.color).numberOfLines(0)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(54.rf)
        }
        
        let imgView = UIImageView(image: "bank_des_bg".image)
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(345.rf)
        }
        
        imgView.addSubview(textLb)
        textLb.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.right.equalTo(-5.rf)
            make.centerY.equalToSuperview()
        }
    }
    
}
