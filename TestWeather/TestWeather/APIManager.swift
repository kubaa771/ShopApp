//
//  APIManager.swift
//  TestWeather
//
//  Created by user on 18/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager: UIViewController{
    
    static var shared:APIManager = APIManager()
    
    func sendRequest( url:String, method:HTTPMethod, parameters:[String:Any]?, successBlock: @escaping ( _ jsonResponse:JSON) -> (), andFailure failureBlock: @escaping ( _ code:Int?,  _ message:String?) -> ()) -> (DataRequest?) {
        
        let req = AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            guard response.result.isSuccess else {
                failureBlock(0, response.result.error?.localizedDescription)
                return
            }
            
            guard let value = response.result.value  else {
                failureBlock(0, "No value")
                return
            }
            let json = JSON(value)
            successBlock(json)
        })

        return req
    }
        
}
