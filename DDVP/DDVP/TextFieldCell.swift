//
//  TextFieldCell.swift
//  DDVP
//
//  Created by Pankaj Neve on 22/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = Color.presenterTheme.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRemoveBtnHidden(isHidden: Bool) {
//        self.removeBtnWidthConstraint.constant = isHidden ? 0.0 : 55.0
//        self.layoutIfNeeded()
    }
}
