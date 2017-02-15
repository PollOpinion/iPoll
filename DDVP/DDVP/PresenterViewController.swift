//
//  PresenterViewController.swift
//  DDVP
//
//  Created by Pankaj Neve on 19/01/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class PresenterViewController: UITableViewController {

    @IBOutlet weak var barBtnAddEvent: UIBarButtonItem!
    
    var eventsArray = [String]()
    var eventName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.presenterTheme.value
        
        self.addObservers()
        self.listAllEvents()
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
        notificationCenter.addObserver(self, selector: #selector(self.addedEventNotification(notification:)), name: NSNotification.Name(rawValue: kNotificationAddedEvents), object: nil)
          notificationCenter.addObserver(self, selector: #selector(self.fetchEventNotification(notification:)), name: NSNotification.Name(rawValue: kNotificationAllEvents), object: nil)
        
    }
    private func listAllEvents() {
       MBProgressHUD.showAdded(to: self.view, animated: true)
       FirebaseManager.sharedInstance.fetchAllEvents()
    }
    
    // MARK: Selector methods
    func addedEventNotification(notification: Notification) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let userInfo = notification.userInfo as! [String: AnyObject]?,
            let isAdded = userInfo["isAdded"] as! Bool? {
            guard isAdded else {
                if let error = userInfo["error"] as! NSError? {
                    //Show ALert
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true) { () -> Void in
                        
                    }
                }
                return
            }
            self.listAllEvents()
        }
    }
    
    func fetchEventNotification(notification: Notification) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let eventsListArray = notification.userInfo as! [String: Any]? {
            self.eventsArray = eventsListArray.keys.sorted()
            self.tableView.reloadData()
        }

    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print ("Row at index \(indexPath.row) tapped")
        self.eventName = self.eventsArray[indexPath.row]
        self.performSegue(withIdentifier: "seguePresenterEventDetailsVC", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! PresenterEventCell
        
        // Configure the cell...
        cell.eventName.text = eventsArray[indexPath.row]
       
        return cell
    }    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteEvent(forRowAt: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "seguePresenterEventDetailsVC" {
            let nextScene =  segue.destination as! EventQuestionListVC
            nextScene.eventName = self.eventName
        }
    }
    
    //MARK: Action Handler
    
    @IBAction func addEventTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Event", message: "Create an Event with event name and min number of subscribers required to publish it.", preferredStyle: UIAlertControllerStyle.alert)
        var eventNameTextField: UITextField?
        alert.addTextField { (textField: UITextField) -> Void in
            eventNameTextField = textField
            eventNameTextField?.placeholder = "Event name goes here..."
            eventNameTextField?.autocapitalizationType = UITextAutocapitalizationType.words
            eventNameTextField?.borderStyle = UITextBorderStyle.roundedRect
        }
        
        var eventMinSubscReq: UITextField?
        alert.addTextField { (textField: UITextField) -> Void in
            eventMinSubscReq = textField
            eventMinSubscReq?.placeholder = "Min subscribers required to publish"
            eventMinSubscReq?.keyboardType = UIKeyboardType.numberPad
            eventMinSubscReq?.borderStyle = UITextBorderStyle.roundedRect
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (alertAction) -> Void in
        }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { [weak self] (alertAction) -> Void in
            
            if let eventName = eventNameTextField?.text, eventName.characters.count > 0 {
                var uploadData: [String: Any] = [:]
                print("\(eventName) - min Subcsribers required : \(eventMinSubscReq?.text)")
                //add event to Firebase
                MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
                uploadData["\(eventName)"] = eventName
                uploadData ["presenterID"] = pollUser?.Id
                FirebaseManager.sharedInstance.addEventWithName(eventName: eventName, withData: uploadData)
            }
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true) { () -> Void in
            
        }
    }
    
    //MARK : helper functions
    
    func deleteEvent(forRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Delete \(eventsArray[indexPath.row])", message: "Deleting an event would lead to delete all of the questions under this event. Do you really want to delete an event?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) { (alertAction) -> Void in
        }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { [weak self] (alertAction) -> Void in
            
            // Delete the row from the data source as well as form firebase
            self?.deleteEventFromFirebase(atIndex: indexPath.row)
            self?.eventsArray.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true) { () -> Void in
        }
    }
    
    func deleteEventFromFirebase(atIndex:Int) {
        
        FirebaseManager.sharedInstance.deleteEvent(eventName: self.eventsArray[atIndex])
    }
}
