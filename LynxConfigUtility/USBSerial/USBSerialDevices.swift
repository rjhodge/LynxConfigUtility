//
//  USBSerialDevices.swift
//  LynxConfigUtility
//
//  Created by Richard Hodge on 12/25/17.
//  Copyright © 2017 Binary Platypus Software. All rights reserved.
//

import Cocoa
import IOKit
import IOKit.serial

class USBSerialDevices: NSObject {

    private class func findSerialDevices(deviceType: String, serialPortIterator: inout io_iterator_t ) -> kern_return_t {
        var result: kern_return_t = KERN_FAILURE
        if let classesToMatch = IOServiceMatching(kIOSerialBSDServiceValue) {
            if var classesToMatchDict = (classesToMatch as NSDictionary) as? Dictionary<String, Any> {
                classesToMatchDict[kIOSerialBSDTypeKey] = deviceType
                let classesToMatchCFDictRef = (classesToMatchDict as NSDictionary) as CFDictionary
                result = IOServiceGetMatchingServices(kIOMasterPortDefault, classesToMatchCFDictRef, &serialPortIterator)
            }
        }
        return result
    }

    private class func printSerialPaths(portIterator: io_iterator_t) {
        var serialService: io_object_t
        repeat {
            serialService = IOIteratorNext(portIterator)
            if (serialService != 0) {
                let key: CFString! = "IOCalloutDevice" as CFString
                let bsdPathAsCFtring: AnyObject? = IORegistryEntryCreateCFProperty(serialService, key, kCFAllocatorDefault, 0).takeUnretainedValue()
                if let path = bsdPathAsCFtring as? String {
                    print(path)
                }
            }
        } while serialService != 0;
    }

    private class func getSerialPaths(portIterator: io_iterator_t) -> [String] {
        var serialService: io_object_t
        var paths: [String] = []
        repeat {
            serialService = IOIteratorNext(portIterator)
            if (serialService != 0) {
                let key: CFString! = "IOCalloutDevice" as CFString
                let bsdPathAsCFtring: AnyObject? = IORegistryEntryCreateCFProperty(serialService, key, kCFAllocatorDefault, 0).takeUnretainedValue()
                if let path = bsdPathAsCFtring as? String, path.lowercased().range(of:"usb") != nil {
                    paths.append(path)
                }
            }
        } while serialService != 0;
        return paths
    }

    class func getDevices() -> [String] {
        var portIterator: io_iterator_t = 0
        let kernResult = findSerialDevices(deviceType: kIOSerialBSDRS232Type, serialPortIterator: &portIterator)
        if kernResult == KERN_SUCCESS {
            return getSerialPaths(portIterator: portIterator)
        } else {
            return []
        }
    }
}
