//
//  PresenterEventCollectionCell.swift
//  DDVP
//
//  Created by Pankaj Neve on 06/02/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class PresenterEventCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    var shakeEnabled:Bool = false
    
    
    //Mark : Shaking effect
    // This function shake the collection view cells
    func shakeIcons() {
        let shakeAnim = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnim.duration = 0.05
        shakeAnim.repeatCount = 2
        shakeAnim.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnim.fromValue = NSNumber(value: startAngle)
        shakeAnim.toValue = NSNumber(value: 3 * stopAngle)
        shakeAnim.autoreverses = true
        shakeAnim.duration = 0.2
        shakeAnim.repeatCount = 10000
        shakeAnim.timeOffset = 290 * drand48()
        
        //Create layer, then add animation to the element's layer
        let layer: CALayer = self.layer
        layer.add(shakeAnim, forKey:"shaking")
        shakeEnabled = true
    }
    
    // This function stop shaking the collection view cells
    func stopShakingIcons() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
        self.deleteButton.isHidden = true
        shakeEnabled = false
    }
    
}
