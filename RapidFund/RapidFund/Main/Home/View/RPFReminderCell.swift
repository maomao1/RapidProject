//
//  RPFReminderCell.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/25.
//

import UIKit
import FSPagerView
class RPFReminderCell: FSPagerViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        contentView.addSubview(remindImg)
        contentView.addSubview(remindText)
        
        remindImg.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(30.rf)
            make.height.equalTo(58.rf)
        }
        
        remindText.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(remindImg.snp.left).offset(24.rf)
            make.right.equalTo(remindImg.snp.right).offset(-72.rf)
            make.height.equalTo(remindImg)
        }
    }
    
    fileprivate lazy var remindImg: UIImageView = {
        let image = UIImageView()
        image.image = .homeReminderImg
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .clear
        return image
    }()
    
    fileprivate lazy var remindText: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys10
        label.textColor = .c_151515
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    func setContent(model: RPFHomeReminder) {
        self.remindText.text = model.message
        
    }
    
    
}
