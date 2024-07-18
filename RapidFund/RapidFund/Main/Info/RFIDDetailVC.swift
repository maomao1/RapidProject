//
//  RFIDDetailVC.swift
//  RapidFund
//
//  Created by C on 2024/7/10.
//

import RxSwift
@_exported import SDWebImage
@_exported import SnapKit
import UIKit

class RFIDDetailVC: RapidBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNav.text = "Identity  Details"
        titleNav.textColor = .white
        titleNav.font = 24.font
        self.rightBtn.isHidden = true
        setup()
        view.bringSubviewToFront(customNavView)
        loadData()
    }

    private lazy var imgPicker: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        return vc
    }()
    private var model:RFAuthFRModel?
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let cardView = UIImageView(image: "ID_bg1".image)
    private let addBtn = UIButton(type: .custom)
    private let face_addBtn = UIButton(type: .custom)
    private let face_recognitionLb = UILabel().text("Face Recognition").textColor(0xffffff.color).font(24.font)
    private let face_recognitionImgV = UIImageView(image: "face_recognition".image)
    private let face_verifyImgV = UIImageView(image: "face_verify".image)
    private func setup() {
        scrollView.bounces = false
        scrollView.frame = self.view.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.bounds = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let bgImgV = UIImageView(image: "id_detail_bg".image)
        bgImgV.isUserInteractionEnabled = true
        contentView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
        let topImgV = UIImageView(image: "id_detail_top".image)
        bgImgV.addSubview(topImgV)
        topImgV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(426.rf)
        }
        
        let RTImgV = UIImageView(image: "ID_rightTop".image)
        topImgV.addSubview(RTImgV)
        RTImgV.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.equalTo(70.rf)
            make.height.equalTo(96.rf)
        }
        
        let cardBgView = UIImageView(image: "ID_bg".image)
        contentView.addSubview(cardBgView)
        cardBgView.snp.makeConstraints { make in
            make.bottom.equalTo(topImgV.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(270.rf)
            make.height.equalTo(158.rf)
        }
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.width.equalTo(271.rf)
            make.height.equalTo(163.rf)
            make.centerX.equalToSuperview()
            make.top.equalTo(cardBgView.snp.top).offset(13.5.rf)
        }
        
        let IDView = RFPRCIDView()
        contentView.addSubview(IDView)
        IDView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(cardBgView.snp.top).offset(-18.5.rf)
        }
        
        addBtn.setImage("ID_add".image, for: .normal)
        addBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        contentView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(cardView.snp.bottom)
        }
        
        let addTitleLb = UILabel().text("Add ID Card").font(16.font).textColor(0x111111.color)
        contentView.addSubview(addTitleLb)
        addTitleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(addBtn.snp.bottom).offset(12.rf)
        }
        
        let cardDesLb = UILabel()
        let param = NSMutableParagraphStyle()
        param.lineSpacing = 4
        param.alignment = .center
        let att = NSAttributedString(string: "Please ensure that your ID card is clearly photographed, unobstructed, and it is your own ID card photo.", attributes: [.font: 12.font, .foregroundColor: 0x999999.color, .paragraphStyle: param])
        cardDesLb.numberOfLines = 0
        cardDesLb.attributedText = att
        contentView.addSubview(cardDesLb)
        cardDesLb.snp.makeConstraints { make in
            make.left.equalTo(23.rf)
            make.right.equalTo(-23.rf)
            make.top.equalTo(addTitleLb.snp.bottom).offset(11.rf)
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
        
        let stackView = UIStackView(arrangedSubviews: [__createTmp(img: "ID_tmp1".image, text: "Standard"), __createTmp(img: "ID_tmp2".image, text: "Missing"), __createTmp(img: "ID_tmp3".image, text: "Blurring")])
        stackView.axis = .horizontal
        stackView.spacing = 23.5.rf
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardDesLb.snp.bottom).offset(20.rf)
        }
        
        contentView.addSubview(face_recognitionImgV)
        face_recognitionImgV.snp.makeConstraints { make in
            make.width.equalTo(327.rf)
            make.height.equalTo(123.rf)
            make.top.equalTo(stackView.snp.bottom).offset(20.rf)
            make.centerX.equalToSuperview()
        }
        face_recognitionImgV.addSubview(face_verifyImgV)
        face_verifyImgV.isHidden = true
        face_verifyImgV.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(47.rf)
        }
        
        face_recognitionImgV.addSubview(face_recognitionLb)
        face_recognitionLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(24.rf)
        }
        
        face_addBtn.setImage("face_add".image, for: .normal)
        face_addBtn.addTarget(self, action: #selector(faceClick), for: .touchUpInside)
        contentView.addSubview(face_addBtn)
        face_addBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(face_recognitionImgV.snp.bottom)
        }
        
        let face_addTitleLb = UILabel().text("Add Your Facial Information").font(16.font).textColor(0x111111.color)
        contentView.addSubview(face_addTitleLb)
        face_addTitleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(face_addBtn.snp.bottom).offset(12.rf)
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
            make.top.equalTo(face_stackView.snp.bottom).offset(32.rf)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-37.rf)
        }
        
        nextimgV.addTapGesture { [weak self] in
            self?.navigationController?.pushViewController(RFPInVC(route: .personal_info), animated: true)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        scrollView.contentSize = CGSize(width: kScreenWidth, height: height)
    }
    private var isFace:Bool = false
}

