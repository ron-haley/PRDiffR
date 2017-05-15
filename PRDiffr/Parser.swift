//
//  Parser.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation
import UIKit

enum DiffCellType {
    case info
    case diff
    case same
}

enum DiffLineType {
    case info
    case added
    case removed
    case same
    case unknown
}

struct DiffCell {
    var cellType: DiffCellType!
    var info: String?
    var infoCellColor: UIColor?
    var oldCell: (Int?, String?, UIColor?)? // (lineNumber, oldText, Cell color)
    var newCell: (Int?, String?, UIColor?)?

    init(type: DiffCellType) {
        self.cellType = type
    }

}

struct DiffObject {
    var fileName: String?
    var lineNumbers: [((Int, Int), (Int, Int))]
    var lineChanges: [String]
    var diffCells: [DiffCell]

    init() {
        self.lineChanges = [String]()
        self.lineNumbers = [((Int, Int), (Int, Int))]()
        self.diffCells = [DiffCell]()
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

    func getDiffLines(string: String) -> ((Int, Int), (Int, Int))? {
        let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { $0 != "" }
            .map { Int($0)! }

        guard numbers.count == 4 else { return nil }
        return ((numbers[0], numbers[1]), (numbers[2], numbers[3]))
    }

    mutating func buildDiffCells() {
        diffCells.removeAll()

        for (index, lineChange) in lineChanges.enumerated() {
            if getLineType(text: lineChange) == .info {
                if let diffLines = getDiffLines(string: lineChange) {
                    let diffCell = infoCell(text: lineChange)
                    diffCells.append(diffCell)

                    var oldLineNumber = diffLines.0.0
                    var newLineNumber = diffLines.1.0
                    let newChangeCount = diffLines.1.1
                    var newIndex = index + 1

                    for _ in (index + 1)...(index + newChangeCount) {
                        let line = lineChanges[newIndex]
                        print("blah: \(line)")
                        switch getLineType(text: line) {
                        case .added:
                            let diffCell = addedCell(text: line, lineNumber: newLineNumber)
                            diffCells.append(diffCell)
                            newLineNumber += 1
                        case .same:
                            let diffCell = unchangedCell(text: line,
                                                         oldLineNumber: oldLineNumber,
                                                         newLineNumber: newLineNumber)
                            diffCells.append(diffCell)
                            oldLineNumber += 1
                            newLineNumber += 1
                        case .info:
                            break
                        case .removed:
                            break
                        default:
                            break
                        }

                        newIndex += 1
                    }
                }
            }
        }
    }

    func addedCell(text: String, lineNumber: Int) -> DiffCell {
        var diffCell = DiffCell(type: .diff)
        diffCell.oldCell = (nil, nil, UIColor.emptyCell())
        diffCell.newCell = (lineNumber, text, UIColor.addedCell())

        return diffCell
    }

    func infoCell(text: String) -> DiffCell {
        var diffCell = DiffCell(type: .info)
        diffCell.info = text
        diffCell.infoCellColor = UIColor.infoCell()

        return diffCell
    }

    func removedCell(oldText: String, newText: String, lineNumber: Int) -> DiffCell {
        var diffCell = DiffCell(type: .diff)
        diffCell.oldCell = (lineNumber, oldText, UIColor.removedCell())
        diffCell.newCell = (lineNumber, newText, UIColor.addedCell())

        return diffCell
    }
 
    func unchangedCell(text: String, oldLineNumber: Int, newLineNumber: Int) -> DiffCell {
        var diffCell = DiffCell(type: .same)
        diffCell.oldCell = (oldLineNumber, text, UIColor.white)
        diffCell.newCell = (newLineNumber, text, UIColor.white)

        return diffCell
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
