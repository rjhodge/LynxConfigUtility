//
//  String+Utilities.swift
//  LynxConfigUtility
//
//  Created by Richard Hodge on 12/26/17.
//  Copyright © 2017 Binary Platypus Software. All rights reserved.
//

import Cocoa

extension String {
    func dataWithHexString() -> Data {
        var hex = self
        var data = Data()
        while(hex.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}
