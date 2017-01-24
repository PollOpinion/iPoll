//
//  PresenterEventDetailVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 20/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

struct PresenterQueEvent{
    
    var title: String
    var question: String
    var duration: Int
    var opt1: String
    var opt2: String
    var opt3: String
    var opt4: String
    
    init(titleStr: String?, questionStr: String?, durationInt:Int, opt1Str: String?, opt2Str: String?, opt3Str: String?, opt4Str: String?) {
        self.title = titleStr ?? ""
        self.question = questionStr ?? ""
        self.duration = durationInt
        self.opt1 = opt1Str ?? ""
        self.opt2 = opt2Str ?? ""
        self.opt3 = opt3Str ?? ""
        self.opt4 = opt4Str ?? ""
    }
    
    func toAnyObject() -> Any {
        
        var obj = [
            "title": title,
            "question": question,
            "duration": duration,
            "opt1": opt1,
            "opt2": opt2
        ] as [String : Any]
        
        if self.opt3.characters.count > 0, self.opt4.characters.count > 0 {
            obj = [
                "title": title,
                "question": question,
                "duration": duration,
                "opt1": opt1,
                "opt2": opt2,
                "opt3": opt3,
                "opt4": opt4
            ] as [String : Any]
        }
        else if self.opt3.characters.count > 0, self.opt4.characters.count < 1 {
            obj = [
                "title": title,
                "question": question,
                "duration": duration,
                "opt1": opt1,
                "opt2": opt2,
                "opt3": opt3
            ] as [String : Any]
        }
      
        return obj
        
    }
}

class PresenterEventDetailVC: UITableViewController {
    
    
    var eventsArray = [Any] ()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.presenterTheme.value

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
        cell.queDurationLbl.text = String("\(eventObj.duration)")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print ("Questions list : Row at index \(indexPath.row) tapped")
        self.performSegue(withIdentifier: "segueShowResultVC", sender: self)
        
//        let resultsVC = QuestionResultVC.instantiateStoryboard()
//        resultsVC.channelName = "Result"
//        self.navigationController?.pushViewController(resultsVC, animated: true)
        
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
        performSegue(withIdentifier: "segueAddQuestionVC", sender: self)
    }
    
    //Mark: helper functions
    func reloadQuestionListWith(question: PresenterQueEvent) {
        eventsArray.append(question)
        self.tableView.reloadData()
    }
}
