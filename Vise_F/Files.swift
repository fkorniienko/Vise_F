//
//  Files.swift
//  Vise
//
//  Created by Fedir Korniienko on 02.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class Files: NSObject,Mappable {
    
    private let kFileNameKey:                              String = "filename"
    private let kTypeKey:                                  String = "type"
    private let kIdKey:                                    String = "id"
    
    var filename:                                           String?
    var type:                                               String?
    var id:                                                 Int?
    
    
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
        filename                    = json[kFileNameKey].string
        type                        = json[kTypeKey].string
        id                          = json[kIdKey].intValue
        
    }
    
    public func mapping(map: Map) {
        filename                    <- map[kFileNameKey]
        type                        <- map[kTypeKey]
        id                          <- map[kIdKey]
    }
}
