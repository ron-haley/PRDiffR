//
//  String+Extensions.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/12/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation

public extension String {

    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.GITHUB_DATE_FORMAT
        return dateFormatter.date(from: self)
    }
}
