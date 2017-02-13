//
//  PollQuestionCell.swift
//  DDVP
//
//  Created by Pankaj Neve on 20/01/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class PollQuestionCell: UITableViewCell {
    
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var queTitleLbl: UILabel!
    @IBOutlet weak var queQueLbl: UILabel!
    @IBOutlet weak var queDurationLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if pollUser?.LoginRole == UserRole.presenter{
            self.backgroundColor = Color.presenterTheme.value
        }
        else { //participant
            self.backgroundColor = Color.participantTheme.value
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
