//
//  RFBankAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import UIKit
@_exported import XYZAlert

class RFBankAlert: XYZAlertView {
    

    private let contents:[String]
    init(strings:[String]) {
        self.contents = strings
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let pickerView = UIPickerView()
    private func setup() {
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .leftTopToRightBottom,colors: [0xE5DEFA.color,0xFFFFFF.color]))
        containerAlertViewMaxSize = CGSize(width: kScreenWidth, height: 500)
        containerAlertView.addSubview(bgView)
        containerAlertViewRoundValue = 24.rf
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(276.rf)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        containerAlertView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func show(on view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerAlertView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(276.rf)
        }
        containerAlertView.transform = CGAffineTransform(translationX: 0, y: -276.rf)
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = .identity
        }
        
    }
    override func dismiss(withAnimation animation: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = CGAffineTransform(translationX: 0, y: -276.rf)
        } completion: { _ in
            super.dismiss(withAnimation: false)
        }
    }
    
    var selectedBlock:((Int)->Void)?
}


extension RFBankAlert:UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.contents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return kScreenWidth - 24.rf
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let cont = UIView()
        let lb = UILabel().font(20.font).textColor(0x111111.color).textAlignment(.center).text(self.contents[row])
        cont.addSubview(lb)
        lb.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cont.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 24.rf, height: 52.rf)
        return cont
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 52.rf
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedBlock?(row)
    }
}
