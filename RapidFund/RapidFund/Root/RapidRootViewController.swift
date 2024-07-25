//
//  RapidRootViewController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD
import ContactsUI



class RapidRootViewController: UITabBarController {
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRootView()
        setUpRx()
        self.delegate = self
#if DEBUG
        setUpDebugView()
#endif
        uploadLocation()
        // Do any additional setup after loading the view.
    }
    
    
   
    
}

extension RapidRootViewController {
    
    func uploadLocation() {
        guard !GetInfo(kRapidSession).isEmpty else{
            return
        }
        
        RPFLocationManager.manager.locationInfoHandle = { (country, code, province, city,street,latitude,longitude, item) in
            var param: [String : Any] = [String : Any]()
            param["aface"] = province
            param["curls"] = code
            param["untidy"] = country
            param["creature"] = street
            param["whichever"] = longitude
            param["scampering"] = latitude
            param["lambgambolling"] = city
            param["towards"] = getRPFRandom()
            param["skipping"] = getRPFRandom()
            RPFReportManager.shared.saveLocation(para: param)
            RPFReportManager.shared.saveDeviceInfo()
        }
    }
    
    func setUpRootView() {
//        self.tabBar.isTranslucent = true
        let homeVC = RapidHomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "", image: .rapidHomeNormal.withRenderingMode(.alwaysOriginal), selectedImage: .rapidHomeSelected.withRenderingMode(.alwaysOriginal))
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.rf, left: 0, bottom: 0, right: 0)
        let homeNVC = RapidBaseNavgationController(rootViewController: homeVC)
        
        let orderVC = RapidOrderViewController()
        orderVC.tabBarItem = UITabBarItem(title: "", image: .rapidOrderNormal.withRenderingMode(.alwaysOriginal), selectedImage: .rapidOrderSelected.withRenderingMode(.alwaysOriginal))
        orderVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.rf, left: 0, bottom: 0, right: 0)

        let orderNVC = RapidBaseNavgationController(rootViewController: orderVC)
        
        let mineVC = RapidMineViewController()
        mineVC.tabBarItem = UITabBarItem(title: "", image: .rapidMineNormal.withRenderingMode(.alwaysOriginal), selectedImage: .rapidMineSelected.withRenderingMode(.alwaysOriginal))
        mineVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10.rf, left: 0, bottom: 0, right: 0)

        let mineNVC = RapidBaseNavgationController(rootViewController: mineVC)
        
        viewControllers = [homeNVC, orderNVC, mineNVC]
        viewControllers?.forEach({ (vc) in
            vc.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
            
        })
        
        
        //iOS 13.0 tabbar兼容适配
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .white
            //tabbar顶部线颜色
            appearance.shadowColor = .white.withAlphaComponent(0.5)
            appearance.shadowImage = UIImage.imageWith(color: .white.withAlphaComponent(0.5), size: CGSize(width: kPortraitScreenW, height: RapidMetrics.separatorThickness))
            appearance.selectionIndicatorTintColor = nil
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.c_FFA83E, .font: UIFont.f_boldSys15]
//            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.c_666666, .font: UIFont.f_regSys15]
//            
            self.tabBar.standardAppearance = appearance
            /// iOS 15兼容适配
            if #available(iOS 15.0, *) {
                self.tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            UITabBar.appearance().backgroundColor = .white
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().shadowImage = UIImage.imageWith(color: .black.withAlphaComponent(0.04), size: CGSize(width: kPortraitScreenW, height: RapidMetrics.separatorThickness))
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.c_FFA83E, .font: UIFont.f_boldSys15], for: .selected)
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.c_666666, .font: UIFont.f_regSys15], for: .normal)
        }
        tabBar.layer.masksToBounds = true
        tabBar.layer.shadowColor = UIColor.white.withAlphaComponent(0.5).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = 11.rf
//        tabBar.layer.masksToBounds = true
//        tabBar.layer.cornerRadius = 40.rf
        
        tabBar.layer.mask = tabBar.configRectCorner(corner: [.topLeft, .topRight], radii: CGSize(width: 48.rf, height: 48.rf))
        
//        selectedIndex = 0
    }
    
    override var selectedIndex: Int {
        didSet {
            
        }
    }
}

//MARK: - 监听
extension RapidRootViewController{
    fileprivate func setUpRx(){
        NotificationCenter.default
            .rx.notification(.RapidLogoutSuccess)
            .subscribe(onNext: { [weak self] (notification) in
                guard let `self` = self else {return}
                RapidUserCache.default.clearUserInfo()
                self.selectedIndex = 0
            })
            .disposed(by: bag)
        
        NotificationCenter.default
            .rx.notification(.RapidLogoffSuccess)
            .subscribe(onNext: { [weak self] (notification) in
                guard let `self` = self else {return}
                
            })
            .disposed(by: bag)
        
        //重新登录逻辑
        RPFAPIInterceptor.shared
            .needLogin
            .subscribe {[weak self] _ in
                guard let `self` = self else {return}
                self.showAlertView()
            }
            .disposed(by: bag)
    }
    
    
    func showAlertView() {
        MBProgressHUD.showMessage("Account has expired, please log in again", toview: nil, afterDelay: 3)
        RapidUserCache.default.clearUserInfo()
        executeAfter(seconds: 1) { [weak self] in
            self?.presentLogin()
        }

    }
    
    func presentLogin() {
        let vc = RapidLoginViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
}

extension RapidRootViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        let childsVc = tabBarController.viewControllers! as NSArray
        let index = childsVc.index(of: viewController)
        if index == 0 {
            return true
        }else {
            if !GetInfo(kRapidSession).isEmpty {
                return true
            }else{
//                let vc = RapidLoginViewController()
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true)
                self.presentLogin()
                return false 
            }
        }
//        guard  index != 0 && GetInfo(RapidSession).isEmpty else {
//            let vc = RapidLoginViewController()
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
//            return false
//        }
//        return true
    }
}

//MARK: - debugView
extension RapidRootViewController {
    
    private func setUpDebugView() {
        
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .red.withAlphaComponent(0.6)
        button.setTitle("debug", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = false
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.bottom.equalTo(-80)
            make.width.equalTo(60)
            make.height.equalTo(45)
        }
        
        button.rx
            .tap
            .throttle(.seconds_0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else {return}
                self.buttonAction()
            })
            .disposed(by: bag)

    }
    
    func buttonAction() {
        
        guard let nc = selectedViewController as? RapidBaseNavgationController else {
            return
        }
       
       

////        let vc = RFPInVC(route: .employment_info, productId: "1")
//        
//        let vc = RFContactListVC( productId: "1", orderId: "1")
//        nc.pushViewController(vc, animated: true)
//=======
        requestBindBankInfo("1", nc.topViewController!)
//        test()
//        let vc = RFPInVC(route: .employment_info, productId: "1")
//        let vc = RFContactListVC( productId: "1")
//        nc.pushViewController(vc, animated: true)
//        let vc = RFBankCardListVC(orderId: "", productId: "1")
//        nc.pushViewController(vc, animated: true)
    }
    

    private func test() {
        
//        RapidApi.shared.getBindCardInfo(para: ["whisked": "0", "frisked": getRPFRandom()]).subscribe(onNext: { [weak self] obj in
//            guard let model = RFBankCfg.deserialize(from: obj.dictionaryObject) else { return }
//            guard let self = self else { return }
//            let alert = RFBankMgrAlert(config: model, product_id: "1", orderId: "1")
//            alert.show(on: self.view)
//        }, onError: { err in
//            MBProgressHUD.showError(err.localizedDescription)
//        })
    }

    
    
    
    
   
   
    
}

