//
//  RFIDVerifyAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import UIKit
import RxSwift
import MBProgressHUD
import IQKeyboardManagerSwift

class RFIDVerifyItem: UIView {
    func updateValue(_ text:String?) {
        contentView.textLb.text = text
    }
    
    var value:String {
        return self.contentView.textLb.text ?? ""
    }
    
    init(_ title: String, placeholder: String? = nil, hiddenNext: Bool = false, isNumberKeyBoard: Bool = false) {
        super.init(frame: .zero)
        setup(placeholder: placeholder, hiddenNext: hiddenNext,isNumberKeyBoard: isNumberKeyBoard)
        
        titLb.text = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titLb = UILabel().textColor(0x111111.color).font(24.font)
    private let textF = UITextField()
    private lazy var contentView: (container: UIView, textLb: UITextField, btn: UIButton) = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.05)
        bgView.clipsCornerRadius(Float(10.rf))
        
//        let label = UITextField()
        textF.font = 14.font
        textF.textColor = .black
        textF.delegate = self
        let btn = UIButton(type: .custom)
        btn.setImage("info_item_next".image, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        bgView.addSubview(textF)
        bgView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(-24.rf)
        }
        textF.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        return (bgView, textF, btn)
    }()

    private func setup(placeholder: String?, hiddenNext: Bool, isNumberKeyBoard: Bool) {
        addSubview(titLb)
        if let placeholder = placeholder {
            contentView.textLb.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: 14.font, .foregroundColor: 0x999999.color])
        }
        textF.keyboardType = isNumberKeyBoard ? .numberPad : .asciiCapable
        
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
    var clickBlock:(()->Void)?
    @objc private func btnClick() {
        clickBlock?()
    }
    
    var canEditing:Bool = false
}

extension RFIDVerifyItem: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return canEditing
    }
}

class RFIDVerifyAlert: XYZAlertView {
    private let bag = DisposeBag()
    private let model:RFUploadResultModel
    init(data: RFUploadResultModel) {
        model = data
        super.init(frame: .zero)
        setup()
        nameItem.updateValue(data.wasan)
        nameItem.canEditing = true
        noItem.updateValue(data.fold)
        noItem.canEditing = true
        birItem.updateValue(data.toput)
        birItem.clickBlock = {
            guard let appDel = UIApplication.shared.delegate as? AppDelegate, let window = appDel.window else { return  }
            IQKeyboardManager.shared.resignFirstResponder()
            let alert = RFDateSelAlert()
            alert.updatePickerDefault(data.toput)
            alert.saveBlock = { [weak self] date in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                data.toput = formatter.string(from: date)
                self?.birItem.updateValue(data.toput)
            }
            alert.show(on: window)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let nameItem = RFIDVerifyItem("Full Name", placeholder: "Please input Full Name", hiddenNext: true)
    private let noItem = RFIDVerifyItem("ID NO.", placeholder: "Please input ID NO.", hiddenNext: true, isNumberKeyBoard: true)
    private let birItem = RFIDVerifyItem("Date of Birth", placeholder: "Please selected Date of Birth")
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
        nextimgV.addTapGesture { [weak self] in
            self?.saveAction()
        }
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
        self.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.8)
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
    
    var dismissBlock:(()->Void)?
    private func saveAction() {
        self.model.wasan = nameItem.value
        self.model.fold = noItem.value
        RapidApi.shared.saveIDInfoData(para: ["toput":model.toput ?? "", "fold":model.fold ?? "", "wasan":model.wasan ?? "",
                                              "dismay":"\(model.type)",
                                              "darkalmost":model.darkalmost ?? "",
                                              "licks":getRPFRandom()]).subscribe (onNext: { [weak self] _ in
            self?.dismissBlock?()
            self?.dismiss(withAnimation: true)
        },onError: { err in
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
}
