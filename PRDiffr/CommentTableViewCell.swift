//
//  CommentTableViewCell.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super .prepareForReuse()

        userNameLabel.text = nil
        dateLabel.text = nil
        bodyLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(commentCell: CommentCell) {
        userNameLabel.text = commentCell.userNameString()
        dateLabel.text = commentCell.createdDateString()
        bodyLabel.text = commentCell.bodyString()
    }
}
