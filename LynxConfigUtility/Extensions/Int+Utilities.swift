//
//  Int+Utilities.swift
//  LynxConfigUtility
//
//  Created by Richard Hodge on 12/26/17.
//  Copyright © 2017 Binary Platypus Software. All rights reserved.
//

import Cocoa

extension Int {
    func toHexString(bytes: Int = 2) -> String {
        let hex = String(format:("%0\(bytes)X"), self)
        return hex
    }
}
