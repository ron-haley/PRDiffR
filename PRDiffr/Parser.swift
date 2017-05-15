//
//  Parser.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation
import UIKit

struct Parser {
    let results: [String]
    var position: Int

    init(_ diffs: String) {
        self.results = diffs.components(separatedBy: .newlines)
        self.position = 0
    }

    mutating func buildDiffObject() -> [DiffObject] {
        var diffObjects = [DiffObject]()

        while position < results.count {
            if isBeginningOfDiff(position: position) {
                var diffObject = DiffObject()

                // Get file Name
                position += 3
                diffObject.fileName = getFileName(string: results[position])

                while position + 1 < results.count && !isBeginningOfDiff(position: position + 1) {
                    position += 1
                    diffObject.lineChanges.append(results[position])
                }
                
                diffObject.buildDiffCells()
                diffObjects.append(diffObject)
                position += 1
            }
        }

        return diffObjects
    }

    func isBeginningOfDiff(position: Int) -> Bool {
        return results[position].contains("diff --git")
    }

    func getFileName(string: String) -> String {
        let offset = 6
        let index = string.index(string.startIndex, offsetBy: offset)
        return string.substring(from: index)
    }
}
