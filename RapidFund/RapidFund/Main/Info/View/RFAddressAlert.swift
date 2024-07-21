//
//  RFAddressAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import JXPagingView
import JXSegmentedView
import UIKit

class RFAddressAlert: XYZAlertView {
    var updateBlock: ((RFAddressDetail, Int) -> Void)?
    private let source: [RFAddressDetail]
    init(address: [RFAddressDetail]) {
        self.source = address
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.containerAlertViewRoundValue = 24.rf

        self.containerAlertViewMaxSize = UIScreen.main.bounds.size
        self.containerAlertView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(369.rf)
        }
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .vertical, colors: [0xe5defa.color, UIColor(rgbHex: 0xfffffff, alpha: 0.93)]))
        containerAlertView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerAlertView.addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(20.rf)
            make.right.equalToSuperview()
            make.height.equalTo(44)
        }

        containerAlertView.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom).offset(12.rf)
        }
    }

    private func getTitles() -> [String] {
        return source.map { $0.wasan }
    }

    fileprivate lazy var segmentedTitleDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = getTitles()
        dataSource.titleNormalFont = 16.font
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

    override func show(on view: UIView) {
        view.addSubview(self)
        self.backgroundColor = UIColor(rgbHex: 0x000000, alpha: 0.8)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerAlertView.transform = CGAffineTransform(translationX: 0, y: -369.rf)
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = .identity
        }
    }

    override func dismiss(withAnimation _: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = CGAffineTransform(translationX: 0, y: -369.rf)
        } completion: { _ in
            super.dismiss(withAnimation: false)
        }
    }
}

extension RFAddressAlert: JXSegmentedViewDelegate {
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

extension RFAddressAlert: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return source.count
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let container = RFAddressSubListView(address: source[index])
        container.selectedBlock = { _, _ in
        }
        return container
    }
}
