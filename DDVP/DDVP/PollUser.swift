//
//  PollUser.swift
//  DDVP
//
//  Created by Pankaj Neve on 18/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import Foundation


class PollUser {
    
    var Id: Int
    var Name: String
    
    init(id: Int, name: String?) {
        self.Id = id
        self.Name = name ?? ""
    }
    
}
