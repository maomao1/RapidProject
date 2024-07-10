//
//  RapidMineMenuCell.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/9.
//

import UIKit

class RapidMineMenuCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setUpViews()
    }
    
    func setUpViews() {
        contentView.addSubview(iconImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rightArrow)
        
        iconImage.snp.makeConstraints { make in
            make.left.equalTo(RapidMetrics.LeftRightMargin)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 36.rf, height: 36.rf))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(20.rf)
            make.centerY.equalToSuperview()
        }
        
        rightArrow.snp.makeConstraints { make in
            make.right.equalTo(-30.rf)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 34.rf, height: 34.rf))
        }
    }
    
    func setUpCell(type: RapidMineViewModel.MenuType){
        self.iconImage.image = type.iconImage
        self.nameLabel.text = type.titleName
    }
    
    
    fileprivate lazy var iconImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    fileprivate lazy var rightArrow: UIImageView = {
        let imageview = UIImageView.init(image: .mineCellArrow)
        return imageview
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys16
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    static func height() -> CGFloat {
        return 68.rf
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
