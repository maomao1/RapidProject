//
//  RapidHomeProductCell.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/10.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class RapidHomeProductCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setUpViews()
    }
    
    func setUpViews(){
        
        contentView.addSubview(containerView)
        contentView.addSubview(productImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(soundBgView)
        contentView.addSubview(soundImg)
        contentView.addSubview(soundLabel)
        contentView.addSubview(applyBtn)
        contentView.addSubview(limitImg)
        containerView.addSubview(statusBgView)
        contentView.addSubview(statusLabel)
        
        containerView.snp.makeConstraints { make in
            make.left.equalTo(-40.rf)
            make.top.equalTo(12.rf)
            make.right.equalTo(-49.rf)
            make.bottom.equalTo(0)
        }
        
        productImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 54.rf, height: 54.rf))
            make.left.equalTo(16.rf)
            make.top.equalTo(containerView.snp.top).offset(12.rf)
        }
        
        applyBtn.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.size.equalTo(CGSize(width: 53.rf, height: 53.rf))
            make.right.equalTo(containerView.snp.right).offset(25.rf)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(productImage.snp.right).offset(12.rf)
            make.top.equalTo(productImage.snp.top).offset(5.rf)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(12.rf)
        }
        
        soundBgView.snp.makeConstraints { make in
            make.left.equalTo(productImage)
            make.bottom.equalTo(containerView).inset(12.rf)
            make.right.equalTo(applyBtn.snp.left).offset(-15.rf)
            make.height.equalTo(24.rf)
        }
        
        soundImg.snp.makeConstraints { make in
            make.centerY.equalTo(soundBgView)
            make.left.equalTo(soundBgView.snp.left).offset(8.rf)
            make.size.equalTo(CGSize(width: 14.rf, height: 14.rf))
        }
        
        soundLabel.snp.makeConstraints { make in
            make.centerY.equalTo(soundBgView)
            make.left.equalTo(soundImg.snp.right).offset(6.rf)
            make.right.equalTo(soundBgView)
        }
        
        limitImg.snp.makeConstraints { make in
            make.left.equalTo(productImage.snp.left)
            make.top.equalTo(containerView.snp.top).offset(-7.rf)
            
        }
        
        statusLabel.snp.makeConstraints { make in
            make.right.equalTo(applyBtn.snp.left).offset(-12.rf)
            make.top.equalTo(containerView.snp.top).offset(2.rf)
            make.height.equalTo(12.rf)
        }
        
        statusBgView.snp.makeConstraints { make in
            make.left.equalTo(statusLabel.snp.left).offset(-12.rf)
            make.right.equalTo(statusLabel.snp.right).offset(12.rf)
            make.top.equalTo(containerView.snp.top).offset(-5.rf)
            make.bottom.equalTo(statusLabel.snp.bottom).offset(2.rf)
        }
        
        
        
    }
    
    func updateCellContent(model: RPFHomeProduct){
        self.productImage.sd_setImage(with: model.productLogo.url, placeholderImage: nil, options: .allowInvalidSSLCertificates)
        self.nameLabel.text = model.productName
        self.contentLabel.text = model.productDesc
        self.applyBtn.setTitle(model.buttonText, for: .normal)
        self.applyBtn.setTitle(model.buttonText, for: .selected)
        self.statusLabel.text = model.productTags
        self.statusBgView.backgroundColor = .red
        
        if model.buttoncolor.count > 1{
            self.applyBtn.backgroundColor = UIColor.init(webColor: model.buttoncolor)
        }
//        self.soundLabel.text = model.
        
    }
    
    fileprivate lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16.rf
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .lightGray
        return image
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys16
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys12
        label.textColor = .c_999999
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var soundBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .c_000000.withAlphaComponent(0.05)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.rf
        return view
    }()
    
    fileprivate lazy var limitImg: UIImageView = {
        let imageview = UIImageView.init(image: .homeLimitIcon)
        return imageview
    }()
    
    fileprivate lazy var soundImg: UIImageView = {
        let imageview = UIImageView.init(image: .homeSoundIcon)
        return imageview
    }()
    
    fileprivate lazy var soundLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys10
        label.textColor = .c_111111
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var containerView: UIImageView = {
        let view = UIImageView(image:UIImage.image(gradientDirection: .horizontal,colors: [.c_E5DEFA,.c_FFFFFF.withAlphaComponent(0.93)]))
//        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 24.rf
        return view
    }()
    
    fileprivate lazy var applyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 18.rf
        btn.backgroundColor = .black
        return btn
    }()
    
    fileprivate lazy var statusBgView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4.5.rf
        return view
    }()
    
    fileprivate lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font =  .f_lightSys10
        label.textColor = .c_111111
        label.textAlignment = .center
        return label
    }()
    
    
    
    static func height() -> CGFloat {
        return 126.rf
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class RapidHomeHotCell: UITableViewCell {
    struct AutoLayout {
        static let applyText = "Apply for a Loan"
        
    }
    
    private let bag = DisposeBag()
    var applyBlock: (() -> Void)?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setUpViews()
        setupRx()
        
    }
    
    func setupRx() {
        applyBtn.rx
            .tap
            .throttle(.seconds_1, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.applyBlock?()

            })
            .disposed(by: bag)
    }
    
    func updateCellContent(model: RPFHomeHotModel){
        self.rapidNameLabel.text = model.pursed
        self.applyTitle.text = model.mymorgan
        self.homeMoneyView.updateContent(model: model)
        self.homeMoneyRateView.updateContent(model: model)
        
    }
    
    func setUpViews(){
        contentView.addSubview(rapidImageView)
        contentView.addSubview(rapidNameLabel)
        contentView.addSubview(unLoginImgBg)
        contentView.addSubview(applyBtn)
        contentView.addSubview(applyTitle)
        contentView.addSubview(applyArrow)
        contentView.addSubview(homeMoneyView)
        contentView.addSubview(homeMoneyRateView)
       
        rapidImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(5.5.rf)
            make.size.equalTo(CGSize(width: 78.rc, height: 78.rc))
        }
        rapidNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rapidImageView)
            make.top.equalTo(rapidImageView.snp.bottom).offset(2.5.rf)
        }
        
        unLoginImgBg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rapidNameLabel.snp.bottom).offset(14.5.rf)
            make.left.equalTo(63.5.rf)
            make.bottom.equalTo(-70.rf)
        }
        
        homeMoneyView.snp.makeConstraints { make in
            make.left.equalTo(unLoginImgBg.snp.left).offset(29.rf)
            make.right.equalTo(unLoginImgBg.snp.right).offset(-29.rf)
            make.top.equalTo(unLoginImgBg.snp.top).offset(105.rf)
            make.height.equalTo(HomeMoneyView.height())
        }
        
        homeMoneyRateView.snp.makeConstraints { make in
            make.left.equalTo(unLoginImgBg.snp.left).offset(29.rf)
            make.right.equalTo(unLoginImgBg.snp.right).offset(-29.rf)
            make.top.equalTo(homeMoneyView.snp.bottom).offset(11.rf)
            make.height.equalTo(HomeMoneyRateView.height())
        }
        
        applyBtn.snp.makeConstraints { make in
            make.left.equalTo(unLoginImgBg.snp.left).offset(-23.rc)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(unLoginImgBg.snp.bottom).offset(30.rc)
            make.height.equalTo(60.rc)
        }
        
        applyTitle.snp.makeConstraints { make in
            make.centerY.equalTo(applyBtn)
            make.left.equalTo(applyBtn.snp.left).offset(32.rc)
            
        }
        
        applyArrow.snp.makeConstraints { make in
            make.centerY.equalTo(applyBtn)
            make.right.equalTo(applyBtn.snp.right).offset(-32.rc)
        }
    }
    
    let rapidImageView = UIImageView(image: .homeRapidIcon)
    let rapidNameLabel = UILabel().withFont(.f_lightSys12)
        .withTextColor(.c_111111)
        .withTextAlignment(.center)
        .withText("")
    let unLoginImgBg  = UIImageView(image: .homeUnloginBg)
    let homeMoneyView = HomeMoneyView()
    let homeMoneyRateView = HomeMoneyRateView()
    
    lazy var applyBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.rf
        button.setBackgroundImage(.homeBtnBg, for: .normal)
        button.setBackgroundImage(.homeBtnBg, for: .selected)
        button.setBackgroundImage(.homeBtnBg, for: .highlighted)
        return button
    }()
    
    lazy var applyTitle: UILabel = {
        let label = UILabel()
        label.textColor = .c_FFFFFF
        label.textAlignment = .left
        label.font = .f_lightSys16
        label.text = AutoLayout.applyText
        return label
    }()
    
    lazy var applyArrow: UIImageView = {
        let imageView = UIImageView(image: .homeApplyArrow)
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .right
        return imageView
    }()
}

