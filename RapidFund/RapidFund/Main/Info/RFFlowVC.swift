//
//  RFFlowVC.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import UIKit

class RFFlowVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private let progressView = RFLoadProgressView()
    private func setup() {
        let bgImgV = UIImageView(image: "em_in_bg".image)
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let topImgV = UIImageView(image: "flow_top".image)
        view.addSubview(topImgV)
        topImgV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(426.rf)
        }

        let bottomImgV = UIImageView(image: "flow_bottom".image)
        view.addSubview(bottomImgV)
        bottomImgV.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.centerY.equalTo(topImgV.snp.bottom)
            make.left.equalTo(24.rf)
            make.right.equalTo(-24.rf)
            make.height.equalTo(117.rf)
        }
        
        let iconNames = ["flow_item_icon1", "flow_item_icon2", "flow_item_icon3", "flow_item_icon4", "flow_item_icon4"]
        let itemNames = ["Identity  Details", "Facial Recognition", "Personal Information", "Employment Information", "Bank Card"]
        
        for i in 0 ..< iconNames.count {
            let item = RFFlowItem(bgImg: "flow_item_bg2".image, icon: iconNames[i].image, text: itemNames[i])
            item.tag = i
            view.addSubview(item)
            let offset = CGFloat((i / 2)) * (121.rf + 12.rf)
            item.snp.makeConstraints { make in
                make.width.equalTo(142.rf)
                make.height.equalTo(121.rf)
                make.left.equalTo(i % 2 == 1 ? 208.rf : 24.rf)
                make.top.equalTo(progressView.snp.bottom).offset(20.rf + offset)
            }
            
            
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:))))
        }
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        let item = sender.view as? RFFlowItem
        guard let item = item else { return }
        if item.tag == 0 {
            navigationController?.pushViewController(RFIDDetailVC(), animated: true)
        } else if item.tag == 2 {
            navigationController?.pushViewController(RFPInVC(route: .personal_info), animated: true)
        } else if item.tag == 3 {
            navigationController?.pushViewController(RFPInVC(route: .employment_info), animated: true)
        }
    }
}
