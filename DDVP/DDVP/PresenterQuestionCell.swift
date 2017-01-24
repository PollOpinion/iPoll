//
//  PresenterQuestionCell.swift
//  DDVP
//
//  Created by Pankaj Neve on 20/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class PresenterQuestionCell: UITableViewCell {
    
    @IBOutlet weak var queTitleLbl: UILabel!
    @IBOutlet weak var queQueLbl: UILabel!
    @IBOutlet weak var queDurationLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = Color.presenterTheme.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
