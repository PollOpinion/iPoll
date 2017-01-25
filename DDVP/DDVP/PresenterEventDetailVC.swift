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
    var eventName : String = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.presenterTheme.value

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.addObservers()
        //self.tableView.reloadData()
        
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
        notificationCenter.addObserver(self, selector: #selector(self.addedQuestionNotification(notification:)), name: NSNotification.Name(rawValue: kNotificationUploadedQuestion), object: nil)
        
    }
    
    // MARK: Selector methods
    func addedQuestionNotification(notification: Notification) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let userInfo = notification.userInfo as! [String: AnyObject]?,
            let isUploaded = userInfo["isUploaded"] as! Bool?{
            guard isUploaded else {
                if let error = userInfo["error"] as! NSError? {
                    self.eventsArray.removeLast()
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
            self.tableView.reloadData()
        }
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
        cell.publishButton.tag = indexPath.row

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print ("Questions list : Row at index \(indexPath.row) tapped")
        self.performSegue(withIdentifier: "segueShowResultVC", sender: self)
        
//        let resultsVC = QuestionResultVC.instantiateStoryboard()
//        resultsVC.channelName = "Result"
//        self.navigationController?.pushViewController(resultsVC, animated: true)
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            eventsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.deleteQuestionFromFirebase(atIndex: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
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
    
    @IBAction func publishRowButtonTapped(_ sender: Any) {
        
        let btn:UIButton = sender as! UIButton
        let currentSelectedRowIndex = btn.tag
        
        self.publishQuestionAtFrirebase(question: eventsArray[currentSelectedRowIndex] as! PresenterQueEvent)
        
        
        
    }
    //Mark: helper functions
    func reloadQuestionListWith(question: PresenterQueEvent, actionID:Int) {
        eventsArray.append(question)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let uploadData : [String : Any] = question.toAnyObject() as! [String : Any];
        
        switch actionID {
        case 1000: //save question
            print("Save question")
            FirebaseManager.sharedInstance.uploadQuestionAtChannel(eventName: self.eventName, withData: uploadData)
            
            break
        case 1001: // publish question
            print("Save and publish question")
            //TODO : publish already saved quesrion here by using it's Question ID, and remove below line of code.
            FirebaseManager.sharedInstance.uploadQuestionAtChannel(eventName: self.eventName, withData: uploadData)
            
            self.publishQuestionAtFrirebase(question: question)
            
            break
        default:
            break
        }
        
        //self.tableView.reloadData()
        
    }
    
    func deleteQuestionFromFirebase(atIndex:Int) {
        // TODO : delete Question from  Firebase
        print("TODO : delete Question from  Firebase")
    }
    
    func publishQuestionAtFrirebase(question: PresenterQueEvent) {
        //TODO : 
        
        print( "publish question \(question)")
    }
}
