//
//  MarklightStyleApplier
//  Marklight
//
//  Created by Christian Tietze on 2017-07-20.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

import Foundation
import CoreGraphics

public protocol MarklightStyleApplier {
    func addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange)
    func addAttributes(_ attrs: [NSAttributedString.Key : Any], range: NSRange)
    func removeAttribute(_ name: NSAttributedString.Key, range: NSRange)
    func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange)
}
