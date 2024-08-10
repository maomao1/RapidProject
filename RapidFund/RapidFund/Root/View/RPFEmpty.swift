//
//  RPFEmpty.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/8/8.
//

import UIKit
import LYEmptyView

class RPFEmpty: LYEmptyView {

    static func emptyDiyView(title: String,
                             detail: String = "",
                             image: UIImage? = nil,
                             titleColor: UIColor? = .white,
                             detailColor: UIColor? = .white,
                             titleFont: UIFont = .f_lightSys16,
                             detailFont: UIFont = .f_lightSys16) -> LYEmptyView? {
      
        let empty = LYEmptyView.empty(with: image ?? UIImage(), titleStr: title, detailStr: detail)
        empty?.titleLabFont = titleFont
        empty?.titleLabTextColor = titleColor
        empty?.detailLabTextColor =  detailColor
        empty?.detailLabFont = detailFont
        empty?.contentViewOffset = -60.rf
        return empty
    }
    
    
    override func prepare() {
        super.prepare()
        emptyViewIsCompleteCoverSuperView = true
        subViewMargin = 15.0
    }
}
