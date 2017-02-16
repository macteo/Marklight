//
//  MarklightTests.swift
//  MarklightTests
//
//  Created by Matteo Gavagnin on 30/12/15.
//  Copyright © 2016 MacTeo. All rights reserved.
//

import XCTest
@testable import Marklight

class MarklightTests: XCTestCase {
    let textStorage = MarklightTextStorage()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testAtxH1() {
        let string = ["# Header", ""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
    }
    
    func testAtxH2() {
        let string = ["## Header ##", ""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, at: 2, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body).pointSize
            XCTAssert(attribute == UIFont.boldSystemFont(ofSize: textSize))
            XCTAssert(range?.length == 8)
        } else {
            XCTFail()
        }
    }
    
    func testSetexH1() {
        let string = ["Header", "========", ""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSFontAttributeName, at: 2, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body).pointSize
            XCTAssert(attribute == UIFont.boldSystemFont(ofSize: textSize))
            XCTAssert(range?.length == 7)
        } else {
            XCTFail()
        }
    }
    
    func testSetexH2() {
        let string = ["Header", "------", ""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSFontAttributeName, at: 2, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body).pointSize
            XCTAssert(attribute == UIFont.boldSystemFont(ofSize: textSize))
            XCTAssert(range?.length == 7)
        } else {
            XCTFail()
        }
    }
    
    func testReferenceLinks() {
        let string = ["[Example][1]","", "[1]: http://example.com/", ""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 8, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
        // TODO: test following attributes
    }
    
    func testList() {
        let string = ["* First", "* Second", "* Third"].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, string.lengthOfBytes(using: .utf8))
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 8, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
    }
    
    func testAnchor() {
        let string = ["[Example](http://www.example.com)",""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 8, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            // TODO: exetend test
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
    }
    
    // TODO: test anchor inline?
    
    func testImage() {
        let string = ["![Example](http://www.example.com/image.png)",""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, string.lengthOfBytes(using: .utf8))
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 9, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            // TODO: exetend test
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
    }
    
    func testCodeBlock() {
        let string = ["```","func testCodeBlock()","```",""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 3)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, at: 3, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body).pointSize
            XCTAssert(attribute == UIFont(name: "Menlo", size: textSize))
            XCTAssert(range?.length == 22)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 25, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 3)
        } else {
            XCTFail()
        }
    }
    
    func testIndentedCodeBlock() {
        let string = ["    func testCodeBlock() {","    }",""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.darkGray)
            XCTAssert(range?.length == 33)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, at: 0, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body).pointSize
            XCTAssert(attribute == UIFont(name: "Menlo", size: textSize))
            XCTAssert(range?.length == 33)
        } else {
            XCTFail()
        }
    }
    
    func testCodeSpan() {
        let string = ["This is a phrase with inline `code`",""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 29, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, at: 30, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body).pointSize
            XCTAssert(attribute == UIFont(name: "Menlo", size: textSize))
            XCTAssert(range?.length == 4)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 34, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
    }
    
    func testQuote() {
        let string = ["> This is a quoted line","> This another one", ""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 24, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
    }
    
    func testItalic() {
        let string = ["*italic* word", ""].joined(separator: "\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: attributedString)
        var range : NSRange? = NSMakeRange(0, string.lengthOfBytes(using: .utf8))
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, at: 1, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body).pointSize
            XCTAssert(attribute == UIFont.italicSystemFont(ofSize: textSize))
            XCTAssert(range?.length == 6)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, at: 7, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGray)
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
    }
    
    // TODO: test the remaining markdown syntax
}
