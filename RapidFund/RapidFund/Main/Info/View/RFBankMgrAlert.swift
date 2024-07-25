//
//  RFBankMgrAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import UIKit
import JXSegmentedView
import JXPagingView

class RFBankMgrAlert: XYZAlertView {
    private let cfg:RFBankCfg
    private let productId:String
    private let orderId:String
    init(config: RFBankCfg, product_id:String, orderId: String) {
        self.cfg = config
        self.productId = product_id
        self.orderId = orderId
        super.init(frame: .zero)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getTitles() -> [String] {
        var titls = [String]()
        cfg.munched.forEach { m in
            titls.append(m.hastily)
        }
        
        return titls
    }
    
    private let topView = UIView()
    private func setup() {
        self.backgroundColor = UIColor(rgbHex: 0x000000,alpha: 0.8)
        containerAlertView.backgroundColor = .clear
        containerAlertViewMaxSize = UIScreen.main.bounds.size
        containerAlertView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 4.5.rf, left: 0, bottom: 0, right: 0))
        }
        containerAlertView.addSubview(topView)
        topView.backgroundColor = .white
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(200)
        }
        let backBtn = UIButton(type: .custom)
        backBtn.setImage("bank_page_back".image, for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        containerAlertViewRoundValue = 24.rf
        containerAlertView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(50.rf)
            make.top.equalTo(27.rf)
            make.left.equalTo(24.rf)
        }
        
        containerAlertView.addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(10.rf)
        }
        containerAlertView.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
        }
    }
     
    fileprivate lazy var segmentedTitleDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = getTitles()
        dataSource.titleNormalFont = 16.font
        dataSource.titleSelectedColor = 0x111111.color
        dataSource.titleNormalColor = UIColor(rgbHex: 0x111111,alpha: 0.23)
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleStrokeWidthEnabled = true
        dataSource.titleSelectedStrokeWidth = -4
//        dataSource.isTitleZoomEnabled = true
//        dataSource.titleSelectedZoomScale = 1.5

        dataSource.isSelectedAnimable = true
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.itemSpacing = 20
        return dataSource
    }()

    private lazy var segmentView: JXSegmentedView = {
        let segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: CGFloat(44)))
        segmentedView.backgroundColor = UIColor.clear
        segmentedView.dataSource = self.segmentedTitleDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.listContainer = self.listContainerView
        segmentedView.delegate = self
        segmentedView.contentEdgeInsetLeft = 24

        let imageView = JXSegmentedIndicatorLineView(color: 0x111111.color)
        
        imageView.indicatorWidth = 42.rf
        imageView.indicatorHeight = 1
        imageView.verticalOffset = -1

        
        segmentedView.indicators = [imageView]

        return segmentedView
    }()

    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        view.defaultSelectedIndex = 0
        view.backgroundColor = .clear
        view.backgroundColor = .clear
        view.listCellBackgroundColor = .clear
        return view
    }()
    
    @objc private func backAction() {
        dismiss(withAnimation: true)
    }
    override func show(on view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerAlertView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kScreenHeight)
        }
        containerAlertView.transform = CGAffineTransform(translationX: 0, y: -kScreenHeight)
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = .identity
        }
    }

    override func dismiss(withAnimation animation: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = CGAffineTransform(translationX: 0, y: -kScreenHeight)
        } completion: { _ in
            super.dismiss(withAnimation: false)
        }
    }
}

extension RFBankMgrAlert:JXSegmentedViewDelegate {
    
    
    /// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
    
    /// 点击选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_: JXSegmentedView, didClickSelectedItemAt _: Int) {}
    
    /// 滚动选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_: JXSegmentedView, didScrollSelectedItemAt _: Int) {}
    
    /// 正在滚动中的回调
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - leftIndex: 正在滚动中，相对位置处于左边的index
    ///   - rightIndex: 正在滚动中，相对位置处于右边的index
    ///   - percent: 从左往右计算的百分比
    func segmentedView(_: JXSegmentedView, scrollingFrom _: Int, to _: Int, percent _: CGFloat) {}
    
    /// 是否允许点击选中目标index的item
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 目标index
    func segmentedView(_: JXSegmentedView, canClickItemAt _: Int) -> Bool {
        return true
    }
}

extension RFBankMgrAlert: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return cfg.munched.count
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let model = self.cfg.munched[index]
        return RFBankBindVC(bankCategory: model.getCardType(), data: model, productId: productId, dismad: model.dismay, orderId: orderId)
    }
}
