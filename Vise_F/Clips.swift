//
//  Clips.swift
//  Vise
//
//  Created by Fedir Korniienko on 02.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class Clips: NSObject, Mappable{
    
    private let kIdKey:                                    String = "id"
    private let kDescriptionsKey:                          String = "descriptions"
    private let kPreviewKey:                               String = "preview"
    private let kFilesKey:                                 String = "files"

    var id:                                                 Int?
    var descriptions:                                       Descriptions?
    var preview:                                            Preview?
    var files : [Files?] = []
    
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
        id                                          = json[kIdKey].int
        descriptions                                = Descriptions(json: json[kDescriptionsKey])
        preview                                     = Preview(json: json[kPreviewKey])
        if let items = json[kFilesKey].array {
            for item in items {
                self.files.append(Files(json: item))
            }
        }
    }
    
    public func mapping(map: Map) {
        id                                          <- map[kIdKey]
        descriptions                                <- map[kDescriptionsKey]
        preview                                     <- map[kPreviewKey]
        var files: [Files]?
        files <- map[kFilesKey]
        if let files = files {
            for file in files {
                self.files.append(file)
            }
        }
    }
}
