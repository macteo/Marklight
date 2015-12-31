//    Marklight
//    Copyright (c) 2016 Matteo Gavagnin
//
//    Permission is hereby granted, free of charge, to any person obtaining
//    a copy of this software and associated documentation files (the
//    "Software"), to deal in the Software without restriction, including
//    without limitation the rights to use, copy, modify, merge, publish,
//    distribute, sublicense, and/or sell copies of the Software, and to
//    permit persons to whom the Software is furnished to do so, subject to
//    the following conditions:
//
//    The above copyright notice and this permission notice shall be
//    included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//    ------------------------------------------------------------------------------
//
//    Markdown.swift
//    Copyright (c) 2014 Kristopher Johnson
//
//    Permission is hereby granted, free of charge, to any person obtaining
//    a copy of this software and associated documentation files (the
//    "Software"), to deal in the Software without restriction, including
//    without limitation the rights to use, copy, modify, merge, publish,
//    distribute, sublicense, and/or sell copies of the Software, and to
//    permit persons to whom the Software is furnished to do so, subject to
//    the following conditions:
//
//    The above copyright notice and this permission notice shall be
//    included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//    Markdown.swift is based on MarkdownSharp, whose licenses and history are
//    enumerated in the following sections.
//
//    ------------------------------------------------------------------------------
//
//    MarkdownSharp
//    -------------
//    a C# Markdown processor
//
//    Markdown is a text-to-HTML conversion tool for web writers
//    Copyright (c) 2004 John Gruber
//    http://daringfireball.net/projects/markdown/
//
//    Markdown.NET
//    Copyright (c) 2004-2009 Milan Negovan
//    http://www.aspnetresources.com
//    http://aspnetresources.com/blog/markdown_announced.aspx
//
//    MarkdownSharp
//    Copyright (c) 2009-2011 Jeff Atwood
//    http://stackoverflow.com
//    http://www.codinghorror.com/blog/
//    http://code.google.com/p/markdownsharp/
//
//    History: Milan ported the Markdown processor to C#. He granted license to me so I can open source it
//    and let the community contribute to and improve MarkdownSharp.
//
//    ------------------------------------------------------------------------------
//
//    Copyright (c) 2009 - 2010 Jeff Atwood
//
//    http://www.opensource.org/licenses/mit-license.php
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//
//    ------------------------------------------------------------------------------
//
//    Copyright (c) 2003-2004 John Gruber
//    <http://daringfireball.net/>
//    All rights reserved.
//
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are
//    met:
//
//    Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
//    Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
//    Neither the name "Markdown" nor the names of its contributors may
//    be used to endorse or promote products derived from this software
//    without specific prior written permission.
//
//    This software is provided by the copyright holders and contributors "as
//    is" and any express or implied warranties, including, but not limited
//    to, the implied warranties of merchantability and fitness for a
//    particular purpose are disclaimed. In no event shall the copyright owner
//    or contributors be liable for any direct, indirect, incidental, special,
//    exemplary, or consequential damages (including, but not limited to,
//    procurement of substitute goods or services; loss of use, data, or
//    profits; or business interruption) however caused and on any theory of
//    liability, whether in contract, strict liability, or tort (including
//    negligence or otherwise) arising in any way out of the use of this
//    software, even if advised of the possibility of such damage.

import Foundation
import UIKit

/**
    Marklight struct that parses a `String` inside a `NSTextStorage`
 subclass, looking for markdown syntax to be highlighted. Internally many 
 regular expressions are used to detect the syntax. The highlights will be 
 applied as attributes to the `NSTextStorage`'s `NSAttributedString`. You should 
 create your our `NSTextStorage` subclass or use the readily available 
 `MarklightTextStorage` class.

 - see: `MarklightTextStorage`
*/
public struct Marklight {
    /**
    `UIColor` used to highlight markdown syntax. Default value is light grey.
     */
    public static var syntaxColor = UIColor.lightGrayColor()
    
    /**
    Font used for blocks and inline code. Default value is *Menlo*.
     */
    public static var codeFontName = "Menlo"
    
    /**
     `UIColor` used for blocks and inline code. Default value is dark grey.
     */
    public static var codeColor = UIColor.darkGrayColor()
    
