//
//  RFBankCardListCell.swift
//  RapidFund
//
//  Created by C on 2024/7/18.
//

import UIKit

class RFBankCardListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        let bgView = UIView()
        bgView.clipsCornerRadius(Float(19.rf))
        bgView.backgroundColor = UIColor(rgbHex: 0xdcd1ff, alpha: 0.3)
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalTo(59.rf)
            make.right.equalTo(-20.rf)
            make.top.equalTo(20.rf)
            make.bottom.equalTo(4.rf)
        }
        
        contentView.addSubview(cardBgView)
        cardBgView.snp.makeConstraints { make in
            make.width.equalTo(296.rf)
            make.height.equalTo(171.rf)
            make.left.equalTo(24.rf)
            make.top.equalTo(16.rf)
        }
        cardBgView.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { make in
            make.width.height.equalTo(30.rf)
            make.left.equalTo(20.rf)
            make.top.equalTo(36.rf)
        }
        cardBgView.addSubview(cardCategoryLb)
        cardCategoryLb.snp.makeConstraints { make in
            make.centerY.equalTo(iconImgView)
            make.left.equalTo(iconImgView.snp.right).offset(11.rf)
        }
        cardBgView.addSubview(cardNoLb)
        cardNoLb.snp.makeConstraints { make in
            make.left.equalTo(20.rf)
            make.top.equalTo(iconImgView.snp.bottom).offset(20.rf)
        }
        cardBgView.addSubview(accountLb)
        accountLb.snp.makeConstraints { make in
            make.bottom.equalTo(-18.rf)
            make.left.equalTo(20.rf)
        }
        selBtn.setBackgroundImage("bankcard_unsel".image, for: .normal)
        selBtn.setBackgroundImage("bankcard_sel".image, for: .selected)
        contentView.addSubview(selBtn)
        selBtn.isUserInteractionEnabled = false
        selBtn.snp.makeConstraints { make in
            make.left.equalTo(self.cardBgView.snp.right).offset(5.5.rf)
            make.centerY.equalTo(cardBgView)
            make.width.height.equalTo(21.rf)
        }
    }
    
    
    
    private let cardBgView = UIImageView()
    private let iconImgView = UIImageView()
    private let cardCategoryLb = UILabel().font(12.font).textColor(0x000000.color)
    private let cardNoLb = UILabel().font(20.font).textColor(0x000000.color)
    private let accountLb = UILabel().font(12.font).textColor(0x000000.color).text("Account")
    private let selBtn = UIButton(type: .custom)
    
    func fill(_ data: RFBankListModel.__BankInfo) {
        cardBgView.image = data.attempt == 1 ? "bankcard_bg1".image : "bankcard_bg2".image
        iconImgView.sd_setImage(with: URL(string: data.toy))
        cardNoLb.text = data.half
        cardCategoryLb.text = data.eager
//        accountLb.text = data.half
        bankSelected = data.isSelected
    }
    
//    func handleAccount(text: String) -> String {
//        var account = ""
//        var first = ""
//        var middle = ""
//        var last = ""
//        if text.count > 4 {
//            first = String(text.prefix(4))
//        }
//        if text.count > 8 {
//            middle = text.su
//        }
//        
//        
//        
//    }
    
    var bankSelected:Bool = false {
        didSet {
            selBtn.isSelected = bankSelected
        }
    }
}
