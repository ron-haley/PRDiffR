//
//  Router.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/11/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    static let baseURL = ""
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        default:
            break
        }
        
        return urlRequest
    }
}
