//
//  RFIDDetailVC.swift
//  RapidFund
//
//  Created by C on 2024/7/10.
//

import MBProgressHUD
import RxSwift
import UIKit
@_exported import SDWebImage
@_exported import SnapKit
import ZLPhotoBrowser

class RFIDDetailVC: RapidBaseViewController {
    private let productId: String
    private let orderId: String
    private var selecteIDTypeTime: String = ""
    private var clickIDTime: String = ""
    private var clickFaceTime: String = ""
    
    init(productId: String, orderId: String) {
        self.productId = productId
        self.orderId = orderId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

//    private lazy var imgPicker: UIImagePickerController = {
//        let vc = UIImagePickerController()
//        vc.sourceType = .camera
//        vc.delegate = self
//        return vc
//    }()

    private var model: RFAuthFRModel?
//    private var nextModel: RFUploadResultModel? //下一步
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let cardView = UIImageView(image: "ID_bg1".image)
    private let IDView = RFPRCIDView()
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
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 15.rf
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
            make.bottom.equalTo(topImgV.snp.bottom).offset(-18.5.rf)
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
        
        cardView.addTapGesture { [weak self] in
            guard let self = self else {
                return
            }
            self.btnClick()
        }
        IDView.block = { [weak self] in
            self?.selectedPRCCard()
        }
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
        face_recognitionImgV.layer.masksToBounds = true
        face_recognitionImgV.layer.cornerRadius = 10.rf
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
        face_recognitionImgV.addTapGesture { [weak self] in
            guard let self = self else {
                return
            }
            self.faceClick()
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
            guard let self = self else {
                return
            }
            self.nextAction()

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

    private var isFace: Bool = false
}

extension RFIDDetailVC {
    @objc private func btnClick() {
        guard model?.carefully?.mustn == 0  else{
            return
        }
        self.clickIDTime = getCurrentTime()
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        isFace = false
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.__openCamera()
        }
        
        let photo = UIAlertAction(title: "Album", style: .default) { [weak self] _ in
            self?.__openPhoto()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        sheetView.addAction(camera)
        sheetView.addAction(photo)
        sheetView.addAction(cancel)
        navigationController?.present(sheetView, animated: true)
    }
    
    @objc private func faceClick() {
        guard model?.carefully?.mustn == 1  else{
            MBProgressHUD.showMessage("Please complete the ID verification first", toview: nil, afterDelay: 3)
            return
        }
        guard model?.tyou == 0 else {
            return
        }
        self.clickFaceTime = getCurrentTime()
        isFace = true
        __openCamera()
    }
    
    private func __openCamera() {
        ZLPhotoConfiguration.default().allowSelectVideo = false
        ZLPhotoConfiguration.default().maxSelectCount = 1
        ZLPhotoConfiguration.default().allowTakePhotoInLibrary = false
        ZLPhotoConfiguration.default().editAfterSelectThumbnailImage = true
        ZLPhotoConfiguration.default().cameraConfiguration.allowSwitchCamera = true 
        ZLPhotoConfiguration.default().cameraConfiguration.devicePosition = .back
        let camera = ZLCustomCamera()
        camera.switchCameraBtn.isHidden = false
        if isFace {
            ZLPhotoConfiguration.default().cameraConfiguration.devicePosition = .front
            ZLPhotoConfiguration.default().cameraConfiguration.allowSwitchCamera = false 
            camera.switchCameraBtn.isHidden = true
        }//        
        camera.takeDoneBlock = {[weak self] (image, videoUrl) in
            camera.dismiss(animated: false, completion: nil)
            if let image = image {
                guard let imgData = image.jpegData(compressionQuality: 0.5) else { return }
                self?.uploadIDCard(source: .camera , data: imgData, dismay: self!.isFace ? 10 : 11)
            }
        }
        
        self.navigationController?.present(camera, animated: true)
    }
    
    private func __openPhoto() {
        ZLPhotoConfiguration.default().allowSelectVideo = false
        ZLPhotoConfiguration.default().maxSelectCount = 1
        ZLPhotoConfiguration.default().allowTakePhotoInLibrary = false
        ZLPhotoConfiguration.default().editAfterSelectThumbnailImage = true
        
        let ps = ZLPhotoPreviewSheet()
        ps.selectImageBlock = {[weak self] (models, isFull) in
            if let image = models.first?.image {
                guard let imgData = image.jpegData(compressionQuality: 0.5) else { return }
                self?.uploadIDCard(source: .photo , data: imgData, dismay: self!.isFace ? 10 : 11)
                
            }
        }
        ps.showPhotoLibrary(sender: self)

//        self.navigationController?.present(ps, animated: true)
    }
    
    private func nextAction() {
        
        if model?.carefully?.mustn == 0 {
            MBProgressHUD.showMessage("Please complete the ID verification first", toview: nil, afterDelay: 3)
            return
        }
        if model?.tyou == 0 {
            MBProgressHUD.showMessage("Please complete the face verification first", toview: nil, afterDelay: 3)
            return
        }
        loadNextData()
//        guard let model = self.nextModel else {
//            self.navigationController?.popViewController(animated: true)
//            return}
//        guard let cur = model.recovered else { 
//            self.navigationController?.popViewController(animated: true)
//            return }
//        
//        let cls = cur.meet
//        if cls == "public" || cls == "thinglike1" {
//            
//        }
//        else  if cls == "personal" || cls == "thinglike2" {
//            self.navigationController?.pushViewController(RFPInVC(route: .personal_info, productId: self.productId, orderId: self.orderId), animated: true)
//        }
//        else  if cls == "work" || cls == "thinglike3" {
//            self.navigationController?.pushViewController(RFPInVC(route: .employment_info, productId: self.productId, orderId: self.orderId), animated: true)
//        }
//        else  if cls == "contacts" || cls == "thinglike4" {
//            self.navigationController?.pushViewController(RFContactListVC(productId: self.productId, orderId: self.orderId), animated: true)
//        }
//        else  if cls == "bank" || cls == "thinglike5" {
//            requestBindBankInfo(self.productId, self.orderId,self)
//        }
//        
        
        
    }
}

//extension RFIDDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        let img = info[.originalImage] as? UIImage
//        picker.dismiss(animated: true)
//        guard let imgData = img?.jpegData(compressionQuality: 0.5) else { return }
//        
//        uploadIDCard(source: picker.sourceType == .camera ? .camera : .photo, data: imgData, dismay: isFace ? 10 : 11)
//    }
//}

extension RFIDDetailVC {
    private func loadNextData() {
        self.showLoading()
        RapidApi.shared.productDetail(para: ["putit": productId, "interrupted": getRPFRandom(), "means": getRPFRandom()]).subscribe(onNext: { [weak self] obj in
            self?.hiddenLoading()

            guard let model = RFProductDetailModel.deserialize(from: obj.dictionaryObject) else {
                return
            }
            self?.handleNext(model: model)
            
        }, onError: { [weak self] err in
            MBProgressHUD.showError(err.localizedDescription)
            self?.hiddenLoading()
        }).disposed(by: bag)

    }
      
    private func  handleNext(model:RFProductDetailModel) {
        guard let cur = model.recovered else { return}
        let  cls = cur.meet
        if cls == "public" || cls == "thinglike1" {
            
        }
        else  if cls == "personal" || cls == "thinglike2" {
            self.navigationController?.pushViewController(RFPInVC(route: .personal_info, productId: productId, orderId: orderId), animated: true)
        }
        else  if cls == "work" || cls == "thinglike3" {
            self.navigationController?.pushViewController(RFPInVC(route: .employment_info, productId: productId, orderId: orderId), animated: true)
        }
        else  if cls == "contacts" || cls == "thinglike4" {
            self.navigationController?.pushViewController(RFContactListVC(productId: productId, orderId: orderId), animated: true)
        }
        else  if cls == "bank" || cls == "thinglike5" {
            requestBindBankInfo(productId, orderId,self)
            
        }
    }                                                                                                                                                                                                                                                           
                                                                                                                                    
    
    private func loadData() {
        self.showLoading()
        RapidApi.shared.getAuthOneData(para: ["putit": productId, "melted": getRPFRandom()]).subscribe(onNext: { [weak self] json in
            self?.hiddenLoading()
            guard let model = RFAuthFRModel.deserialize(from: json.dictionaryObject) else {
                return
            }
            self?.render(model: model)
            // todo
        }, onError: { [weak self] err in
            self?.hiddenLoading()
            MBProgressHUD.showError(err.localizedDescription)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
    
    private func render(model: RFAuthFRModel) {
        self.model = model
        let imageStr = model.carefully?.darkalmost ?? ""
        IDView.fill(model.carefully?.darkalmost ?? "")
        self.cardView.image = ("ID_type_" + imageStr).image
        if model.carefully?.mustn == 1 {
            addBtn.setImage("id_add_1".image, for: .normal)
            addBtn.isUserInteractionEnabled = false
            
            cardView.sd_setImage(with: URL(string: model.carefully?.littleroom ?? ""), placeholderImage: "ID_bg1".image, context: nil)
            self.scrollToBottom(scrollView: self.scrollView)
        }else{
            self.selectedPRCCard()
        }
        if model.tyou == 1 {
            face_addBtn.setImage("face_add_1".image, for: .normal)
            face_addBtn.isUserInteractionEnabled = false
        }
        if model.littleroom.isEmpty == false {
            face_verifyImgV.isHidden = false
            face_recognitionLb.isHidden = true
            face_recognitionImgV.sd_setImage(with: URL(string: model.littleroom), placeholderImage: "face_recognition".image, context: nil)
        }
        
    }
    
    enum __FromSource: Int {
        case photo = 1
        case camera = 2
    }
    
    private func uploadAnalysis(type: RFAnalysisScenenType){
        var startTime = ""
        if type == .IDType {
            startTime = self.selecteIDTypeTime
        }
        else if type == .IDInformation {
            startTime = self.clickIDTime
        }else if type == .FacePhoto {
            startTime = self.clickFaceTime
        }
        
        RPFLocationManager.manager.analysisBackList.append {  (longitude,latitude) in
            RPFReportManager.shared.saveAnalysis(pId: self.productId, type: type, startTime: startTime, longitude: longitude, latitude: latitude)
        }
        RPFLocationManager.manager.requestLocationAuthorizationStatus(isLocation: false)
        
//        RPFLocationManager.manager.analysisHandle = { [weak self] (longitude,latitude) in
//            guard let `self` = self else {return}
//            RPFReportManager.shared.saveAnalysis(pId: self.productId, type: type, startTime: startTime, longitude: longitude, latitude: latitude)
//        }
    }

    private func uploadIDCard(source: __FromSource, data: Data, dismay: Int) {

        let params = ["quiteexpected": source.rawValue,
                      "putit": productId,
                      "dismay": dismay,
                      "woods": data,
                      "elf": "",
                      "thanksmost": getRPFRandom(),
                      "pixie": "1",
                      "darkalmost": isFace ? "" : self.IDView.value] as [String: Any]
        self.showLoading()
        RapidApi.shared.getIDUploadData(para: params).subscribe(onNext: { [weak self] obj in
            guard let self = self else { return  }
            self.hiddenLoading()
            guard let model = RFUploadResultModel.deserialize(from: obj.dictionaryObject) else {
                return
            }
            model.type = dismay
            model.darkalmost = self.model?.carefully?.darkalmost
            
            if model.type == 10 {
                self.model?.tyou = 1
                self.uploadAnalysis(type: .FacePhoto)
                self.loadData()
                self.nextAction()
                return
            }
            
            let alert = RFIDVerifyAlert(data: model)
            alert.show(on: self.view)
            alert.dismissBlock = {
                self.model?.carefully?.mustn = 1
                self.uploadAnalysis(type: .IDInformation)
//                self.loadData()
                self.renderPickerResultData(data: model)
            }
            self.scrollToBottom(scrollView: self.scrollView)
        }, onError: { [weak self]  err in
            self?.hiddenLoading()
            MBProgressHUD.showError(err.localizedDescription)
        }).disposed(by: bag)
    }
    
    private func renderPickerResultData(data: RFUploadResultModel) {
        if data.type == 11 ||
            data.type == 12
        {
            cardView.sd_setImage(with: URL(string: data.littleroom ?? ""))
            addBtn.setImage("id_add_1".image, for: .normal)
            addBtn.isUserInteractionEnabled = false
        } else {
            face_verifyImgV.isHidden = false
            face_recognitionLb.isHidden = true
            face_recognitionImgV.sd_setImage(with: URL(string: data.littleroom ?? ""))
            face_addBtn.setImage("face_add_1".image, for: .normal)
            face_addBtn.isUserInteractionEnabled = false
        }
    }
    
    private func selectedPRCCard() {
        self.selecteIDTypeTime = getCurrentTime()
        guard let imgUrl = self.model?.carefully?.littleroom, imgUrl.isEmpty == true else {
            return
        }
        
        guard let smoke = self.model?.smoke else { return }
        var list = [String]()
        for item in smoke {
            list.append(contentsOf: item)
        }
        guard list.isEmpty == false else {
            return
        }
        
        
        let alert = RFIDTypeAlert(strings: list)
        alert.selectedContent = model?.carefully?.darkalmost ?? ""
        alert.selectedBlock = { [weak self] content in
            self?.IDView.fill(content)
            self?.cardView.image = ("ID_type_" + content).image
            self?.uploadAnalysis(type: .IDType)
        }
        alert.show(on: self.view)
    }
    
    
    func scrollToBottom(scrollView: UIScrollView) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}

 