    /**
    Font used for quote blocks. Default value is *Menlo*.
     */
    public static var quoteFontName = "Menlo"
    
    /**
    `UIColor` used for quote blocks. Default value is dark grey.
     */
    public static var quoteColor = UIColor.darkGrayColor()
    
    /**
    Quote indentation in points. Default 20.
     */
    public static var quoteIndendation : CGFloat = 20
    
    /**
     Dynamic type font text style, default `UIFontTextStyleBody`.
     
     - see: 
     [Text 
     Styles](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/UIFontDescriptor_Class/index.html#//apple_ref/doc/constant_group/Text_Styles)
     */
    public static var fontTextStyle : String = UIFontTextStyleBody
    
    // We are validating the user provided fontTextStyle `String` to match the 
    // system supported ones.
    private static var fontTextStyleValidated : String {
        if Marklight.fontTextStyle == UIFontTextStyleHeadline {
            return UIFontTextStyleHeadline
        } else if Marklight.fontTextStyle == UIFontTextStyleSubheadline {
            return UIFontTextStyleSubheadline
        } else if Marklight.fontTextStyle == UIFontTextStyleBody {
            return UIFontTextStyleBody
        } else if Marklight.fontTextStyle == UIFontTextStyleFootnote {
            return UIFontTextStyleFootnote
        } else if Marklight.fontTextStyle == UIFontTextStyleCaption1 {
            return UIFontTextStyleCaption1
        } else if Marklight.fontTextStyle == UIFontTextStyleCaption2 {
            return UIFontTextStyleCaption2
        }

        if #available(iOS 9.0, *) {
            if Marklight.fontTextStyle == UIFontTextStyleTitle1 {
                return UIFontTextStyleTitle1
            } else if Marklight.fontTextStyle == UIFontTextStyleTitle2 {
                return UIFontTextStyleTitle2
            } else if Marklight.fontTextStyle == UIFontTextStyleTitle3 {
                return UIFontTextStyleTitle3
            } else if Marklight.fontTextStyle == UIFontTextStyleCallout {
                return UIFontTextStyleCallout
            }
        }
        return UIFontTextStyleBody
    }
    
    // We transform the user provided `codeFontName` `String` to a `NSFont`
    private static func codeFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: Marklight.codeFontName, size: size) {
            return font
        } else {
            return UIFont.systemFontOfSize(size)
        }
    }

    // We transform the user provided `quoteFontName` `String` to a `NSFont`
    private static func quoteFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: Marklight.quoteFontName, size: size) {
            return font
        } else {
            return UIFont.systemFontOfSize(size)
        }
    }
    
    // Transform the quote indentation in the `NSParagraphStyle` required to set
    //  the attribute on the `NSAttributedString`.
    private static var quoteIndendationStyle : NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = Marklight.quoteIndendation
        return paragraphStyle
    }
    
    // MARK: Processing
    
    /**
    This function should be called by the `-processEditing` method in your 
        `NSTextStorage` subclass and this is the function that is being called 
        for every change in the `UITextView`'s text.

    - parameter textStorage: your `NSTextStorage` subclass as the highlights
        will be applied to its attributed string through the `-addAttribute:value:range:` method.
    */
    public static func processEditing(textStorage: NSTextStorage) {
        let wholeRange = NSMakeRange(0, (textStorage.string as NSString).length)
        let paragraphRange = (textStorage.string as NSString).paragraphRangeForRange(textStorage.editedRange)
        
        let textSize = UIFontDescriptor.preferredFontDescriptorWithTextStyle(Marklight.fontTextStyleValidated).pointSize
        let codeFont = Marklight.codeFont(textSize)
        let quoteFont = Marklight.quoteFont(textSize)
        let boldFont = UIFont.boldSystemFontOfSize(textSize)
        let italicFont = UIFont.italicSystemFontOfSize(textSize)
        
        // We detect and process underlined headers
        Marklight.headersSetexRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)
            Marklight.headersSetexUnderlineRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process dashed headers
        Marklight.headersAtxRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)
            Marklight.headersAtxOpeningRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.headersAtxClosingRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process reference links
        Marklight.referenceLinkRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: result!.range)
        }
        
        // We detect and process lists
        Marklight.listRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
            Marklight.listOpeningRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process anchors (links)
        Marklight.anchorRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            Marklight.openingSquareRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.closingSquareRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.parenRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process inline anchors (links)
        Marklight.anchorInlineRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            Marklight.openingSquareRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.closingSquareRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.parenRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        Marklight.imageRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            Marklight.imageOpeningSquareRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.imageClosingSquareRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process inline images
        Marklight.imageInlineRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            Marklight.imageOpeningSquareRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.imageClosingSquareRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.parenRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process inline code
        Marklight.codeSpanRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            textStorage.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: result!.range)
            Marklight.codeSpanOpeningRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.codeSpanClosingRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process code blocks
        Marklight.codeBlockRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            textStorage.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: result!.range)
        }
        
        // We detect and process quotes
        Marklight.blockQuoteRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: quoteFont, range: result!.range)
            textStorage.addAttribute(NSForegroundColorAttributeName, value: quoteColor, range: result!.range)
            textStorage.addAttribute(NSParagraphStyleAttributeName, value: quoteIndendationStyle, range: result!.range)
            Marklight.blockQuoteOpeningRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process strict italics
        Marklight.strictItalicRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: italicFont, range: result!.range)
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: NSMakeRange(result!.range.location, 1))
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: NSMakeRange(result!.range.location + result!.range.length - 1, 1))
        }
        
        // We detect and process italics
        Marklight.italicRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: italicFont, range: result!.range)
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: NSMakeRange(result!.range.location, 1))
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: NSMakeRange(result!.range.location + result!.range.length - 1, 1))
        }
        
        // We detect and process strict bolds
        Marklight.strictBoldRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: NSMakeRange(result!.range.location, 2))
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: NSMakeRange(result!.range.location + result!.range.length - 2, 2))
        }
        
        // We detect and process bolds
        Marklight.boldRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
            textStorage.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: NSMakeRange(result!.range.location, 2))
            textStorage.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: NSMakeRange(result!.range.location + result!.range.length - 2, 2))
        }
    }
    
    /// Tabs are automatically converted to spaces as part of the transform
    /// this constant determines how "wide" those tabs become in spaces
    private static let _tabWidth = 4
    
    // MARK: Headers

    /*
        Head
        ======
    
        Subhead
        -------
    */

    private static let headerSetexPattern = [
        "^(.+?)",
        "\\p{Z}*",
        "\\n",
        "(=+|-+)     # $1 = string of ='s or -'s",
        "\\p{Z}*",
        "\\n+"
        ].joinWithSeparator("\n")
    
    private static let headersSetexRegex = Regex(pattern: headerSetexPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
    
    private static let setexUnderlinePattern = [
        "(=+|-+)     # $1 = string of ='s or -'s",
        "\\p{Z}*",
        "\\n+"
        ].joinWithSeparator("\n")
    
    private static let headersSetexUnderlineRegex = Regex(pattern: setexUnderlinePattern, options: [.AllowCommentsAndWhitespace])
    
    /*
        # Head
    
        ## Subhead ##
    */
    
    private static let headerAtxPattern = [
        "^(\\#{1,6})  # $1 = string of #'s",
        "\\p{Z}*",
        "(.+?)        # $2 = Header text",
        "\\p{Z}*",
        "\\#*         # optional closing #'s (not counted)",
        "\\n+"
        ].joinWithSeparator("\n")
    
    private static let headersAtxRegex = Regex(pattern: headerAtxPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

    private static let headersAtxOpeningPattern = [
        "^(\\#{1,6})"
        ].joinWithSeparator("\n")
    
    private static let headersAtxOpeningRegex = Regex(pattern: headersAtxOpeningPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
    
    private static let headersAtxClosingPattern = [
        "\\#{1,6}\\n+"
        ].joinWithSeparator("\n")
    
    private static let headersAtxClosingRegex = Regex(pattern: headersAtxClosingPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
    
    // MARK: Reference links
    
    /*
        ???
    */
    
    private static let referenceLinkPattern = [
        "^\\p{Z}{0,\(_tabWidth - 1)}\\[([^\\[\\]]+)\\]:  # id = $1",
        "  \\p{Z}*",
        "  \\n?                   # maybe *one* newline",
        "  \\p{Z}*",
        "<?(\\S+?)>?              # url = $2",
        "  \\p{Z}*",
        "  \\n?                   # maybe one newline",
        "  \\p{Z}*",
        "(?:",
        "    (?<=\\s)             # lookbehind for whitespace",
        "    [\"(]",
        "    (.+?)                # title = $3",
        "    [\")]",
        "    \\p{Z}*",
        ")?                       # title is optional",
        "(?:\\n+|\\Z)"
        ].joinWithSeparator("\n")
    
    private static let referenceLinkRegex = Regex(pattern: referenceLinkPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
    
    // MARK: Lists
    
    /*
        * First element
        * Second element
    */
    
    private static let _markerUL = "[*+-]"
    private static let _markerOL = "\\d+[.]"
    
    private static let _listMarker = "(?:\(_markerUL)|\(_markerOL))"
    private static let _wholeList = [
        "(                               # $1 = whole list",
        "  (                             # $2",
        "    \\p{Z}{0,\(_tabWidth - 1)}",
        "    (\(_listMarker))            # $3 = first list item marker",
        "    \\p{Z}+",
        "  )",
        "  (?s:.+?)",
        "  (                             # $4",
        "      \\z",
        "    |",
        "      \\n{2,}",
        "      (?=\\S)",
        "      (?!                       # Negative lookahead for another list item marker",
        "        \\p{Z}*",
        "        \(_listMarker)\\p{Z}+",
        "      )",
        "  )",
        ")"
        ].joinWithSeparator("\n")
    
    private static let listPattern = "(?:(?<=\\n\\n)|\\A\\n?)" + _wholeList
    
    private static let listRegex = Regex(pattern: listPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
    private static let listOpeningRegex = Regex(pattern: _listMarker, options: [.AllowCommentsAndWhitespace])
    
    // MARK: Anchors
    
    /*
        [Title](http://example.com)
    */
    
    private static let anchorPattern = [
        "(                               # wrap whole match in $1",
        "    \\[",
        "        (\(Marklight.getNestedBracketsPattern()))  # link text = $2",
        "    \\]",
        "",
        "    \\p{Z}?                        # one optional space",
        "    (?:\\n\\p{Z}*)?                # one optional newline followed by spaces",
        "",
        "    \\[",
        "        (.*?)                   # id = $3",
        "    \\]",
        ")"
        ].joinWithSeparator("\n")
    
    private static let anchorRegex = Regex(pattern: anchorPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])
    
    private static let opneningSquarePattern = [
        "(\\[)"
        ].joinWithSeparator("\n")
    
    private static let openingSquareRegex = Regex(pattern: opneningSquarePattern, options: [.AllowCommentsAndWhitespace])
    
    private static let closingSquarePattern = [
        "\\]"
        ].joinWithSeparator("\n")
    
    private static let closingSquareRegex = Regex(pattern: closingSquarePattern, options: [.AllowCommentsAndWhitespace])
    
    private static let parenPattern = [
        "(",
        "\\(                 # literal paren",
        "      \\p{Z}*",
        "      (\(Marklight.getNestedParensPattern()))    # href = $3",
        "      \\p{Z}*",
        "      (               # $4",
        "      (['\"])       # quote char = $5",
        "      (.*?)           # title = $6",
        "      \\5             # matching quote",
        "      \\p{Z}*",
        "      )?              # title is optional",
        "  \\)",
        ")"
        ].joinWithSeparator("\n")
    
    private static let parenRegex = Regex(pattern: parenPattern, options: [.AllowCommentsAndWhitespace])
    
    private static let anchorInlinePattern = [
        "(                           # wrap whole match in $1",
        "    \\[",
        "        (\(Marklight.getNestedBracketsPattern()))   # link text = $2",
        "    \\]",
        "    \\(                     # literal paren",
        "        \\p{Z}*",
        "        (\(Marklight.getNestedParensPattern()))   # href = $3",
        "        \\p{Z}*",
        "        (                   # $4",
        "        (['\"])           # quote char = $5",
        "        (.*?)               # title = $6",
        "        \\5                 # matching quote",
        "        \\p{Z}*                # ignore any spaces between closing quote and )",
        "        )?                  # title is optional",
        "    \\)",
        ")"
        ].joinWithSeparator("\n")
    
    private static let anchorInlineRegex = Regex(pattern: anchorInlinePattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])
    
    // Mark: Images
    
    /*
        ![Title](http://example.com/image.png)
    */
    
    private static let imagePattern = [
        "(               # wrap whole match in $1",
        "!\\[",
        "    (.*?)       # alt text = $2",
        "\\]",
        "",
        "\\p{Z}?            # one optional space",
        "(?:\\n\\p{Z}*)?    # one optional newline followed by spaces",
        "",
        "\\[",
        "    (.*?)       # id = $3",
        "\\]",
        "",
        ")"
        ].joinWithSeparator("\n")
    
    private static let imageRegex = Regex(pattern: imagePattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])
    
    private static let imageOpeningSquarePattern = [
        "(!\\[)"
        ].joinWithSeparator("\n")
    
    private static let imageOpeningSquareRegex = Regex(pattern: imageOpeningSquarePattern, options: [.AllowCommentsAndWhitespace])
    
    private static let imageClosingSquarePattern = [
        "(\\])"
        ].joinWithSeparator("\n")
    
    private static let imageClosingSquareRegex = Regex(pattern: imageClosingSquarePattern, options: [.AllowCommentsAndWhitespace])
    
    private static let imageInlinePattern = [
        "(                     # wrap whole match in $1",
        "  !\\[",
        "      (.*?)           # alt text = $2",
        "  \\]",
        "  \\s?                # one optional whitespace character",
        "  \\(                 # literal paren",
        "      \\p{Z}*",
        "      (\(Marklight.getNestedParensPattern()))    # href = $3",
        "      \\p{Z}*",
        "      (               # $4",
        "      (['\"])       # quote char = $5",
        "      (.*?)           # title = $6",
        "      \\5             # matching quote",
        "      \\p{Z}*",
        "      )?              # title is optional",
        "  \\)",
        ")"
        ].joinWithSeparator("\n")
    
    private static let imageInlineRegex = Regex(pattern: imageInlinePattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])
    
    // MARK: Code
    
    /*
        ```
        Code
        ```
    
            Code
    */
    
    private static let codeBlockPattern = [
        "(?:\\n\\n|\\A\\n?)",
        "(                        # $1 = the code block -- one or more lines, starting with a space",
        "(?:",
        "    (?:\\p{Z}{\(_tabWidth)})       # Lines must start with a tab-width of spaces",
        "    .*\\n+",
        ")+",
        ")",
        "((?=^\\p{Z}{0,\(_tabWidth)}[^ \\t\\n])|\\Z) # Lookahead for non-space at line-start, or end of doc"
        ].joinWithSeparator("\n")
    
    private static let codeBlockRegex = Regex(pattern: codeBlockPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
    
    private static let codeSpanPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `",
        "(?!`)          # and no more backticks -- match the full run",
        "(.+?)          # $2 = The code block",
        "(?<!`)",
        "\\1",
        "(?!`)"
        ].joinWithSeparator("\n")
    
    private static let codeSpanRegex = Regex(pattern: codeSpanPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])
    
    private static let codeSpanOpeningPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `"
        ].joinWithSeparator("\n")
    
    private static let codeSpanOpeningRegex = Regex(pattern: codeSpanOpeningPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])
    
    private static let codeSpanClosingPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `"
        ].joinWithSeparator("\n")
    
    private static let codeSpanClosingRegex = Regex(pattern: codeSpanClosingPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])
    
    // MARK: Block quotes
    
    /*
        > Quoted text
    */
    
    private static let blockQuotePattern = [
        "(                           # Wrap whole match in $1",
        "    (",
        "    ^\\p{Z}*>\\p{Z}?              # '>' at the start of a line",
        "        .+\\n               # rest of the first line",
        "    (.+\\n)*                # subsequent consecutive lines",
        "    \\n*                    # blanks",
        "    )+",
        ")"
        ].joinWithSeparator("\n")
    
    private static let blockQuoteRegex = Regex(pattern: blockQuotePattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

    private static let blockQuoteOpeningPattern = [
        "(^\\p{Z}*>\\p{Z})"
        ].joinWithSeparator("\n")

    private static let blockQuoteOpeningRegex = Regex(pattern: blockQuoteOpeningPattern, options: [.AnchorsMatchLines])
    
    // MARK: Bold
    
    /*
        **Bold**
        __Bold__
    */
    
    private static let strictBoldPattern = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)\\2(?=\\S)(.*?\\S)\\2\\2(?!\\2)(?=[\\W_]|$)"
    
    private static let strictBoldRegex = Regex(pattern: strictBoldPattern, options: [.AnchorsMatchLines])
    
    private static let boldPattern = "(\\*\\*|__) (?=\\S) (.+?[*_]*) (?<=\\S) \\1"
    
    private static let boldRegex = Regex(pattern: boldPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
    
    // MARK: Italic
    
    /*
        *Italic*
        _Italic_
    */

    
    private static let strictItalicPattern = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)(?=\\S)((?:(?!\\2).)*?\\S)\\2(?!\\2)(?=[\\W_]|$)"
    
    private static let strictItalicRegex = Regex(pattern: strictItalicPattern, options: [.AnchorsMatchLines])
    
    private static let italicPattern = "(\\*|_) (?=\\S) (.+?) (?<=\\S) \\1"
    
    private static let italicRegex = Regex(pattern: italicPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
    
    private struct Regex {
        private let regularExpression: NSRegularExpression!
        
        private init(pattern: String, options: NSRegularExpressionOptions = NSRegularExpressionOptions(rawValue: 0)) {
            var error: NSError?
            let re: NSRegularExpression?
            do {
                re = try NSRegularExpression(pattern: pattern,
                    options: options)
            } catch let error1 as NSError {
                error = error1
                re = nil
            }
            
            // If re is nil, it means NSRegularExpression didn't like
            // the pattern we gave it.  All regex patterns used by Markdown
            // should be valid, so this probably means that a pattern
            // valid for .NET Regex is not valid for NSRegularExpression.
            if re == nil {
                if let error = error {
                    print("Regular expression error: \(error.userInfo)")
                }
                assert(re != nil)
            }
            
            self.regularExpression = re
        }
        
        private func matches(input: String, range: NSRange,
            completion: (result: NSTextCheckingResult?) -> Void) {
            let s = input as NSString
            let options = NSMatchingOptions(rawValue: 0)
            let range = NSMakeRange(0, s.length)
            regularExpression.enumerateMatchesInString(s as String,
                options: options,
                range: range,
                usingBlock: { (result, flags, stop) -> Void in
                    completion(result: result)
            })
        }
    }
    
    /// maximum nested depth of [] and () supported by the transform; 
    /// implementation detail
    private static let _nestDepth = 6
    
    private static var _nestedBracketsPattern = ""
    private static var _nestedParensPattern = ""
    
    /// Reusable pattern to match balanced [brackets]. See Friedl's
    /// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
    private static func getNestedBracketsPattern() -> String {
        // in other words [this] and [this[also]] and [this[also[too]]]
        // up to _nestDepth
        if (_nestedBracketsPattern.isEmpty) {
            _nestedBracketsPattern = repeatString([
                "(?>             # Atomic matching",
                "[^\\[\\]]+      # Anything other than brackets",
                "|",
                "\\["
                ].joinWithSeparator("\n"), _nestDepth) +
                repeatString(" \\])*", _nestDepth)
        }
        return _nestedBracketsPattern
    }
    
    /// Reusable pattern to match balanced (parens). See Friedl's
    /// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
    private static func getNestedParensPattern() -> String {
        // in other words (this) and (this(also)) and (this(also(too)))
        // up to _nestDepth
        if (_nestedParensPattern.isEmpty) {
            _nestedParensPattern = repeatString([
                "(?>            # Atomic matching",
                "[^()\\s]+      # Anything other than parens or whitespace",
                "|",
                "\\("
                ].joinWithSeparator("\n"), _nestDepth) +
                repeatString(" \\))*", _nestDepth)
        }
        return _nestedParensPattern
    }

    /// this is to emulate what's available in PHP
    private static func repeatString(text: String, _ count: Int) -> String {
        return Array(count: count, repeatedValue: text).reduce("", combine: +)
    }
}