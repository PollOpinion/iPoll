//
//  LoginResultDetailViewController.swift
//  DDVP
//
//  Created by Pankaj Neve on 17/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class LoginResultDetailViewController: UIViewController {
    
    @IBOutlet weak var myPicView: UIImageView!
    @IBOutlet weak var fbName: UILabel!
    @IBOutlet weak var fbEmail: UILabel!
    @IBOutlet weak var fbPicLoadActivity: UIActivityIndicatorView!
    @IBOutlet weak var coverPhotoActivity: UIActivityIndicatorView!
    @IBOutlet weak var fbCoverPhoto: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "Login Result"

        alignSubviews()
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
    
    // align all subviews Horizontally Centered to view
    func alignSubviews(){
        let x = view.center.x
        
        myPicView.center = CGPoint(x: x, y: myPicView.center.y)
        fbName.center = CGPoint(x: x, y: fbName.center.y)
        fbEmail.center = CGPoint(x: x, y: fbEmail.center.y)
        fbPicLoadActivity.center = CGPoint(x: x, y: fbPicLoadActivity.center.y)
        fbCoverPhoto.center = CGPoint(x: x, y: fbCoverPhoto.center.y)
        coverPhotoActivity.center = CGPoint(x: x, y: coverPhotoActivity.center.y)
        
    }

}
