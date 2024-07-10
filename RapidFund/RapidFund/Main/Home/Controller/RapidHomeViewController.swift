//
//  RapidHomeViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD
class RapidHomeViewController: RapidBaseViewController {
    
    // MARK: - Properties
//    let bag = DisposeBag()
    
    var viewModel: RapidHomeViewModel = RapidHomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        self.titleNav.text = "Hello User"
        viewModel.getData()
        setBackBtnHidden()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.navigationController?.pushViewController(RFFlowVC(), animated: true)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
