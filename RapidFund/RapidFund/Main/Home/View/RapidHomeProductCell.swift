//
//  RapidHomeProductCell.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/10.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class RapidHomeProductCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setUpViews()
    }
    
    func setUpViews(){
        
        contentView.addSubview(containerView)
        contentView.addSubview(productImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(soundBgView)
        contentView.addSubview(soundImg)
        contentView.addSubview(soundLabel)
        contentView.addSubview(applyBtn)
        contentView.addSubview(limitImg)
        
        containerView.snp.makeConstraints { make in
            make.left.equalTo(-40.rf)
            make.top.equalTo(10.rf)
            make.right.equalTo(-49.rf)
            make.bottom.equalTo(0)
        }
        
        productImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 54.rf, height: 54.rf))
            make.left.equalTo(16.rf)
            make.top.equalTo(containerView.snp.top).offset(10.rf)
        }
        
        applyBtn.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.size.equalTo(CGSize(width: 53.rf, height: 53.rf))
            make.right.equalTo(containerView.snp.right).offset(25.rf)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(productImage.snp.right).offset(12.rf)
            make.top.equalTo(productImage.snp.top).offset(5.rf)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(12.rf)
        }
        
        soundBgView.snp.makeConstraints { make in
            make.left.equalTo(productImage)
            make.bottom.equalTo(containerView).inset(12.rf)
            make.right.equalTo(applyBtn.snp.left).offset(-15.rf)
            make.height.equalTo(24.rf)
        }
        
        soundImg.snp.makeConstraints { make in
            make.centerY.equalTo(soundBgView)
            make.left.equalTo(soundBgView.snp.left).offset(8.rf)
            make.size.equalTo(CGSize(width: 14.rf, height: 14.rf))
        }
        
        soundLabel.snp.makeConstraints { make in
            make.centerY.equalTo(soundBgView)
            make.left.equalTo(soundImg.snp.right).offset(6.rf)
            make.right.equalTo(soundBgView)
        }
        
        limitImg.snp.makeConstraints { make in
            make.right.equalTo(containerView.snp.right).inset(20.rf)
            make.top.equalTo(containerView.snp.top).offset(-7.rf)
            
        }
        
    }
    
    func updateCellContent(model: RPFHomeProduct){
        self.productImage.sd_setImage(with: model.productLogo.url, placeholderImage: nil, options: .allowInvalidSSLCertificates)
        self.nameLabel.text = model.productName
        self.contentLabel.text = model.productDesc
        self.applyBtn.setTitle(model.buttonText, for: .normal)
        self.applyBtn.setTitle(model.buttonText, for: .selected)
//        self.applyBtn.backgroundColor = 
//        self.soundLabel.text = model.
        
    }
    
    fileprivate lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16.rf
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .lightGray
        return image
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys16
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys12
        label.textColor = .c_999999
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var soundBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .c_000000.withAlphaComponent(0.05)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.rf
        return view
    }()
    
    fileprivate lazy var limitImg: UIImageView = {
        let imageview = UIImageView.init(image: .homeLimitIcon)
        return imageview
    }()
    
    fileprivate lazy var soundImg: UIImageView = {
        let imageview = UIImageView.init(image: .homeSoundIcon)
        return imageview
    }()
    
    fileprivate lazy var soundLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys10
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 24.rf
        return view
    }()
    
    fileprivate lazy var applyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 18.rf
        btn.backgroundColor = .black
        return btn
    }()
    
    static func height() -> CGFloat {
        return 124.rf
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
