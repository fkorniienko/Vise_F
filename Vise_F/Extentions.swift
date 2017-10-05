//
//  Extentions.swift
//  Vise
//
//  Created by Fedir Korniienko on 05.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import Foundation
import UIKit
//MARK: UIView
extension UIView {
    
    func getTargetViewController() -> (UIViewController)? {
        var responder : UIResponder? = self
        
        while !(responder is UIViewController) {
            if let res = responder {
                responder = res.next
            } else { break }
        }
        return responder == nil ? nil : responder as? UIViewController
    }
}
//MARK: Dictionary
extension Dictionary{
    public init(keys: [Key], values: [Value])
    {
        precondition(keys.count == values.count)
        
        self.init()
        
        for (index, key) in keys.enumerated()
        {
            self[key] = values[index]
        }
    }
}
