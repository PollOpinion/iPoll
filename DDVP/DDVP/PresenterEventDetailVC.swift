//
//  PresenterEventDetailVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 20/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class PresenterEventDetailVC: UITableViewController {
    
    
    struct PresenterQueEvent{
        
        var title: String
        var question: String
        var count: Int
        
        
        init(titleStr: String?, questionStr: String?, countInt:Int) {
            self.title = titleStr ?? ""
            self.question = questionStr ?? ""
            self.count = countInt
        }
    }
    
    
    var eventsArray = [Any] ()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresenterQueCell", for: indexPath) as! PresenterQuestionCell

        // Configure the cell...
        let eventObj : PresenterQueEvent = self.eventsArray[indexPath.row] as! PresenterQueEvent
        cell.queTitleLbl.text = eventObj.title
        cell.queQueLbl.text = eventObj.question
        cell.queSubscribersCountLbl.text = String("\(eventObj.count)")

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

    @IBAction func addQuestionBarBtnTapped(_ sender: Any) {
        
        print ("addQuestionBarBtnTapped")
        //TODO: launch another view(something similar to AddQuestionVC form PUBLISHER app) or a readymade view for PUBLISHER reference app, which will configure a question. 
        
        /// folllwoing code is for testing only
        
        let eventTemp : PresenterQueEvent = PresenterQueEvent.init(titleStr: "Title", questionStr: "Question string here?", countInt: 23)
        eventsArray.append(eventTemp)
        
        self.tableView.reloadData()
        
    }
}
