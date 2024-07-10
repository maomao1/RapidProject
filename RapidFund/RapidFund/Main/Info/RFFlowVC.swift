//
//  RFFlowVC.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import UIKit

class RFFlowVC: RapidBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleNav.text = "Borrowing  Process"
        self.titleNav.textColor = .white
//        adjustNavTitleCenter()
        titleNav.font = 24.font
        self.rightBtn.isHidden = true
        setup()
        self.view.bringSubviewToFront(self.customNavView)
    }
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let progressView = RFLoadProgressView()
    private func setup() {
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.frame = self.view.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let bgImgV = UIImageView(image: "em_in_bg".image)
        contentView.bounds = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let topImgV = UIImageView(image: "flow_top".image)
        contentView.addSubview(topImgV)
        topImgV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(426.rf)
        }

        let bottomImgV = UIImageView(image: "flow_bottom".image)
        contentView.addSubview(bottomImgV)
        bottomImgV.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
        
        contentView.addSubview(progressView)
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
            contentView.addSubview(item)
            let offset = CGFloat((i / 2)) * (121.rf + 12.rf)
            item.snp.makeConstraints { make in
                make.width.equalTo(142.rf)
                make.height.equalTo(121.rf)
                make.left.equalTo(i % 2 == 1 ? 208.rf : 24.rf)
                make.top.equalTo(progressView.snp.bottom).offset(20.rf + offset)
                
                if i == iconNames.count - 1 {
                    make.bottom.equalTo(contentView.snp.bottom).offset(-12.5.rf)
                }
            }
            
            
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:))))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        scrollView.contentSize = CGSize(width: kScreenWidth, height: height)
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        let item = sender.view as? RFFlowItem
        guard let item = item else { return }
        if item.tag == 0 {
            navigationController?.pushViewController(RFIDDetailVC(), animated: true)
        } else if item.tag == 1 {
            navigationController?.pushViewController(RFFRVC(), animated: true)
        } else if item.tag == 2 {
            navigationController?.pushViewController(RFPInVC(route: .personal_info), animated: true)
        } else if item.tag == 3 {
            navigationController?.pushViewController(RFPInVC(route: .employment_info), animated: true)
        }
    }
}
