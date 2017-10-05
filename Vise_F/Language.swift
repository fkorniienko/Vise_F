//
//  Language.swift
//  
//
//  Created by Fedir Korniienko on 02.10.17.
//
//

import Foundation
import ObjectMapper
import SwiftyJSON

class Language: NSObject,Mappable {
    
    private let kNameKey:                         String = "name"
    
    var name:                                     String?
    
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
        name                   = json[kNameKey].string
  
        
    }
    
    public func mapping(map: Map) {
        name                   <- map[kNameKey]
       
    }
}
