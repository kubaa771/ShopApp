//
//  APIManager.swift
//  TestWeather
//
//  Created by user on 18/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: UIViewController{
   func getData(completion: @escaping ([City]?) -> Void) {
    var dataArray = [City] ()
      let url = URL(string: "https://concise-test.firebaseio.com/cities.json")
        AF.request(url!).responseJSON { (response) in
            guard response.result.isSuccess else {
                self.displayAlert(errorMessage: "Error", tryAgainClosure: {
                    self.getData(completion: { (self) in //?????
                    })
                })
                completion(nil)
                return
            }
            
            guard let value = response.result.value as? [[String: Any]] else {
                self.displayAlert(errorMessage: "Error while getting data", tryAgainClosure: {
                    self.getData(completion: { (self) in
                    })
                })
                completion(nil)
                return
            }
            
            for object in value {
                guard let id = object["id"] as? Int, let name = object["name"] as? String, let image = object["image"] as? String, let description = object["description"] as? String else {
                    self.displayAlert(errorMessage: "Error while fetching data", tryAgainClosure: {
                        self.getData(completion: { (self) in
                        })
                    })
                    return
                    }
                dataArray.append(City(name: name, id: id, image: image, description: description, isExpanded: false))
            }
            completion(dataArray)
        }
    
        
    }
        
}
