//
//  ViewController.swift
//  DDVP
//
//  Created by Pankaj Neve on 11/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    @IBOutlet weak var firLoginView: UIView!
    @IBOutlet weak var txtFirEmail: UITextField!
    @IBOutlet weak var txtFirPassword: UITextField!
    @IBOutlet weak var btnFirSignUp: UIButton!
    @IBOutlet weak var btnFirLogin: UIButton!
    @IBOutlet weak var myPicView: UIImageView!
    @IBOutlet weak var fbName: UILabel!
    @IBOutlet weak var fbEmail: UILabel!
    @IBOutlet weak var fbPicLoadActivity: UIActivityIndicatorView!
    @IBOutlet weak var coverPhotoActivity: UIActivityIndicatorView!
    @IBOutlet weak var fbCoverPhoto: UIImageView!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        
        if (FBSDKAccessToken.current()) != nil{
            fetchFBProfile()
        }
        
        alignSubviews()
       
    }
    
    // align all subviews Horizontally Centered to view
    func alignSubviews(){
        let x = view.center.x
        
        myPicView.center = CGPoint(x: x, y: myPicView.center.y)
        fbName.center = CGPoint(x: x, y: fbName.center.y)
        fbEmail.center = CGPoint(x: x, y: fbEmail.center.y)
        fbPicLoadActivity.center = CGPoint(x: x, y: fbPicLoadActivity.center.y)
        fbCoverPhoto.center = CGPoint(x: x, y: fbCoverPhoto.center.y)
        coverPhotoActivity.center = CGPoint(x: x, y: coverPhotoActivity.center.y)
        firLoginView.center = CGPoint(x: x, y: firLoginView.center.y)
    }

    func fetchFBProfile(){
        
        print("fetch FB profile")
        
        let parameter = ["fields": "id, email, name, picture.type(large), cover"]
        FBSDKGraphRequest(graphPath: "me", parameters:parameter ).start { (connection, result, error) -> Void in
            if error != nil{
                print("FBSDKGraphRequest error : \(error)")
                return
            }
            print(result)
            let resultDic = result as? NSDictionary
            
            let name = resultDic!["name"]
            let email = resultDic!["email"]
            let fbId = resultDic!["id"]
            let pic = resultDic!["picture"] as? NSDictionary
            let data = pic!["data"] as? NSDictionary
            let dpUrl = data!["url"] as? String
            let cover = resultDic!["cover"] as? NSDictionary
            let coverSourceUrl = cover!["source"] as? String
            
            print("----------")
            print(" Name : \(name!) \n Fb ID : \(fbId!) \n Email : \(email!) \n DP URL : \(dpUrl!) \n Cover URL : \(coverSourceUrl!)")

            print("----------")
            
            self.fbName.text = "\(name!) - \(fbId!)"
            self.fbEmail.text = "\(email!)"
            self.loadPic(imageUrl: dpUrl!, imgView: self.myPicView, activity: self.fbPicLoadActivity)
            self.loadPic(imageUrl: coverSourceUrl!, imgView: self.fbCoverPhoto, activity: self.coverPhotoActivity)
        }
    }
    
    func voidFBProfile(){
        
        print("void FB profile")
        
        self.fbName.text = nil
        self.fbEmail.text = nil
        self.myPicView.image = nil
        self.fbCoverPhoto.image = nil
    }
    
    func logoutFirebase(){
        
        try! FIRAuth.auth()?.signOut()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        
        print("FB login did complete")
        
        fetchFBProfile()
        
        loginToFirebaseUsingFb()
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        
        print("FB logout complete")
        
        voidFBProfile()
        logoutFirebase()
        self.firLoginView.isHidden = false
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
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
    
    func loginToFirebaseUsingFb(){
        let fbToken = FBSDKAccessToken.current()
        guard let fbaccessTokenString = fbToken?.tokenString else {return}
        let firAuthCredentials = FIRFacebookAuthProvider.credential(withAccessToken: fbaccessTokenString)
        FIRAuth.auth()?.signIn(with: firAuthCredentials, completion: { (fireBaseUser, error) in
            if error != nil {
                print("Error logging in for firebase user. Error :\n ", error)
                
                self.displayAlert(message: "Error logging in to firebase user.")
                return
            }
            
            self.firLoginView.isHidden = true
            self.displayAlert(message: "Sucesfully loggedin to firebase.")
            
            print("Sucesfully loggedin for firebase user : ", fireBaseUser)
            
        })
    }
    
    func displayAlert(message:String){
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnFirSignUpTapped(_ sender: AnyObject) {
        
        print("Firebase SignUp button tapped... \n", self.txtFirEmail.text!, "\n", self.txtFirPassword.text!)
        if self.txtFirEmail.text! != nil && self.txtFirPassword.text! != nil {
            
            FIRAuth.auth()?.signIn(withEmail: self.txtFirEmail.text!, password: self.txtFirPassword.text!, completion: { (firUser, error) in
                if error != nil {
                    self.displayAlert(message: error.debugDescription)
                }
            })
        }
        else{
            
            self.displayAlert(message: "Email and passowrd are mandatory!")
        }
        
    }
    
    @IBAction func btnFirLoginTapped(_ sender: AnyObject) {
        
        print("Firebase Login button tapped...\n", self.txtFirEmail.text!, "\n", self.txtFirPassword.text!)
    }
    
}

