//
//  MarklightStyleApplier
//  Marklight
//
//  Created by Christian Tietze on 2017-07-20.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

public protocol MarklightStyleApplier {
    func addAttribute(_ name: String, value: Any, range: NSRange)
    func addAttributes(_ attrs: [String : Any], range: NSRange)
    func removeAttribute(_ name: String, range: NSRange)
    func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange)
}

extension NSTextStorage: MarklightStyleApplier {
    public func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange) {
        self.removeAttribute(NSForegroundColorAttributeName, range: range)
        self.addAttribute(NSFontAttributeName, value: MarklightFont.systemFont(ofSize: textSize), range: range)
        self.addAttribute(NSParagraphStyleAttributeName, value: NSParagraphStyle(), range: range)
    }
}

