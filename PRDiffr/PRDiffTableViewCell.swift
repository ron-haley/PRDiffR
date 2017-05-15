//
//  PRDiffTableViewCell.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/14/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class PRDiffTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var oldLineNumberLabel: UILabel!
    @IBOutlet weak var oldTextLabel: UILabel!
    @IBOutlet weak var newLineNumberLabel: UILabel!
    @IBOutlet weak var newTextlabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(diffCell: DiffCell) {
        if let oldCell = diffCell.oldCell {
            if let oldLine = oldCell.0 {
                oldLineNumberLabel.text = String(oldLine)
            }

            oldTextLabel.text = oldCell.1

            if let color = oldCell.2 {
                oldLineNumberLabel.backgroundColor = color
                oldTextLabel.backgroundColor = color
            }
        }

        if let newCell = diffCell.newCell {
            if let newLine = newCell.0 {
                newLineNumberLabel.text = String(newLine)
            }

            newTextlabel.text = newCell.1

            if let color = newCell.2 {
                newLineNumberLabel.backgroundColor = color
                newTextlabel.backgroundColor = color
            }
        }
    }
}
