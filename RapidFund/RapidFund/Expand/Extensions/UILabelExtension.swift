//
//  UILabelExtension.swift
//  YDYCloudDoctor
//
//  Created by xzr on 2021/6/28.
//

import UIKit

extension UILabel {
    func addStrikeThrough(width: CGFloat = 1) {
        let attrText = NSMutableAttributedString(attributedString: attributedText!)
        attrText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: width, range: NSRange(location: 0, length: attrText.length))
        attributedText = attrText
    }
    
    func withTextColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    func withText(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    func withAttributedText(_ attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }
 
    func withFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func withNumberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    func withTextAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    func withMinimumScaleFactor(_ minimumScaleFactor: CGFloat) -> Self {
        adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = minimumScaleFactor
        return self
    }
    
    func withBackgroundColor(_ backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    func underline(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}

