//
//  ParticipantViewController.swift
//  DDVP
//
//  Created by Pankaj Neve on 19/01/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ParticipantViewController: UITableViewController {
    
     var eventsArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.participantTheme.value

        addObservers()
        listenToEventsForParticipant()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: Private methods
    private func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.fetchQuizEvents(notification:)), name: NSNotification.Name(rawValue: kNotificationFetchedEventsForParticipants), object: nil)
        
    }
    
    private func listenToEventsForParticipant() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        FirebaseManager.sharedInstance.fetchAllEventForParticipant()
        
    }
    
    //MARK : selector methods
    func fetchQuizEvents(notification: Notification) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let eventsListArray = notification.userInfo as! [String: Any]? {
            self.eventsArray = eventsListArray.keys.sorted()
            self.eventsArray.removeLast()
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numOfSections: Int = 1
        if self.eventsArray.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No events available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.eventsArray.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantEventCell", for: indexPath) as! ParticipantEventTableViewCell

        let eventName = eventsArray[indexPath.row]
        let eventNameParts = eventName.components(separatedBy: "_quiz")
        cell.eventName.text = eventNameParts[0]

        return cell
    }
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueParticipantEventToQuestion" {
            let nextScene =  segue.destination as! EventQuestionListVC
            let name = eventsArray[(self.tableView.indexPathForSelectedRow?.row)!]
            
            nextScene.eventName = name.components(separatedBy: "_quiz")[0]
        }
    }


}
