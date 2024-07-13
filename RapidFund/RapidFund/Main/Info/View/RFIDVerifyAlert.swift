//
//  RFIDVerifyAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import UIKit

class RFIDVerifyItem: UIView {
    init(_ title: String, placeholder: String? = nil, hiddenNext: Bool = false) {
        super.init(frame: .zero)
        setup(placeholder: placeholder, hiddenNext: hiddenNext)
        
        titLb.text = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titLb = UILabel().textColor(0x111111.color).font(24.font)
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
            make.right.equalTo(-24.rf)
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.centerY.equalToSuperview()
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
            make.height.equalTo(32.rf)
        }
        
        contentView.container.snp.makeConstraints { make in
            make.left.equalTo(titLb)
            make.top.equalTo(titLb.snp.bottom).offset(12.rf)
            make.height.equalTo(42.rf)
            make.right.bottom.equalToSuperview()
        }
    }

    @objc private func btnClick() {}
}

extension RFIDVerifyItem: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

class RFIDVerifyAlert: XYZAlertView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let nameItem = RFIDVerifyItem("Full Name", placeholder: "Santos Jose", hiddenNext: true)
    private let noItem = RFIDVerifyItem("ID NO.", placeholder: "0028-1222980-2", hiddenNext: true)
    private let birItem = RFIDVerifyItem("Date of Birth", placeholder: "1998-01-28")
    private func setup() {
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .leftTopToRightBottom, colors: [0xe5defa.color, 0xffffff.color]))
        containerAlertViewMaxSize = CGSize(width: kScreenWidth, height: 568.rf)
        containerAlertView.addSubview(bgView)
        containerAlertViewRoundValue = 24.rf
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(568.rf)
        }
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage("home_nav_black_back".image, for: .normal)
        backBtn.clipsCornerRadius(Float(16.rf))
        backBtn.backgroundColor = UIColor(rgbHex: 0x232323,alpha: 0.1)
        backBtn.layer.shadowColor = 0xFFFFFF.color.cgColor
        backBtn.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        backBtn.layer.shadowOpacity = 0.5
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        containerAlertView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(50.rf)
            make.top.equalTo(55.rf)
            make.left.equalTo(25.rf)
        }
        
        let titleLb = UILabel().font(24.font).textColor(0x111111.color).text("Identity verification")
        containerAlertView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn)
            make.left.equalTo(backBtn.snp.right).offset(12.rf)
        }
        
        let stackView = UIStackView(arrangedSubviews: [nameItem, noItem, birItem])
        stackView.axis = .vertical
        stackView.spacing = 16.rf
        stackView.distribution = .fillProportionally
        containerAlertView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.top.equalTo(backBtn.snp.bottom).offset(32.rf)
        }
        
        let nextimgV = UIImageView(image: "face_next_bg".image)
        containerAlertView.addSubview(nextimgV)
        nextimgV.snp.makeConstraints { make in
            make.width.equalTo(294.rf)
            make.height.equalTo(60.rf)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-48.rf)
        }
        
        let nextLb = UILabel().font(16.font).text("Confirm").textColor(0xffffff.color)
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
        let desLb = UILabel().text("*Please confirm relevant information").font(12.font).textColor(0xff0000.color)
        containerAlertView.addSubview(desLb)
        desLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20.rf)
        }
    }

    override func show(on view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerAlertView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(568.rf)
        }
        containerAlertView.transform = CGAffineTransform(translationX: 0, y: -568.rf)
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = .identity
        }
    }

    override func dismiss(withAnimation animation: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = CGAffineTransform(translationX: 0, y: -568.rf)
        } completion: { _ in
            super.dismiss(withAnimation: false)
        }
    }
    
    @objc private func backAction() {
        self.dismiss(withAnimation: true)
    }
}