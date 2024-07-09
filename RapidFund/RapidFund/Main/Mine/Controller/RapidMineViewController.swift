//
//  RapidMineViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit

class RapidMineViewController: RapidBaseViewController {
    
    var viewModel: RapidMineViewModel = RapidMineViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        setupViews()
        // Do any additional setup after loading the view.
    }

}

extension RapidMineViewController {
    
    func setupViews() {
        
    }
}
