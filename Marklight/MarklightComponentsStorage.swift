//
//  MarklightComponentsStorage.swift
//  Marklight
//
//  Created by Matteo Gavagnin on 31/08/2017.
//

import Foundation
import CoreGraphics

public protocol MarklightComponentsStorage {
    func addComponent(_ string: String)
    func addComponent(_ attributedString: NSAttributedString)
}
