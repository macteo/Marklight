//  Created by Christian Tietze on 2017-07-20.
//  Copyright © 2017 MacTeo. See LICENSE for details.

import XCTest
@testable import Marklight

extension NSRange: Equatable, CustomStringConvertible {
    public static func ==(lhs: NSRange, rhs: NSRange) -> Bool {
        return lhs.location == rhs.location && lhs.length == rhs.length
    }

    public var description: String {
        return "NSRange(\(location), \(length))"
    }
}

class MarklightTextProcessorTests: XCTestCase {

    class StyleApplierDouble: MarklightStyleApplier {
        var didAddAttributes: (attributes: [String : Any], range: NSRange)?
        func addAttributes(_ attrs: [String : Any], range: NSRange) {
            didAddAttributes = (attrs, range)
        }

        var didAddAttribute: (name: String, value: Any, range: NSRange)?
        func addAttribute(_ name: String, value: Any, range: NSRange) {
            didAddAttribute = (name, value, range)
        }

        var didRemoveAttribute: (name: String, range: NSRange)?
        func removeAttribute(_ name: String, range: NSRange) {
            didRemoveAttribute = (name, range)
        }

        var didResetMarklightTextAttributes: (textSize: CGFloat, range: NSRange)?
        func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange) {
            didResetMarklightTextAttributes = (textSize, range)
        }
    }

    var styleApplierDouble: StyleApplierDouble!

    override func setUp() {
        super.setUp()
        styleApplierDouble = StyleApplierDouble()
    }
    
    override func tearDown() {
        styleApplierDouble = nil
        super.tearDown()
    }


    func testProcess_EditedSingleLine_ResetsAttributesForWholeLine() {

        let string = "single"
        let editedRange = NSRange(location: 0, length: 0)

        let result = MarklightTextProcessor().processEditing(styleApplier: styleApplierDouble, string: string, editedRange: editedRange)

        let expectedAffectedRange = NSRange(location: 0, length: 6)
        XCTAssertNotNil(styleApplierDouble.didResetMarklightTextAttributes)
        if let values = styleApplierDouble.didResetMarklightTextAttributes {
            XCTAssertEqual(values.range, expectedAffectedRange)
        }

        XCTAssertEqual(result.editedRange, editedRange)
        XCTAssertEqual(result.affectedRange, expectedAffectedRange)
    }


    func testProcess_EditedFirstLine_ResetsAttributesForFirstAndSecondLine() {

        let string = "1\n2\n3\n"
        let editedRange = NSRange(location: 0, length: 0)

        let result = MarklightTextProcessor().processEditing(styleApplier: styleApplierDouble, string: string, editedRange: editedRange)

        let expectedAffectedRange = NSRange(location: 0, length: 4)
        XCTAssertNotNil(styleApplierDouble.didResetMarklightTextAttributes)
        if let values = styleApplierDouble.didResetMarklightTextAttributes {
            XCTAssertEqual(values.range, expectedAffectedRange)
        }

        XCTAssertEqual(result.editedRange, editedRange)
        XCTAssertEqual(result.affectedRange, expectedAffectedRange)
    }

    func testProcess_EditedLineWithEmptyLinesAround_ResetsAttributesForEmptyLines() {

        let string = "_\n\nxx\n\n_\n"
        //               ^ ^^^ ^
        let editedRange = NSRange(location: 4, length: 0)

        let result = MarklightTextProcessor().processEditing(styleApplier: styleApplierDouble, string: string, editedRange: editedRange)

        let expectedAffectedRange = NSRange(location: 2, length: 5)
        XCTAssertNotNil(styleApplierDouble.didResetMarklightTextAttributes)
        if let values = styleApplierDouble.didResetMarklightTextAttributes {
            XCTAssertEqual(values.range, expectedAffectedRange)
        }

        XCTAssertEqual(result.editedRange, editedRange)
        XCTAssertEqual(result.affectedRange, expectedAffectedRange)
    }

    func testProcess_EditedAtMiddleOfMiddleLine_ResetsAttributesForSurroundingLines() {

        let string = "1\n2\n3333\n4\n5\n"
        //               ^^ ^^^^^ ^^
        let editedRange = NSRange(location: 6, length: 0)

        let result = MarklightTextProcessor().processEditing(styleApplier: styleApplierDouble, string: string, editedRange: editedRange)

        let expectedAffectedRange = NSRange(location: 2, length: 9)
        XCTAssertNotNil(styleApplierDouble.didResetMarklightTextAttributes)
        if let values = styleApplierDouble.didResetMarklightTextAttributes {
            XCTAssertEqual(values.range, expectedAffectedRange)
        }

        XCTAssertEqual(result.editedRange, editedRange)
        XCTAssertEqual(result.affectedRange, expectedAffectedRange)
    }
}
