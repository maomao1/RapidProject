//
//  MBProgressHUDExtension.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/8.
//

import Foundation
import MBProgressHUD
import SnapKit
// import Lottie
import UIKit

let loadingMessage = "loading..."

// MARK: - 添加属性

extension MBProgressHUD {
    enum LoadingType {
        case toast // toast 穿透hud可点击
        case loading // 加载中
    }
    
    private enum AssociatedKeys {
        static var loadingTypeKey: LoadingType?
    }
    
    var loadingType: LoadingType? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingTypeKey) as? LoadingType
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingTypeKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        guard let hud = hitView?.superview as? MBProgressHUD else { return hitView }
        if hitView is MBBackgroundView,
           hud.loadingType == .toast
        {
            return nil
        }
        return hitView
    }
    
    static func viewToShow() -> UIView {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != .normal {
            let windows = UIApplication.shared.windows
            for w in windows {
                if w.windowLevel == .normal {
                    window = w
                    break
                }
            }
        }
        return window!
    }
}

// MARK: - 文本TOAST

extension MBProgressHUD {
    enum Autolayout {
        static let hudMaxWidth = 270.rf
        static let hudMinWidth = 70.rf
        static let hudContentMaxWidth = 240.rf
    }
    
    static func showError(_ error: String?, to view: UIView? = nil) {
        guard let error = error else { return }
        display(message: error, toView: view, withIcon: nil, forDuration: 1)
    }
    
    static func showSuccess(_ success: String, to view: UIView? = nil) {
        display(message: success, toView: view, withIcon: nil, forDuration: 1)
    }
    
    static func showMessage(_ text: String, toview view: UIView?, afterDelay delay: TimeInterval) {
        display(message: text, toView: view, withIcon: nil, forDuration: delay)
    }
    
    static func display(message: String, toView view: UIView?, withIcon icon: UIImage?, forDuration duration: TimeInterval) {
        guard !message.trim().isEmpty else {
            return
        }
        let parentView: UIView
        if view == nil {
            guard let view = UIApplication.shared.keyWindow else {
                return
            }
            parentView = view
        } else {
            parentView = view!
        }
        if let first = parentView.subviews.first(where: { $0 is MBProgressHUD }) {
            first.removeFromSuperview()
        }
        let hud = MBProgressHUD(view: parentView)
        hud.loadingType = .toast
        hud.mode = .customView
        let customView = customViewByMessage(message: message)
        hud.customView = customView
        hud.minSize = customView.bounds.size
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.8)
        hud.bezelView.layer.cornerRadius = 11
        hud.removeFromSuperViewOnHide = true
        parentView.addSubview(hud)
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: duration)
    }
    
    static func customViewByMessage(message: String) -> UIView {
        let hudToastLabFont = UIFont.f_lightSys16
        
        let containerView = UIView()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        style.alignment = .center
        let messageWidth = message.width(font: hudToastLabFont, paraStyle: style)
        let messageHeight = message.heightWithConstrainedWidth(width: Autolayout.hudContentMaxWidth, font: hudToastLabFont, paraStyle: style)
        let containerHeight = ((messageHeight + 46.rf) > 70.rf) ? (messageHeight + 46.rf) : 70.rf
        containerView.frame = CGRect(x: 0, y: 0, width: 270.rf, height: containerHeight)
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.attributedText = message.transformToAttributedText(color: .white, font: hudToastLabFont, lineSpacing: 6, alignment: .center)
        lab.lineBreakMode = .byWordWrapping
        containerView.addSubview(lab)
        lab.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(messageWidth > Autolayout.hudContentMaxWidth ? 0 : 3.rf)
            make.centerX.equalToSuperview()
            make.width.equalTo(240.rf)
        }
        return containerView
    }
    
//    static func showLoading() {
//
//        guard let view = UIApplication.shared.keyWindow else {
//            return
//        }
//        if let first = view.subviews.first(where: { $0 is MBProgressHUD } ) {
//            first.removeFromSuperview()
//        }
//        let hud = MBProgressHUD.showAdded(to: view, animated: true)
//        hud.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
//
//        view.addSubview(hud)
//        hud.show(animated: true)
//
//    }
}

// loading
extension MBProgressHUD {
   static func showLoading(msg: String?, inView: UIView?) {
        let hud = createMBProgressHUDView(msg: msg, inView: inView)
        hud?.mode = .indeterminate
        hud?.graceTime = 0
        hud?.show(animated: true)
    }
    
   static func hideAllHUD(for view: UIView?) {
        let tar_view = view != nil ? view : UIApplication.shared.delegate?.window as? UIView
        guard let tar_view = tar_view else { return }
        MBProgressHUD.hide(for: tar_view, animated: true)
    }
    
    private static func createMBProgressHUDView(msg: String?, inView: UIView?) -> MBProgressHUD? {
        let view = inView != nil ? inView : UIApplication.shared.delegate?.window as? UIView
        guard let view = view else { return nil }
        hideAllHUD(for: view)
        let hud = MBProgressHUD(view: view)
        hud.label.text = msg
        hud.label.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
        hud.margin = 15
        hud.label.font = 15.fontMedium
        hud.isUserInteractionEnabled = true
        hud.contentColor = .white
        hud.bezelView.style = .solidColor
        hud.bezelView.color = .black.withAlphaComponent(0.75)
        hud.bezelView.layer.cornerRadius = 12
        view.addSubview(hud)
        return hud
    }
}

// MARK: - JSON动画HUD

extension MBProgressHUD {}

// MARK: - 扩展UIViewController

extension UIViewController {
    private enum AssociatedKeys {
        static var loadingViewKey: MBProgressHUD?
    }
    
    var loadingView: MBProgressHUD? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingViewKey) as? MBProgressHUD
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
//     显示
    @discardableResult
//    全局通用loading
    func showLoading() {
        guard let view = self.view else {
            return
        }
        if let first = view.subviews.first(where: { $0 is MBProgressHUD }) {
            first.removeFromSuperview()
        }
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        
        view.addSubview(hud)
        hud.show(animated: true)
    }
    
//     隐藏
    func hiddenLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
