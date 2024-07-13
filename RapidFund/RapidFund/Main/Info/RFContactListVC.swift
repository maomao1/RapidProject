//
//  RFContactListVC.swift
//  RapidFund
//
//  Created by C on 2024/7/12.
//

import UIKit

class RFContactListVC: RapidBaseViewController {

    
    private let tb = UITableView(frame: .zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        view.bringSubviewToFront(self.customNavView)
        titleNav.text = "Contact Information"
        setNavImageTitleWhite(isWhite: true)
        rightBtn.isHidden = true
        
    }
    
    private func setup() {
        let bgView = UIImageView(image: "contact_bg".image)
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let topview = UIImageView(image: "contact_top".image)
        view.addSubview(topview)
        topview.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(303.rf)
        }
        tb.dataSource = self
        tb.delegate = self
        tb.register(RFContactCell.self, forCellReuseIdentifier: "RFContactCell")
        tb.backgroundColor = .clear
        tb.showsVerticalScrollIndicator = false
        tb.separatorStyle = .none
        tb.rowHeight = 168.rf
        view.addSubview(tb)
        tb.contentInsetAdjustmentBehavior = .never
        tb.contentInset = UIEdgeInsets(top: 268.rf, left: 0, bottom: 0, right: 0)
        tb.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 24.rf, bottom: 0, right: 24.rf))
        }
        tb.contentOffset = CGPoint(x: 0, y: -268.rf)
        
        
        
    }

   

}

extension RFContactListVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.rf
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 48.rf, height: 12.rf))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RFContactCell", for: indexPath) as! RFContactCell
        return cell
    }
}
