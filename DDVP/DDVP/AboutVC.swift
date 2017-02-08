//
//  AboutVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 08/02/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        closeButton.layer.cornerRadius = closeButton.layer.frame.width / 2
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
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

//        self.dismiss(animated: true, completion: nil)
    }

}
