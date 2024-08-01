//
//  RFIDTypeAlert.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/28.
//

import UIKit
import RxSwift
import RxCocoa
@_exported import XYZAlert
class RFIDTypeAlert: XYZAlertView {
    // MARK: - Constants
    struct AutoLayout {
        static let minimumInteritemSpacing = CGFloat.leastNormalMagnitude
        static let itemW = kScreenWidth / 2
        static let itemH = 120.rf
    }
    
    struct CellID {
        static let typeCell = "RFIDTypeCellIdentifier"
    }
    let bag = DisposeBag()
    private let contents:[String]
   
    var selectedContent = "UMID" {
        didSet {
            self.collectionView.reloadData() 
        }
    }
    init(strings:[String]) {
        self.contents = strings
        super.init(frame: .zero)
        setup()
        setUpRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .leftTopToRightBottom,colors: [0xE5DEFA.color,0xFFFFFF.color]))
        containerAlertViewMaxSize = CGSize(width: kScreenWidth, height: 600)
        containerAlertViewRoundValue = 24.rf
        let line = UIView()
        line.backgroundColor = .c_000000.withAlphaComponent(0.05)
        
        containerAlertView.addSubview(bgView)
        containerAlertView.addSubview(typeTitle)
        containerAlertView.addSubview(finishButton)
        containerAlertView.addSubview(line)
        containerAlertView.addSubview(collectionView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(550.rf)
        }
        
        typeTitle.snp.makeConstraints { make in
            make.left.equalTo(20.rf)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16.rf)
            } else{
                make.top.equalTo(16.rf)
            }
        }
        
        finishButton.snp.makeConstraints { make in
            make.right.equalTo(-20.rf)
            make.centerY.equalTo(typeTitle)
            make.size.equalTo(CGSize(width: 80.rf, height: 20.rf))
        }
        
        line.snp.makeConstraints { make in
            make.left.equalTo(typeTitle)
            make.right.equalTo(finishButton)
            make.height.equalTo(0.5)
            make.top.equalTo(finishButton.snp.bottom).offset(14.rf)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(finishButton.snp.bottom).offset(15.rf)
            make.bottom.equalTo(bgView.snp.bottom).offset(-20.rf)
        }
    }
    
    func setUpRx() {
        finishButton.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                self.selectedBlock?(self.selectedContent)
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
            make.height.equalTo(550.rf)
        }
        containerAlertView.transform = CGAffineTransform(translationX: 0, y: -550.rf)
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = .identity
        }
        
    }
    override func dismiss(withAnimation animation: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = CGAffineTransform(translationX: 0, y: -550.rf)
        } completion: { _ in
            super.dismiss(withAnimation: false)
        }
    }
    
    var selectedBlock:((String)->Void)?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12.rf, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = AutoLayout.minimumInteritemSpacing
        layout.minimumLineSpacing = 12.rf
        layout.itemSize = CGSize(width: AutoLayout.itemW, height: AutoLayout.itemH)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(RFIDTypeCell.self, forCellWithReuseIdentifier: CellID.typeCell)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var finishButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.c_FF7E00, for: .normal)
        button.titleLabel?.font = .f_lightSys14
        button.contentHorizontalAlignment = .right
//        button.backgroundColor = .c_FF7E00
        return button
    }()
    
    private let typeTitle: UILabel = {
        let label = UILabel()
        label.text = "Document Type"
        label.textColor = .c_111111
        label.font = .f_lightSys14
        return label
    }()
}

extension RFIDTypeAlert: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.typeCell, for: indexPath) as! RFIDTypeCell
        cell.text = self.contents[indexPath.item]
        cell.selectedText = self.selectedContent
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedContent = self.contents[indexPath.item]
    }

}


class RFIDTypeCell: UICollectionViewCell {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(containerView)
        contentView.addSubview(IDImageView)
        contentView.addSubview(selectedIcon)
        contentView.addSubview(textLab)
       
        containerView.clipsCornerRadius(Float(6.rf))
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.borderWidth = 1
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(16.rf)
            make.right.equalTo(-16.rf)
            make.bottom.equalTo(-20.rf)
        }
        
        IDImageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(4.rf)
        }
        
        selectedIcon.snp.makeConstraints { make in
            make.left.top.equalTo(containerView)
        }
        
        textLab.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(4.rf)
            make.left.right.equalToSuperview()
            make.height.equalTo(15.rf)
        }
        
        
    }
    
    
    var text: String? {
        didSet {
            textLab.text = text
            if let imageStr = text {
                IDImageView.image = ("ID_type_" + imageStr).image
            }
        }
    }
    
    var selectedText: String = "" {
        didSet {
            if selectedText == textLab.text {
                containerView.layer.borderColor = UIColor.c_FF7E00.cgColor
                selectedIcon.isHidden = false
            }else{
                containerView.layer.borderColor = UIColor.clear.cgColor
                selectedIcon.isHidden = true
            }
        }
    }
    
    private let textLab = UILabel()
        .withFont(.f_lightSys12)
        .withTextColor(.c_111111)
        .withTextAlignment(.center)
    
    private let IDImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var selectedIcon: UIImageView = {
        let imageView = UIImageView(image: .rapidIDTypeSelected)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let containerView = UIView()
}
