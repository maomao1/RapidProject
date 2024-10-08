//
//  RFAddressAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import JXPagingView
import JXSegmentedView
import UIKit
import RxSwift
import RxCocoa

class RFAddressAlert: XYZAlertView {
    let bag = DisposeBag()
    var updateBlock: ((RFAddressDetail, Int, Int) -> Void)?
    private let source: [RFAddressDetail]

    private var titles = ["Choose","Choose","Choose"]
    private let childVcs:[Int:RFAddressSubListView] = [0:RFAddressSubListView(level: .level_one),1:RFAddressSubListView(level: .level_two),2:RFAddressSubListView(level: .level_three)]
    private var selectedAddress:RFAddressDetail = RFAddressDetail()
    private var selectedLevelTowIndex:Int?
    private var selectedLevelThreeIndex:Int?
   
    
    init(address: [RFAddressDetail]) {
        self.source = address
        selectedAddress = address.first!
        super.init(frame: .zero)
        setup()
        setUpRx()
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
            make.height.equalTo(429.rf)
        }
        let bgView = UIImageView(image: UIImage.image(gradientDirection: .vertical, colors: [0xe5defa.color, UIColor(rgbHex: 0xfffffff, alpha: 0.93)]))
        containerAlertView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerAlertView.addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.left.equalToSuperview()
//            make.top.equalTo(20.rf)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20.rf)
            } else {
                make.top.equalTo( 20.rf)
            }
            make.right.equalToSuperview()
            make.height.equalTo(44)
        }

        containerAlertView.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom).offset(5.rf)
            make.bottom.equalTo(-60.rf)
        }
        
        let line = UIView()
        line.backgroundColor = .c_000000.withAlphaComponent(0.05)
        containerAlertView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalTo(20.rf)
            make.right.equalTo(-20.rf)
            make.height.equalTo(0.5)
            make.bottom.equalTo(-46.5.rf)
        }
        containerAlertView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(46.rf)
            make.left.right.equalToSuperview()
        }

    }
    func setUpRx() {
        confirmButton.rx
            .tap
            .throttle(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                self.updateAddress()
                
            })
            .disposed(by: bag)
    }
    
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.c_FF7E00, for: .normal)
        button.titleLabel?.font = .f_boldSys14
//        button.backgroundColor = .c_FF7E00
        return button
    }()

    fileprivate lazy var segmentedTitleDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = titles
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
        containerAlertView.transform = CGAffineTransform(translationX: 0, y: -429.rf)
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = .identity
        }
    }

    override func dismiss(withAnimation _: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.containerAlertView.transform = CGAffineTransform(translationX: 0, y: -429.rf)
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

extension RFAddressAlert: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return titles.count
    }
    
    func getNextChildVc(level:RFAddressPageLevel)->RFAddressSubListView {
        let vc = childVcs[level.rawValue]
        return vc!
    }
    func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = childVcs[index]
        
        vc?.selectedBlock = { [weak self] indexPath, level in
            guard let self = self else { return  }
            if level == .level_one {
                self.selectedAddress = self.source[indexPath.row]
                self.getNextChildVc(level: .level_two).levelTowData = self.selectedAddress.army
                self.selectedLevelTowIndex = nil
                self.selectedLevelThreeIndex = nil
                self.titles = [self.selectedAddress.wasan, "Choose","Choose"]
                self.segmentedTitleDataSource.titles = self.titles
                self.segmentView.dataSource = self.segmentedTitleDataSource
                self.segmentView.reloadData()
                self.segmentView.selectItemAt(index: 1)
            } else if level == .level_two {
                self.getNextChildVc(level: .level_three).levelThreeData = self.selectedAddress.army[self.selectedLevelTowIndex ?? 0].army
                self.selectedLevelTowIndex = indexPath.row
                self.selectedLevelThreeIndex = nil
                self.titles = [self.selectedAddress.wasan, self.selectedAddress.army[self.selectedLevelTowIndex ?? 0].wasan,"Choose"]
                self.segmentedTitleDataSource.titles = self.titles
                self.segmentView.dataSource = self.segmentedTitleDataSource
                self.segmentView.reloadData()
                self.segmentView.selectItemAt(index: 2)
                
            } else {
                self.selectedLevelThreeIndex = indexPath.row
                self.titles = [self.selectedAddress.wasan, self.selectedAddress.army[self.selectedLevelTowIndex ?? 0].wasan,self.getNextChildVc(level: .level_three).levelThreeData[self.selectedLevelThreeIndex ?? 0].wasan]
                self.segmentedTitleDataSource.titles = self.titles
                self.segmentView.dataSource = self.segmentedTitleDataSource
                self.segmentView.reloadData()
//                self.updateAddress()
            }
        }
        if index == RFAddressPageLevel.level_one.rawValue {
            vc?.levelOneData = source
        }
        return vc!
    }
    
    private func updateAddress() {
        guard let selectedLevelTowIndex = selectedLevelTowIndex else { return  }
        guard let selectedLevelThreeIndex = selectedLevelThreeIndex else { return  }
        self.updateBlock?(self.selectedAddress, selectedLevelTowIndex, selectedLevelThreeIndex)
        self.dismiss(withAnimation: true)
    }
}
