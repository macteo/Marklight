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
        let string = ["# Header", ""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
    }
    
    func testAtxH2() {
        let string = ["## Header ##", ""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, atIndex: 2, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody).pointSize
            XCTAssert(attribute == UIFont.boldSystemFontOfSize(textSize))
            XCTAssert(range?.length == 8)
        } else {
            XCTFail()
        }
    }
    
    func testSetexH1() {
        let string = ["Header", "========", ""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSFontAttributeName, atIndex: 2, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody).pointSize
            XCTAssert(attribute == UIFont.boldSystemFontOfSize(textSize))
            XCTAssert(range?.length == 7)
        } else {
            XCTFail()
        }
    }
    
    func testSetexH2() {
        let string = ["Header", "------", ""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSFontAttributeName, atIndex: 2, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody).pointSize
            XCTAssert(attribute == UIFont.boldSystemFontOfSize(textSize))
            XCTAssert(range?.length == 7)
        } else {
            XCTFail()
        }
    }
    
    func testReferenceLinks() {
        let string = ["[Example][1]","", "[1]: http://example.com/", ""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 8, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
        // TODO: test following attributes
    }
    
    func testList() {
        let string = ["* First", "* Second", "* Third"].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 8, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
    }
    
    func testAnchor() {
        let string = ["[Example](http://www.example.com)",""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 8, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 25)
        } else {
            XCTFail()
        }
    }
    
    // TODO: test anchor inline?
    
    func testImage() {
        let string = ["![Example](http://www.example.com/image.png)",""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 9, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 35)
        } else {
            XCTFail()
        }
    }
    
    func testCodeBlock() {
        let string = ["```","func testCodeBlock()","```",""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 3)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, atIndex: 3, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody).pointSize
            XCTAssert(attribute == UIFont(name: "Menlo", size: textSize))
            XCTAssert(range?.length == 22)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 25, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 3)
        } else {
            XCTFail()
        }
    }
    
    func testIndentedCodeBlock() {
        let string = ["    func testCodeBlock() {","    }",""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.darkGrayColor())
            XCTAssert(range?.length == 33)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody).pointSize
            XCTAssert(attribute == UIFont(name: "Menlo", size: textSize))
            XCTAssert(range?.length == 33)
        } else {
            XCTFail()
        }
    }
    
    func testCodeSpan() {
        let string = ["This is a phrase with inline `code`",""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 29, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, atIndex: 30, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody).pointSize
            XCTAssert(attribute == UIFont(name: "Menlo", size: textSize))
            XCTAssert(range?.length == 4)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 34, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
    }
    
    func testQuote() {
        let string = ["> This is a quoted line","> This another one", ""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 24, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 2)
        } else {
            XCTFail()
        }
    }
    
    func testItalic() {
        let string = ["*italic* word", ""].joinWithSeparator("\n")
        let attributedString = NSAttributedString(string: string)
        self.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withAttributedString: attributedString)
        var range : NSRange? = NSMakeRange(0, 1)
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSFontAttributeName, atIndex: 1, effectiveRange: &range!) as? UIFont {
            let textSize = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody).pointSize
            XCTAssert(attribute == UIFont.italicSystemFontOfSize(textSize))
            XCTAssert(range?.length == 6)
        } else {
            XCTFail()
        }
        if let attribute = self.textStorage.attribute(NSForegroundColorAttributeName, atIndex: 7, effectiveRange: &range!) as? UIColor {
            XCTAssert(attribute == UIColor.lightGrayColor())
            XCTAssert(range?.length == 1)
        } else {
            XCTFail()
        }
    }
    
    // TODO: test the remaining markdown syntax
}
