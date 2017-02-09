//
//  ResultVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 23/01/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var timeLeftLbl: UILabel!
    @IBOutlet weak var option1Lbl: UILabel!
    @IBOutlet weak var option2Lbl: UILabel!
    @IBOutlet weak var option3Lbl: UILabel!
    @IBOutlet weak var option4Lbl: UILabel!
    let pieChartView = PieChartView()
    var questionObj:[String : Any] = [:]
    var answers = [String:Int]()
    
    
    @IBOutlet weak var chartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pollUser?.LoginRole == UserRole.presenter{
            view.backgroundColor = Color.presenterTheme.value
            pieChartView.isHidden = false
        }
        else { //participant
            view.backgroundColor = Color.participantTheme.value
            pieChartView.isHidden = true
        }
        
        self.fillInQuestionDetails()
    }
    
    override func viewDidLayoutSubviews() {
        // Set your constraint here
        pieChartView.center.x = view.center.x
        pieChartView.frame = chartView.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pieChartFor(values: ["abc": 12], tempView: chartView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func pieChartFor(values: Any, tempView: UIView){
        
        let colorArr = [UIColor.orange, UIColor.green, UIColor.cyan, UIColor.yellow, UIColor.blue, UIColor.brown, UIColor.red ]
        pieChartView.frame = tempView.frame
        
        var i=0
        for ans in answers {
            pieChartView.segments.append(Segment(color: colorArr[i], name:ans.key , value: CGFloat(ans.value)))
            i += 1
        }
        pieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 12)
        pieChartView.showSegmentValueInLabel = true
        view.addSubview(pieChartView)
    }
    
    func fillInQuestionDetails() {
        
        if let screenTitle = questionObj["title"] as! String? {
            
            if screenTitle.characters.count > 0 {
                self.navigationItem.title = screenTitle
            }
            else{
                self.navigationItem.title = "Result"
            }
        }
        
        if let questionStr = questionObj["question"] as! String? {
            self.questionLbl.text = questionStr
        }
        else{
            self.questionLbl.text = ""
        }
        
        if let option1Str = questionObj["opt1"] as! String? {
            self.option1Lbl.text = option1Str
        }
        else{
            self.option1Lbl.text = ""
        }
        
        if let option2Str = questionObj["opt2"] as! String? {
            self.option2Lbl.text = option2Str
        }
        else{
            self.option2Lbl.text = ""
        }
        
        if let option3Str = questionObj["opt3"] as! String? {
            self.option3Lbl.text = option3Str
        }
        else{
            self.option3Lbl.text = ""
        }
        
        if let option4Str = questionObj["opt4"] as! String? {
            self.option4Lbl.text = option4Str
        }
        else{
            self.option4Lbl.text = ""
        }
        
        let expiresIn:Int = questionObj["duration"] as! Int
        if expiresIn > 0  {
            self.timeLeftLbl.text = String(format:"Expires in \(expiresIn) sec.")
        }
        else{
            self.timeLeftLbl.text = "Expires in time not set for this question"
        }
       
    }
}
