//
//  RFBankAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import UIKit
import RxSwift
import RxCocoa
@_exported import XYZAlert

class RFBankAlert: XYZAlertView {
    
    let bag = DisposeBag()
    private let contents:[String]
    init(strings:[String]) {
        self.contents = strings
        super.init(frame: .zero)
        setup()
        setUpRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedRow = 0
    private let pickerView = UIPickerView()
    private let confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.c_FF7E00, for: .normal)
        button.titleLabel?.font = .f_boldSys14
//        button.backgroundColor = .c_FF7E00
        return button
    }()
    private func setup() {
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .leftTopToRightBottom,colors: [0xE5DEFA.color,0xFFFFFF.color]))
        containerAlertViewMaxSize = CGSize(width: kScreenWidth, height: 500)
        containerAlertView.addSubview(bgView)
        containerAlertViewRoundValue = 24.rf
        let line = UIView()
        line.backgroundColor = .c_000000.withAlphaComponent(0.05)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(400.rf)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        containerAlertView.addSubview(pickerView)
        containerAlertView.addSubview(line)
        containerAlertView.addSubview(confirmButton)
        pickerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(0.rf)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(46.rf)
            make.left.right.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.left.equalTo(20.rf)
            make.right.equalTo(-20.rf)
            make.height.equalTo(0.5)
            make.bottom.equalTo(-46.5.rf)
        }
        
        
    }
    
    func setUpRx() {
        confirmButton.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                self.selectedBlock?(self.selectedRow)
                self.dismiss(withAnimation: true)
            })
            .disposed(by: bag)
    }
    
    override func show(on view: UIView) {
        self.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.8)
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerAlertView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(400.rf)
        }
        containerAlertView.transform = CGAffineTransform(translationX: 0, y: -400.rf)
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = .identity
        }
        
    }
    override func dismiss(withAnimation animation: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = CGAffineTransform(translationX: 0, y: -400.rf)
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
        self.selectedRow = row
    }
}
