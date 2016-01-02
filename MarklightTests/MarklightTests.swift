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
            print("range length \(range?.length)")
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
            print("range length \(range?.length)")
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
    
    // TODO: test the remaining markdown syntax
}
