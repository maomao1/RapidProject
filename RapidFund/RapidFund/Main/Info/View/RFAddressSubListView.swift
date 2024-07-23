//
//  RFAddressSubListView.swift
//  RapidFund
//
//  Created by C on 2024/7/21.
//

import UIKit
import SnapKit
import JXSegmentedView

class RFAddressCell:UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selected_add:Bool = false {
        didSet {
            self.selBgView.isHidden = !selected_add
        }
    }
    
    let titleLb = UILabel().font(14.font).textColor(0x111111.color)
    private let selBgView = UIView()
    private func setup() {
        selectionStyle = .none
        self.backgroundColor = .clear
        selBgView.backgroundColor = .clear
        selBgView.clipsCornerRadius(Float(10.rf))
        selBgView.backgroundColor = UIColor(rgbHex: 0x000000,alpha: 0.05)
        contentView.addSubview(selBgView)
        selBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        self.selectedBackgroundView = view
        self.contentView.addSubview(self.titleLb)
        titleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12.rf)
        }
    }
    
}

enum RFAddressPageLevel:Int {
    case level_one = 0
    case level_two = 1
    case level_three = 2
}

class RFAddressSubListView: UIViewController {
    private let level:RFAddressPageLevel
    var selectedBlock:((IndexPath, RFAddressPageLevel)->Void)?
    var levelOneData:[RFAddressDetail] = [] {
        didSet {
            tb.reloadData()
        }
    }
    var levelTowData:[RFAddressDetail.__ShedidItem] = [] {
        didSet {
            tb.reloadData()
        }
    }
    var levelThreeData:[RFAddressDetail.__ShedidSubItem] = [] {
        didSet {
            tb.reloadData()
        }
    }
    init(level:RFAddressPageLevel) {
        self.level = level
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    private var selectedIndexPath:IndexPath?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let tb = UITableView(frame: .zero, style: .plain)
    private func setup() {
        self.view.backgroundColor = .clear
        tb.backgroundColor = .clear
        tb.rowHeight = 40
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.contentInsetAdjustmentBehavior = .never
        tb.register(RFAddressCell.self, forCellReuseIdentifier: "RFAddressCell")
        self.view.addSubview(tb)
        tb.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 12.rf, bottom: 0, right: 12.rf))
            make.width.equalTo(kScreenWidth - 24.rf)
        }
        
    }

}

extension RFAddressSubListView:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if level == .level_one {
            return levelOneData.count
        }
        if level == .level_two {
            return levelTowData.count
        }
        return levelThreeData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return  nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RFAddressCell", for: indexPath) as! RFAddressCell
        let text:String?
        if level == .level_one {
            text = levelOneData[indexPath.row].wasan
        } else if level == .level_two {
            text = levelTowData[indexPath.row].wasan
        } else {
            text = levelThreeData[indexPath.row].wasan
        }
        cell.titleLb.text = text
        if selectedIndexPath?.row == indexPath.row {
            cell.selected_add = true
        } else {
            cell.selected_add = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath, indexPath == selectedIndexPath {
            return
        }
        self.selectedIndexPath = indexPath
        self.tb.reloadData()
        self.selectedBlock?(indexPath, self.level)
    }
}

extension RFAddressSubListView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        self.view
    }
}
