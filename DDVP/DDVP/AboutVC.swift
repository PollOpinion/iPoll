//
//  AboutVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 08/02/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {


    @IBOutlet weak var wv: UIWebView!
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        closeButton.layer.cornerRadius = closeButton.layer.frame.width / 2
        
        let htmlFile = Bundle.main.path(forResource: "iPollAbout", ofType: "htm")
        let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        wv.loadHTMLString(htmlString!, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }

}
