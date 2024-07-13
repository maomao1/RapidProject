//
//  RapidOrderListCell.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/11.
//

import UIKit

class RapidOrderListCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setUpViews()
    }
    
    func setUpViews() {
        contentView.addSubview(containerView)
        contentView.addSubview(iconImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bottomImage)
        contentView.addSubview(detailBtn)
        contentView.addSubview(moneyContainerView)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(moneyValueLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateValueLabel)
        contentView.addSubview(soundImg)
        contentView.addSubview(soundLabel)
        
        containerView.snp.makeConstraints { make in
            make.left.equalTo(-40.rf)
            make.right.equalTo(-49.rf)
            make.top.bottom.equalTo(0)
        }
        
        detailBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(containerView.snp.right).offset(25.rf)
            make.size.equalTo(CGSize(width: 53.rf, height: 53.rf))
        }
        
        iconImage.snp.makeConstraints { make in
            make.left.equalTo(24.rf)
            make.top.equalTo(12.rf)
            make.size.equalTo(CGSize(width: 31.5.rf, height: 31.5.rf))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(8.rf)
            make.centerY.equalTo(iconImage)
            make.right.equalTo(containerView)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.left).offset(16.rf)
            make.top.equalTo(iconImage.snp.bottom).offset(24.rf)
            
        }
        
        moneyValueLabel.snp.makeConstraints { make in
            make.right.equalTo(detailBtn.snp.left).offset(-41.rf)
            make.centerY.equalTo(moneyLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(moneyLabel)
            make.top.equalTo(moneyLabel.snp.bottom).offset(20.rf)
        }
        
        dateValueLabel.snp.makeConstraints { make in
            make.right.equalTo(moneyValueLabel)
            make.centerY.equalTo(dateLabel)
        }
        
        moneyContainerView.snp.makeConstraints { make in
            make.left.equalTo(iconImage)
            make.right.equalTo(detailBtn.snp.left).offset(-25.rf)
            make.top.equalTo(moneyLabel.snp.top).offset(-12.rf)
            make.bottom.equalTo(dateLabel.snp.bottom).offset(20.rf)
        }
        
        bottomImage.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 16.5.rf, height: 33.5.rf))
        }
        
        soundLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.left).offset(24.rf)
            make.top.equalTo(moneyContainerView.snp.bottom).offset(10.5.rf)
            make.right.equalTo(moneyContainerView)
            make.bottom.equalTo(-10.5.rf)
        }
        
        soundImg.snp.makeConstraints { make in
            make.left.equalTo(iconImage)
            make.centerY.equalTo(soundLabel)
            make.size.equalTo(CGSize(width: 16.rf, height: 16.rf))
        }

    }
    
    func setContentCell(){
        self.iconImage.backgroundColor = .blue
        self.nameLabel.text = "product name"
        self.moneyLabel.text = "Tapperapperapp"
        self.moneyValueLabel.text = "₱50,000"
        self.dateLabel.text = "Repayment Date"
        self.dateValueLabel.text = "12-12-2024"
        self.soundLabel.text = "XXXXXXXXXXXXXXXXXXXX"
    }
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 24.rf
        return view
    }()
    
    fileprivate lazy var detailBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(.orderListDetailBtnIcon, for: .normal)
//        btn.layer.masksToBounds = true
//        btn.layer.cornerRadius = 18.rf
        return btn
    }()
    
    fileprivate lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 11.rf
        return image
    }()
    
    fileprivate lazy var bottomImage: UIImageView = {
        let image = UIImageView(image: .orderListBottomIcon)
        return image
    }()
    
    fileprivate lazy var soundImg: UIImageView = {
        let imageview = UIImageView.init(image: .orderListSoundIcon)
        return imageview
    }()
    
    fileprivate lazy var soundLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys10
        label.textColor = .c_111111
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys12
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var moneyContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .c_000000.withAlphaComponent(0.05)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.rf
        return view
    }()
    
    fileprivate lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys12
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var moneyValueLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys12
        label.textColor = .c_111111
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys12
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var dateValueLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys12
        label.textColor = .c_111111
        label.textAlignment = .right
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}