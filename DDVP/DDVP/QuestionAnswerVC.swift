//
//  QuestionAnswerVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 23/01/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class QuestionAnswerVC: UIViewController {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var timeLeftLbl: UILabel!
    @IBOutlet weak var option1Lbl: UILabel!
    @IBOutlet weak var option2Lbl: UILabel!
    @IBOutlet weak var option3Lbl: UILabel!
    @IBOutlet weak var option4Lbl: UILabel!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var submitAnswerButton: UIBarButtonItem!
    @IBOutlet weak var image: UIImageView!
    
    let pieChartView = PieChartView()
    var questionObj:[String : Any] = [:]
    var answers = [String:Int]()
    var selectedAnswerOption = 0
    let animationInterval = TimeInterval(2.0)
    var timeLeft = 0
    var countdownTimer : Timer = Timer()
    var animationTimer : Timer = Timer()
    var gestureRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideBarButton(barButton: submitAnswerButton, hide: true)
        self.fillInQuestionDetails()
        
        if pollUser?.LoginRole == UserRole.presenter{
            view.backgroundColor = Color.presenterTheme.value
            pieChartView.isHidden = false
        }
        else { //participant
            view.backgroundColor = Color.participantTheme.value
            
            configureOptionLbl(withInteraction: true)
            image.isHidden = false
            startAnimation()
            
            pieChartView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Set your constraint here
        pieChartView.frame = chartView.frame
        image.center = chartView.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pieChartFor(values: ["abc": 12], tempView: chartView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - supporting functions
    
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
            self.option1Lbl.text = "  " + option1Str
        }
        else{
            self.option1Lbl.text = ""
        }
        
        if let option2Str = questionObj["opt2"] as! String? {
            self.option2Lbl.text = "  " + option2Str
        }
        else{
            self.option2Lbl.text = ""
        }
        
        if let option3Str = questionObj["opt3"] as! String? {
            self.option3Lbl.text = "  " + option3Str
        }
        else{
            self.option3Lbl.text = ""
        }
        
        if let option4Str = questionObj["opt4"] as! String? {
            self.option4Lbl.text = "  " + option4Str
        }
        else{
            self.option4Lbl.text = ""
        }
        
        let expiresIn:Int = questionObj["duration"] as! Int
        if expiresIn > 0  {
            timeLeft = expiresIn
            self.timeLeftLbl.text = String(format:"Expires in \(expiresIn) sec.")

            countdownTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(QuestionAnswerVC.updateTimeLeft), userInfo: nil, repeats: true);
        }
        else{
            self.timeLeftLbl.text = "Expires in time not set for this question"
        }
       
    }
    
    func configureOptionLbl(withInteraction enalbeInteraction:Bool) {
        
        let lbls = [option1Lbl, option2Lbl, option3Lbl, option4Lbl]
        
        for lbl in lbls {
            
            lbl?.backgroundColor = UIColor(hexString: "#ff8000")
            lbl?.textColor = UIColor.white
            lbl?.layer.borderColor = UIColor.gray.cgColor;
            lbl?.layer.borderWidth = 1.0;
            lbl?.layer.cornerRadius = 8.0;
            lbl?.layer.masksToBounds = true
            lbl?.isUserInteractionEnabled = enalbeInteraction
            if (lbl?.text?.characters.count)! <= 0 {
                lbl?.isHidden = true
            }
            
            if enalbeInteraction == true {
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(QuestionAnswerVC.labelTapped))
                lbl?.addGestureRecognizer(gestureRecognizer)
            }
            else{
                lbl?.removeGestureRecognizer(gestureRecognizer)
            }
        }

    }
    
    func highlightSelectedAnswerOption(at position:CGPoint) -> Int{
        
        var selectedAnswer:Int = 0

        let lbls = [option1Lbl, option2Lbl, option3Lbl, option4Lbl]
        var indx = 0
        for lbl in lbls {
            let lblFrame = lbl?.frame
            
            if lblFrame?.contains(position) == true {
                lbl?.backgroundColor = UIColor(hexString: "#00ff00")
                lbl?.textColor = UIColor.blue
                lbl?.layer.borderColor = UIColor(hexString: "#009900").cgColor;
                
                selectedAnswer = indx
            }
            else{
                lbl?.backgroundColor = UIColor(hexString: "#ff8000")
                lbl?.textColor = UIColor.white
                lbl?.layer.borderColor = UIColor.gray.cgColor;
            }
            indx += 1
        }
        
        return selectedAnswer+1
    }
    
    func hideBarButton(barButton:UIBarButtonItem, hide:Bool) {
        barButton.isEnabled = !hide
        
        if hide == true {
            barButton.tintColor = UIColor.clear
        }
        else{
            barButton.tintColor = self.navigationItem.backBarButtonItem?.tintColor
        }
        
    }
    
    func startAnimation() {
        animationTimer = Timer.scheduledTimer(timeInterval: animationInterval, target: self, selector: #selector(QuestionAnswerVC.animateImage), userInfo: nil, repeats: true);
        animationTimer.fire()
    }
    
    func stopAnimation() {
        animationTimer.invalidate()
        //stopping an animation means poll is expired , hence disable submit button and reset all of the answers to default state and also do not allow user to tap/select an answer
        hideBarButton(barButton: submitAnswerButton, hide: true)
        configureOptionLbl(withInteraction: false)
    }
    
    func animateImage () {
        print("Image Animation Timer \(Date())")
            UIView.animate(withDuration: animationInterval) {
                self.image.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                self.image.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2))
            }
    }
    
    func updateTimeLeft(){
        timeLeft -= 1
        
        if timeLeft == 0 {
            self.timeLeftLbl.textColor = UIColor.red
            self.timeLeftLbl.text = String(format:"This poll is already expired")
            countdownTimer.invalidate()
            stopAnimation()
        }
        else{
            self.timeLeftLbl.text = String(format:"Expires in \(timeLeft) sec.")
        }
        
    }
    
    // MARK: - Selector Handlers
    
    func labelTapped(gestureRec : UITapGestureRecognizer){
        
        if submitAnswerButton.isEnabled == false {
            self.hideBarButton(barButton: submitAnswerButton, hide: false)
        }
       
        if gestureRec.state == UIGestureRecognizerState.ended {
            let position = gestureRec.location(in: self.view)
            selectedAnswerOption =  highlightSelectedAnswerOption(at: position)
        }
        
    }
    
    @IBAction func submitAnswerButtonTapped(_ sender: Any) {
        
        //TODO: send the slected answer to firebase and hide the submit button.
        
        print ("Selected Answer Option = Option\(selectedAnswerOption)")
        
    }
    
}
