//
//  AddQuestionVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 22/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class AddQuestionVC: UITableViewController {
    
    var noOfExtraOptionsOn = 0
    var isAddButtonOn = false
    var enteredData = [String](repeating: "", count: PresenterQue.getTotalTextLabels())


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        let textLabelsCount = PresenterQue.getTotalTextLabels()
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
            textCell?.descLabel.text = PresenterQue.getTextLabelAtIndex(index: indexPath.row)
            textCell?.textField.placeholder = PresenterQue.getPlaceholderTextAtIndex(index: indexPath.row)
            textCell?.textField.text = self.enteredData[indexPath.row]
            
            var isRemoveBtnHidden = true
            if self.noOfExtraOptionsOn > 0 {
                if self.noOfExtraOptionsOn == 2 && indexPath.row == PresenterQue.getTotalTextLabels() - 1 {
                    isRemoveBtnHidden = false
                }
                else if self.noOfExtraOptionsOn == 1 && indexPath.row == PresenterQue.getTotalTextLabels() - 2 {
                    isRemoveBtnHidden = false
                }
            }
            
            textCell?.removeBtn.isHidden = isRemoveBtnHidden
            textCell?.textField.keyboardType = PresenterQue.isInputNumberAtIndex(index: indexPath.row) ? UIKeyboardType.numbersAndPunctuation : UIKeyboardType.asciiCapable
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
    
    // MARK: Helper functions
    private func getNoOfTextFieldCells() -> Int {
        let currentTextLabels = PresenterQue.getTotalTextLabels() - (2 - self.noOfExtraOptionsOn)
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
    
    
    //MARK: Action and Selector  Handler
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        self.noOfExtraOptionsOn -= 1
        if self.noOfExtraOptionsOn == 1 {
            let lastIndexPath = IndexPath(row: PresenterQue.getTotalTextLabels() - 1, section: 0)
            
            if let cell:TextFieldCell = tableView.cellForRow(at: IndexPath(row:PresenterQue.getTotalTextLabels() - 2, section: 0)) as? TextFieldCell {
                cell.removeBtn.isHidden = false
            }
            
            self.tableView.beginUpdates()
            
            self.tableView.reloadRows(at: [lastIndexPath], with: UITableViewRowAnimation.automatic)
            self.tableView.endUpdates()
            
            self.enteredData[PresenterQue.getTotalTextLabels() - 1] = ""
        }
        else {
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath(row: PresenterQue.getTotalTextLabels() - 2, section: 0)], with: UITableViewRowAnimation.automatic)
            
            self.tableView.endUpdates()
            self.enteredData[PresenterQue.getTotalTextLabels() - 2] = ""
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        self.tableView.endEditing(true)
        
        print(enteredData)
        
        let textLabelsCount = PresenterQue.getTotalTextLabels()
        let isAddButtonOn = self.noOfExtraOptionsOn < 2
        var countCurrentText = textLabelsCount
        if isAddButtonOn {
            countCurrentText = textLabelsCount - (2 - self.noOfExtraOptionsOn) + (self.isAddButtonOn ? 1 : 0)
        }
        
        
        let durationVal:Int = Int(enteredData[2]) ?? -1
        
        let eventToSave : PresenterQueEvent = PresenterQueEvent.init(titleStr: enteredData[0], questionStr: enteredData[1], durationInt: durationVal, opt1Str:enteredData[3], opt2Str:enteredData[4], opt3Str:enteredData[5], opt4Str:enteredData[6] )
        
        
        let questionListVC: PresenterEventDetailVC = self.backViewController() as! PresenterEventDetailVC
        questionListVC.reloadQuestionListWith(question: eventToSave)
        self.navigationController?.popViewController(animated: true)
        
        //#warning : for testing
        for quetionField in enteredData {
            print( quetionField)
        }
        
        print(eventToSave)
        
        print(eventToSave.toAnyObject())
    }
}

// MARK: TextField Delegate methods
extension AddQuestionVC: UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        let currentTextLabels = PresenterQue.getTotalTextLabels() - (2 - self.noOfExtraOptionsOn)
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
