//
//  NSString+paragraphRangeAt.swift
//  Marklight
//
//  Created by Christian Tietze on 20.07.17.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation

extension NSString {
    func paragraphRange(at location: Int) -> NSRange {
        return paragraphRange(for: NSRange(location: location, length: 0))
    }
}
