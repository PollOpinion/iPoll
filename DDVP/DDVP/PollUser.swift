//
//  PollUser.swift
//  DDVP
//
//  Created by Pankaj Neve on 18/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import Foundation


// login provider e.g. facebook
enum UserProvider {
    case custom, facebook
}

//user role
enum UserRole {
    case presenter, participant
}


struct PollUser {
    
    var Id: String
    var Name: String
    var Email: String
    var PhotoURL: URL
    var ProviderId: String
    var LoginRole: UserRole
    
    
    init(id: String?, name: String?, email: String?, photoURL: URL?, providerId: String?, role: UserRole) {
        self.Id = id!
        self.Name = name ?? "NotAvailable"
        self.Email = email ?? "NotAvailable"
        self.PhotoURL = photoURL ?? URL(string: "NoUrlAvailable")!
        self.ProviderId = providerId ?? "NotAvailable"
        self.LoginRole = role
    }
    
    func toAnyObject() -> Any {
        return [
            "name": Name,
            "email": Email,
            "providerId": ProviderId
        ]
    }
}
