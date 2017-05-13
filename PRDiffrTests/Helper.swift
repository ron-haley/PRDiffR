//
//  Helper.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/12/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation

struct Helper {
    static func readJSON<T>(fileName: String) -> T {
        do {
            let data = try NSData(contentsOfFile: fileName) as Data
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let JSON = json as? T {
                return JSON
            } else {
                fatalError()
            }
        } catch {
            fatalError()
        }
    }
}
