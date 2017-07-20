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

class ViewController: UIViewController, UITextViewDelegate {

    // Keep strong instance of the `NSTextStorage` subclass
    let textStorage = MarklightTextStorage()
    
    var textView : UITextView?

    // Connect the `textView`'s bottom layout constraint to react to keyboard movements
    var bottomTextViewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textStorage.marklightTextProcessor.codeColor = UIColor.orange
        textStorage.marklightTextProcessor.quoteColor = UIColor.darkGray
        textStorage.marklightTextProcessor.syntaxColor = UIColor.blue
        textStorage.marklightTextProcessor.codeFontName = "Courier"
        textStorage.marklightTextProcessor.fontTextStyle = UIFontTextStyle.subheadline.rawValue
        textStorage.marklightTextProcessor.hideSyntax = true
        
        let layoutManager = NSLayoutManager()
        
        // Assign the `UITextView`'s `NSLayoutManager` to the `NSTextStorage` subclass
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        
        textView = UITextView(frame: view.bounds, textContainer: textContainer)
        guard let textView = textView else { return }
        
        textView.frame = view.bounds
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        bottomTextViewConstraint = NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        guard let bottomTextViewConstraint = bottomTextViewConstraint else { return }
        view.addConstraint(bottomTextViewConstraint)
        
        // Add a beautiful padding to the `UITextView` content
        textView.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4)
        textView.delegate = self
        textView.isEditable = true
        
        // Load a sample markdown content from a file inside the app bundle
        if let samplePath = Bundle.main.path(forResource: "Sample", ofType:  "md"){
            do {
                let string = try String(contentsOfFile: samplePath)
                // Convert string to an `NSAttributedString`
                let attributedString = NSAttributedString(string: string)
                
                // Set the loaded string to the `UITextView`
                textStorage.append(attributedString)
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
            
            guard let bottomTextViewConstraint = self.bottomTextViewConstraint else { return }
            bottomTextViewConstraint.constant = newHeight
            
            textView.setNeedsUpdateConstraints()
            
            let duration = ((notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
            let curve = ((notification as NSNotification).userInfo![UIKeyboardAnimationCurveUserInfoKey] as AnyObject).uintValue
            
            UIView.animate(withDuration: duration!, delay: 0, options: [UIViewAnimationOptions(rawValue: curve!), .beginFromCurrentState], animations: { () -> Void in
                textView.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    
            })
        }
        
        // Partial fixes to a long standing bug, to keep the caret inside the `UITextView` always visible
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: textView, queue: OperationQueue.main) { (notification) -> Void in
            if textView.textStorage.string.hasSuffix("\n") {
                CATransaction.setCompletionBlock({ () -> Void in
                    self.scrollToCaret(textView, animated: false)
                })
            } else {
                self.scrollToCaret(textView, animated: false)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("Should interact with: \(URL)")
        return true
    }
    
    func scrollToCaret(_ textView: UITextView, animated: Bool) {
        var rect = textView.caretRect(for: textView.selectedTextRange!.end)
        rect.size.height = rect.size.height + textView.textContainerInset.bottom
        textView.scrollRectToVisible(rect, animated: animated)
    }
}

