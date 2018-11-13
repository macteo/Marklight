//
//  MarklightTextStorage
//
//  Created by Matteo Gavagnin on 01/01/16.
//  Copyright © 2016 MacTeo. LICENSE for details.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

/**
    `NSTextStorage` subclass that uses `Marklight` to highlight markdown syntax
    on a `UITextView`.
    In your `UIViewController` subclass keep a strong instance of the this
    `MarklightTextStorage` class.
    ```swift
    let textStorage = MarklightTextStorage()
    ```
 
    Customise the appearance as desired:

    * Dynamic text style.
    * Markdown syntax color.
    * Code's font and color.
    * Quotes' font and color.
 
    As per Apple's documentation it should be enough to assign the
    `UITextView`'s `NSLayoutManager` to the `NSTextStorage` subclass, in our
    case `MarklightTextStorage`.
 
    ```swift
     textStorage.addLayoutManager(textView.layoutManager)
    ```
    However I'm experiencing some crashes if I want to preload some text instead
    of letting the user start from scratch with a new text. A workaround is 
    proposed below.
    
    For simplicity we assume you have a `String` to be highlighted inside an
    editable `UITextView` loaded from a storyboard.

    ```swift
    let string = "# My awesome markdown string"
    ```

    Convert `string` to an `NSAttributedString`

    ```swift
    let attributedString = NSAttributedString(string: string)
    ```
 
    Set the loaded string to the `UITextView`

    ```swift
    textView.attributedText = attributedString
    ```
 
    Append the loaded string to the `NSTextStorage`

    ```swift
    textStorage.appendAttributedString(attributedString)
    ```
 
    For more informations on how to implement your own `NSTextStorage` subclass,
    follow Apple's official documentation.
 
    - see: [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorageDelegate_Protocol_TextKit/index.html#//apple_ref/swift/intf/c:objc(pl)NSTextStorage)
    - see: `Marklight`
 */

open class MarklightTextStorage: NSTextStorage, MarklightStyleApplier {

    open lazy var marklightTextProcessor: MarklightTextProcessor = MarklightTextProcessor()

    /// Delegate from this class cluster to a regular `NSTextStorage` instance
    /// because it does some additional performance optimizations 
    /// over `NSMutableAttributedString`.
    fileprivate let imp = NSTextStorage()

        
    // MARK: Syntax highlighting

    /// Switch used to prevent `processEditing` callbacks from 
    /// within `processEditing`.
    fileprivate var isBusyProcessing = false

    /**
    To customise the appearance of the markdown syntax highlights you should
     subclass `MarklightTextProcessor`. Sends out
     `-textStorage:willProcessEditing`, fixes the attributes, sends out
     `-textStorage:didProcessEditing`, and notifies the layout managers of
     change with the
     `-processEditingForTextStorage:edited:range:changeInLength:invalidatedRange:`
     method.  Invoked from `-edited:range:changeInLength:` or `-endEditing`.
    
    - see:
    [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
    */
    override open func processEditing() {

        self.isBusyProcessing = true
        defer { self.isBusyProcessing = false }

        let processingResult = marklightTextProcessor.processEditing(
            styleApplier: self,
            string: self.string,
            editedRange: editedRange)

        defer {
            // Include surrounding paragraphs in layout manager's styling pass
            // after finishing the real edit. Mostly needed for Setex headings.
            processingResult.updateLayoutManagers(for: self)
        }

        super.processEditing()
    }

    public func resetMarklightTextAttributes(textSize: CGFloat, range: NSRange) {
        // Use `imp` directly instead of `self` to avoid changing the edited range
        // after attribute fixing, affecting the insertion point on macOS.
        imp.removeAttribute(NSAttributedString.Key.foregroundColor, range: range)
        imp.addAttribute(NSAttributedString.Key.font, value: MarklightFont.systemFont(ofSize: textSize), range: range)
        imp.addAttribute(NSAttributedString.Key.paragraphStyle, value: NSParagraphStyle(), range: range)
    }


    // MARK: Reading Text
    
    /**
    Use this method to extract the text from the `UITextView` as plain text.
    
    - returns: The `String` containing the text inside the `UITextView`.
    
    - see:
    [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
     */
    override open var string : String {
        return imp.string
    }
    
    /**
    Returns the attributes for the character at a given index.
    The attributes for the character at index.
     
    - parameter index: The index for which to return attributes. This value must
      lie within the bounds of the receiver.
     - parameter aRange: Upon return, the range over which the attributes and
       values are the same as those at index. This range isn’t necessarily the
       maximum range covered, and its extent is implementation-dependent. If you
       need the maximum range, use
       attributesAtIndex:longestEffectiveRange:inRange:. If you don't need this
       value, pass NULL.
     - returns: The attributes for the character at index.     - see:
     [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
     */

    open override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return imp.attributes(at: location, effectiveRange: range)
    }
    
    // MARK: Text Editing
    
    /**
    Replaces the characters in the given range with the characters of the given
     string. The new characters inherit the attributes of the first replaced
     character from aRange. Where the length of aRange is 0, the new characters
     inherit the attributes of the character preceding aRange if it has any,
     otherwise of the character following aRange. Raises an NSRangeException if
     any part of aRange lies beyond the end of the receiver’s characters.
    - parameter aRange: A range specifying the characters to replace.
    - parameter aString: A string specifying the characters to replace those in
       aRange.
    - see:
    [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
    */
    override open func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        imp.replaceCharacters(in: range, with: str)
        edited([.editedCharacters], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    /**
    Sets the attributes for the characters in the specified range to the 
    specified attributes. These new attributes replace any attributes previously
    associated with the characters in aRange. Raises an NSRangeException if any
    part of aRange lies beyond the end of the receiver’s characters. To set
    attributes for a zero-length NSMutableAttributedString displayed in a text
    view, use the NSTextView method setTypingAttributes:.
     - parameter attributes: A dictionary containing the attributes to set. 
       Attribute keys can be supplied by another framework or can be custom ones
       you define. For information about where to find the system-supplied
       attribute keys, see the overview section in NSAttributedString Class
       Reference.
     - parameter aRange: The range of characters whose attributes are set.
     - see: 
        [`NSMutableAttributedString`](xcdoc://?url=developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSMutableAttributedString_Class/index.html#//apple_ref/swift/cl/c:objc(cs)NSMutableAttributedString
     )
     - see:
        [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
     */
    
    override open func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        // When we are processing, using the regular callback triggers will
        // result in the caret jumping to the end of the document.
        guard !isBusyProcessing else {
            imp.setAttributes(attrs, range: range)
            return
        }

        beginEditing()
        imp.setAttributes(attrs, range: range)
        edited([.editedAttributes], range: range, changeInLength: 0)
        endEditing()
    }

    #if os(iOS)

    // MARK: - Dynamic text sizing

    required override public init() {
        super.init()
        observeTextSize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        observeTextSize()
    }

    /**
     Internal method to register to notifications determined by dynamic type size
     changes and redraw the attributed text with the appropriate text size.

     - note: Currently it works only after the user adds or removes some chars inside the
     `UITextView`.
     */
    // TODO: Make this work without needing to type in the text view.
    func observeTextSize() {
        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) -> Void in
            self?.invalidateTextSizeForWholeRange()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    fileprivate func invalidateTextSizeForWholeRange() {
        let wholeRange = NSMakeRange(0, (self.string as NSString).length)
        self.invalidateAttributes(in: wholeRange)
        for layoutManager in self.layoutManagers {
            layoutManager.invalidateDisplay(forCharacterRange: wholeRange)
        }
    }
    #endif
}
