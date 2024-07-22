//
//  RFInfoItem.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import UIKit

class RFInfoItem: UIView {
    func update(_ des: String) {
        self.contentView.textLb.text = des
    }
    
    var value: String {
        return self.contentView.textLb.text ?? ""
    }

    var model: RFTwoUserDataModel? {
        didSet {
            if model?.marking == "boyswent2" {
//            if model?.hastily == "Email" || model?.hastily == "Address Details" || model?.hastily == "Company Name" || model?.hastily == "Company Phone Number" {
                if let a = model?.upthe, a.isEmpty == false {
                    update(a)
                }
                contentView.btn.isHidden = true
                canEditing = true
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: self.contentView.textLb, queue: .main) { [weak self] _ in
                    self?.model?.upthe = self?.contentView.textLb.text
                }
                return
            }
            guard let text = model?.snatch.first(where: { $0.dismay == model?.dismay ?? "" })?.wasan else {
                return
            }
            update(text)
        }
    }
    
    init(_ title: String, placeholder: String? = nil, hiddenNext: Bool = false) {
        super.init(frame: .zero)
        setup(placeholder: placeholder, hiddenNext: hiddenNext)
        
        titLb.text = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titLb = UILabel().textColor(0x111111.color).font(20.font)
    private lazy var contentView: (container: UIView, textLb: UITextField, btn: UIButton) = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.05)
        bgView.clipsCornerRadius(Float(10.rf))
        
        let label = UITextField()
        label.font = 14.font
        label.textColor = 0x999999.color
        label.delegate = self
        let btn = UIButton(type: .custom)
        btn.setImage("info_item_next".image, for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        bgView.addSubview(label)
        bgView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16.rf)
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-50.rf)
        }
        
        return (bgView, label, btn)
    }()

    private func setup(placeholder: String?, hiddenNext: Bool) {
        addSubview(titLb)
        if let placeholder = placeholder {
            contentView.textLb.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: 14.font, .foregroundColor: 0x999999.color])
        }
        
        contentView.btn.isHidden = hiddenNext
        addSubview(contentView.container)
        titLb.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        contentView.container.snp.makeConstraints { make in
            make.left.equalTo(titLb)
            make.top.equalTo(titLb.snp.bottom).offset(12.rf)
            make.height.equalTo(42.rf)
            make.right.bottom.equalToSuperview()
        }
    }

    var btnBlock: (() -> Void)?
    
    @objc private func btnClick() {
        btnBlock?()
    }
    
    private var canEditing = false
}

extension RFInfoItem: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return canEditing
    }
    
    
}

class RFGengerItem: UIView {
    var model: RFTwoUserDataModel?
    
    private class __GenderView: UIView {
        var selected: Bool = false {
            didSet {
                if isMale {
                    backgroundColor = selected == true ? UIColor(rgbHex: 0x3f7cf8, alpha: 0.1) : UIColor(rgbHex: 0x000000, alpha: 0.05)
                    layer.borderWidth = selected == true ? 0.5 : 0
                    layer.borderColor = 0x3f7cf8.color.cgColor
                    
                } else {
                    backgroundColor = selected == true ? UIColor(rgbHex: 0xff6a6a, alpha: 0.05) : UIColor(rgbHex: 0x000000, alpha: 0.05)
                    layer.borderWidth = selected == true ? 0.5 : 0
                    layer.borderColor = 0xff6a6a.color.cgColor
                }
            }
        }

        // nan
        var isMale = false
        
        init(_ img: UIImage?, text: String?) {
            super.init(frame: .zero)
            setup()
            iconImgV.image = img
            textLb.text = text
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private let iconImgV = UIImageView()
        private let textLb = UILabel().textColor(0x232323.color).font(14.font)
        func setup() {
            clipsCornerRadius(Float(10.rf))
            backgroundColor = UIColor(rgbHex: 0x3f7cf8, alpha: 0.1)
            layer.borderWidth = 0.5
            layer.borderColor = 0x3f7cf8.color.cgColor
            addSubview(textLb)
            addSubview(iconImgV)
            iconImgV.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(16.rf)
            }
            
            textLb.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(iconImgV.snp.right).offset(25.rf)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isMale: Bool = false {
        didSet {
            maleItem.selected = isMale
            femaleItem.selected = !isMale
        }
    }
    
    private let titLb = UILabel().textColor(0x111111.color).font(20.font).text("Gender")
    private let femaleItem
        = __GenderView("info_female".image, text: "Miss.")
    
    private let maleItem
        = __GenderView("info_male".image, text: "Mr.")
    
    private func setup() {
        addSubview(titLb)
        titLb.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        maleItem.isMale = true
        femaleItem.isMale = false
        maleItem.selected = true
        femaleItem.selected = false
        let stackView = UIStackView(arrangedSubviews: [maleItem, femaleItem])
        stackView.spacing = 12.5.rf
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(42.rf)
            make.top.equalTo(titLb.snp.bottom).offset(12.rf)
        }
        
        maleItem.addTapGesture { [weak self] in
            guard let self = self else {
                return
            }
            self.genderClick(self.maleItem)
        }
        femaleItem.addTapGesture { [weak self] in
            guard let self = self else {
                return
            }
            self.genderClick(self.femaleItem)
        }
    }
    
    private func genderClick(_ item: __GenderView) {
        guard item.selected == false else {
            return
        }
        item.selected = true
        if item == femaleItem {
            maleItem.selected = false
            model?.theboys = "0"
        } else {
            femaleItem.selected = false
            model?.theboys = "1"
        }
    }
}
