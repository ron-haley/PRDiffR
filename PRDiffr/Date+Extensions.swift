//
//  Date+Extensions.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/12/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation

public extension Date {
    static let GITHUB_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:sszzz"

    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.GITHUB_DATE_FORMAT
        return dateFormatter.string(from: self)
    }

    var toReadableString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        return dateFormatter.string(from: self)
    }

}
