//
//  PresenterEventsCVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 03/02/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

private let reuseIdentifier = "presenterEventCell"
var touchPoint:CGPoint? = nil

class PresenterEventsCVC: UICollectionViewController, UIGestureRecognizerDelegate {
    
    let scRect:CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var btnAddEvent: UIBarButtonItem!
    
    var eventsArray = [String]()
    var eventName : String = ""
    var displayDeleteButton:Bool = true
    var shakeIconsAnim:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Color.presenterTheme.value
        self.addObservers()
        self.listAllEvents()
        
        // This will be helpful to restore the animation when clicked outside the cell
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(PresenterEventsCVC.handleTap))
        tap.delegate = self;
        self.collectionView?.addGestureRecognizer(tap);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.displayDeleteButton = true
        self.collectionView?.reloadData()
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToPollQuestionList" {
            let nextScene =  segue.destination as! EventQuestionListVC
            nextScene.eventName = self.eventName
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numOfSections: Int = 1
        if self.eventsArray.count > 0 {

            collectionView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.text          = "No events available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel

        }
        return numOfSections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.eventsArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PresenterEventCollectionCell
    
        // Configure the cell
    
        cell.eventName.text = eventsArray[indexPath.row]
       
        cell.deleteButton.isHidden = self.displayDeleteButton
        cell.deleteButton.tag = indexPath.row
        
        let lpgr:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PresenterEventsCVC.handleLongPress))
        lpgr.delegate = self
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        cell.addGestureRecognizer(lpgr)
        return cell
    }

    // MARK: Animation Cell with Spring Damping
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //        Animation - 1
        
//        cell.contentView.center = CGPoint(x: scRect.width / 2, y: scRect.height / 2)
//        cell.contentView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
//        
//        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            cell.layer.transform = CATransform3DIdentity
//            cell.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            
//        }, completion: { finished in
//            
//        })
        
        //        Animation - 2
        
