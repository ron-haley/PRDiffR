//
//  CommitTableViewCell.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class CommitTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(commitCell: CommitCell) {
        userNameLabel.text = commitCell.userNameString()
        dateLabel.text = commitCell.dateString()
        messageLabel.text = commitCell.messageString()
    }
}
