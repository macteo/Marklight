//
//  UniversalTypes.swift
//  Marklight
//
//  Created by Christian Tietze on 20.07.17.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

#if os(iOS)
    import UIKit

    typealias MarklightColor = UIColor
    typealias MarklightFont = UIFont
    typealias MarklightFontDescriptor = UIFontDescriptor
#elseif os(macOS)
    import AppKit


    typealias MarklightColor = NSColor
    typealias MarklightFont = NSFont
    typealias MarklightFontDescriptor = NSFontDescriptor

    extension NSFont {
        static func italicSystemFont(ofSize size: CGFloat) -> NSFont {
            return NSFontManager().convert(NSFont.systemFont(ofSize: size), toHaveTrait: .italicFontMask)
        }
    }
#endif
