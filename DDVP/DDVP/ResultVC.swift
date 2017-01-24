//
//  ResultVC.swift
//  DDVP
//
//  Created by Pankaj Neve on 23/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    
    let pieChartView = PieChartView()

    @IBOutlet weak var chartView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.presenterTheme.value

    }
    
    override func viewDidLayoutSubviews() {
        // Set your constraint here
        pieChartView.center.x = view.center.x
        pieChartView.frame = chartView.frame
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pieChartFor(values: ["abc": 12], tempView: chartView)
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

    
    func pieChartFor(values: Any, tempView: UIView){
        
        pieChartView.frame = tempView.frame
        
        pieChartView.segments = [
            Segment(color: UIColor.orange, name:"Option 1", value: 313),
            Segment(color: UIColor.green, name:"Option 2", value: 67),
            Segment(color: UIColor.cyan, name:"Option 3", value: 113),
            Segment(color: UIColor.yellow, name:"Option 4", value: 87)
        ]
        pieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 12)
        pieChartView.showSegmentValueInLabel = true
        view.addSubview(pieChartView)
    }
}
