//
//  Preview.swift
//  Vise
//
//  Created by Fedir Korniienko on 02.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class Preview: NSObject,Mappable {
    
    private let kFileNameKey:                              String = "filename"
    private let kFilePathKey:                              String = "filepath"
    private let kIsMainKey:                                String = "is_main"
    private let kIdKey:                                    String = "id"
    
    var filename:                                           String?
    var filepath:                                           String?
    var isMain:                                             Bool?
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
        filepath                    = json[kFilePathKey].string
        isMain                      = json[kIsMainKey].bool
        id                          = json[kIdKey].intValue
        
    }
    
    public func mapping(map: Map) {
        filename                    <- map[kFileNameKey]
        filepath                    <- map[kFilePathKey]
        isMain                      <- map[kIsMainKey]
        id                          <- map[kIdKey]
    }
}
