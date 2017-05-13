//
//  PRTableViewCell.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class PRTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var prTitleLabel: UILabel!
    @IBOutlet weak var prDescription: UILabel!
    @IBOutlet weak var prIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(cell: PRCell) {
        self.prTitleLabel.text = cell.title
        self.prDescription.text = "\(cell.numberString()) \(cell.openDescription())"
        self.prIcon.tintColor = UIColor.darkGreen()
    }
}
