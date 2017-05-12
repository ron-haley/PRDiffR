//
//  BackendError.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/11/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Alamofire

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}
