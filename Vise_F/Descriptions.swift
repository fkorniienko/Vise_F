//
//  Descriptions.swift
//  Vise
//
//  Created by Fedir Korniienko on 02.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class Descriptions: NSObject, Mappable{
    
    private let kEnKey:                          String = "en"
    private let kRuKey:                          String = "ru"
    private let kUaKey:                          String = "ua"
    
    var english:                                      Language?
    var rus:                                          Language?
    var ukrain:                                       Language?
    
    
    required public init?(map: Map){
        super.init()
    }
    
    required public override init() {
        super.init()
    }
    
    
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        super.init()
        english                           = Language(json: json[kEnKey])
        rus                               = Language(json: json[kRuKey])
        ukrain                            = Language(json: json[kUaKey])
        
    }
    
    public func mapping(map: Map) {
        english                           <- map[kEnKey]
        rus                               <- map[kRuKey]
        ukrain                            <- map[kUaKey]
    }
}
