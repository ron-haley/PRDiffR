//
//  String+Extensions.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/12/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation

public extension String {

    /*
        Since only dealing with a date format from GitHub
        I decided against creating a method that would allow
        the date format to be passed as a parameter.
    */
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.GITHUB_DATE_FORMAT
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: self)
    }

    var trim: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
