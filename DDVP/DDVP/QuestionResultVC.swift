//
//  QuestionResultVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 22/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class QuestionResultVC: UIViewController {
    
    var channelName: String?
    
    var questionsArray: [[String: AnyObject]] = []

    var timer: Timer?
    var currentTimeLeft = -1
    
    var clickedQuestionIndex: Int = 0
    var option1Count = 0
    var option2Count = 0
    var option3Count = 0
    var option4Count = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var option3Label: UILabel!
    @IBOutlet weak var option4Label: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!

    // MARK: Class methods
    class func instantiateStoryboard() -> QuestionResultVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let resultsVC = storyBoard.instantiateViewController(withIdentifier: "QuestionResultVC") as! QuestionResultVC
        return resultsVC
    }
    
    // MARK: View Controller Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addObservers()
        self.listenToQuestions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.stopOptionFirebaseRefs()
    }
    
    // MARK: helper  methods
    func addObservers() {
//        NotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchedQuestionsNotification(_:)), name: kNotificationFetchedQuestions, object: nil)
//        NotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchedAnswersNotification(_:)), name: kNotificationFetchedAnswers, object: nil)
    }
    
    func listenToQuestions() {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        if let channelName = self.channelName {
//            FirebaseManager.sharedInstance.fetchAllQuestionsInChannel(eventName: channelName)
//        }
    }
    
    func openResultViewAtIndex(index: Int) {
//        let questionData = self.questionsArray[index]
//        if let questionId = questionData[kKeyQuestionId] as! Int?,
//            let title = questionData[PresenterQue.QueTitle.getDictKeyTitle()] as! String?,
//            let question = questionData[PresenterQue.QuestionStr.getDictKeyTitle()] as! String?,
//            let duration = questionData[PresenterQue.VottingDuration.getDictKeyTitle()] as! Int?,
//            let channelName = self.channelName {
                self.questionTitleLabel.text = "Que Title"
                self.questionLabel.text = "Que Str"
//                let endsAt = duration + questionId
                //let currentTimeStamp = Int(NSDate().timeIntervalSince1970 * 1000)
//                let graceTimeMilliSec = kConstGraceSecTimeAllowed * 1000
//                if currentTimeStamp < endsAt + graceTimeMilliSec {
//                    let timeLeft = (endsAt - currentTimeStamp) / 1000
//                    self.timeLeftLabel.text = "Voting ends in \(timeLeft) seconds"
//                    self.currentTimeLeft = timeLeft
//                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(timerHit(_:)), userInfo: nil, repeats: true)
//                }
//                else {
//                    self.timeLeftLabel.text = "Voting is over"
//                }
            
                self.option1Count = 0
                self.option2Count = 0
                self.option3Count = 0
                self.option4Count = 0
            
                let isContinous = true // currentTimeStamp < endsAt + graceTimeMilliSec
//                if let option1LabelBaseText = questionData[PresenterQue.Option1.getDictKeyTitle()] as! String? {
                    self.option1Label.text = "Option 1"//option1LabelBaseText
//                }
//                if let option2LabelBaseText = questionData[PresenterQue.Option2.getDictKeyTitle()] as! String? {
                    self.option2Label.text = "Option 2"//option2LabelBaseText
//                }
        
                var totalOptions = 2
//                if let option3LabelBaseText = questionData[PresenterQue.Option3.getDictKeyTitle()] as! String? {
                    self.option3Label.text = "Option 3"//option3LabelBaseText
                    totalOptions += 1
                    self.option3Label.isHidden = false
//                }
//                else {
//                    self.option3Label.isHidden = true
//                }
//                if let option4LabelBaseText = questionData[PresenterQue.Option4.getDictKeyTitle()] as! String? {
                    self.option4Label.text = "Option 4" //option4LabelBaseText
                    totalOptions += 1
                    self.option4Label.isHidden = false
//                }
//                else {
//                    self.option4Label.isHidden = true
//                }
//                FirebaseManager.sharedInstance.listenToFirebaseAnswers(isContinous, inChannel: channelName, questionId: questionId, totalOptions: totalOptions)
                self.resultView.isHidden = false
//        }
    }
    
    private func stopOptionFirebaseRefs() {
//        FirebaseManager.sharedInstance.stopContinousFirebaseAnswers()
    }
    
    // MARK: Action and selector methods
    @IBAction func closeBtnTapped(sender: AnyObject) {
//        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func resultViewCloseBtnTapped(sender: AnyObject) {
        self.resultView.isHidden = true
        self.stopOptionFirebaseRefs()
    }
    
//    func fetchedQuestionsNotification(notification: NSNotification) {
//        MBProgressHUD.hide(for: self.view, animated: true)
//        if let userInfo = notification.userInfo as! [String: [String: AnyObject]]? {
//            self.questionsArray = Array(userInfo.values).sorted{
//                ((($0)[kKeyQuestionId] as? Int)! > (($1)[kKeyQuestionId] as? Int)!)
//            }
//        }
//        else {
//            self.questionsArray = []
//        }
//        self.tableView.reloadData()
//    }
//    
//    func fetchedAnswersNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo as! [String: AnyObject]?,
//            isContinuous = userInfo[kConstIsContinuous] as! Bool?,
//            index = userInfo[kConstIndex] as! Int?,
//            count = userInfo[kConstCount] as! Int? {
//            switch index {
//            case 1:
//                let baseText = self.questionsArray[self.clickedQuestionIndex][QuestionText.Option1.getDictKeyTitle()] as! String? ?? ""
//                self.option1Count = isContinuous ? self.option1Count + 1 : count
//                self.option1Label.text = baseText + " (\(self.option1Count))"
//            case 2:
//                let baseText = self.questionsArray[self.clickedQuestionIndex][QuestionText.Option2.getDictKeyTitle()] as! String? ?? ""
//                self.option2Count = isContinuous ? self.option2Count + 1 : count
//                self.option2Label.text = baseText + " (\(self.option2Count))"
//            case 3:
//                let baseText = self.questionsArray[self.clickedQuestionIndex][QuestionText.Option2.getDictKeyTitle()] as! String? ?? ""
//                self.option3Count = isContinuous ? self.option3Count + 1 : count
//                self.option3Label.text = baseText + " (\(self.option3Count))"
//            case 4:
//                let baseText = self.questionsArray[self.clickedQuestionIndex][QuestionText.Option2.getDictKeyTitle()] as! String? ?? ""
//                self.option4Count = isContinuous ? self.option4Count + 1 : count
//                self.option4Label.text = baseText + " (\(self.option4Count))"
//            default:
//                break
//            }
//        }
//    }
    
    func timerHit(decreaseTimer: Timer) {
        self.currentTimeLeft -= 1
        if self.currentTimeLeft > 0 {
            self.timeLeftLabel.text = "Voting ends in \(self.currentTimeLeft) seconds"
        }
        else {
            self.timeLeftLabel.text = "Voting is over"
            self.timer?.invalidate()
            self.timer = nil
            self.stopOptionFirebaseRefs()
        }
    }
}

// MARK: Table View methods
extension QuestionResultVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: TableView Data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        let questionObject = self.questionsArray[indexPath.row]
        if let questionTitle = questionObject[PresenterQue.QueTitle.getDictKeyTitle()] as! String? {
            cell?.textLabel?.text = questionTitle
        }
        return cell!
    }
    
    // MARK: TableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.clickedQuestionIndex = indexPath.row
        self.openResultViewAtIndex(index: indexPath.row)
    }

}
