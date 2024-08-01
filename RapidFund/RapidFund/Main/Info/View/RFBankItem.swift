//
//  RFBankItem.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import UIKit
import IQKeyboardManagerSwift

class RFBankItem: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    private var iconStr:String?
    var canEditing = false
    var model: RFBankCfg.__MunchedModel? {
        didSet {
           
            iconImgV.sd_setImage(with: URL(string: iconStr ?? ""))
//            textLb.text = self.model?.upthe
            textLb.attributedPlaceholder = NSAttributedString(string: self.model?.hastily ?? "", attributes: [.font:14.font, .foregroundColor:0x999999.color])
            if model?.snatch.first?.toy.isEmpty == false {
                iconImgV.isHidden = false
            } else {
                iconImgV.isHidden = true
            }
           
            model?.snatch.forEach {   
                if $0.dismay == model?.upthe {
                    textLb.text = $0.wasan
                    iconImgV.sd_setImage(with: URL(string: $0.toy))
                    return
                }
            }
            
            
        }
    }
    
    var isHiddenIcon: Bool = false {
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let iconImgV = UIImageView()
    private let textLb = UITextField()
    private func setup() {
        self.clipsCornerRadius(Float(10.rf))
        self.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.05)
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
        nextBtn.contentHorizontalAlignment = .right
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16.rf)
            make.left.equalToSuperview()
        }
        self.snp.makeConstraints { make in
            make.width.equalTo(327.rf)
            make.height.equalTo(54.rf)
        }
    }
    
    @objc private func nextAction() {
        guard let list = model?.snatch.map({ $0.wasan }).compactMap({ $0 }) else {
            return
        }
        let alert = RFBankAlert(strings: list)
        alert.selectedBlock = { [weak self] index in
            guard let it = self?.model?.snatch[index] else { return }
            self?.textLb.text = it.wasan
            self?.iconStr = it.toy
            self?.iconImgV.sd_setImage(with: URL(string: it.toy))
            self?.model?.upthe = it.wasan
            self?.model?.dismay = it.dismay
        }
        let appDel = UIApplication.shared.delegate as! AppDelegate
        alert.show(on: appDel.window!)
        IQKeyboardManager.shared.resignFirstResponder()
    }
}

extension RFBankItem: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return canEditing
    }
}

class RFBankEditItem: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    var model: RFBankCfg.__MunchedModel? {
        didSet {
            guard let text = model?.hastily else { return }
            tf.attributedPlaceholder = NSAttributedString(string: text, attributes: [.font: 14.font, .foregroundColor: 0x999999.color])
            guard let name = model?.upthe else { return}
            tf.text = name
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var value: String {
        return tf.text ?? ""
    }

    private let tf = UITextField()
    private func setup() {
        self.snp.makeConstraints { make in
            make.width.equalTo(327.rf)
            make.height.equalTo(54.rf)
        }
        self.clipsCornerRadius(Float(10.rf))
        self.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.05)
        tf.font = 14.font
        tf.textColor = 0x111111.color
        addSubview(tf)
        tf.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(16.rf)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-100.rf)
        }
        
        let nextBtn = UIButton(type: .custom)
        nextBtn.setImage("bank_edit".image, for: .normal)
        nextBtn.contentHorizontalAlignment = .right
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16.rf)
            make.left.equalToSuperview()
        }
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tf, queue: .main) { [weak self] obj in
            self?.model?.upthe = self?.tf.text ?? ""
        }
    }
    
    @objc private func nextAction() {
        self.tf.becomeFirstResponder()
    }
}

class RFBankDesItem: UIView {
    func fill(_ text: String) {
        textLb.text = text
    }

    private let textLb = UILabel().font(12.font).textColor(0x151515.color).numberOfLines(0)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
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
            make.centerY.equalTo(self.snp.centerY).offset(-4.rf)
        }
    }
}
