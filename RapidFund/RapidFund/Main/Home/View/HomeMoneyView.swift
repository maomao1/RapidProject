//
//  HomeMoneyView.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/10.
//

import UIKit
import SnapKit

class HomeMoneyView: UIView {

//    var widthConstraint:Constraint?
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
            .withFont(.f_lightSys11)
            .withTextColor(.c_999999)
            .withTextAlignment(.center)
            .withNumberOfLines(0)
            .withText("your Maximum Loan Am")
        return label
    }()
    
    fileprivate lazy var moneyLabel: UILabel = {
        let label = UILabel()
            .withFont(.f_boldSys32)
            .withTextColor(.c_232323)
            .withTextAlignment(.center)
            .withNumberOfLines(0)
            .withText("₱50,000")
        return label
    }()
    
    fileprivate lazy var progressLabel: UILabel = {
        let label = UILabel()
            .withFont(.f_lightSys10)
            .withTextColor(.c_999999)
            .withTextAlignment(.right)
            .withText("50%")

        return label
    }()
    
    fileprivate lazy var progressBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .c_FF8000
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4.rf
        return view
    }()
    
    fileprivate lazy var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .c_FFFFFF.withAlphaComponent(0.67)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4.rf
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 24.rf
        
        self.addSubview(titleLabel)
        self.addSubview(moneyLabel)
        self.addSubview(progressLabel)
        self.addSubview(progressBgView)
        self.addSubview(progressView)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(20.rf)
        }
        moneyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(9.5.rf)
        }
        progressBgView.snp.makeConstraints { make in
            make.right.equalTo(-17.5.rf)
            make.top.equalTo(moneyLabel.snp.bottom).offset(12.5.rf)
            make.height.equalTo(7.5.rf)
            make.left.equalTo(43.rf)
        }
        progressView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(progressBgView)
//            self.widthConstraint = 
            make.width.equalTo(progressBgView).multipliedBy(0.5)
            make.bottom.equalTo(-20.rf)
//                .constraint
        }
        
        progressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(progressBgView)
            make.right.equalTo(progressBgView.snp.left).offset(-2.rc)
        }
//        progressView.snp.updateConstraints { make in
//            make.width.equalTo(progressBgView).multipliedBy(0.5)
//        }
    }
    
    static func height() -> CGFloat {
        return 125.rf
    }
}



class HomeMoneyRateView: UIView {
    
    fileprivate lazy var daysLabel: UILabel = {
        let label = UILabel()
            .withFont(.f_lightSys11)
            .withTextColor(.c_232323)
            .withTextAlignment(.left)
            .withText("eweewewlsljoi")
//            .withNumberOfLines(0)
        return label
    }()
    
    fileprivate lazy var rateLabel: UILabel = {
        let label = UILabel()
            .withFont(.f_lightSys11)
            .withTextColor(.c_232323)
            .withTextAlignment(.left)
            .withText("eweewewlsljoi")
//            .withNumberOfLines(0)
        return label
    }()
    
    fileprivate lazy var dayValueLabel: UILabel = {
        let label = UILabel()
            .withFont(.f_lightSys11)
            .withTextColor(.c_232323)
            .withTextAlignment(.right)
            .withText("0.000")
//            .withNumberOfLines(0)
        return label
    }()
    
    fileprivate lazy var rateValueLabel: UILabel = {
        let label = UILabel()
            .withFont(.f_lightSys11)
            .withTextColor(.c_232323)
            .withTextAlignment(.right)
            .withText("0.000")
//            .withBackgroundColor(.cle)
//            .withNumberOfLines(0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        backgroundColor = .white.withAlphaComponent(0.81)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16.rf
        
        self.addSubview(daysLabel)
        self.addSubview(dayValueLabel)
        self.addSubview(rateLabel)
        self.addSubview(rateValueLabel)
        
        daysLabel.snp.makeConstraints { make in
            make.top.equalTo(12.5.rf)
            make.left.equalTo(10.5.rf)
        }
        dayValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(daysLabel)
            make.right.equalTo(-14.rf)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.left.equalTo(daysLabel)
            make.top.equalTo(daysLabel.snp.bottom).offset(15.rf)
            make.bottom.equalTo(-9.5.rf)
        }
        
        rateValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rateLabel)
            make.right.equalTo(-14.rf)
        }
    }
    
    static func height() -> CGFloat {
        return 59.rf
    }
}