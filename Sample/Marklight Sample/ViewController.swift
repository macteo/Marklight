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
        
        textStorage.codeColor = UIColor.orange
        textStorage.quoteColor = UIColor.darkGray
        textStorage.syntaxColor = UIColor.blue
        textStorage.codeFontName = "Courier"
        textStorage.fontTextStyle = UIFontTextStyle.subheadline.rawValue
        
        // Assign the `UITextView`'s `NSLayoutManager` to the `NSTextStorage` subclass
        textStorage.addLayoutManager(textView.layoutManager)
        
        // Load a sample markdown content from a file inside the app bundle
        if let samplePath = Bundle.main.path(forResource: "Sample", ofType:  "md"){
            do {
                let string = try String(contentsOfFile: samplePath)
                // Convert string to an `NSAttributedString`
                
                let attributedString = NSAttributedString(string: string)
                // Set the loaded string to the `UITextView`
                textStorage.append(attributedString)

                // textView.attributedText = attributedString
                // Append the loaded string to the `NSTextStorage`
                
            } catch _ {
                print("Cannot read Sample.md file")
            }
        }
        
        // We do some magic to resize the `UITextView` to react the the keyboard size change (appearance, disappearance, ecc)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: OperationQueue.main) { (notification) -> Void in
            
            let initialRect = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue
            let _ = self.view.frame.size.height - self.view.convert(initialRect!, from: nil).origin.y
            let keyboardRect = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let newHeight = self.view.frame.size.height - self.view.convert(keyboardRect!, from: nil).origin.y
            
            self.bottomTextViewConstraint.constant = newHeight
            
            self.textView.setNeedsUpdateConstraints()
            
            let duration = ((notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
            let curve = ((notification as NSNotification).userInfo![UIKeyboardAnimationCurveUserInfoKey] as AnyObject).uintValue
            
            
            UIView.animate(withDuration: duration!, delay: 0, options: [UIViewAnimationOptions(rawValue: curve!), .beginFromCurrentState], animations: { () -> Void in
                self.textView.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    
            })
        }
        
        // Partial fixes to a long standing bug, to keep the caret inside the `UITextView` always visible
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: textView, queue: OperationQueue.main) { (notification) -> Void in
            if self.textView.textStorage.string.hasSuffix("\n") {
                CATransaction.setCompletionBlock({ () -> Void in
                    self.scrollToCaret(self.textView, animated: false)
                })
            } else {
                self.scrollToCaret(self.textView, animated: false)
            }
        }
    }
    
    func scrollToCaret(_ textView: UITextView, animated: Bool) {
        var rect = textView.caretRect(for: textView.selectedTextRange!.end)
        rect.size.height = rect.size.height + textView.textContainerInset.bottom
        textView.scrollRectToVisible(rect, animated: animated)
    }
}

