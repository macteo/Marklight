//
//  String+SubstringWithNSRange.swift
//  Markit-Sample
//
//  Created by Matteo Gavagnin on 30/08/2017.
//  Copyright © 2017 Dolomate. All rights reserved.
//

import Foundation

extension String {
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
    
    func removeTrailingNewline() -> String {
        var newString = self
        if newString.hasSuffix("\n") {
            newString.removeLast()
        } else {
            return newString
        }
        return newString.removeTrailingNewline()
    }
}

// TODO: create separate file
extension NSAttributedString {
    var trailingNewlineChopped: NSAttributedString {
        if string.hasSuffix("\n") {
            let choppedString =  self.attributedSubstring(from: NSMakeRange(0, length - 1))
            return choppedString.trailingNewlineChopped
        } else {
            return self
        }
    }
}

extension NSRange {
    func removePrefix(range: NSRange, padding: Int = 0) -> NSRange {
        let reducedRange = NSMakeRange(location + range.length + padding, length - range.length - padding)
        return reducedRange
    }
    
    func removeSuffix(range: NSRange, padding: Int = 0) -> NSRange {
        let reducedRange = NSMakeRange(location, length - range.length - padding)
        return reducedRange
    }
    
    func shift(_ padding: Int) -> NSRange {
        let shiftedRange = NSMakeRange(location - padding, length)
        return shiftedRange
    }
}
