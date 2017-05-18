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

    /*
        This method takes the diff file returned from GitHub
        and creates `DiffObject`s.
     
        - TODO: Refactor - this methods should be responsible for
                building DiffObject's `[DiffCell]` attr which will
                improve performance and also allow the
                `lineChanges` attr to deleted.
    */
    mutating func buildDiffObject() -> [DiffObject] {
        var diffObjects = [DiffObject]()

        while position < results.count {
            if results[position].containsDiffGit {
                // Create DiffObject
                var diffObject = DiffObject()

                // Grab headers
                var tempCounter = position
                while results[tempCounter].nthChar(2) != "@@" {
                    tempCounter += 1
                }

                // Get file Name
                position = tempCounter - 1
                diffObject.fileName = getFileName(position: position)

                while position + 1 < results.count && !results[position + 1].containsDiffGit {
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

    func getFileName(position: Int) -> String {
        if results[position].contains("/dev/null") {
            return fileName(string: results[position - 1])
        } else {
            return fileName(string: results[position])
        }
    }

    func fileName(string: String) -> String {        let offset = 6
        let index = string.index(string.startIndex, offsetBy: offset)
        return string.substring(from: index)
    }
}
