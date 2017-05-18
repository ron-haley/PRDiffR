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

    init(_ diffs: String) {
        self.results = diffs.components(separatedBy: .newlines)
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
        var index = 0

        while index < results.count {
            if results[index].containsDiffGit {
                // Determine DiffFile & Create DiffObject
                let diffFile = getDiffFile(index: index + 1)
                var diffObject = DiffObject(diffFile: diffFile)

                // Determine position of file names
                while results[index].nthChar(2) != "@@" {
                    index += 1
                }

                // Get file Name
                index -= 1
                diffObject.fileName = getFileName(index: index)

                while index + 1 < results.count && !results[index + 1].containsDiffGit {
                    index += 1
                    if diffFile == .new && results[index] == "" {
                        continue
                    } else {
                        diffObject.lineChanges.append(results[index])
                    }
                }
                
                diffObject.buildDiffCells()
                diffObjects.append(diffObject)
                index += 1
            }
        }

        return diffObjects
    }

    func getDiffData(string: String) -> ((Int, Int), (Int, Int))? {
        let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { $0 != "" }
            .map { Int($0)! }
        
        guard numbers.count == 4 else { return nil }
        return ((numbers[0], numbers[1]), (numbers[2], numbers[3]))
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

    func getLineType(text: String) -> DiffLineType {
        let char = text.nthChar(1)
        
        switch char {
        case "+":
            return .added
        case "@":
            return .info
        case "-":
            return .removed
        default:
            return .same
        }
    }
}
