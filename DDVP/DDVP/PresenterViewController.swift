//
//  PresenterViewController.swift
//  DDVP
//
//  Created by Pankaj Neve on 19/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class PresenterViewController: UITableViewController {

    @IBOutlet weak var barBtnAddEvent: UIBarButtonItem!
    
    var eventsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        self.performSegue(withIdentifier: "seguePresenterEventDetailsVC", sender: self)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.eventsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! PresenterEventCell

        cell.eventName.text = self.eventsArray[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
        
//        eventsArray.append((eventNameTextField?.text)!)
//        self.tableView.reloadData()
    }
}
