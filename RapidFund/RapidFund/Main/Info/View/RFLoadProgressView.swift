//
//  RFLoadProgressView.swift
//  RapidFund
//
//  Created by C on 2024/7/9.
//

import UIKit

class RFLoadProgressView: UIView {

    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let bgImgV = UIImageView(image: "flow_progress_bg".image)
        addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let titleLb = UILabel().text("Loan Progress").font(20.fontBold).textColor(0x111111.color)
        addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(14.rf)
        }
        let bgImg = UIImage.image(colors: [0xB3AFFF.color,0xE4D8FF.color])
        pgBgView.image = bgImg
        pgBgView.clipsCornerRadius(Float(20.5.rf))
        addSubview(pgBgView)
        let progressImg = UIImage.image(colors: [0xD9D7FF .color.withAlphaComponent(0.3),0xD9D7FF .color.withAlphaComponent(0.6)])
        progressView.image = progressImg
        addSubview(progressView)
        addSubview(progressLb)
        progressView.clipsCornerRadius(Float(20.5.rf))
        pgBgView.snp.makeConstraints { make in
            make.height.equalTo(41.rf)
            make.left.equalTo(35.rf)
            make.right.equalTo(-35.rf)
            make.top.equalTo(titleLb.snp.bottom).offset(7.5.rf)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(pgBgView)
            make.width.equalTo(0)
        }
        progressLb.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(progressView)
            make.right.equalTo(progressView.snp.right).offset(-15.rf)
        }
    }
    private let progressLb = UILabel()
        .textColor(0xffffff.color)
        .font(12.fontBold)
        .text("0%")
        .textAlignment(.right)
    private let progressView = UIImageView()
    private let pgBgView = UIImageView()
    func fill(finishCount: Int, totalCount: Int) {
        let schedule: Double = Double(finishCount) / Double(totalCount)
        let number = NSNumber(value: schedule)
        let percent = NumberFormatter.localizedString(from: number, number: .percent)
        progressLb.text = "\(percent)"

        progressView.snp.updateConstraints { make in
            make.width.equalTo((kScreenWidth - 118.rf) * CGFloat(schedule))
        }
        
        let width = (kScreenWidth - 118.rf) * CGFloat(schedule)
        if width < 40.rf {
            progressLb.snp.remakeConstraints { make in
                make.top.bottom.equalTo(progressView)
                make.left.equalTo(progressView.snp.right).offset(0)
                make.width.equalTo(30.rf)
            }
        }else {
            progressLb.snp.makeConstraints { make in
                make.left.top.bottom.equalTo(progressView)
                make.right.equalTo(progressView.snp.right).offset(-15.rf)
            }
        }
            
    }
}
