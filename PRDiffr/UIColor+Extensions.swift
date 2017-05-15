//
//  UIColor+Extensions.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

public extension UIColor {
    static func darkGreen() -> UIColor {
        return hexToUIColor("2C9306")
    }

    static func addedCell() -> UIColor {
        return hexToUIColor("A5FDAB")
    }

    static func infoCell() -> UIColor {
        return hexToUIColor("5886F2")
    }

    static func removedCell() -> UIColor {
        return hexToUIColor("FA8AA4")
    }
    
    /*
            Create UIColor from hex string.
     */
    static func hexToUIColor(_ hexColor: String) -> UIColor {
        let characterSet = CharacterSet.whitespacesAndNewlines
        var color = hexColor.trimmingCharacters(in: characterSet)
        var rgb: UInt32 = 0
        
        color = color.uppercased()
        
        if color.hasPrefix("#") {
            color = color.substring(from: color.characters.index(color.startIndex, offsetBy: 1))
        }
        
        if color.characters.count != 6 {
            return UIColor.clear
        }
        
        Scanner(string: color).scanHexInt32(&rgb)
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