extension RFIDDetailVC {
    @objc private func btnClick() {
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        isFace = false
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.__openCamera()
        }
        
        let photo = UIAlertAction(title: "Album", style: .default) { [weak self] _ in
            self?.__openPhoto()
        }
        sheetView.addAction(camera)
        sheetView.addAction(photo)
        navigationController?.present(sheetView, animated: true)
    }
    
    @objc private func faceClick() {
        guard model?.trouble?.tyou == 0 else {
            return
        }
        isFace = true
        __openCamera()
    }
    
    private func __openCamera() {
        self.imgPicker.sourceType = .camera
        self.navigationController?.present(self.imgPicker, animated: true)
    }
    
    private func __openPhoto() {
        self.imgPicker.sourceType = .photoLibrary
        self.navigationController?.present(self.imgPicker, animated: true)
    }
}

extension RFIDDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let img = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
        guard let imgData = img?.jpegData(compressionQuality: 0.5) else { return  }
        
        uploadIDCard(source: picker.sourceType == .camera ? .camera : .photo, data: imgData, dismay: isFace ? 10 : 11)
        
    }
}

extension RFIDDetailVC {
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
        if model.trouble?.carefully?.mustn == 1 {
            addBtn.setImage("id_add_1".image, for: .normal)
            addBtn.isUserInteractionEnabled = false
            
            cardView.sd_setImage(with: URL(string: model.trouble?.carefully?.littleroom ?? ""), placeholderImage: "ID_bg1".image, context: nil)
        }
        if model.trouble?.tyou == 1 {
            face_addBtn.setImage("face_add_1".image, for: .normal)
            face_addBtn.isUserInteractionEnabled = false
        }
        if model.trouble?.littleroom.isEmpty == false {
            face_verifyImgV.isHidden = false
            face_recognitionLb.isHidden = true
            face_recognitionImgV.sd_setImage(with: URL(string: model.trouble?.littleroom ?? ""), placeholderImage: "face_recognition".image, context: nil)
        }
    }
    
    enum __FromSource: Int {
        case photo = 1
        case camera = 2
    }

    private func uploadIDCard(source: __FromSource, data: Data, dismay: Int) {
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
            self?.renderPickerResultData(data: model)
        }, onError: { _ in
            
        }).disposed(by: bag)
    }
    
    private func renderPickerResultData(data:RFUploadResultModel) {
        if data.type == 11 ||
            data.type == 12 {
            cardView.sd_setImage(with: URL(string: data.littleroom ?? ""))
        } else {
            face_verifyImgV.isHidden = false
            face_recognitionLb.isHidden = true
            face_recognitionImgV.sd_setImage(with: URL(string: data.littleroom ?? ""))
        }
    }
}

