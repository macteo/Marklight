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

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

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
    Color used to highlight markdown syntax. Default value is light grey.
     */
    public static var syntaxColor = MarklightColor.lightGray
    
    /**
    Font used for blocks and inline code. Default value is *Menlo*.
     */
    public static var codeFontName = "Menlo"
    
    /**
     Color used for blocks and inline code. Default value is dark grey.
     */
    public static var codeColor = MarklightColor.darkGray
    
    /**
    Font used for quote blocks. Default value is *Menlo*.
     */
    public static var quoteFontName = "Menlo"
    
    /**
    Color used for quote blocks. Default value is dark grey.
     */
    public static var quoteColor = MarklightColor.darkGray
    
    /**
    Quote indentation in points. Default 20.
     */
    public static var quoteIndendation : CGFloat = 20
    
    /**
     If the markdown syntax should be hidden or visible
     */
    public static var hideSyntax = false

    /**
     Text size measured in points.
     */
    #if os(iOS)
    public static var textSize: CGFloat = MarklightFont.systemFontSize
    #elseif os(macOS)
    public static var textSize: CGFloat = MarklightFont.systemFontSize()
    #endif

    // We transform the user provided `codeFontName` `String` to a `NSFont`
    fileprivate static func codeFont(_ size: CGFloat) -> MarklightFont {
        if let font = MarklightFont(name: Marklight.codeFontName, size: size) {
            return font
        } else {
            return MarklightFont.systemFont(ofSize: size)
        }
    }

    // We transform the user provided `quoteFontName` `String` to a `NSFont`
    fileprivate static func quoteFont(_ size: CGFloat) -> MarklightFont {
        if let font = MarklightFont(name: Marklight.quoteFontName, size: size) {
            return font
        } else {
            return MarklightFont.systemFont(ofSize: size)
        }
    }
    
    // Transform the quote indentation in the `NSParagraphStyle` required to set
    //  the attribute on the `NSAttributedString`.
    fileprivate static var quoteIndendationStyle : NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = Marklight.quoteIndendation
        return paragraphStyle
    }
    
    // MARK: Processing
    
    /**
     This function should be called by the `-processEditing` method in your
     `NSTextStorage` subclass and this is the function that is being called
      for every change in the text view's text.

     - parameter styleApplier: `MarklightStyleApplier`, for example
         your `NSTextStorage` subclass.
     - parameter string: The text that should be scanned for styling.
     - parameter affectedRange: The range to apply styling to.
    */
    public static func applyMarkdownStyle(_ styleApplier: MarklightStyleApplier, string: String, affectedRange paragraphRange: NSRange) {

        let textStorageNSString = string as NSString
        let wholeRange = NSMakeRange(0, textStorageNSString.length)

        let codeFont = Marklight.codeFont(textSize)
        let quoteFont = Marklight.quoteFont(textSize)
        let boldFont = MarklightFont.boldSystemFont(ofSize: textSize)
        let italicFont = MarklightFont.italicSystemFont(ofSize: textSize)

        let hiddenFont = MarklightFont.systemFont(ofSize: 0.1)
        let hiddenColor = MarklightColor.clear
        let hiddenAttributes: [String : Any] = [
            NSFontAttributeName : hiddenFont,
            NSForegroundColorAttributeName : hiddenColor
        ]

        func hideSyntaxIfNecessary(range: @autoclosure () -> NSRange) {
            guard Marklight.hideSyntax else { return }

            styleApplier.addAttributes(hiddenAttributes, range: range())
        }

        // We detect and process underlined headers
        Marklight.headersSetextRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)

            Marklight.headersSetextUnderlineRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }

        // We detect and process dashed headers
        Marklight.headersAtxRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)
            Marklight.headersAtxOpeningRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
                hideSyntaxIfNecessary(range: NSMakeRange(innerResult!.range.location, innerResult!.range.length + 1))
            }
            Marklight.headersAtxClosingRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
                hideSyntaxIfNecessary(range: innerResult!.range)
            }
        }
        
        // We detect and process reference links
        Marklight.referenceLinkRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: result!.range)
        }
        
        // We detect and process lists
        Marklight.listRegex.matches(string, range: wholeRange) { (result) -> Void in
            Marklight.listOpeningRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process anchors (links)
        Marklight.anchorRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            Marklight.openingSquareRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.closingSquareRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.parenRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)

                hideSyntaxIfNecessary(range: NSMakeRange(innerResult!.range.location, 1))
                hideSyntaxIfNecessary(range: NSMakeRange(innerResult!.range.location + innerResult!.range.length - 1, 1))
            }
        }
        
        // We detect and process inline anchors (links)
        Marklight.anchorInlineRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            
            var destinationLink : String?
            
            Marklight.coupleRoundRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
                
                var range = innerResult!.range
                range.location = range.location + 1
                range.length = range.length - 2
                
                let substring = textStorageNSString.substring(with: range)
                guard substring.lengthOfBytes(using: .utf8) > 0 else { return }

                destinationLink = substring
                styleApplier.addAttribute(NSLinkAttributeName, value: substring, range: range)

                hideSyntaxIfNecessary(range: innerResult!.range)
            }
            
            Marklight.openingSquareRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
                hideSyntaxIfNecessary(range: innerResult!.range)
            }
            
            Marklight.closingSquareRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
                hideSyntaxIfNecessary(range: innerResult!.range)
            }
            
            guard let destinationLinkString = destinationLink else { return }
            
            Marklight.coupleSquareRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                var range = innerResult!.range
                range.location = range.location + 1
                range.length = range.length - 2
                
                let substring = textStorageNSString.substring(with: range)
                guard substring.lengthOfBytes(using: .utf8) > 0 else { return }
                
                styleApplier.addAttribute(NSLinkAttributeName, value: destinationLinkString, range: range)
            }
        }
        
        Marklight.imageRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            
            // TODO: add image attachment
            if Marklight.hideSyntax {
                styleApplier.addAttribute(NSFontAttributeName, value: hiddenFont, range: result!.range)
            }
            Marklight.imageOpeningSquareRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.imageClosingSquareRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process inline images
        Marklight.imageInlineRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)

            // TODO: add image attachment

            hideSyntaxIfNecessary(range: result!.range)

            Marklight.imageOpeningSquareRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.imageClosingSquareRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
            Marklight.parenRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
            }
        }
        
        // We detect and process inline code
        Marklight.codeSpanRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: result!.range)
            
            Marklight.codeSpanOpeningRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
                hideSyntaxIfNecessary(range: innerResult!.range)
            }
            Marklight.codeSpanClosingRegex.matches(string, range: paragraphRange) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
                hideSyntaxIfNecessary(range: innerResult!.range)
            }
        }
        
        // We detect and process code blocks
        Marklight.codeBlockRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: result!.range)
        }
        
        // We detect and process quotes
        Marklight.blockQuoteRegex.matches(string, range: wholeRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: quoteFont, range: result!.range)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: quoteColor, range: result!.range)
            styleApplier.addAttribute(NSParagraphStyleAttributeName, value: quoteIndendationStyle, range: result!.range)
            Marklight.blockQuoteOpeningRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: innerResult!.range)
                hideSyntaxIfNecessary(range: innerResult!.range)
            }
        }

        // We detect and process strict italics
        Marklight.strictItalicRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: italicFont, range: result!.range)
            let substring = textStorageNSString.substring(with: NSMakeRange(result!.range.location, 1))
            var start = 0
            if substring == " " {
                start = 1
            }

            let preRange = NSMakeRange(result!.range.location + start, 1)
            hideSyntaxIfNecessary(range: preRange)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: preRange)

            let postRange = NSMakeRange(result!.range.location + result!.range.length - 1, 1)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: postRange)
            hideSyntaxIfNecessary(range: postRange)
        }
        
        // We detect and process strict bolds
        Marklight.strictBoldRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)
            let substring = textStorageNSString.substring(with: NSMakeRange(result!.range.location, 1))
            var start = 0
            if substring == " " {
                start = 1
            }

            let preRange = NSMakeRange(result!.range.location + start, 2)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: preRange)
            hideSyntaxIfNecessary(range: preRange)

            let postRange = NSMakeRange(result!.range.location + result!.range.length - 2, 2)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: postRange)
            hideSyntaxIfNecessary(range: postRange)
        }

        // We detect and process italics
        Marklight.italicRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: italicFont, range: result!.range)

            let preRange = NSMakeRange(result!.range.location, 1)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: preRange)
            hideSyntaxIfNecessary(range: preRange)

            let postRange = NSMakeRange(result!.range.location + result!.range.length - 1, 1)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: postRange)
            hideSyntaxIfNecessary(range: postRange)
        }
        
        // We detect and process bolds
        Marklight.boldRegex.matches(string, range: paragraphRange) { (result) -> Void in
            styleApplier.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)

            let preRange = NSMakeRange(result!.range.location, 2)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: preRange)
            hideSyntaxIfNecessary(range: preRange)

            let postRange = NSMakeRange(result!.range.location + result!.range.length - 2, 2)
            styleApplier.addAttribute(NSForegroundColorAttributeName, value: Marklight.syntaxColor, range: postRange)
            hideSyntaxIfNecessary(range: postRange)
        }

        // We detect and process inline links not formatted
        Marklight.autolinkRegex.matches(string, range: paragraphRange) { (result) -> Void in
            let substring = textStorageNSString.substring(with: result!.range)
            guard substring.lengthOfBytes(using: .utf8) > 0 else { return }
            styleApplier.addAttribute(NSLinkAttributeName, value: substring, range: result!.range)
            
            if Marklight.hideSyntax {
                Marklight.autolinkPrefixRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                    styleApplier.addAttribute(NSFontAttributeName, value: hiddenFont, range: innerResult!.range)
                    styleApplier.addAttribute(NSForegroundColorAttributeName, value: hiddenColor, range: innerResult!.range)
                }
            }
        }
        
        // We detect and process inline mailto links not formatted
        Marklight.autolinkEmailRegex.matches(string, range: paragraphRange) { (result) -> Void in
            let substring = textStorageNSString.substring(with: result!.range)
            guard substring.lengthOfBytes(using: .utf8) > 0 else { return }
            styleApplier.addAttribute(NSLinkAttributeName, value: substring, range: result!.range)
            
            if Marklight.hideSyntax {
                Marklight.mailtoRegex.matches(string, range: result!.range) { (innerResult) -> Void in
                    styleApplier.addAttribute(NSFontAttributeName, value: hiddenFont, range: innerResult!.range)
                    styleApplier.addAttribute(NSForegroundColorAttributeName, value: hiddenColor, range: innerResult!.range)
                }
            }
        }
    }
    
    /// Tabs are automatically converted to spaces as part of the transform
    /// this constant determines how "wide" those tabs become in spaces
    fileprivate static let _tabWidth = 4
    
    // MARK: Headers

    /*
        Head
        ======
    
        Subhead
        -------
    */

    fileprivate static let headerSetextPattern = [
        "^(.+?)",
        "\\p{Z}*",
        "\\n",
        "(=+|-+)",  // $1 = string of ='s or -'s
        "\\p{Z}*",
        "\\n+"
        ].joined(separator: "\n")
    
    fileprivate static let headersSetextRegex = Regex(pattern: headerSetextPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    fileprivate static let setextUnderlinePattern = [
        "(==+|--+)     # $1 = string of ='s or -'s",
        "\\p{Z}*$"
        ].joined(separator: "\n")
    
    fileprivate static let headersSetextUnderlineRegex = Regex(pattern: setextUnderlinePattern, options: [.allowCommentsAndWhitespace])
    
    /*
        # Head
    
        ## Subhead ##
    */
    
    fileprivate static let headerAtxPattern = [
        "^(\\#{1,6})  # $1 = string of #'s",
        "\\p{Z}*",
        "(.+?)        # $2 = Header text",
        "\\p{Z}*",
        "\\#*         # optional closing #'s (not counted)",
        "\\n+"
        ].joined(separator: "\n")
    
    fileprivate static let headersAtxRegex = Regex(pattern: headerAtxPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    fileprivate static let headersAtxOpeningPattern = [
        "^(\\#{1,6})"
        ].joined(separator: "\n")
    
    fileprivate static let headersAtxOpeningRegex = Regex(pattern: headersAtxOpeningPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    fileprivate static let headersAtxClosingPattern = [
        "\\#{1,6}\\n+"
        ].joined(separator: "\n")
    
    fileprivate static let headersAtxClosingRegex = Regex(pattern: headersAtxClosingPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    // MARK: Reference links
    
    /*
        TODO: we don't know how reference links are formed
    */
    
    fileprivate static let referenceLinkPattern = [
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
        ].joined(separator: "")
    
    fileprivate static let referenceLinkRegex = Regex(pattern: referenceLinkPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    // MARK: Lists
    
    /*
        * First element
        * Second element
    */
    
    fileprivate static let _markerUL = "[*+-]"
    fileprivate static let _markerOL = "\\d+[.]"
    
    fileprivate static let _listMarker = "(?:\(_markerUL)|\(_markerOL))"
    fileprivate static let _wholeList = [
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
        ].joined(separator: "\n")
    
    fileprivate static let listPattern = "(?:(?<=\\n\\n)|\\A\\n?)" + _wholeList
    
    fileprivate static let listRegex = Regex(pattern: listPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    fileprivate static let listOpeningRegex = Regex(pattern: _listMarker, options: [.allowCommentsAndWhitespace])
    
    // MARK: Anchors
    
    /*
        [Title](http://example.com)
    */
    
    fileprivate static let anchorPattern = [
        "(                                  # wrap whole match in $1",
        "    \\[",
        "        (\(Marklight.getNestedBracketsPattern()))  # link text = $2",
        "    \\]",
        "",
        "    \\p{Z}?                        # one optional space",
        "    (?:\\n\\p{Z}*)?                # one optional newline followed by spaces",
        "",
        "    \\[",
        "        (.*?)                      # id = $3",
        "    \\]",
        ")"
        ].joined(separator: "\n")
    
    fileprivate static let anchorRegex = Regex(pattern: anchorPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let opneningSquarePattern = [
        "(\\[)"
        ].joined(separator: "\n")
    
    fileprivate static let openingSquareRegex = Regex(pattern: opneningSquarePattern, options: [.allowCommentsAndWhitespace])
    
    fileprivate static let closingSquarePattern = [
        "\\]"
        ].joined(separator: "\n")
    
    fileprivate static let closingSquareRegex = Regex(pattern: closingSquarePattern, options: [.allowCommentsAndWhitespace])
    
    fileprivate static let coupleSquarePattern = [
        "\\[(.*?)\\]"
        ].joined(separator: "\n")
    
    fileprivate static let coupleSquareRegex = Regex(pattern: coupleSquarePattern, options: [])
    
    fileprivate static let coupleRoundPattern = [
        "\\((.*?)\\)"
        ].joined(separator: "\n")
    
    fileprivate static let coupleRoundRegex = Regex(pattern: coupleRoundPattern, options: [])
    
    fileprivate static let parenPattern = [
        "(",
        "\\(                 # literal paren",
        "      \\p{Z}*",
        "      (\(Marklight.getNestedParensPattern()))    # href = $3",
        "      \\p{Z}*",
        "      (               # $4",
        "      (['\"])         # quote char = $5",
        "      (.*?)           # title = $6",
        "      \\5             # matching quote",
        "      \\p{Z}*",
        "      )?              # title is optional",
        "  \\)",
        ")"
        ].joined(separator: "\n")
    
    fileprivate static let parenRegex = Regex(pattern: parenPattern, options: [.allowCommentsAndWhitespace])
    
    fileprivate static let anchorInlinePattern = [
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
        ].joined(separator: "\n")
    
    fileprivate static let anchorInlineRegex = Regex(pattern: anchorInlinePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    // Mark: Images
    
    /*
        ![Title](http://example.com/image.png)
    */
    
    fileprivate static let imagePattern = [
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
        ].joined(separator: "\n")
    
    fileprivate static let imageRegex = Regex(pattern: imagePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let imageOpeningSquarePattern = [
        "(!\\[)"
        ].joined(separator: "\n")
    
    fileprivate static let imageOpeningSquareRegex = Regex(pattern: imageOpeningSquarePattern, options: [.allowCommentsAndWhitespace])
    
    fileprivate static let imageClosingSquarePattern = [
        "(\\])"
        ].joined(separator: "\n")
    
    fileprivate static let imageClosingSquareRegex = Regex(pattern: imageClosingSquarePattern, options: [.allowCommentsAndWhitespace])
    
    fileprivate static let imageInlinePattern = [
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
        ].joined(separator: "\n")
    
    fileprivate static let imageInlineRegex = Regex(pattern: imageInlinePattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    // MARK: Code
    
    /*
        ```
        Code
        ```
    
            Code
    */
    
    fileprivate static let codeBlockPattern = [
        "(?:\\n\\n|\\A\\n?)",
        "(                        # $1 = the code block -- one or more lines, starting with a space",
        "(?:",
        "    (?:\\p{Z}{\(_tabWidth)})       # Lines must start with a tab-width of spaces",
        "    .*\\n+",
        ")+",
        ")",
        "((?=^\\p{Z}{0,\(_tabWidth)}[^ \\t\\n])|\\Z) # Lookahead for non-space at line-start, or end of doc"
        ].joined(separator: "\n")
    
    fileprivate static let codeBlockRegex = Regex(pattern: codeBlockPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    fileprivate static let codeSpanPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `",
        "(?!`)          # and no more backticks -- match the full run",
        "(.+?)          # $2 = The code block",
        "(?<!`)",
        "\\1",
        "(?!`)"
        ].joined(separator: "\n")
    
    fileprivate static let codeSpanRegex = Regex(pattern: codeSpanPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let codeSpanOpeningPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `"
        ].joined(separator: "\n")
    
    fileprivate static let codeSpanOpeningRegex = Regex(pattern: codeSpanOpeningPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let codeSpanClosingPattern = [
        "(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
        "(`+)           # $1 = Opening run of `"
        ].joined(separator: "\n")
    
    fileprivate static let codeSpanClosingRegex = Regex(pattern: codeSpanClosingPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    // MARK: Block quotes
    
    /*
        > Quoted text
    */
    
    fileprivate static let blockQuotePattern = [
        "(                           # Wrap whole match in $1",
        "    (",
        "    ^\\p{Z}*>\\p{Z}?              # '>' at the start of a line",
        "        .+\\n               # rest of the first line",
        "    (.+\\n)*                # subsequent consecutive lines",
        "    \\n*                    # blanks",
        "    )+",
        ")"
        ].joined(separator: "\n")
    
    fileprivate static let blockQuoteRegex = Regex(pattern: blockQuotePattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])

    fileprivate static let blockQuoteOpeningPattern = [
        "(^\\p{Z}*>\\p{Z})"
        ].joined(separator: "\n")

    fileprivate static let blockQuoteOpeningRegex = Regex(pattern: blockQuoteOpeningPattern, options: [.anchorsMatchLines])
    
    // MARK: Bold
    
    /*
        **Bold**
        __Bold__
    */
    
    fileprivate static let strictBoldPattern = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)\\2(?=\\S)(.*?\\S)\\2\\2(?!\\2)(?=[\\W_]|$)"
    
    fileprivate static let strictBoldRegex = Regex(pattern: strictBoldPattern, options: [.anchorsMatchLines])
    
    fileprivate static let boldPattern = "(\\*\\*|__) (?=\\S) (.+?[*_]*) (?<=\\S) \\1"
    
    fileprivate static let boldRegex = Regex(pattern: boldPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    // MARK: Italic
    
    /*
        *Italic*
        _Italic_
    */

    fileprivate static let strictItalicPattern = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)(?=\\S)((?:(?!\\2).)*?\\S)\\2(?!\\2)(?=[\\W_]|$)"
    
    fileprivate static let strictItalicRegex = Regex(pattern: strictItalicPattern, options: [.anchorsMatchLines])
    
    fileprivate static let italicPattern = "(\\*|_) (?=\\S) (.+?) (?<=\\S) \\1"
    
    fileprivate static let italicRegex = Regex(pattern: italicPattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines])
    
    fileprivate static let autolinkPattern = "((https?|ftp):[^'\">\\s]+)"
    
    fileprivate static let autolinkRegex = Regex(pattern: autolinkPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let autolinkPrefixPattern = "((https?|ftp)://)"
    
    fileprivate static let autolinkPrefixRegex = Regex(pattern: autolinkPrefixPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let autolinkEmailPattern = [
        "(?:mailto:)?",
        "(",
        "  [-.\\w]+",
        "  \\@",
        "  [-a-z0-9]+(\\.[-a-z0-9]+)*\\.[a-z]+",
        ")"
        ].joined(separator: "\n")
    
    fileprivate static let autolinkEmailRegex = Regex(pattern: autolinkEmailPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate static let mailtoPattern = "mailto:"
    
    fileprivate static let mailtoRegex = Regex(pattern: mailtoPattern, options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators])
    
    fileprivate struct Regex {
        fileprivate let regularExpression: NSRegularExpression!
        
        fileprivate init(pattern: String, options: NSRegularExpression.Options = NSRegularExpression.Options(rawValue: 0)) {
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
        
        fileprivate func matches(_ input: String, range: NSRange,
            completion: @escaping (_ result: NSTextCheckingResult?) -> Void) {
            let s = input as NSString
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            regularExpression.enumerateMatches(in: s as String,
                options: options,
                range: range,
                using: { (result, flags, stop) -> Void in
                    completion(result)
            })
        }
    }
    
    /// maximum nested depth of [] and () supported by the transform; 
    /// implementation detail
    fileprivate static let _nestDepth = 6
    
    fileprivate static var _nestedBracketsPattern = ""
    fileprivate static var _nestedParensPattern = ""
    
    /// Reusable pattern to match balanced [brackets]. See Friedl's
    /// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
    fileprivate static func getNestedBracketsPattern() -> String {
        // in other words [this] and [this[also]] and [this[also[too]]]
        // up to _nestDepth
        if (_nestedBracketsPattern.isEmpty) {
            _nestedBracketsPattern = repeatString([
                "(?>             # Atomic matching",
                "[^\\[\\]]+      # Anything other than brackets",
                "|",
                "\\["
                ].joined(separator: "\n"), _nestDepth) +
                repeatString(" \\])*", _nestDepth)
        }
        return _nestedBracketsPattern
    }
    
    /// Reusable pattern to match balanced (parens). See Friedl's
    /// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
    fileprivate static func getNestedParensPattern() -> String {
        // in other words (this) and (this(also)) and (this(also(too)))
        // up to _nestDepth
        if (_nestedParensPattern.isEmpty) {
            _nestedParensPattern = repeatString([
                "(?>            # Atomic matching",
                "[^()\\s]+      # Anything other than parens or whitespace",
                "|",
                "\\("
                ].joined(separator: "\n"), _nestDepth) +
                repeatString(" \\))*", _nestDepth)
        }
        return _nestedParensPattern
    }

    /// this is to emulate what's available in PHP
    fileprivate static func repeatString(_ text: String, _ count: Int) -> String {
        return Array(repeating: text, count: count).reduce("", +)
    }

}
