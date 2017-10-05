//
//  ClipsData.swift
//  Vise
//
//  Created by Fedir Korniienko on 02.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class ClipsData: NSObject, Mappable{
    
    private let kErrorKey:                                     String = "error"
    private let kMessageKey:                                   String = "message"
    private let kDataListKey:                                  String = "data_list"
    
    var error:                                                  Int?
    var message:                                                String?
    var dataList:                                               DataList?
    
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
        error                                           = json[kErrorKey].int
        message                                         = json[kErrorKey].string
        dataList                                        = DataList(json: json[kDataListKey])
        
    }
    
    public func mapping(map: Map) {
        error                                           <- map[kErrorKey]
        message                                         <- map[kMessageKey]
        dataList                                        <- map[kDataListKey]
        
    }
}
