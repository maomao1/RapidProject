//
//  UIViewExtension.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit

extension UIView {
   
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        backgroundColor = color
    }
    
    func configRectCorner(corner: UIRectCorner, radii: CGSize) -> CALayer {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: radii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.strokeColor = UIColor.white.cgColor
        return maskLayer
    }
}
