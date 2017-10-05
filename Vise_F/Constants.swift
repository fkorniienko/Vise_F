//
//  Constants.swift
//  Puvouice
//
//  Created by Fedir Korniienko on 2/11/16.
//  Copyright © 2016 Puvouice. All rights reserved.
//

import Alamofire
import UIKit

enum APIEndPoints: Int {
    case getClips
    case getImage
    case getVideo
    var urlSufix: String {
        switch self {
        case .getClips: return ""            
        case .getImage: return "getImage.php?id="
        case .getVideo: return "external/video?id="
        }
    }
    
    
    var requestMethod: Alamofire.HTTPMethod{
        switch self {
        case .getClips:
            return .get

        default: return .put
        }
    }
    
    var bodyParams: [String] {
        switch self {
        default: break
        }
        return []
        
    }
    
    var accessTokenRequared: Bool {
        
        switch self {
        case .getClips:
            return false
        default: return true
        }
    }
    
    var keyPath: String{
        switch self {
            
            
        default:
            return ""
        }
        
    }
    
    var objectType: Bool{
        switch self {
        default: return true
        }
    }
}
    


let windowSize = (UIApplication.shared.keyWindow?.frame.size)

let documentsDirectory : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]


