//
//  RestAPI.swift
//  ydzbApp
//
//  Created by 刘驰 on 15/1/21.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//
import Foundation
import Alamofire



enum RequestError {
    case BadAuth
    case Success
    case ConnectionFailed
}


var headers: [String: String] = [:]

class RestAPI {
    
    class func sendGETRequest(request: String, params:[String : AnyObject], success: (data: AnyObject?) -> (), error: (error: RequestError) -> ()) {
        Alamofire.request(.GET, B.BASE_URL + request,parameters:params)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .Success:
                    success(data: response.result.value!)
                case .Failure(let encodingError):
                    error(error: .ConnectionFailed)
                    SwiftSpinner.hide()
                }
        }
    }
    
    class  func sendPostRequest(request:String,params:[String : AnyObject], success: (data: AnyObject?) -> (), error: (error: RequestError) -> ()){
        Alamofire.request(.POST, B.BASE_URL + request, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    success(data: response.result.value!)
                case .Failure(let encodingError):
                    error(error: .ConnectionFailed)
                    SwiftSpinner.hide()
                }
        }
        
    }
    
    
    class func sendPostUpload(request:String,params:[String:String],fileData:NSData, success: (data: AnyObject?) -> (), error: (error: RequestError) -> ()){
        let urlRequest = PhotoUtils.urlRequestWithComponents(request, parameters: params, imageData: fileData)
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .responseJSON { response in
                switch response.response!.statusCode {
                case 200:
                    success(data: response.result.value!)
                default:
                    error(error: .ConnectionFailed)
                    SwiftSpinner.hide()
                }
        }
    }
    
    class func sendPostRequestGetSession(request:String,params:[String : AnyObject], success: (data: AnyObject?) -> (), error: (error: RequestError) -> ()){
        Alamofire.request(.POST, B.BASE_URL + request, parameters: params)
            .response { (request, response, data, err) in
                switch response?.statusCode {
                case .Some(let status) where status == 200:
                    for (field, value) in response!.allHeaderFields {
                        headers["\(field)"] = "\(value)"
                        if field == "Set-Cookie" {
                            //userDefaultsUtil.setSessionId(value as! String)
                        }
                    }
                    success(data: data)
                default:
                    error(error: .ConnectionFailed)
                    SwiftSpinner.hide()
                }
        }

    }
    
}
