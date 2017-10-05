//
//  ServerManager.swift
//  Puvouice
//
//  Created by Fedir Korniienko on 2/11/16.
//  Copyright © 2016 Puvouice. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

class ServerManager: NSObject{

 
    let BaseAPIUrl = "http://dev.see.ua/"
    static let sharedManager = ServerManager()
    
    let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return SessionManager(configuration: configuration)
    }()
    
    private override init() {
    }
    
    private func urlStringWithParameter(params: [String]?) -> String {
        if params == nil {
            return ""
        }
        var url: String = ""
        
        for param in params! {
            url += "/" + param
        }
        
        return url
    }
        
    func fetchDataWithEndPoint<T:Mappable>(type: T, endPoint: APIEndPoints, urlParams: [String]? = nil, urlStringParams: String = "", bodyParams: [String]? = nil, bodyParamsInt: [NSNumber]? = nil,  withCompletionClosure completionClosure: @escaping (_ data: Any?, _ error: NSError?) ->()) {
        let url = BaseAPIUrl + endPoint.urlSufix + self.urlStringWithParameter(params: urlParams) + urlStringParams
        
        
        var body: [String: String]? = nil
        
        if bodyParams != nil {
            body = bodyParams!.count > 0 ? Dictionary.init(keys: endPoint.bodyParams, values: bodyParams!) : [String: String]()
        }
        
        if endPoint.objectType {
            
            self.getObject(success: { (object: T) in
                
                completionClosure(object, nil)
            }, methods: endPoint.requestMethod, url: url, parameters: body as [String : AnyObject]?, headers: nil, keyPath: endPoint.keyPath) { (error: NSError) in
                completionClosure(nil, error)
            }
            
        } else {
            self.getArray(success: { (objects: [T]) in
                completionClosure(objects, nil)
            }, methods: endPoint.requestMethod, url: url, parameters: body as [String : AnyObject]?, headers: nil, keyPath: endPoint.keyPath) { (error: NSError) in
                completionClosure(nil, error)
            }
        }
    }
    
    private func getObject <T:Mappable> (success:@escaping (T) -> Void, methods: HTTPMethod, url: String?, parameters: [String: AnyObject]?, headers: [String: String]?, keyPath: String, fail:@escaping (_ error:NSError)->Void)->Void {
        
        DispatchQueue.global(qos: .background).async {
            
            self.manager.request(url!, method: methods, parameters: parameters, encoding:  URLEncoding.methodDependent, headers: headers).responseObject(keyPath: keyPath) { (response: DataResponse <T>) in
                
                if let js = String(data: response.data!, encoding: String.Encoding.utf8) {
                    let dic = JSON.parse(js)
                    
                    if dic["code"].int == 401  || dic["code"].int == 429 || dic["code"].int == 503 {
                        let serverError = self.formError(from: dic)
                        fail(serverError)
                        
                        return
                        
                    } else if dic["code"].int == 404{
                        fail(self.formError(from: dic))
                        
                        return
                    }
                }
                
                switch response.result {
                case .success:
                    success(response.result.value!)
                case .failure:
                    fail(response.result.error! as NSError)
                }
            }
            
        }
    }
    
    private func getArray <T:Mappable> (success:@escaping ([T]) -> Void, methods: HTTPMethod, url: String?, parameters: [String: AnyObject]?, headers: [String: String]?, keyPath: String, fail:@escaping (_ error:NSError)->Void)->Void {
        DispatchQueue.global(qos: .background).async {
            
            self.manager.request(url!, method: methods, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseArray(keyPath: keyPath) { (response: DataResponse <[T]>) in
                
                if let js = String(data: response.data!, encoding: String.Encoding.utf8) {
                    let dic = JSON.parse(js)
                    if dic["code"].int == 401 || dic["code"].int == 422 || dic["code"].int == 429 || dic["code"].int == 503 {
                        let serverError = self.formError(from: dic)
                        fail(serverError)
                        return
                    }
                }
                print (response)
                switch response.result {
                case .success:
                    success(response.result.value!)
                case .failure:
                    fail(response.result.error! as NSError)
                }
            }
        }
    }
    
}

extension ServerManager {
    func formError(from dictionary: SwiftyJSON.JSON) -> NSError {
        let currentError = NSError(domain: "somedomain",
                                   code: dictionary["code"].int!,
                                   userInfo: ["message": dictionary["message"].stringValue])
        return currentError
    }
}

