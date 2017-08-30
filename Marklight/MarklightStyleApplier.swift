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
    func addAttribute(_ name: NSAttributedStringKey, value: Any, range: NSRange)
    func addAttributes(_ attrs: [NSAttributedStringKey : Any], range: NSRange)
    func removeAttribute(_ name: NSAttributedStringKey, range: NSRange)
    func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange)
}
