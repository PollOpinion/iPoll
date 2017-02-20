//
//  LoginViewController.swift
//  DDVP
//
//  Created by Pankaj Neve on 11/01/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

var pollUser : PollUser?

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UIViewControllerTransitioningDelegate {
    
    let transition = CircularTransition()
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    @IBOutlet weak var aboutButton: UIButton!
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
        
        let overlapingView = UIView(frame: (self.view.frame))
        overlapingView.frame = self.view.frame
        overlapingView.center = self.view.center
        overlapingView.backgroundColor = Color.presenterTheme.value
        self.view.addSubview(overlapingView)
        self.view.bringSubview(toFront: overlapingView)
        
        animateScreen { (sucess:Bool) in
            if sucess == true{
                overlapingView.removeFromSuperview()
                self.loadLoginScreen()
            }
        }
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
        
        if result.isCancelled {
            print("FB login was cancelled by the user")
        }
        else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            firebaseLogin(provider: UserProvider.facebook)
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        
        print("FB logout complete")

        logoutFirebaseAndReset()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        print ("loginButtonWillLogin")
        
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
        
        if let profileVC:ProfileVC = segue.destination as? ProfileVC{
            
            profileVC.loginButton.delegate = self
        }
        
        if let aboutVC:AboutVC = segue.destination as? AboutVC {
        
        aboutVC.transitioningDelegate = self
        aboutVC.view.backgroundColor = aboutButton.backgroundColor
        aboutVC.modalPresentationStyle = .custom
        
        }
        
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
        
        aboutButton.layer.cornerRadius = aboutButton.layer.frame.width / 2
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
        
        self.roleSegment.selectedSegmentIndex = 0
        roleChanged()
        
        _ = self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func firebaseLogin (provider: UserProvider){
        
        if provider == UserProvider.custom {
            FIRAuth.auth()?.signIn(withEmail: self.txtFirEmail.text!, password: self.txtFirPassword.text!, completion: { (firUser, error) in
                if error != nil {
                    print("Error while logging into firebase using custom user. Error :\n ", error!)
                    self.displayAlert(titleStr:"iPoll Login Error", messageStr: (error?.localizedDescription)!)
                    
                    self.logoutFirebaseAndReset()
                    
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
                    
                    self.logoutFirebaseAndReset()
                    
                    return
                }
                
                self.fireBaseLoginComplete(user: fireBaseUser!, loginProvider: provider)
            })
        }
    }
    
    //MARK: segment value changed delegate
    
    func roleChanged() {
        print("Role Changed... ")
        
        switch self.roleSegment.selectedSegmentIndex {
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
    
    //MARK : transition delegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present
        transition.startingPoint = aboutButton.center
        transition.circleColor = aboutButton.backgroundColor!
        return transition
    
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .dismiss
        transition.startingPoint = aboutButton.center
        transition.circleColor = aboutButton.backgroundColor!
        return transition
    }
    
    func animateScreen(completion: ((Bool) -> Swift.Void)? = nil) {
        self.navigationController?.isNavigationBarHidden = true
        let splashScreen = UIImageView(frame: (self.view.frame))
        splashScreen.image = UIImage(named: "Default")
        self.view.addSubview(splashScreen)
        self.view.bringSubview(toFront: splashScreen)
        
        UIView.animate(withDuration: TimeInterval(4.0), animations:
            {
                //                splashScreen.layer.anchorPoint = CGPoint(x: 0.1, y: 1.0)
                //                splashScreen.frame = (self.view.frame)
                
                splashScreen.layer.transform = CATransform3DRotate(CATransform3DIdentity, -(CGFloat)(M_PI_2), 0, 1, 0)
                splashScreen.transform = CGAffineTransform(rotationAngle: 270.0)
                self.view.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
                
                splashScreen.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
                splashScreen.center = self.view.center
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
        }) { (finish:Bool) in
            self.navigationController?.isNavigationBarHidden = false
            splashScreen.removeFromSuperview()
            completion!(finish)
        }
    }
    
    func loadLoginScreen() {
        self.roleSegment.addTarget(self, action: #selector(LoginViewController.roleChanged), for: .valueChanged)
        self.roleChanged()
        
        self.view.addSubview(self.loginButton)
        
        self.loginButton.delegate = self
        
        self.btnLogout.center = self.view.center
        self.btnLogout.isHidden = true
        
        if (FBSDKAccessToken.current()) != nil{
            self.firebaseLogin(provider: UserProvider.facebook)
        }
        else{
            print("Auto fb login failed...")
        }
        
        self.alignSubviews()
    }
}

