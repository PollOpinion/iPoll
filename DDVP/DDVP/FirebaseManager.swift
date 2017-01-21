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
    
    private var onlineUsersFirebase: FIRDatabaseReference?
    
    // MARK: Initialization methods
    override init() {
        super.init()
    }
    deinit {
        //self.stopListeningToOnlineUsersCount()
    }
    
    // MARK: Public methods
    // MARK: Event methods
    
    func fetchAllEvents(){
        let allEventsFirebase = FIRDatabase.database().reference().child(kEventsList)
        
        allEventsFirebase.observeSingleEvent(of: FIRDataEventType.value) { (dataSnapshot: FIRDataSnapshot) in
            guard dataSnapshot.exists() else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNotificationAllEvents), object: nil)
                return
            }
            
            let channelsListArray = dataSnapshot.value as! [String: String]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNotificationAllEvents), object: nil, userInfo: channelsListArray)
        }
        
    }
    
    func addEventWithName(eventName: String) {
        let allEventsFirebase = FIRDatabase.database().reference().child(kEventsList + "/" + eventName)
        
        allEventsFirebase.setValue(eventName) { (error, databaseReference) in
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
    func uploadQuestionAtChannel(eventName: String, withData data: [String: Any]) {
        var uploadData = data
        uploadData[kKeyQuestionId] = FIRServerValue.timestamp()
        
        let uploadQuestionFirebase = FIRDatabase.database().reference().child(eventName + kEventsQuiz).childByAutoId()
        
        
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
    
    
    func fetchAllQuestionsInChannel(eventName: String) {
        let questionsFirebase = FIRDatabase.database().reference().child(eventName + kEventsQuiz)
        
        questionsFirebase.queryOrderedByKey().observeSingleEvent(of: FIRDataEventType.value) { (dataSnapshot: FIRDataSnapshot) in
            
            guard dataSnapshot.exists() else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNotificationFetchedQuestions), object: nil)
                return
            }
            
            let questionData = dataSnapshot.value as! [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNotificationFetchedQuestions), object: nil, userInfo: questionData)
        }

    }
    
    // MARK: Online User methods

    func listenToOnlineUsersCount() {
        self.stopListeningToOnlineUsersCount()
        
        self.onlineUsersFirebase = FIRDatabase.database().reference().child(kEventsOnlineUsers)
        
        self.onlineUsersFirebase?.observe(FIRDataEventType.value, with: { (dataSnapshot: FIRDataSnapshot) in
            
            guard dataSnapshot.exists() else{
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNotificationOnlineUsers), object: nil)
                return
            }
            let userInfo = dataSnapshot.value as! [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNotificationOnlineUsers), object: nil, userInfo: userInfo)
        })
    }
    
    
    func stopListeningToOnlineUsersCount() {
        self.onlineUsersFirebase?.removeAllObservers()
        self.onlineUsersFirebase = nil
    }
    
}
