//
//  ViewController.swift
//  Marklight Sample
//
//  Created by Matteo Gavagnin on 01/01/16.
//  Copyright © 2016 MacTeo. All rights reserved.
//

import UIKit

// Import the Marklight framework
import Marklight

class ViewController: UIViewController {

    // Keep strong instance of the `NSTextStorage` subclass
    let textStorage = MarklightTextStorage()
    
    // Connect an outlet from the `UITextView` on the storyboard
    @IBOutlet weak var textView: UITextView!

    // Connect the `textView`'s bottom layout constraint to react to keyboard movements
    @IBOutlet weak var bottomTextViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a beautiful padding to the `UITextView` content
        textView.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4)
        
        textStorage.codeColor = UIColor.orangeColor()
        textStorage.quoteColor = UIColor.darkGrayColor()
        textStorage.syntaxColor = UIColor.blueColor()
        textStorage.codeFontName = "Courier"
        textStorage.fontTextStyle = UIFontTextStyleSubheadline
        
        // Load a sample markdown content from a file inside the app bundle
        if let samplePath = NSBundle.mainBundle().pathForResource("Sample", ofType:  "md"){
            do {
                let string = try String(contentsOfFile: samplePath)
                // Convert string to an `NSAttributedString`
                let attributedString = NSAttributedString(string: string)
                // Set the loaded string to the `UITextView`
                textView.attributedText = attributedString
                // Append the loaded string to the `NSTextStorage`
                textStorage.appendAttributedString(attributedString)
            } catch _ {
                print("Cannot read Sample.md file")
            }
        }

        // Assign the `UITextView`'s `NSLayoutManager` to the `NSTextStorage` subclass
        textStorage.addLayoutManager(textView.layoutManager)
        
        // We do some magic to resize the `UITextView` to react the the keyboard size change (appearance, disappearance, ecc)
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            let initialRect = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue
            let _ = self.view.frame.size.height - self.view.convertRect(initialRect!, fromView: nil).origin.y
            let keyboardRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
            let newHeight = self.view.frame.size.height - self.view.convertRect(keyboardRect!, fromView: nil).origin.y
            
            self.bottomTextViewConstraint.constant = newHeight
            
            self.textView.setNeedsUpdateConstraints()
            
            let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
            let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntegerValue
            
            
            UIView.animateWithDuration(duration!, delay: 0, options: [UIViewAnimationOptions(rawValue: curve!), .BeginFromCurrentState], animations: { () -> Void in
                self.textView.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    
            })
        }
        
        // Partial fixes to a long standing bug, to keep the caret inside the `UITextView` always visible
        NSNotificationCenter.defaultCenter().addObserverForName(UITextViewTextDidChangeNotification, object: textView, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            if self.textView.textStorage.string.hasSuffix("\n") {
                CATransaction.setCompletionBlock({ () -> Void in
                    self.scrollToCaret(self.textView, animated: false)
                })
            } else {
                self.scrollToCaret(self.textView, animated: false)
            }
        }
    }
    
    func scrollToCaret(textView: UITextView, animated: Bool) {
        var rect = textView.caretRectForPosition(textView.selectedTextRange!.end)
        rect.size.height = rect.size.height + textView.textContainerInset.bottom
        textView.scrollRectToVisible(rect, animated: animated)
    }
}

