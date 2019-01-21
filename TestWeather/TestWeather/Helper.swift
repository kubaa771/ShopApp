//
//  Helper.swift
//  TestWeather
//
//  Created by user on 21/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

class Helper {
    
    static func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
}

