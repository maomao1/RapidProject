//
//  RFBankMgrAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import JXPagingView
import JXSegmentedView
import MBProgressHUD
import UIKit


func requestBindBankInfo(_ productId: String, _ orderId: String,  _ vc: UIViewController) {
    RapidApi.shared.getBindCardInfo(para: ["whisked": "0", "frisked": getRPFRandom()]).subscribe(onNext: { obj in
        guard let model = RFBankCfg.deserialize(from: obj.dictionaryObject) else { return }
        let bankVc = RFBankMgrVc(config: model, product_id: productId, order_id: orderId)
        vc.navigationController?.pushViewController(bankVc, animated: true)
    }, onError: { err in
        MBProgressHUD.showError(err.localizedDescription)
    })
}

class RFBankMgrVc: RapidBaseViewController {
    private let cfg: RFBankCfg
    private let productId: String
    private let orderId: String
    init(config: RFBankCfg, product_id: String, order_id: String) {
        self.cfg = config
        self.productId = product_id
        self.orderId = order_id
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.view.bringSubviewToFront(self.customNavView)
        self.rightBtn.isHidden = true
        removeLastVC()
    }
    
    private func getTitles() -> [String] {
        var titls = [String]()
        cfg.munched.forEach { m in
            titls.append(m.hastily)
        }
        
        return titls
    }
    
    private func setup() {
        view.backgroundColor = .white
//        setNavImageTitleWhite(isWhite: false)
//        self.setLeftBarButtonItem(image: "bank_page_back".image!)
        self.backBtn.setImage("bank_page_back".image, for: .normal)
        
        self.customNavView.addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.centerY.equalTo(self.backBtn.snp.centerY)
            make.left.equalTo(self.backBtn.snp.right).offset(5.rf)
            make.width.equalTo(kScreenWidth - 120.rf)
        }
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.customNavView.snp.bottom)
        }
    }
     
    fileprivate lazy var segmentedTitleDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = getTitles()
        dataSource.titleNormalFont = 26.font
        dataSource.titleSelectedColor = 0x111111.color
        dataSource.titleNormalColor = UIColor(rgbHex: 0x111111, alpha: 0.23)
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
        let segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 120.rf, height: CGFloat(44)))
        segmentedView.backgroundColor = UIColor.clear
        segmentedView.dataSource = self.segmentedTitleDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.listContainer = self.listContainerView
        segmentedView.delegate = self
//        segmentedView.contentEdgeInsetLeft = 24

        let imageView = JXSegmentedIndicatorLineView(color: 0x111111.color)
        imageView.indicatorColor = 0x111111.color
        imageView.indicatorWidth = 42.rf
        imageView.indicatorHeight = 1
        imageView.verticalOffset = 1

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
}

extension RFBankMgrVc: JXSegmentedViewDelegate {
    /// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_: JXSegmentedView, didSelectedItemAt _: Int) {}
    
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

extension RFBankMgrVc: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return cfg.munched.count
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let model = self.cfg.munched[index]
        return RFBankBindVC(bankCategory: model.getCardType(), data: model, productId: productId, dismad: model.dismay, orderId: orderId)
    }
}
