//
//  Data+Utilities.swift
//  LynxConfigUtility
//
//  Created by Richard Hodge on 12/26/17.
//  Copyright © 2017 Binary Platypus Software. All rights reserved.
//

import Cocoa

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
