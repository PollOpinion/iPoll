//
//  LoginResultDetailViewController.swift
//  DDVP
//
//  Created by Pankaj Neve on 17/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginResultDetailViewController: UIViewController {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var photoActivity: UIActivityIndicatorView!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRole: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    @IBOutlet weak var roleSegement: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if pollUser?.UserProvider == UserProvider.facebook {
        
            logoutButton.isHidden = true
            
            view.addSubview(loginButton)
            loginButton.center = view.center
            let loginViewController: LoginViewController = self.backViewController() as! LoginViewController
            loginButton.delegate = loginViewController
        }
        else {
            logoutButton.isHidden = false
            
        }
        
        
        alignSubviews()
        
        self.userId.text = pollUser?.Id
        self.userEmail.text = pollUser?.Email
        self.userName.text = pollUser?.Name
        
        if pollUser?.PhotoURL != nil {
            self.loadPic(imageUrl: (pollUser?.PhotoURL.absoluteString)!, imgView: self.userPhoto, activity: self.photoActivity)
        }
        
        self.displayUserRole()
        
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
    
    //MARK: - Action handler
    
    @IBAction func nextBarBtnTapped(_ sender: Any) {
        
        if pollUser?.LoginRole == UserRole.presenter {
            self.performSegue(withIdentifier: "seguePresenterVC", sender: nil)
        }
        else{ //participant
            self.performSegue(withIdentifier: "segueParticipantVC", sender: nil)
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
        
        let loginViewController: LoginViewController = self.backViewController() as! LoginViewController
        loginViewController.btnLogoutTapped(self)
    }
    //MARK: - Helper Functions
    
    // align all subviews Horizontally Centered to view
    func alignSubviews(){
        let x = view.center.x
        
        logoutButton.center = view.center
        
        userPhoto.center = CGPoint(x: x, y: userPhoto.center.y)
        photoActivity.center = CGPoint(x: x, y: photoActivity.center.y)
        userId.center = CGPoint(x: x, y: userId.center.y)
        userEmail.center = CGPoint(x: x, y: userEmail.center.y)
        userName.center = CGPoint(x: x, y: userName.center.y)
        userRole.center = CGPoint(x: x, y: userRole.center.y)
        roleSegement.center = CGPoint(x: x, y: roleSegement.center.y)
        
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
        }
        else{
            roleStr = "Participant"
            self.roleSegement.selectedSegmentIndex = 1
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
}
