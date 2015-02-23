//
//  CAMSeismograph.swift
//  Earthquake
//
//  Created by Chris Mays on 2/22/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//


import UIKit
@objc @IBDesignable class CAMSeismograph: UIView {
    
    @IBInspectable var magnitude : CGFloat = 10.0{
        didSet {
            scaler = magnitude
        }
    }
    var scaler : CGFloat = 1.0;
    var period : CGFloat = 3.0;
    var lineShape : CAShapeLayer?;
    
    override func prepareForInterfaceBuilder() {
        drawPath(true)
    }
    
    /*
        Draws the seismograph reading
    */
    func drawPath(animated : Bool){
        var bezierPath = path()
        if let lineShape = lineShape {
           lineShape.removeFromSuperlayer()
        }
        
        lineShape = CAShapeLayer()
        
        if let lineShape = lineShape {
            lineShape.path = bezierPath.CGPath
            
            if let window = self.window{
                lineShape.strokeColor = window.tintColor.CGColor
            }else{
                lineShape.strokeColor = UIColor.blackColor().CGColor
            }
            
            lineShape.fillColor = UIColor.clearColor().CGColor
            lineShape.lineWidth = 2.0
            lineShape.strokeStart = 0.0
            lineShape.strokeEnd = 1.0
            
            self.layer.addSublayer(lineShape)
            
            if(animated){
                var animatedStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
                animatedStrokeEnd.duration = 3.0
                animatedStrokeEnd.fromValue = 0.0
                animatedStrokeEnd.toValue = 1.0
                lineShape.addAnimation(animatedStrokeEnd, forKey: "strokeEndAnimation")
            }
        }
        
    }
    
    
    /*
        Creates the path of the seismograph reading
    */
    func path() -> UIBezierPath{
        var path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0.0), self.frame.size.height/CGFloat(2.0)))
        var point = CGPointZero
        let scaleIncrement =  (magnitude * 5.0)/self.frame.width
        
        var reachedMiddle = false
        
        for(var x : CGFloat = 0.0; x<=self.frame.size.width; x+=3.0){
            point = CGPointMake(x, yValue(x))
            path.addLineToPoint(point);
            if reachedMiddle {
                if scaler < magnitude{
                    scaler += scaleIncrement;
                }
            }else {
                if scaler > 1 {
                   scaler -= scaleIncrement
                }else{
                    reachedMiddle = true;
                }
            }
        }
        return path;
    }
    
    /*
        Determines the yValue for the given x
    */
    func yValue(x : CGFloat) -> CGFloat{
        let period : CGFloat = 3.0;
        let yScale = ((CGFloat(4.0)*self.frame.height)/CGFloat(100)) * (magnitude/scaler)
        let center = self.frame.size.height / CGFloat(2.0)
        
        let y: CGFloat = (sin(x*period)*yScale)+center;
        
        return y;
    }
    
    override func layoutSubviews() {
        if let lineShape = lineShape {
            drawPath(true)
        }
    }
}
