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
    
    var eventsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let alert = UIAlertController(title: "Add Event", message: "Enter the event name", preferredStyle: UIAlertControllerStyle.alert)
        var eventNameTextField: UITextField?
        alert.addTextField { (textField: UITextField) -> Void in
            eventNameTextField = textField
            eventNameTextField?.placeholder = "Your event name goes here..."
            eventNameTextField?.autocapitalizationType = UITextAutocapitalizationType.words
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (alertAction) -> Void in
        }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { [weak self] (alertAction) -> Void in
            
            if let eventName = eventNameTextField?.text, eventName.characters.count > 0 {
                print(eventName)
                //TOOD : add event to Firebase
                self?.eventsArray.append(eventName)
                self?.tableView.reloadData()
            }
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true) { () -> Void in
            
        }
    }
}
