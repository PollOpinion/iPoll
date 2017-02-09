//
//  ParticipantEventTableViewCell.swift
//  DDVP
//
//  Created by Pankaj Neve on 09/02/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class ParticipantEventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = Color.participantTheme.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
