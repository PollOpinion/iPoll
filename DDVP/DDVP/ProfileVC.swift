//
//  ProfileVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 17/01/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FBSDKLoginKit

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var photoActivity: UIActivityIndicatorView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRole: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var updateProfilePicButton: UIButton!
    @IBOutlet weak var roleSegement: UISegmentedControl!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        roleSegement.addTarget(self, action: #selector(ProfileVC.roleChanged), for: .valueChanged)
        
        self.navigationItem.hidesBackButton = true
        
        if pollUser?.UserProvider == UserProvider.facebook {
        
            updateProfilePicButton.isHidden = true
            logoutButton.isHidden = true
            view.addSubview(loginButton)

        }
        else {
            updateProfilePicButton.isHidden = false
            logoutButton.isHidden = false
            logoutButton.layer.cornerRadius = 3.0
            
            //position the update pic button
            updateProfilePicButton.layer.frame.origin.x = userPhoto.layer.frame.origin.x
            updateProfilePicButton.layer.frame.origin.y = 100
            updateProfilePicButton.bringSubview(toFront: userPhoto)
            
            //et current view controller as the delegate for the UIImagePickerController, to handle a few events.
            imagePicker.delegate = self
        }
        
        self.userEmail.text = pollUser?.Email
        self.userName.text = pollUser?.Name
        
        if pollUser?.PhotoURL != nil {
            self.loadPic(imageUrl: (pollUser?.PhotoURL.absoluteString)!, imgView: self.userPhoto, activity: self.photoActivity)
        }
        
        self.displayUserRole()
        
    }

    override func viewDidLayoutSubviews() {
        // Set your constraint here
        loginButton.center = CGPoint.init(x: logoutButton.center.x, y: logoutButton.center.y)
        logoutButton.frame = loginButton.frame
        alignSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action handler
    
    @IBAction func nextBarBtnTapped(_ sender: Any) {
        
        if pollUser?.LoginRole == UserRole.presenter {
            //At a time keep any one of the following
            
            //1. Presenter scene as a table list
//            self.performSegue(withIdentifier: "seguePresenterVC", sender: nil)
            
            //2. Presenter scene as a collection view
            self.performSegue(withIdentifier: "seguePresenterCVC", sender: self)
        }
        else{ //participant
            self.performSegue(withIdentifier: "segueParticipantVC", sender: self)
        }
        
    }


    @IBAction func userRoleChanged(_ sender: Any) {
        
        let segCntrl:UISegmentedControl = sender as! UISegmentedControl
        switch segCntrl.selectedSegmentIndex  {
        case 0:
            pollUser?.LoginRole = UserRole.presenter
            break
        case 1:
            pollUser?.LoginRole = UserRole.participant
            break
        default:
            pollUser?.LoginRole = UserRole.presenter
            break
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        let loginViewController: LoginViewController = loginButton.delegate as! LoginViewController
        loginViewController.btnLogoutTapped(self)
    }
    
    @IBAction func updateProfilePicButtonTapped(_ sender: Any) {
        
       //Action sheet
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view

        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            print("Camera action")
            
            if Platform.isSimulator {
                print ("camera won't work as it's Simulator")
            }
            else{
                
                self.presentImagePicker(source:.camera)
                
            }
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
            print("Photo Library action")
            
            self.presentImagePicker(source:.photoLibrary)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            print("Cancelled")
            //do nothing
        }
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            userPhoto.image = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userPhoto.image = originalImage
        }
        userPhoto.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    
    // align all subviews Horizontally Centered to view
    func alignSubviews(){
        
        //user photo formatting
        userPhoto.layer.borderWidth = 3.0
        userPhoto.layer.borderColor = UIColor.lightGray.cgColor
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width/2
        userPhoto.clipsToBounds = true
    }
    
    func loadPic(imageUrl:String, imgView:UIImageView, activity:UIActivityIndicatorView)
    {
        activity.startAnimating()
        
        let catPictureURL = URL(string: imageUrl)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        imgView.image = image
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
            activity.stopAnimating()
        }
        
        downloadPicTask.resume()
    }
    
    func displayUserRole() {
        var roleStr:String
        
        if pollUser?.LoginRole == UserRole.presenter{
            roleStr = "Presenter"
            self.roleSegement.selectedSegmentIndex = 0
            self.roleChanged()
        }
        else{
            roleStr = "Participant"
            self.roleSegement.selectedSegmentIndex = 1
            self.roleChanged()
        }
        
        print("You are logged in as \(roleStr)")
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
    
    func presentImagePicker(source:UIImagePickerControllerSourceType){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: segment value changed delegate
    
    func roleChanged() {
        print("Role Changed... ")
        
        switch self.roleSegement.selectedSegmentIndex {
        case 0:
            view.backgroundColor = Color.presenterTheme.value
            break
        case 1:
            view.backgroundColor = Color.participantTheme.value
            break
        default:
            break
        }
    }
}
