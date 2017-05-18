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
                // Determine DiffFile & Create DiffObject
                let diffFile = getDiffFile(index: position + 1)
                var diffObject = DiffObject(diffFile: diffFile)

                // Determine position of file names
                while results[position].nthChar(2) != "@@" {
                    position += 1
                }

                // Get file Name
                position -= 1
                diffObject.fileName = getFileName(index: position)

                while position + 1 < results.count && !results[position + 1].containsDiffGit {
                    position += 1
                    if diffFile == .new && results[position] == "" {
                        continue
                    } else {
                        diffObject.lineChanges.append(results[position])
                    }
                }
                
                diffObject.buildDiffCells()
                diffObjects.append(diffObject)
                position += 1
            }
        }

        return diffObjects
    }

    func getDiffFile(index: Int) -> DiffFile {
        if results[index].contains("new file") {
            return .new
        } else if results[index].contains("deleted file") {
            return .deleted
        } else {
            return .same
        }
    }

    func getFileName(index: Int) -> String {
        if results[index].contains("/dev/null") {
            return fileName(string: results[index - 1])
        } else {
            return fileName(string: results[index])
        }
    }

    func fileName(string: String) -> String {
        let offset = 6
        let index = string.index(string.startIndex, offsetBy: offset)
        return string.substring(from: index)
    }
}
