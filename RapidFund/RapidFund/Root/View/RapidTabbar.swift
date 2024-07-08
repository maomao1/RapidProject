//
//  RapidTabbar.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit
import RxCocoa
import RxSwift


class RapidTabbar: UIView {
    
    let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    lazy var homeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.rapidHomeNormal, for: .normal)
        button.setImage(.rapidHomeSelected, for: .selected)
        button.contentHorizontalAlignment = .center
        return button
    }() 
    
    lazy var orderBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.rapidOrderNormal, for: .normal)
        button.setImage(.rapidOrderSelected, for: .selected)
        button.contentHorizontalAlignment = .center
        return button
    }() 
    
    lazy var mineBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.rapidMineNormal, for: .normal)
        button.setImage(.rapidMineSelected, for: .selected)
        button.contentHorizontalAlignment = .center
        return button
    }() 

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpViews() {
        self.backgroundColor = .white
        self.layer.mask = self.configRectCorner(corner: [.topLeft, .topRight], radii: CGSize(width: 40.rf, height: 40.rf))
    }    
   
}


