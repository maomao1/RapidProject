//
//  OtherExtension.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/18.
//

import UIKit

func executeAfter(seconds: TimeInterval, queue: DispatchQueue = DispatchQueue.main, block: @escaping () -> Void) {
    let when = DispatchTime.now() + seconds
    queue.asyncAfter(deadline: when) {
        block()
    }
}
