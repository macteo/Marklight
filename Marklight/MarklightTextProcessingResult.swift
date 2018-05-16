//
//  MarklightTextProcessingResult
//  Marklight
//
//  Created by Christian Tietze on 2017-07-20.
//  Copyright © 2017 MacTeo. See LICENSE for details.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Foundation
    import AppKit
#endif

public struct MarklightProcessingResult {
    public let editedRange: NSRange
    public let affectedRange: NSRange

    public init(editedRange: NSRange, affectedRange: NSRange) {

        self.editedRange = editedRange
        self.affectedRange = affectedRange
    }

    public func updateLayoutManagers(for textStorage: NSTextStorage) {

        textStorage.layoutManagers.forEach {
            $0.processEditing(
                for: textStorage,
                processingResult: self)
        }
    }
}

extension NSLayoutManager {
    func processEditing(for textStorage: NSTextStorage, processingResult: MarklightProcessingResult) {

        self.processEditing(
            for: textStorage,
            edited: .editedAttributes,
            range: processingResult.editedRange,
            changeInLength: 0,
            invalidatedRange: processingResult.affectedRange)
    }
}
