//
//  LoginViewController.swift
//  DDVP
//
//  Created by Pankaj Neve on 11/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

var pollUser : PollUser?

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    @IBOutlet weak var roleSegment: UISegmentedControl!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var firLoginView: UIView!
    @IBOutlet weak var txtFirEmail: UITextField!
    @IBOutlet weak var txtFirPassword: UITextField!
    @IBOutlet weak var btnFirSignUp: UIButton!
    @IBOutlet weak var btnFirLogin: UIButton!
    
    @IBOutlet weak var lblOR: UILabel!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        view.backgroundColor = Color.lightBackground.value
        view.addSubview(loginButton)
        
        loginButton.delegate = self
        
        btnLogout.center = view.center
        btnLogout.isHidden = true
        
        if (FBSDKAccessToken.current()) != nil{
            firebaseLogin(provider: UserProvider.facebook)
        }
        else{
            print("Auto fb login failed...")
        }
        
        alignSubviews()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        // Set your constraint here
        loginButton.center = CGPoint.init(x: lblOR.center.x, y: lblOR.center.y+60)

    }
    
    //MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        
        print("FB login did complete")
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        firebaseLogin(provider: UserProvider.facebook)
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        
        print("FB logout complete")

        logoutFirebaseAndReset()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
    //MARK: - Action Button Handlers
    
    @IBAction func btnFirSignUpTapped(_ sender: AnyObject) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        print("Firebase SignUp button tapped... \n", self.txtFirEmail.text!, "\n", self.txtFirPassword.text!)
       
        if self.txtFirEmail.text?.isEmpty == false && self.txtFirPassword.text?.isEmpty == false {
            
            FIRAuth.auth()?.createUser(withEmail: self.txtFirEmail.text!, password: self.txtFirPassword.text!, completion: { (firUser, error) in
                if error != nil {
                    self.displayAlert(titleStr: "iPoll SignUp Error", messageStr: (error?.localizedDescription)!)
                    
                    return
                }
                
                self.fireBaseSignUpComplete(user: firUser!)
            })
        }
        else{
            
            self.displayAlert( titleStr: "SignUp", messageStr: "Email and passoword are mandatory!")
        }
        
    }
    
    @IBAction func btnFirLoginTapped(_ sender: AnyObject) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        print("Firebase Login button tapped...\n", self.txtFirEmail.text!, "\n", self.txtFirPassword.text!)
        
        if self.txtFirEmail.text?.isEmpty == false && self.txtFirPassword.text?.isEmpty == false {
            self.firebaseLogin(provider: UserProvider.custom)
        }
        else{
            
            self.displayAlert(titleStr: "Login", messageStr: "Email and passoword are mandatory!")
        }
    }
    
    @IBAction func btnLogoutTapped(_ sender: AnyObject) {
        
        print("Custom logout complete")
        
        logoutFirebaseAndReset()
        
    }
    
   // MARK: - Firebase
    
    func fireBaseLoginComplete(user : FIRUser, loginProvider:UserProvider){
        
        if loginProvider == UserProvider.custom {
            self.btnLogout.isHidden = false
            self.loginButton.isHidden = true
        }
        else {
            self.btnLogout.isHidden = true
            self.loginButton.isHidden = false
        }
        
        self.firLoginView.isHidden = true
        
        var userRole: UserRole
        switch self.roleSegment.selectedSegmentIndex {
        case 0:
            userRole = UserRole.presenter
            break
        case 1:
            userRole = UserRole.participant
            break
        default:
            userRole = UserRole.presenter
            break
        }
        
        pollUser = PollUser.init(id: user.uid, name: user.displayName, email: user.email, photoURL: user.photoURL, providerId: user.providerID, role: userRole, provider: loginProvider )
        
        
        //below two lines just for testing, can be removed later
        let msg:String  = String(format:"Login Sucessfull \n Display Name : \(pollUser!.Name) \n Email : \(pollUser!.Email) \n Provider Id: \(pollUser!.ProviderId) \n User Id : \(pollUser!.Id) \n Photo URL : \(pollUser!.PhotoURL)")
        
        print(msg)
        
        MBProgressHUD.hide(for: self.view, animated: true)
        self.performSegue(withIdentifier: "segueLoginResultDetailVC", sender: nil)
        
    }
    
    func fireBaseSignUpComplete(user : FIRUser){
        
        self.btnLogout.isHidden = false
        self.loginButton.isHidden = true
        self.firLoginView.isHidden = true
        self.firebaseLogin(provider: UserProvider.custom)
    }
    

    
    
     // MARK: - Navigation
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
//        if let loginResultVC:LoginResultDetailViewController = segue.destination as? LoginResultDetailViewController {
//        
//        loginResultVC.fbEmail.text = "email"
//        loginResultVC.fbName.text = "name"
//        }
        
     }
    
    // MARK: - Helper functions
    
    func displayAlert(titleStr:String, messageStr:String){
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // align all subviews Horizontally Centered to view
    func alignSubviews(){
        let x = view.center.x
        
        firLoginView.center = CGPoint(x: x, y: firLoginView.center.y)
    }
    
    //Not in use currently
    func fetchFBProfile(){
        
        print("fetch FB profile")
        
        let parameter = ["fields": "id, email, name, picture.type(large), cover"]
        FBSDKGraphRequest(graphPath: "me", parameters:parameter ).start { (connection, result, error) -> Void in
            if error != nil{
                print("FBSDKGraphRequest error : \(error)")
                return
            }
            print(result!)
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
            
            //            self.fbName.text = "\(name!) - \(fbId!)"
            //            self.fbEmail.text = "\(email!)"
            //            self.loadPic(imageUrl: dpUrl!, imgView: self.myPicView, activity: self.fbPicLoadActivity)
            //            self.loadPic(imageUrl: coverSourceUrl!, imgView: self.fbCoverPhoto, activity: self.coverPhotoActivity)
            
        }
    }
    
    func logoutFirebaseAndReset(){
        
        print("FireBase logout and reset")
        
        try! FIRAuth.auth()?.signOut()
        
        self.btnLogout.isHidden = true
        self.loginButton.isHidden = false
        self.firLoginView.isHidden = false
        
        pollUser = nil
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func firebaseLogin (provider: UserProvider){
        
        if provider == UserProvider.custom {
            FIRAuth.auth()?.signIn(withEmail: self.txtFirEmail.text!, password: self.txtFirPassword.text!, completion: { (firUser, error) in
                if error != nil {
                    print("Error while logging into firebase using custom user. Error :\n ", error!)
                    self.displayAlert(titleStr:"iPoll Login Error", messageStr: (error?.localizedDescription)!)
                    return
                }
                
                self.fireBaseLoginComplete(user: firUser!, loginProvider: provider)
            })
        }
        else{ // facebook login
            
            let fbToken = FBSDKAccessToken.current()
            guard let fbaccessTokenString = fbToken?.tokenString else {return}
            let firAuthCredentials = FIRFacebookAuthProvider.credential(withAccessToken: fbaccessTokenString)
            FIRAuth.auth()?.signIn(with: firAuthCredentials, completion: { (fireBaseUser, error) in
                if error != nil {
                    print("Error while logging into firebase using facebook user. Error :\n ", error!)
                    self.displayAlert(titleStr:"Facebook Login Error",  messageStr: (error?.localizedDescription)!)
                    return
                }
                
                self.fireBaseLoginComplete(user: fireBaseUser!, loginProvider: provider)
            })
        }
    }
}

