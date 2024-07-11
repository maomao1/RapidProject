//
//  RFFRVC.swift
//  RapidFund
//
//  Created by C on 2024/7/10.
//

import UIKit

class RFFRVC: RapidBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNav.text = "Face Recognition"
        titleNav.textColor = .white
        titleNav.font = 24.font
        self.rightBtn.isHidden = true
        setup()
        view.bringSubviewToFront(customNavView)
    }
    
    private let contentView = UIView()
    private func setup() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let bgImgV = UIImageView(image: "id_detail_bg".image)
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
        let topImgV = UIImageView(image: "FR_bg".image)
        bgImgV.addSubview(topImgV)
        topImgV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(398.rf)
        }
        
        let RTImgV = UIImageView(image: "ID_rightTop".image)
        topImgV.addSubview(RTImgV)
        RTImgV.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.equalTo(70.rf)
            make.height.equalTo(96.rf)
        }
        
        let faceView = UIImageView(image: "".image)
        topImgV.addSubview(faceView)
        faceView.snp.makeConstraints { make in
            make.bottom.equalTo(-27.rf)
            make.left.equalTo(35.rf)
            make.width.equalTo(288.rf)
            make.height.equalTo(255.rf)
        }
        
        let addBtn = UIButton(type: .custom)
        addBtn.setImage("face_add".image, for: .normal)
        addBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        contentView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(topImgV.snp.bottom)
        }
        
        func __createTmp(img: UIImage?, text: String?) -> UIView {
            let view = UIView()

            let iconImgV = UIImageView(image: img)
            view.addSubview(iconImgV)
            iconImgV.snp.makeConstraints { make in
                make.width.equalTo(95.rf)
                make.height.equalTo(81.rf)
                make.top.left.right.equalToSuperview()
            }
            let textLb = UILabel().text(text).font(12.font).textColor(0x232323.color)
            view.addSubview(textLb)
            textLb.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(iconImgV.snp.bottom).offset(8.rf)
                make.bottom.equalToSuperview()
            }
            return view
        }
        
        let face_addTitleLb = UILabel().text("Add Your Facial Information").font(16.font).textColor(0x111111.color)
        contentView.addSubview(face_addTitleLb)
        face_addTitleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(addBtn.snp.bottom).offset(12.rf)
        }
        
        let faceDesLb = UILabel()
        let face_param = NSMutableParagraphStyle()
        face_param.lineSpacing = 4
        face_param.alignment = .center
        let face_att = NSAttributedString(string: "Please ensure that your ID card is clearly photographed, unobstructed, and it is your own ID card photo.", attributes: [.font: 12.font, .foregroundColor: 0x999999.color, .paragraphStyle: face_param])
        faceDesLb.numberOfLines = 0
        faceDesLb.attributedText = face_att
        contentView.addSubview(faceDesLb)
        faceDesLb.snp.makeConstraints { make in
            make.left.equalTo(23.rf)
            make.right.equalTo(-23.rf)
            make.top.equalTo(face_addTitleLb.snp.bottom).offset(11.rf)
        }
        
        let face_stackView = UIStackView(arrangedSubviews: [__createTmp(img: "face_tmp1".image, text: "Look Down"), __createTmp(img: "face_tmp2".image, text: "Occlusion"), __createTmp(img: "face_tmp3".image, text: "Overexposure")])
        face_stackView.axis = .horizontal
        face_stackView.spacing = 23.5.rf
        contentView.addSubview(face_stackView)
        face_stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(faceDesLb.snp.bottom).offset(20.rf)
        }
        
        let nextimgV = UIImageView(image: "face_next_bg".image)
        contentView.addSubview(nextimgV)
        nextimgV.snp.makeConstraints { make in
            make.width.equalTo(294.rf)
            make.height.equalTo(60.rf)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-53.rf)
        }
        
        let nextLb = UILabel().font(16.font).text("Next").textColor(0xffffff.color)
        nextimgV.addSubview(nextLb)
        nextLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(35.rf)
        }
        
        let next_arr = UIImageView(image: "face_next".image)
        nextimgV.addSubview(next_arr)
        next_arr.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-32.rf)
        }
    }
}

extension RFFRVC {
    @objc private func btnClick() {}
}
