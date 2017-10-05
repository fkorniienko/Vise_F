//
//  DataList.swift
//  Vise
//
//  Created by Fedir Korniienko on 02.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//


import Foundation
import ObjectMapper
import SwiftyJSON

class DataList: NSObject, Mappable{
    
    private let kClipsKey:                          String = "clips"

    var clips          : [Clips?] = []
    
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
        if let items = json[kClipsKey].array {
            for item in items {
                self.clips.append(Clips(json: item))
            }
        }
    }
    
    public func mapping(map: Map) {
        var clips: [Clips]?
        clips <- map[kClipsKey]
        if let clips = clips {
            for clip in clips {
                self.clips.append(clip)
            }
        }
    }
}
