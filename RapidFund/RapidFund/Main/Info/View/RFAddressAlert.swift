//
//  RFAddressAlert.swift
//  RapidFund
//
//  Created by C on 2024/7/11.
//

import UIKit

class RFAddressAlert: XYZAlertView {

    
    private let source:[RFAddressDetail]
    init(address:[RFAddressDetail]) {
        self.source = address
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        
        
        
    }

}
