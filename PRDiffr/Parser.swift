//
//  Parser.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation

struct DiffObject {
    var fileName: String?
    var lineNumbers: [((Int, Int), (Int, Int))]
    var lineChanges: [String]

    init() {
        self.lineChanges = [String]()
        self.lineNumbers = [((Int, Int), (Int, Int))]()
    }
}

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
                    
                    if isStartOfChanges(position: position) {
                        // Get Linenumbers
                        diffObject.lineChanges.append(results[position])

                        // Store diff numbers
                        if let diffLines = getDiffLines(string: results[position]) {
                            diffObject.lineNumbers.append(diffLines)
                        }
                    } else {
                        diffObject.lineChanges.append(results[position])
                    }
                }
                
                diffObjects.append(diffObject)
                position += 1
            }
        }

        return diffObjects
    }

    func isBeginningOfDiff(position: Int) -> Bool {
        return results[position].contains("diff --git")
    }

    func isStartOfChanges(position: Int) -> Bool {
        return results[position].contains("@@")
    }

    func getFileName(string: String) -> String {
        let offset = 6
        let index = string.index(string.startIndex, offsetBy: offset)
        return string.substring(from: index)
    }

    func getDiffLines(string: String) -> ((Int, Int), (Int, Int))? {
        let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { $0 != "" }
            .map { Int($0)! }

        guard numbers.count == 4 else { return nil }
        return ((numbers[0], numbers[1]), (numbers[2], numbers[3]))
    }
}
