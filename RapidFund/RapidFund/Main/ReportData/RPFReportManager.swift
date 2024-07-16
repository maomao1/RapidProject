//
//  RPFReportManager.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/15.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa
class RPFReportManager: NSObject {
    private override init() {}
    static let shared = RPFReportManager()
    let bag = DisposeBag()
}
