//
//  MarklightTextProcessor
//  Marklight
//
//  Created by Christian Tietze on 2017-07-20.
//  Copyright © 2017 MacTeo. LICENSE for details.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif


open class MarklightTextProcessor {

    // MARK: Syntax highlight customisation

    /**
     Color used to highlight markdown syntax. Default value is light grey.
     */
    open var syntaxColor = MarklightColor.lightGray

    /**
     Font used for blocks and inline code. Default value is *Menlo*.
     */
    open var codeFontName = "Menlo"

    /**
     `MarklightColor` used for blocks and inline code. Default value is dark grey.
     */
    open var codeColor = MarklightColor.darkGray

    /**
     Font used for quote blocks. Default value is *Menlo*.
     */
    open var quoteFontName = "Menlo"

    /**
     `MarklightColor` used for quote blocks. Default value is dark grey.
     */
    open var quoteColor = MarklightColor.darkGray

    /**
     Quote indentation in points. Default 20.
     */
    open var quoteIndendation : CGFloat = 20

    /**
     If the markdown syntax should be hidden or visible
     */
    open var hideSyntax = false


    // MARK: Syntax highlighting

    open func processEditing(
        styleApplier: MarklightStyleApplier,
        string: String,
        editedRange: NSRange
        ) -> MarklightProcessingResult {

        let editedAndAdjacentParagraphRange = self.editedAndAdjacentParagraphRange(in: string, editedRange: editedRange)

        Marklight.syntaxColor = syntaxColor
        Marklight.codeFontName = codeFontName
        Marklight.codeColor = codeColor
        Marklight.quoteFontName = quoteFontName
        Marklight.quoteColor = quoteColor
        Marklight.quoteIndendation = quoteIndendation
        Marklight.textSize = textSize
        Marklight.hideSyntax = hideSyntax

        resetMarklightAttributes(
            styleApplier: styleApplier,
            range: editedAndAdjacentParagraphRange)
        Marklight.applyMarkdownStyle(
            styleApplier,
            string: string,
            affectedRange: editedAndAdjacentParagraphRange)

        return MarklightProcessingResult(
            editedRange: editedRange,
            affectedRange: editedAndAdjacentParagraphRange)
    }

    fileprivate func editedAndAdjacentParagraphRange(in string: String, editedRange: NSRange) -> NSRange {
        let nsString = string as NSString
        let editedParagraphRange = nsString.paragraphRange(for: editedRange)

        let previousParagraphRange: NSRange
        if editedParagraphRange.location > 0 {
            previousParagraphRange = nsString.paragraphRange(at: editedParagraphRange.location - 1)
        } else {
            previousParagraphRange = NSRange(location: editedParagraphRange.location, length: 0)
        }

        let nextParagraphRange: NSRange
        let locationAfterEditedParagraph = editedParagraphRange.location + editedParagraphRange.length
        if locationAfterEditedParagraph < nsString.length {
            nextParagraphRange = nsString.paragraphRange(at: locationAfterEditedParagraph)
        } else {
            nextParagraphRange = NSRange.init(location: 0, length: 0)
        }

        return NSRange(
            location: previousParagraphRange.location,
            length: [previousParagraphRange, editedParagraphRange, nextParagraphRange].map { $0.length }.reduce(0, +))
    }

    fileprivate func resetMarklightAttributes(styleApplier: MarklightStyleApplier, range: NSRange) {

        styleApplier.resetMarklightTextAttributes(
            textSize: self.textSize,
            range: range)
    }

    #if os(iOS)

    // MARK: Font Style Settings

    /**
     Dynamic type font text style, default `UIFontTextStyleBody`.

     - see: [Text Styles](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/UIFontDescriptor_Class/index.html#//apple_ref/doc/constant_group/Text_Styles)
     */
    open var fontTextStyle : String = UIFont.TextStyle.body.rawValue

    /// Text size measured in points.
    fileprivate var textSize: CGFloat {
        return MarklightFontDescriptor
            .preferredFontDescriptor(withTextStyle: UIFont.TextStyle(rawValue: self.fontTextStyleValidated))
            .pointSize
    }

    // We are validating the user provided fontTextStyle `String` to match the
    // system supported ones.
    fileprivate var fontTextStyleValidated : String {

        let supportedTextStyles: [String] = {

            let baseStyles = [
                UIFont.TextStyle.headline.rawValue,
                UIFont.TextStyle.subheadline.rawValue,
                UIFont.TextStyle.body.rawValue,
                UIFont.TextStyle.footnote.rawValue,
                UIFont.TextStyle.caption1.rawValue,
                UIFont.TextStyle.caption2.rawValue
            ]

            guard #available(iOS 9.0, *) else { return baseStyles }

            return baseStyles.appending(contentsOf: [
                UIFont.TextStyle.title1.rawValue,
                UIFont.TextStyle.title2.rawValue,
                UIFont.TextStyle.title3.rawValue,
                UIFont.TextStyle.callout.rawValue
                ])
        }()
        
        guard supportedTextStyles.contains(self.fontTextStyle) else {
            return UIFont.TextStyle.body.rawValue
        }
        
        return self.fontTextStyle
    }

    #elseif os(macOS)

    open var textSize: CGFloat = NSFont.systemFontSize

    #endif
}
