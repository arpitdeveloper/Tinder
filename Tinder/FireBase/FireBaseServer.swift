//
//  FireBaseServer.swift
//  Tinder
//
//  Created by Apple on 06/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import Alamofire

typealias CompletionHandler = (_ resposnObj: DataResponse<Any>) -> Void
class FireBaseServer: NSObject {

    //https://api.gotinder.com
    //https://github.com/fbessez/Tinder
    class func connectToHome(ssidName: String, password: String, responseBlcok: @escaping CompletionHandler){
        let urlStr = "https://api.gotinder.com/auth"

        let parameters =  ["facebook_token": "EAAfZAygJUJ54BAEc8ku0oNiNs43fgUsJv7uc3ihlZAuxhZA9jnpPb8HXHVXecQOZBZAR0DfZASmKTGoyJZBMGijAUz5iEpTCiPFyIZBWpl1QI8d8bg3Mq0Cct4zodHBpgBVTnp5F4TlHrZAjmVfe2ZCj0iHZBBRDUXzq5QtvsNLWchIzHXSnkeUKxvcMRmkWWowm5H6vXHKaOhmbgZDZD", "facebook_id": "100039154202948"]

          Alamofire.request(urlStr, method: .post, parameters: parameters, encoding: URLEncoding.httpBody ) .responseJSON { response in
            
            switch response.result {
            case .success:
                
                //print("reso \(response)")
                responseBlcok (response)
                break
            case .failure(let error):
                print("error \(error)")
                
                break
            }
        }

    }
    
    class func connectToHome(responseBlcok: @escaping CompletionHandler){
         let urlStr = "https://api.gotinder.com//profile"
        Alamofire.request(urlStr, method: .get, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        //debugPrint(response)
                        responseBlcok(response)
        
                        if let data = response.result.value{
                            // Response type-1
                            if  (data as? [[String : AnyObject]]) != nil{
                                print("data_1: \(data)")
                            }
                            // Response type-2
                            if  (data as? [String : AnyObject]) != nil{
        
                                print("data_2: \(data)")
        
                            }
                        }
                    }.resume()
    }
    
}
