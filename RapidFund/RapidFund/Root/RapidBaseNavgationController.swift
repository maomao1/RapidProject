//
//  RapidBaseNavgationController.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import UIKit

class RapidBaseNavgationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.f_lightSys32,NSAttributedString.Key.foregroundColor: UIColor.c_111111], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.f_lightSys32,NSAttributedString.Key.foregroundColor: UIColor.c_111111], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.f_lightSys32,NSAttributedString.Key.foregroundColor: UIColor.c_111111], for: .selected)
        
        let navFont: UIFont = .f_lightSys32
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundEffect = nil
            navBarAppearance.shadowColor = .clear
            navBarAppearance.backgroundColor = .clear
            navBarAppearance.shadowImage = UIImage.imageWith(color: UIColor.clear)
            navBarAppearance.backgroundImage = nil
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font : navFont, NSAttributedString.Key.foregroundColor: UIColor.c_5E9F7A]
            navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationBar.standardAppearance = navBarAppearance
        } else {
            navigationBar.barTintColor = .white
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage.imageWith(color: UIColor.clear)
            navigationBar.titleTextAttributes = [NSAttributedString.Key.font : navFont, NSAttributedString.Key.foregroundColor: UIColor.c_111111]
        }
        
        interactivePopGestureRecognizer?.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
    override var childForStatusBarHidden: UIViewController? {
        if visibleViewController?.isBeingDismissed == true || visibleViewController?.navigationController?.isBeingDismissed == true {
            return viewControllers.last
        } else {
            return visibleViewController
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if let first = viewControllers.first, first != viewController {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    
}

extension RapidBaseNavgationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension RapidBaseNavgationController {
    func ydyPushViewControllerDownToUp(controller: UIViewController) {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            pushViewController(controller, animated: false)
        }
        func ydyPopViewControllerTopToBottom() {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromBottom
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            popViewController(animated: false)
        }
}
