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
    
    static func toArrayofPresenterQueEvent(fromArray: [[String : Any]]) -> [PresenterQueEvent]{
        var presenterQueEventArray = [PresenterQueEvent]()
        for dict in fromArray{
            let duration  = Int((dict["duration"] as! Int?)!)
            let que  = self.init(titleStr: dict["title"] as! String?, questionStr: dict["question"] as! String?, durationInt: duration, opt1Str: dict["opt1"] as! String?, opt2Str: dict["opt2"] as! String?, opt3Str: dict["opt3"] as! String?, opt4Str: dict["opt4"] as! String?)
            presenterQueEventArray.append(que)
        }
        return presenterQueEventArray
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
    
    
    var questionArray = [PresenterQueEvent] ()
    var eventName : String = ""
    var currentSelectedRow:Int = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.presenterTheme.value
        self.navigationItem.title = eventName

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.addObservers()
        self.listenToQuestions()
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
        notificationCenter.addObserver(self, selector: #selector(self.fetchQuestionNotification(notification:)), name: NSNotification.Name(rawValue: kNotificationFetchedQuestions), object: nil)
        
    }
    
    private func listenToQuestions() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        FirebaseManager.sharedInstance.fetchAllQuestionsInEvent(eventName: eventName)
      
    }
    
    // MARK: Selector methods
    func addedQuestionNotification(notification: Notification) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let userInfo = notification.userInfo as! [String: AnyObject]?,
            let isUploaded = userInfo["isUploaded"] as! Bool?{
            guard isUploaded else {
                if let error = userInfo["error"] as! NSError? {
                    self.questionArray.removeLast()
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
    
    func fetchQuestionNotification(notification: Notification) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let userInfo = notification.userInfo as! [String: [String: Any]]? {
            
            let receivedQuestionArray  = Array(userInfo.values).sorted{
                (Int((($0)[kKeyQuestionId] as! Int?)!) > Int((($1)[kKeyQuestionId] as! Int?)!))
            }
            var questionsArray  = PresenterQueEvent.toArrayofPresenterQueEvent(fromArray: receivedQuestionArray)
            self.questionArray = (questionsArray as! [PresenterQueEvent]?)!
            
        }
        else{
            self.questionArray = []
        }
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numOfSections: Int = 0
        if self.questionArray.count > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.questionArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresenterQueCell", for: indexPath) as! PresenterQuestionCell

        // Configure the cell...
        let eventObj : PresenterQueEvent = self.questionArray[indexPath.row] as! PresenterQueEvent
        cell.queTitleLbl.text = eventObj.title
        cell.queQueLbl.text = eventObj.question
        cell.queDurationLbl.text = String("\(eventObj.duration)")
        cell.publishButton.tag = indexPath.row

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentSelectedRow = indexPath.row
        print ("Questions list : Row at index \(currentSelectedRow) tapped")
        
        self.performSegue(withIdentifier: "segueShowResultVC", sender: self)
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
            questionArray.remove(at: indexPath.row)
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
        
        if segue.identifier == "segueShowResultVC" {
            
            print ( segue.destination )
            
            let selectedQuestion:PresenterQueEvent = questionArray[currentSelectedRow] as! PresenterQueEvent
            
            let resultvc:ResultVC = segue.destination as! ResultVC
            resultvc.questionObj = selectedQuestion.toAnyObject() as! [String : Any]
            resultvc.ansCount = [10, 25, 3, 17]   //TODO : pass actual values here later
            
            
        }
        else if segue.identifier == "segueAddQuestionVC" {
            
            print ( segue.destination )
        }
        
    }
    
    @IBAction func addQuestionBarBtnTapped(_ sender: Any) {
        print ("addQuestionBarBtnTapped")
        performSegue(withIdentifier: "segueAddQuestionVC", sender: self)
    }
    
    @IBAction func publishRowButtonTapped(_ sender: Any) {
        
        let btn:UIButton = sender as! UIButton
        let currentSelectedRowIndex = btn.tag
        
        self.publishQuestionAtFrirebase(question: questionArray[currentSelectedRowIndex] as! PresenterQueEvent)
        
        
        
    }
    //Mark: helper functions
    func reloadQuestionListWith(question: PresenterQueEvent, actionID:Int) {
        questionArray.append(question)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let uploadData : [String : Any] = question.toAnyObject() as! [String : Any];
        
        switch actionID {
        case 1000: //save question
            print("Save question")
            FirebaseManager.sharedInstance.uploadQuestionAtEvent(eventName: self.eventName, withData: uploadData)
            
            break
        case 1001: // publish question
            print("Save and publish question")
            //TODO : publish already saved quesrion here by using it's Question ID, and remove below line of code.
            FirebaseManager.sharedInstance.uploadQuestionAtEvent(eventName: self.eventName, withData: uploadData)
            
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
