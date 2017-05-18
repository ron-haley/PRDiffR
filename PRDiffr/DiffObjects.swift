//
//  DiffObjects.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/14/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation
import UIKit

enum DiffFile {
    case new
    case deleted
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
    var info: String?
    var infoCellColor: UIColor?
    var oldCell: (Int?, String?, UIColor?)? // (lineNumber, oldText, Cell color)
    var newCell: (Int?, String?, UIColor?)?
}

struct DiffObject {
    var fileName: String?
//    var lineNumbers: [((Int, Int), (Int, Int))]
    var diffCells: [DiffCell]
    var diffFile: DiffFile
    var lineChanges: [String]
    
    init(diffFile: DiffFile) {
        self.diffCells = [DiffCell]()
        self.diffFile = diffFile
        self.lineChanges = [String]()
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
    
    /*
        This is the first iteration of the algorithm to build DiffCell objects
        which contain the data necessary for the PRDiffTableCell.
     
        - Note: This needs refactoring; due to time contraints it will have to
                remain. It will also me moved to Parse#buildDiffObject allowing
                the attr lineChanges to be removed an improve performace.
    */
    mutating func buildDiffCells() {
        diffCells.removeAll()
        
        for (index, lineChange) in lineChanges.enumerated() {
            if getLineType(text: lineChange) == .info {
                if let diffLines = getDiffLines(string: lineChange) {
                    var oldLineNumber = diffLines.0.0
                    let oldChangeCount = diffLines.0.1
                    var newLineNumber = diffLines.1.0
                    let newChangeCount = diffLines.1.1
                    var newIndex = index + 1
                    var blackListIndex = [Int]()


                    // Determine max range
                    var maxLines = 0
                    switch diffFile {
                    case .new, .same:
                        maxLines = newChangeCount
                    case .deleted:
                        maxLines = oldChangeCount
                    }
                    
                    if maxLines == 0 { return }
                    
                    for _ in (index + 1)...(index + maxLines) {
                        let line = lineChanges[newIndex]
                        
                        switch getLineType(text: line) {
                        case .added:
                            if !blackListIndex.contains(newIndex) {
                                let diffCell = addedCell(text: line, lineNumber: newLineNumber)
                                diffCells.append(diffCell)
                                newLineNumber += 1
                            }
                        case .same:
                            let diffCell = unchangedCell(text: line,
                                                         oldLineNumber: oldLineNumber,
                                                         newLineNumber: newLineNumber)
                            diffCells.append(diffCell)
                            oldLineNumber += 1
                            newLineNumber += 1
                        case .removed:
                            // Keep line
                            if diffFile == .deleted {
                                let diffCell = deletedCell(oldText: line, oldLineNumber: oldLineNumber)
                                diffCells.append(diffCell)
                                oldLineNumber += 1
                            } else {
                                var tempIndex = newIndex + 1
                                var flag = true
                                while flag {
                                    if tempIndex == lineChanges.count {
                                        flag = false
                                        return
                                    }
                                    
                                    if !blackListIndex.contains(tempIndex) {
                                        if getLineType(text: lineChanges[tempIndex]) == .added {
                                            flag = false
                                        } else {
                                            tempIndex += 1
                                        }
                                    } else {
                                        tempIndex += 1
                                    }
                                }
                                
                                blackListIndex.append(tempIndex)
                                let addedLine = lineChanges[tempIndex]
                                let diffCell = removedCell(oldText: line,
                                                           oldLineNumber: oldLineNumber,
                                                           newText: addedLine,
                                                           newLineNumber: newLineNumber)
                                
                                diffCells.append(diffCell)
                                oldLineNumber += 1
                                newLineNumber += 1
                            }
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
        var diffCell = DiffCell()
        diffCell.oldCell = (nil, nil, UIColor.emptyCell())
        diffCell.newCell = (lineNumber, text, UIColor.addedCell())
        
        return diffCell
    }

    func deletedCell(oldText: String, oldLineNumber: Int) -> DiffCell {
        var diffCell = DiffCell()
        diffCell.oldCell = (oldLineNumber, oldText, UIColor.removedCell())
        diffCell.newCell = (nil, nil, UIColor.emptyCell())
        
        return diffCell
    }
    
    func removedCell(oldText: String, oldLineNumber: Int, newText: String, newLineNumber: Int) -> DiffCell {
        var diffCell = DiffCell()
        diffCell.oldCell = (oldLineNumber, oldText, UIColor.removedCell())
        diffCell.newCell = (newLineNumber, newText, UIColor.addedCell())
        
        return diffCell
    }
    
    func unchangedCell(text: String, oldLineNumber: Int, newLineNumber: Int) -> DiffCell {
        var diffCell = DiffCell()
        diffCell.oldCell = (oldLineNumber, text, UIColor.white)
        diffCell.newCell = (newLineNumber, text, UIColor.white)
        
        return diffCell
    }
}
