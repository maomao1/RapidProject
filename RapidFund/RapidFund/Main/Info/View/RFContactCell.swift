//
//  RFContactCell.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import UIKit
import ContactsUI

class RFContactCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLb = UILabel().font(20.font).textColor(0x111111.color)
    private var lb1:UITextField!
    private var lb2:UITextField!
    private var btn1:UIButton!
    private var btn2:UIButton!
    
    private func setup() {
        self.backgroundColor = .clear
        let bgImgV = UIImageView(image: UIImage.image(gradientDirection: .leftTopToRightBottom, colors: [0xE5DEFA.color,0xFFFFFF.color]))
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.clipsCornerRadius(Float(24.rf))
        contentView.addSubview(titleLb)
        let items = createSubItem(text: "Ralationship", img: "contact_next".image)
        
        let items2 = createSubItem(text: "Ralationship", img: "contact".image)
        lb1 = items.1
        btn1 = items.2
        lb2 = items2.1
        btn2 = items2.2
        contentView.addSubview(items.0)
        contentView.addSubview(items2.0)
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(20.rf)
            make.left.equalTo(16.rf)
            make.height.equalTo(20.rf)
        }
        items.0.snp.makeConstraints { make in
            make.left.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(12.rf)
            make.right.equalTo(-12.rf)
            make.height.equalTo(42.rf)
        }
        items2.0.snp.makeConstraints { make in
            make.left.equalTo(titleLb)
            make.top.equalTo(items.0.snp.bottom).offset(12.rf)
            make.right.equalTo(-12.rf)
            make.height.equalTo(42.rf)
        }
    }
    
    private func createSubItem(text: String, img: UIImage?) -> (UIView, UITextField, UIButton) {
        let view = UIView()
        view.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.05)
        view.clipsCornerRadius(Float(10.rf))
        let tf = UITextField()
        tf.textColor = 0x999999.color
        tf.font = 14.font
        tf.text = text
        view.addSubview(tf)
        tf.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(24.rf)
        }
        
        let btn = UIButton(type: .custom)
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16.rf)
        }
        return (view, tf, btn)
    }
    
    @objc private func btnClick(sender:UIButton) {
        
        if sender == btn1 {
            return
        }
        guard self.model?.bumped == nil ||
        self.model?.bumped?.isEmpty == true else {
            return
        }
        
    }
    
    private var model:RFContactModel?
    
    func fill(_ data:RFContactModel) {
        self.model = data
        titleLb.text = "Contact\(data.indexPath.section + 1)"
        lb2.text = data.bumped
        lb1.text = data.knee.first(where: {$0.wasan == data.fany })?.wasan
    }
    
    private func openConatctPicker() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        self.viewController?.present(picker, animated: true)
        
    }
    
    var saveBlock:(()->Void)?
}

extension RFContactCell:CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let num = contact.phoneNumbers.first
        let numStr = num?.label
        self.model?.bumped = numStr
        picker.dismiss(animated: true)
        guard let numStr = numStr else { return  }
        saveBlock?()
        
    }
    
}
