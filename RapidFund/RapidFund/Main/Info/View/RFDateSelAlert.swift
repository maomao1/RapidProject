//
//  RFDateSelAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import UIKit

class RFDateSelAlert: XYZAlertView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let datePicker = UIDatePicker()
    private func setup() {
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .leftTopToRightBottom,colors: [0xE5DEFA.color,0xFFFFFF.color]))
        containerAlertViewMaxSize = CGSize(width: kScreenWidth, height: 381.rf)
        containerAlertView.addSubview(bgView)
        containerAlertViewRoundValue = 24.rf
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(381.rf)
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
        
        let titleLb = UILabel().font(24.font).textColor(0x111111.color).text("Date Selection")
        containerAlertView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn)
            make.left.equalTo(backBtn.snp.right).offset(12.rf)
        }
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setImage("date_sel_conf".image, for: .normal)
        rightBtn.clipsCornerRadius(Float(16.rf))
        rightBtn.backgroundColor = UIColor(rgbHex: 0x232323,alpha: 0.1)
        rightBtn.layer.shadowColor = 0xFFFFFF.color.cgColor
        rightBtn.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        rightBtn.layer.shadowOpacity = 0.5
        rightBtn.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        containerAlertView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { make in
            make.width.height.equalTo(50.rf)
            make.top.equalTo(55.rf)
            make.right.equalTo(-25.rf)
        }
        
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.calendar = Calendar.gregorian
        datePicker.datePickerMode = .date
        
        datePicker.minimumDate = Date(timeIntervalSince1970: TimeInterval(-946_800_000))
        datePicker.maximumDate = Date()
        containerAlertView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.bottom.equalTo(-32.rf)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(212.rf)
        }
    }
    
    @objc private func backAction() {
        dismiss(withAnimation: true)
    }
    
    @objc private func rightAction() {
        
    }
    
    override func show(on view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerAlertView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(381.rf)
        }
        containerAlertView.transform = CGAffineTransform(translationX: 0, y: 381.rf)
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = .identity
        }
        
    }
    override func dismiss(withAnimation animation: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = CGAffineTransform(translationX: 0, y: 381.rf)
        } completion: { _ in
            super.dismiss(withAnimation: false)
        }
    }
}



