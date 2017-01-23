//
//  PieChartView.swift
//  Pie Chart View
//
//  Created by Hamish Knight on 04/03/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

private extension CGFloat {
    
    /// Formats the CGFloat to a maximum of 1 decimal place.
    var formattedToOneDecimalPlace : String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self.native)) ?? "\(self)"
    }
}

/// Defines a segment of the pie chart
struct Segment {
    
    /// The color of the segment
    var color : UIColor
    
    /// The name of the segment
    var name : String
    
    /// The value of the segment
    var value : CGFloat
}

class PieChartView: UIView {

    /// An array of structs representing the segments of the pie chart
    var segments = [Segment]() {
        didSet { setNeedsDisplay() } // re-draw view when the values get set
    }
    
    /// Defines whether the segment labels should be shown when drawing the pie chart
    var showSegmentLabels = true {
        didSet { setNeedsDisplay() }
    }
    
    /// Defines whether the segment labels will show the value of the segment in brackets
    var showSegmentValueInLabel = false {
        didSet { setNeedsDisplay() }
    }
    
    /// The font to be used on the segment labels
    var segmentLabelFont = UIFont.systemFont(ofSize: 20) {
        didSet {
            textAttributes[NSFontAttributeName] = segmentLabelFont
            setNeedsDisplay()
        }
    }
    
    private let paragraphStyle : NSParagraphStyle = {
        var p = NSMutableParagraphStyle()
        p.alignment = .center
        return p.copy() as! NSParagraphStyle
    }()
    
    private lazy var textAttributes : [String : Any] = {
        return [NSParagraphStyleAttributeName : self.paragraphStyle, NSFontAttributeName : self.segmentLabelFont]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        // get current context
        let ctx = UIGraphicsGetCurrentContext()
        
        // radius is the half the frame's width or height (whichever is smallest)
        let radius = min(frame.width, frame.height) * 0.5
        
        // center of the view
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        
        // enumerate the total value of the segments by using reduce to sum them
        let valueCount = segments.reduce(0, {$0 + $1.value})
        
        // the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
        var startAngle = -CGFloat.pi * 0.5
        
        // loop through the values array
        for segment in segments {
            
            // set fill color to the segment color
            ctx?.setFillColor(segment.color.cgColor)
            
            // update the end angle of the segment
            let endAngle = startAngle + .pi * 2 * (segment.value / valueCount)
            
            // move to the center of the pie chart
            ctx?.move(to: viewCenter)
            
            // add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            // fill segment
            ctx?.fillPath()
            
            if showSegmentLabels { // do text rendering
                
                // get the angle midpoint
                let halfAngle = startAngle + (endAngle - startAngle) * 0.5;
                
                // the ratio of how far away from the center of the pie chart the text will appear
                let textPositionValue : CGFloat = 0.67
                
                // get the 'center' of the segment. It's slightly biased to the outer edge, as it's wider.
                let segmentCenter = CGPoint(x: viewCenter.x + radius * textPositionValue * cos(halfAngle), y: viewCenter.y + radius * textPositionValue * sin(halfAngle))
                
                // text to render – the segment value is formatted to 1dp if needed to be displayed.
                let textToRender = showSegmentValueInLabel ? "\(segment.name) (\(segment.value.formattedToOneDecimalPlace))" : segment.name
                
                // get the color components of the segement color
                guard let colorComponents = segment.color.cgColor.components else { return }
                
                // get the average brightness of the color
                let averageRGB = (colorComponents[0] + colorComponents[1] + colorComponents[2]) / 3
                
                // if too light, use black. If too dark, use white
                textAttributes[NSForegroundColorAttributeName] = (averageRGB > 0.7) ? UIColor.black : UIColor.white
                
                // the bounds that the text will occupy
                var renderRect = CGRect(origin: .zero, size: textToRender.size(attributes: textAttributes))
                
                // center the origin of the rect
                renderRect.origin = CGPoint(x: segmentCenter.x - renderRect.size.width * 0.5, y: segmentCenter.y - renderRect.size.height * 0.5)
                
                // draw text in the rect, with the given attributes
                textToRender.draw(in: renderRect, withAttributes: textAttributes)
            }
            
            // update starting angle of the next segment to the ending angle of this segment
            startAngle = endAngle
        }
    }
}
