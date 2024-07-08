//
//  StringExtension.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit
import Alamofire

extension String {
    
    var url: URL? {
        return URL(string: self)
    }
    
    var localUrl: URL? {
        return URL(fileURLWithPath: self)
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    //
    func width(font: UIFont) -> CGFloat {
        let boundingBox = self.boundingRect(with: CGSize.zero,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.width)
    }
    
    func width(font: UIFont, paraStyle: NSMutableParagraphStyle? = nil) -> CGFloat {
        var atts: [NSAttributedString.Key : Any] = [.font: font]
        if let style = paraStyle {
            atts[.paragraphStyle] = style
        }
        let boundingBox = self.boundingRect(with: CGSize.zero,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: atts,
                                            context: nil)
        return ceil(boundingBox.width)
    }
    
    //
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont, paraStyle: NSMutableParagraphStyle? = nil) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        var atts: [NSAttributedString.Key : Any] = [.font: font]
        if let style = paraStyle {
            atts[.paragraphStyle] = style
        }
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: atts,
            context: nil)
        return ceil(boundingBox.height)
    }
    
    func transformToAttributedText(color: UIColor?, font: UIFont, lineSpacing: CGFloat? = nil, alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> NSMutableAttributedString {
        guard let c = color else { return NSMutableAttributedString() }
        var atts: [NSAttributedString.Key : Any] = [.font: font,
                                                    .foregroundColor: c]
        let style = NSMutableParagraphStyle()
        if let spacing = lineSpacing {
            style.lineSpacing = spacing
            style.alignment = alignment
        }
        style.lineBreakMode = lineBreakMode
        atts[NSAttributedString.Key.paragraphStyle] = style
        return NSMutableAttributedString(string: self, attributes: atts)
    }
}

//url拼接参数
extension String {
    mutating func urlAddCompnentForValue(with key: String, value: String) {
        //先判断链接是否带？
        if self.contains("?") {
            //?号是否在最后一个字符
            if self.last == "?" {
                self += "\(key)=\(value)"
            } else {
                //最后一个字符是否是&
                if self.last == "&" {
                    self += "\(key)=\(value)"
                } else {
                    self += "&\(key)=\(value)"
                }
            }
        } else {
            //不带问号
            self += "?\(key)=\(value)"
        }
    }
    
    
    
    
    //
//    var isValiadStr: Bool {
//        let regex = "[a-zA-Z\\u4E00-\\u9FA5\\u0030-\\u0039]+"
//        let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
//        return predicate.evaluate(with: self)
//    }
}

extension Parameters {
   
    func compentUrl() -> String {
        var url = "?"
        self.forEach { (key,value) in
            url.urlAddCompnentForValue(with: key, value: value as! String)
        }
        return url
    }
}
