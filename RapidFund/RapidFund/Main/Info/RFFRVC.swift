//
//  RFFRVC.swift
//  RapidFund
//
//  Created by C on 2024/7/10.
//

import UIKit

class RFFRVC: RapidBaseViewController {
    private let faceView = UIImageView(image: "".image)
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
    private let addBtn = UIButton(type: .custom)
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
        
        topImgV.addSubview(faceView)
        faceView.snp.makeConstraints { make in
            make.bottom.equalTo(-27.rf)
            make.left.equalTo(35.rf)
            make.width.equalTo(288.rf)
            make.height.equalTo(255.rf)
        }
        
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
        
        let nextBtn = RFNextBtn()
        contentView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-53.rf)
        }
    }
    
    private lazy var imgPicker: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        return vc
    }()
    
    private var model: RFAuthFRModel?
}

extension RFFRVC {
    private func loadData() {
        RapidApi.shared.getAuthOneData(para: ["putit": "putit", "melted": "melted"]).subscribe(onNext: { [weak self] json in
            guard let model = RFAuthFRModel.deserialize(from: json.dictionary) else {
                return
            }
            self?.render(model: model)
            // todo
        }, onError: { _ in
            
        }).disposed(by: bag)
    }
    
    private func render(model: RFAuthFRModel) {
        self.model = model
        
        if model.trouble?.tyou == 1 {
            addBtn.setImage("face_add_1".image, for: .normal)
            addBtn.isUserInteractionEnabled = false
        }
        if model.trouble?.littleroom.isEmpty == false {
            faceView.sd_setImage(with: URL(string: model.trouble?.littleroom ?? ""), placeholderImage: "face_recognition".image, context: nil)
        }
    }
    
    @objc private func btnClick() {
        __openCamera()
    }

    private func __openCamera() {
        self.navigationController?.present(self.imgPicker, animated: true)
    }
}

extension RFFRVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let img = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
        guard let imgData = img?.jpegData(compressionQuality: 0.5) else { return }
    
        uploadIDCard(source:.camera, data: imgData, dismay: 10)
    }
    
    private func uploadIDCard(source: RFIDDetailVC.__FromSource, data: Data, dismay: Int) {
        let params = ["quiteexpected": source.rawValue,
                      "putit": "123",
                      "dismay": dismay,
                      "woods": data,
                      "elf": "",
                      "thanksmost": "xxx",
                      "pixie": "3",
                      "darkalmost": "UMID"] as [String: Any]
        
        RapidApi.shared.getIDUploadData(para: params).subscribe(onNext: { [weak self] obj in
            guard let json = obj.dictionary?["trouble"] as? [String: Any], let model = RFUploadResultModel.deserialize(from: json) else {
                return
            }
            model.type = dismay
            self?.faceView.sd_setImage(with: URL(string: model.littleroom ?? ""))
        }, onError: { _ in
            
        }).disposed(by: bag)
    }
    
    
}
