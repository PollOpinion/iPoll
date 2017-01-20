//
//  FirebaseManager.swift
//  DDVP
//
//  Created by Krunal Soni on 19/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseManager: NSObject{
    
    static let sharedInstance = FirebaseManager()
    
    // MARK: Initialization methods
    override init() {
        super.init()
    }
    
    // MARK: Public methods
    // MARK: Event methods
    func addEventWithName(eventName: String) {
        let allChannelsFirebase = FIRDatabase.database().reference().child(kEventsList + "/" + eventName)
        
        allChannelsFirebase.setValue(eventName) { (error, databaseReference) in
            let isAdded = error == nil
            var userInfo : [String : Any] = ["isAdded": isAdded]
            
            if !isAdded,
                let terror = error{
                userInfo["error"] = terror
            }
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationAddedEvents), object: nil, userInfo: userInfo)
        }
    }
    
    // MARK: Question methods
    func uploadQuestionAtChannel(channelName: String, withData data: [String: Any]) {
        var uploadData = data
        uploadData[kKeyQuestionId] = FIRServerValue.timestamp()
        
        let uploadQuestionFirebase = FIRDatabase.database().reference().child(channelName + kEventsQuiz).childByAutoId()
        
        
        uploadQuestionFirebase.setValue(uploadData) { (error, databaseReference) in
            
            let isUploaded = error == nil
            var userInfo: [String: Any] = ["isUploaded": isUploaded]
            if !isUploaded,
                let error = error {
                userInfo["error"] = error
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUploadedQuestion), object: nil, userInfo: userInfo)
        }
    }
    
}
