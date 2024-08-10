//
//  AppDelegate.swift
//  RapidFund
//
//  Created by 毛亚恒 on  2024/7/8.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let bag = DisposeBag()
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpRootVC()
        setUIAttribute()
        uploadReport()
        observeMemory()
        registerKeyBoard()
        
        return true
    }
    

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

extension AppDelegate {
    func setUpRootVC() {
//        let vc = ViewController()
        window?.backgroundColor = .white
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = RapidRootViewController()
        window?.makeKeyAndVisible()
    }
    
    //MARK: - 配置UI属性
    func setUIAttribute() {
        let tableViewAppearance = UITableView.appearance()
//        let scrollViewApperance = UIScrollView.appearance()
        

        tableViewAppearance.tableFooterView = UIView()
        tableViewAppearance.separatorColor = .black.withAlphaComponent(0.08)
        if #available(iOS 11.0, *) {
            tableViewAppearance.contentInsetAdjustmentBehavior = .never
            tableViewAppearance.estimatedSectionFooterHeight = 0
            tableViewAppearance.estimatedSectionHeaderHeight = 0
            tableViewAppearance.estimatedRowHeight = 0
//            scrollViewApperance.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            tableViewAppearance.sectionHeaderTopPadding = 0.f
        }
    }
    
    //开启IQKeyboardManager
    func registerKeyBoard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.placeholderFont = .f_lightSys14
        IQKeyboardManager.shared.toolbarDoneBarButtonItemImage = UIImage.textToImage(text: "Done", font: .f_boldSys16)
//        IQKeyboardManager.shared.toolbarTintColor = .c_FF942F
//        IQToolbarHandler.titleFont = .f_boldSys15
//        IQTitleBarButtonItem.titleFont = .f_boldSys15
//        IQKeyboardManager.shared.to

    }
    
    func uploadReport() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized{
                    RPFReportManager.shared.saveGoogleMarket()
                }
            }
        } else {
            RPFReportManager.shared.saveGoogleMarket()
        }
    }
    
    
    
    
    
    //监听内存
    func observeMemory() {
        #if DEBUG
        Observable<Int>
            .interval(.seconds_1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (_) in
                print("RxSwift resource count is \(RxSwift.Resources.total)")
            })
            .disposed(by: bag)
        #endif
    }
}
