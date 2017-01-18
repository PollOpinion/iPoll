//
//  PollUser.swift
//  DDVP
//
//  Created by Pankaj Neve on 18/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import Foundation


enum LoginProvider {
    // enumeration definition goes here
    case custom, facebook
}

class PollUser {
    
    var Id: String
    var Name: String
    var Email: String
    var PhotoURL: URL
    var ProviderId: String
    
    
    init(id: String?, name: String?, email: String?, photoURL: URL?, providerId: String?) {
        self.Id = id!
        self.Name = name ?? "NotAvailable"
        self.Email = email ?? "NotAvailable"
        self.PhotoURL = photoURL ?? URL(string: "NoUrlAvailable")!
        self.ProviderId = providerId ?? "NotAvailable"
        
        
    }
    
}