//        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 50, 100)
//        cell.layer.transform = rotationTransform
//        
//        UIView.animate(withDuration: 1.0) {
//            cell.layer.transform = CATransform3DIdentity
//        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("Cell at index \(indexPath.row) tapped")
        self.eventName = self.eventsArray[indexPath.row]
        self.performSegue(withIdentifier: "segueToPollQuestionList", sender: self)
    }
 

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
        print ("Selected Index: \(indexPath.row) ")
    }
    */
 
    
    // MARK: Private methods
    private func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.addedEventNotification(notification:)), name: NSNotification.Name(rawValue: kNotificationAddedEvents), object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.fetchEventNotification(notification:)), name: NSNotification.Name(rawValue: kNotificationAllEvents), object: nil)
        
    }
    private func listAllEvents() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        FirebaseManager.sharedInstance.fetchAllEvents()
    }
    
    // MARK: Selector methods
    func addedEventNotification(notification: Notification) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let userInfo = notification.userInfo as! [String: AnyObject]?,
            let isAdded = userInfo["isAdded"] as! Bool? {
            guard isAdded else {
                if let error = userInfo["error"] as! NSError? {
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
            self.listAllEvents()
        }
    }
    
    func fetchEventNotification(notification: Notification) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let eventsListArray = notification.userInfo as! [String: Any]? {
            self.eventsArray = eventsListArray.keys.sorted()
            self.collectionView?.reloadData()
            
        }
        
    }
    
    func handleLongPress(){
        
//        if self.displayDeleteButton { // enable delete biutton for event cell
//            self.displayDeleteButton = false
//            self.collectionView?.reloadData()
//        }
        
        // Loop through the collectionView's visible cells
        for item in self.collectionView!.visibleCells as! [PresenterEventCollectionCell] {
            let indexPath: IndexPath = self.collectionView!.indexPath(for: item )!
            let cell: PresenterEventCollectionCell = self.collectionView!.cellForItem(at: indexPath) as! PresenterEventCollectionCell!
            cell.deleteButton.isHidden = false // show all of the delete buttons
            cell.shakeIcons()
        }
        
        self.shakeIconsAnim = true
        
    }
    
    func handleTap(gestureRec : UITapGestureRecognizer){
        
        if self.shakeIconsAnim == true {
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells as! [PresenterEventCollectionCell] {
                let indexPath: IndexPath = self.collectionView!.indexPath(for: item )!
                let cell: PresenterEventCollectionCell = self.collectionView!.cellForItem(at: indexPath) as! PresenterEventCollectionCell!
                cell.deleteButton.isHidden = true // show all of the delete buttons
                cell.stopShakingIcons()
            }
            
            self.displayDeleteButton = true
            self.shakeIconsAnim = false
            
        }
        else{
            
            if (gestureRec.state != UIGestureRecognizerState.ended) {
                return;
            }
            touchPoint = gestureRec.location(in: self.collectionView);
            
            let indexPath = self.collectionView?.indexPathForItem(at: touchPoint!)
            
            if indexPath != nil{
                print("Pass on the gesture for \(indexPath?.row)")
                self.collectionView(self.collectionView!, didSelectItemAt: indexPath!)
                
            } else {
                print("Could not find index path as - Tapped outside")
                // Do nothing
                
            }
        }
    }

    
    //MARK : Action handler 
    @IBAction func addEventBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Event", message: "Create an Event with event name and min number of subscribers required to publish it.", preferredStyle: UIAlertControllerStyle.alert)
        var eventNameTextField: UITextField?
        alert.addTextField { (textField: UITextField) -> Void in
            eventNameTextField = textField
            eventNameTextField?.placeholder = "Event name goes here..."
            eventNameTextField?.autocapitalizationType = UITextAutocapitalizationType.words
            eventNameTextField?.borderStyle = UITextBorderStyle.roundedRect
        }
        
        var eventMinSubscReq: UITextField?
        alert.addTextField { (textField: UITextField) -> Void in
            eventMinSubscReq = textField
            eventMinSubscReq?.placeholder = "Min subscribers required to publish"
            eventMinSubscReq?.keyboardType = UIKeyboardType.numberPad
            eventMinSubscReq?.borderStyle = UITextBorderStyle.roundedRect
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (alertAction) -> Void in
        }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { [weak self] (alertAction) -> Void in
            
            if let eventName = eventNameTextField?.text, eventName.characters.count > 0 {
                var uploadData: [String: Any] = [:]
                print("\(eventName) - min Subcsribers required : \(eventMinSubscReq?.text)")
                //add event to Firebase
                MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
                uploadData["\(eventName)"] = eventName
                uploadData ["presenterID"] = pollUser?.Id
                FirebaseManager.sharedInstance.addEventWithName(eventName: eventName, withData: uploadData)
            }
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true) { () -> Void in
            
        }
    }
    
    @IBAction func deleteEventTapped(_ sender: Any) {
        
        let btn:UIButton = sender as! UIButton
        print("Delete Event at index \(btn.tag)")
        
        self.deleteEvent(forRowAt: btn.tag)
    }
    
    //MARK : helper functions
    
    func deleteEvent(forRowAt index: Int) {
        
        let alert = UIAlertController(title: "Delete \(eventsArray[index])", message: "Deleting an event would lead to delete all of the questions under this event. Do you really want to delete an event?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            
            self.displayDeleteButton = true
            self.collectionView?.reloadData()
        }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { [weak self] (alertAction) -> Void in
            
            // Delete the row from the data source as well as form firebase
            self?.deleteEventFromFirebase(atIndex: index)
            self?.eventsArray.remove(at: index)
            
            self?.displayDeleteButton = true
            self?.collectionView?.reloadData()
            
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true) { () -> Void in
        }
    }
    
    func deleteEventFromFirebase(atIndex:Int) {
        
        FirebaseManager.sharedInstance.deleteEvent(eventName: self.eventsArray[atIndex])
    }
    
}
