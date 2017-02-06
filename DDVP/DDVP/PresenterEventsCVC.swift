//
//  PresenterEventsCVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 03/02/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

private let reuseIdentifier = "presenterEventCell"

class PresenterEventsCVC: UICollectionViewController {
    
    @IBOutlet weak var btnAddEvent: UIBarButtonItem!
    
    var eventsArray = [String]()
    var eventName : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Color.presenterTheme.value

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        self.addObservers()
        self.listAllEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToPresenterQuestionList" {
            let nextScene =  segue.destination as! PresenterEventDetailVC
            nextScene.eventName = self.eventName
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.eventsArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PresenterEventCollectionCell
    
        // Configure the cell
    
        cell.eventName.text = eventsArray[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("Cell at index \(indexPath.row) tapped")
        self.eventName = self.eventsArray[indexPath.row]
        self.performSegue(withIdentifier: "segueToPresenterQuestionList", sender: self)
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
}
