//
//  AddQuestionVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 22/01/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AddQuestionVC: UITableViewController {
    
    var noOfExtraOptionsOn = 0
    var isAddButtonOn = false
    var enteredData = [String](repeating: "", count: Question.getTotalTextLabels())


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.presenterTheme.value

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TextFieldCell {
            cell.textField.becomeFirstResponder()
        }
        
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
        let textLabelsCount = Question.getTotalTextLabels()
        self.isAddButtonOn = self.noOfExtraOptionsOn < 2
        let count = textLabelsCount - (2 - self.noOfExtraOptionsOn) + (self.isAddButtonOn ? 1 : 0)
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if self.isAddOptionBtnAtIndex(index: indexPath.row) {
            let cellId = "normalCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellId)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
                cell?.textLabel?.textAlignment = NSTextAlignment.center
            }
            cell.textLabel?.text = "Add Another Option"
        }
        else {
            let textCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell?
            textCell?.descLabel.text = Question.getTextLabelAtIndex(index: indexPath.row)
            textCell?.textField.placeholder = Question.getPlaceholderTextAtIndex(index: indexPath.row)
            textCell?.textField.text = self.enteredData[indexPath.row]
            
            var isRemoveBtnHidden = true
            if self.noOfExtraOptionsOn > 0 {
                if self.noOfExtraOptionsOn == 2 && indexPath.row == Question.getTotalTextLabels() - 1 {
                    isRemoveBtnHidden = false
                }
                else if self.noOfExtraOptionsOn == 1 && indexPath.row == Question.getTotalTextLabels() - 2 {
                    isRemoveBtnHidden = false
                }
            }
            
            textCell?.removeBtn.isHidden = isRemoveBtnHidden
            textCell?.textField.keyboardType = Question.isInputNumberAtIndex(index: indexPath.row) ? UIKeyboardType.numbersAndPunctuation : UIKeyboardType.asciiCapable
            textCell?.textField.tag = indexPath.row
            textCell?.textField.delegate = self
            cell = textCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated: true)

        if self.isAddOptionBtnAtIndex(index: indexPath.row) {
            self.noOfExtraOptionsOn += 1
            tableView.beginUpdates()
            if self.noOfExtraOptionsOn == 1 {
                
                tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            else {
                
                if let cell:TextFieldCell = tableView.cellForRow(at: IndexPath(row: indexPath.row-1, section: indexPath.section)) as? TextFieldCell{
                    cell.removeBtn.isHidden = true
                }
                
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            tableView.endUpdates()
            
        }
        else {
            if let textField = self.view.viewWithTag(indexPath.row + 1) as! UITextField? {
                textField.becomeFirstResponder()
            }
        }
    }
    
    
    // MARK: Helper functions
    private func getNoOfTextFieldCells() -> Int {
        let currentTextLabels = Question.getTotalTextLabels() - (2 - self.noOfExtraOptionsOn)
        return currentTextLabels
    }
    
    private func isAddOptionBtnAtIndex(index: Int) -> Bool {
        let currentTextLabels = self.getNoOfTextFieldCells()
        return currentTextLabels == index && self.noOfExtraOptionsOn < 2
    }
    
    func backViewController() -> UIViewController? {
        if let stack = self.navigationController?.viewControllers {
            for i in (1..<stack.count).reversed() {
                if(stack[i] == self) {
                    return stack[i-1]
                }
            }
        }
        return nil
    }
    
    func questionAction(sender: Any) {
        
        let barButton:UIBarButtonItem = sender as! UIBarButtonItem
        let action:Int = barButton.tag
        print("Question bar button tapped (Save = 1000, Publish = 1001), button tag ID : \(action)")
        
        self.tableView.endEditing(true)
        
//        let textLabelsCount = Question.getTotalTextLabels()
//        let isAddButtonOn = self.noOfExtraOptionsOn < 2
//        var countCurrentText = textLabelsCount
//        if isAddButtonOn {
//            countCurrentText = textLabelsCount - (2 - self.noOfExtraOptionsOn) + (self.isAddButtonOn ? 1 : 0)
//        }
        
        let durationVal:Int = Int(enteredData[2]) ?? -1
        let isPublished:String = action == 1001 ? "YES" : "NO"
        let newQuestion : PollQuestion = PollQuestion.init(titleStr: enteredData[0], questionStr: enteredData[1], durationInt: durationVal, opt1Str:enteredData[3], opt2Str:enteredData[4], opt3Str:enteredData[5], opt4Str:enteredData[6], publish: isPublished )
        
        
        let questionListVC: EventQuestionListVC = self.backViewController() as! EventQuestionListVC
        questionListVC.reloadQuestionListWith(question: newQuestion, actionID:action)
        _ = self.navigationController?.popViewController(animated: true)
        
        //#warning : for testing
        for quetionField in enteredData {
            print( quetionField)
        }
    }
    
    
    //MARK: Action and Selector  Handler
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        self.noOfExtraOptionsOn -= 1
        if self.noOfExtraOptionsOn == 1 {
            let lastIndexPath = IndexPath(row: Question.getTotalTextLabels() - 1, section: 0)
            
            if let cell:TextFieldCell = tableView.cellForRow(at: IndexPath(row:Question.getTotalTextLabels() - 2, section: 0)) as? TextFieldCell {
                cell.removeBtn.isHidden = false
            }
            
            self.tableView.beginUpdates()
            
            self.tableView.reloadRows(at: [lastIndexPath], with: UITableViewRowAnimation.automatic)
            self.tableView.endUpdates()
            
            self.enteredData[Question.getTotalTextLabels() - 1] = ""
        }
        else {
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath(row: Question.getTotalTextLabels() - 2, section: 0)], with: UITableViewRowAnimation.automatic)
            
            self.tableView.endUpdates()
            self.enteredData[Question.getTotalTextLabels() - 2] = ""
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        questionAction(sender: sender)
    }
    
    @IBAction func publishButtonTapped(_ sender: Any) {
        
        questionAction(sender: sender)
    }
    
}

// MARK: TextField Delegate methods
extension AddQuestionVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        let currentTextLabels = Question.getTotalTextLabels() - (2 - self.noOfExtraOptionsOn)
        if tag < currentTextLabels {
            if let textField = self.view.viewWithTag(tag + 1) as! UITextField? {
                textField.becomeFirstResponder()
            }
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.enteredData[textField.tag] = textField.text ?? ""
    }
    
}
