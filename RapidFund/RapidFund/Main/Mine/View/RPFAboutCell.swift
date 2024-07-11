//
//  RPFAboutCell.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/11.
//

import UIKit

class RPFAboutCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setUpViews()
    }
    
    func setUpViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(12.rf)
            make.left.equalTo(RapidMetrics.LeftRightMargin)
            make.right.equalTo(-RapidMetrics.LeftRightMargin)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(18.rf)
            make.right.equalTo(-RapidMetrics.LeftRightMargin)
            make.bottom.equalTo(-20.rf)
        }
    }
    
    func setCellContent() {
        self.nameLabel.text = "Rapid Fund"
        self.contentLabel.text = "NO.DF726638479"
    }
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys12
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys16
        label.textColor = .c_111111
        label.textAlignment = .left
        label.numberOfLines = 0
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
