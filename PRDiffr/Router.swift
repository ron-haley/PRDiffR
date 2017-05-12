//
//  Router.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/11/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    static let baseURL = "https://api.github.com"
    
    // Temporary hard coded repo owner and repo name.
    static let repo = "MagicalRecord"
    static let repoOwner = "magicalpanda"
    
    case getPullRequests
    
    var method: HTTPMethod {
        switch self {
        case .getPullRequests:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getPullRequests:
            return "/repos/\(Router.repoOwner)/\(Router.repo)/pulls"
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
