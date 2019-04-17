//
//  RAHCheckbox.swift
//  CheckBoxSwift
//
//  Created by Richard Hyman on 2/18/19.
//  Copyright © 2019 Richard Hyman. All rights reserved.
//

import UIKit

//  optional protocol that sends state of the checkbox when changed
protocol RAHCheckboxDelegate: AnyObject {
    func checkboxChangedValue(isOn: Bool)
}


/*
    Declaration of public functions
 
 
            class RAHCheckbox
             Public Functions
 
    public required init?(coder: NSCoder)
    public override init(frame: CGRect)
 
//      Background Color
    public func set(backgroundColor: UIColor)

//      Checkbox Characteristics
    public func set(boxBorderColor: UIColor)
    public func set(boxBorderWidth: CGFloat)

//       Checkmark Characteristics
    public func set(checkmarkColor: UIColor)
    public func set(checkmarkStrokeWidth: CGFloat)
    public func use(XMark: Bool)

//       Checkmark Animation
    public func animateMark(Bool)
    public func set(animationDuration: CGFloat)

//       Checkmark: get state on/off, set state
    public func isOn() -> Bool
    public func setOn(Bool, animated: Bool)
*/


public class RAHCheckbox: UIControl, CAAnimationDelegate {
    weak var delegate:RAHCheckboxDelegate?

    private var fullRectW: CGFloat = 0.0
    //     Taken from the width of the rect used to init this view
    //  used as characteristic length for all layer sizing/drawing
    //     Based on the width of the defined box containing this
    //  control; the height is ignored, and a square box
    //  is constructed.
    
    private var background:                 CALayer?
    private var checkBox:                   CALayer?
    private var checkMark:                  CAShapeLayer?
    
    private var on:                         Bool = false
    
    private var colorForBackground:         UIColor = .white
    
    //  checkbox characteristics
    private var checkboxBorderWidth:        CGFloat?
    private var checkboxColor:              UIColor?
    
    //  checkmark characteristics
    private var checkmarkWidth:             CGFloat?
    private var checkmarkColor:             UIColor?
    private var checkmarkAnimationDuration: CGFloat?
    private var animateCheckMark:           Bool?
    private var useXMark:                   Bool?
    
    
// MARK: __________ Init views and defaults
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupInRect(theRect: self.frame)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInRect(theRect: self.frame)
    }
    
    private func setupInRect(theRect: CGRect) {
        //    we will set up the view as a square, even if the user input a rect
        //  fullRectW is used as the characteristic size for defining the
        //  checkbox and checkmark
        self.fullRectW = theRect.size.width;
    
        self.setupControlFrameAndBackground(theRect: theRect)
    
        //  init the defaults for the properties the programmer can change
        self.setupDefaults(theRect: theRect)
    
        //  set up the checkbox and the checkmark
        self.setupCheckboxComponents(theRect: theRect)
    
        //  show the checkmark;  default is off
        self.drawCheckBox()
        //  init with the checkmark not drawn
    }
    
    private func setupControlFrameAndBackground(theRect: CGRect) {
        let rectWidth: CGFloat = theRect.size.width
        
        //    set up the frame for the entire control, which is about 15%
        //  larger than the checkbox on all 4 sides
        self.frame = CGRect(x:theRect.origin.x , y:theRect.origin.y, width:rectWidth, height:rectWidth)
        self.backgroundColor = UIColor.clear // background color of entire control
    
        //  the background behind the checkbox
        self.background = CALayer.init() //[CALayer layer]
        //  background frame is relative to self; not view containing self
        self.background!.frame = CGRect(x:rectWidth*0.2, y:rectWidth*0.2, width:rectWidth*0.6, height:rectWidth*0.6)
        self.background?.backgroundColor = self.colorForBackground.cgColor
    
        self.layer.addSublayer(self.background!)
    }
    
    private func setupDefaults(theRect: CGRect) {
        let rectWidth: CGFloat = theRect.size.width
        self.checkboxBorderWidth = 0.04 * rectWidth
        self.checkboxColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        self.checkmarkWidth = 0.10 * rectWidth
        self.checkmarkColor = .black
        self.checkmarkAnimationDuration = 0.5
        self.animateCheckMark = true
        self.useXMark = false
    }
    
    private func setupCheckboxComponents(theRect: CGRect) {
        let rectWidth: CGFloat = theRect.size.width
        
        checkBox = CALayer.init()
        checkMark = CAShapeLayer.init()

        checkBox?.frame = CGRect(x: 0, y: 0, width: rectWidth, height: rectWidth)
        checkBox?.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(checkBox!)
    
        checkMark?.frame = CGRect(x: 0, y: 0, width: rectWidth, height: rectWidth)
        checkMark?.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(checkMark!)
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
    
        //  the rect is defined in the InterfaceBuilder
        //  make sure the height is equal to the width
        var heightConstraint: NSLayoutConstraint?
        for constraint: NSLayoutConstraint in self.constraints {
            if constraint.firstAttribute == .height {
                heightConstraint = constraint
                break
            }
        }
        if heightConstraint != nil {
            heightConstraint?.constant = self.frame.size.width
        }
    }
    
    
    
    // MARK: __________ change checkbox & checkmark properties
    
    public func adjustFrame(rect: CGRect) {
        self.frame = rect
        self.background?.removeFromSuperlayer()
        self.checkBox?.removeFromSuperlayer()
        self.checkMark?.removeFromSuperlayer()
        self.setupInRect(theRect: rect)
    }
    
    public func set(backgroundColor: UIColor) {
        self.colorForBackground = backgroundColor
        self.background?.backgroundColor = self.colorForBackground.cgColor
    }
    
    public func set(boxBorderColor: UIColor) {
        self.checkboxColor = boxBorderColor
        self.drawCheckBox()
    }
    
    public func set(boxBorderWidth: CGFloat) {
        self.checkboxBorderWidth = boxBorderWidth
        self.drawCheckBox()
    }
    
    
    public func set(checkmarkColor: UIColor) {
        self.checkmarkColor = checkmarkColor
        self.drawCheckMark()
    }
    
    public func set(checkmarkStrokeWidth: CGFloat) {
        self.checkmarkWidth = checkmarkStrokeWidth
        self.drawCheckMark()
    }
    
    public func set(animationDuration: CGFloat) {
        self.checkmarkAnimationDuration = animationDuration
        self.drawCheckMark()
    }
    
    public func animateMark(_ animate: Bool) {
        self.animateCheckMark = animate
    }
    
    public func use(XMark: Bool) {
        self.useXMark = XMark
        self.drawCheckMark()
    }
    
    
    
    // MARK: __________ draw checkbox & checkmark
    
    private func drawCheckBox() {
        self.checkBox?.removeFromSuperlayer()
        
        let refXLength: CGFloat = self.fullRectW
        let borderWidth: CGFloat = self.checkboxBorderWidth!
    
        // create bezier path
        let aPath: UIBezierPath = UIBezierPath.init() //[UIBezierPath bezierPath];
        let strokeColor: UIColor = self.checkboxColor!
        let fillColor: UIColor = UIColor.clear //[UIColor clearColor];
        
        aPath.move(to: CGPoint(x: 0.15*refXLength, y: (0.15*refXLength + 0.5*borderWidth)))  // left most point
        aPath.addLine(to: CGPoint(x: (0.85*refXLength - 0.5*borderWidth), y: (0.15*refXLength + 0.5*borderWidth)))  //  right most vertice
        aPath.addLine(to: CGPoint(x: (0.85*refXLength - 0.5*borderWidth), y: (0.85*refXLength - 0.5*borderWidth)))  //  bottom right
        aPath.addLine(to: CGPoint(x: (0.15*refXLength + 0.5*borderWidth), y: (0.85*refXLength - 0.5*borderWidth)))  //  bottom right to bottom left
        aPath.addLine(to: CGPoint(x: (0.15*refXLength + 0.5*borderWidth), y: (0.15*refXLength + 0.5*borderWidth)))  //  bottom right to bottom left
        
        // create shape layer for the defined path
        let shapeLayer: CAShapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.lineWidth = self.checkboxBorderWidth!
        shapeLayer.path = aPath.cgPath
        
        self.checkBox = shapeLayer
        self.layer.addSublayer(shapeLayer)
    }
    
    private func drawCheckMark() {
        if(!self.on) {
            return;
        }
        if(self.checkMark != nil) {
            self.checkMark?.removeFromSuperlayer()
        }
        let refXLength: CGFloat = fullRectW;
        
        // create bezier path
        let aPath: UIBezierPath = UIBezierPath.init()
        var strokeColor: UIColor?
        var fillColor: UIColor?
        if(self.animateCheckMark! && !self.useXMark!) {
            aPath.move(to: CGPoint(x: (0.25*refXLength), y: (0.42*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.48*refXLength), y: (0.66*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.77*refXLength), y: (0.005*refXLength)))
            strokeColor = self.checkmarkColor
            fillColor = .clear
        } else if(!self.animateCheckMark! && !self.useXMark!) {
            aPath.move(to: CGPoint(x: (0.25*refXLength), y: (0.42*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.46*refXLength), y: (0.68*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.79*refXLength), y: (0.015*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.78*refXLength), y: (0.005*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.455*refXLength), y: (0.57*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.27*refXLength), y: (0.395*refXLength)))
            aPath.close()
            strokeColor = self.checkmarkColor
            fillColor = self.checkmarkColor
        } else {  //  self.useXMark, for both animated and not animated
            aPath.move(to: CGPoint(x: (0.3*refXLength), y: (0.3*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.7*refXLength), y: (0.7*refXLength)))
            aPath.move(to: CGPoint(x: (0.7*refXLength), y: (0.3*refXLength)))
            aPath.addLine(to: CGPoint(x: (0.3*refXLength), y: (0.7*refXLength)))
            strokeColor = self.checkmarkColor
            fillColor = .clear
        }

        // create shape layer for the defined path
        let shapeLayer: CAShapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = strokeColor?.cgColor
        shapeLayer.fillColor = fillColor?.cgColor
        shapeLayer.lineWidth = self.checkmarkWidth!
        shapeLayer.path = aPath.cgPath
        
        if(self.useXMark!) {
            shapeLayer.lineCap = CAShapeLayerLineCap.round  //swift3/4.0 use kCALineCapRound
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round  //swift3/4.0 use kCALineCapRound
        }
        
        // animate it
        //    https://oleb.net/blog/2010/12/animating-drawing-of-cgpath-with-cashapelayer/
        //    https://collectiveidea.com/blog/archives/2017/12/04/cabasicanimation-for-animating-strokes-plus-a-bonus-gratuitous-ui-interaction
        
        var animationDuration: CGFloat = 0.0;
        if(self.animateCheckMark!) {
            animationDuration = self.checkmarkAnimationDuration!
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = CFTimeInterval(animationDuration)
            
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            shapeLayer.add(pathAnimation, forKey: "strokeEndAnimation")
        }
        
        self.checkMark = shapeLayer;
        self.layer.addSublayer(shapeLayer)
    }
    
    
    
    // MARK: __________ track touches
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        //  the control momentarily dims when touched to provide feedback
        //  if you don't like the 'flash', comment this line out
        self.alpha = 0.7
        self.setNeedsDisplay()
        return true
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.alpha = 1.0
        
        if(touch?.view == self) {
            if(self.on) {
                self.on = false
                
                if(animateCheckMark!) {
                    UIView.animate(withDuration: Double(checkmarkAnimationDuration! * 0.5), animations: {
                            self.checkMark!.opacity = 0.0
                    })
                    //    Whether the animation is performed with UIView or CATransaction,
                    //  the completion block is being performed immediately, rather
                    //  than after the animation is complete. Perhaps due to the animation
                    //  being interrupted somehow, although the reason is unknown.
                    //    So, the CAShapeLayer is removed using this delay function instead
                    //  of a completion block in the previous UIView.animate call.
                    let theDelay = Double(checkmarkAnimationDuration! * 0.5)
                    DispatchQueue.main.asyncAfter(deadline: .now() + theDelay, execute: {
                        self.checkMark?.removeFromSuperlayer()
                    })

                } else {
                    self.checkMark?.removeFromSuperlayer()
                }
                
            } else {
                self.on = true
                self.drawCheckMark()
            }
            self.delegate?.checkboxChangedValue(isOn: self.on)
        }
    }
    
    
    // MARK: __________ determine and set state
    
    public func isOn() -> Bool {
        return self.on
    }
    
    public func setOn(_ on: Bool, animated: Bool)  {
        let saveAnimationSetting = self.animateCheckMark
        if(animated) {
            self.animateCheckMark = true
        }
        if(on) {
            self.on = true
            self.drawCheckMark()
        } else {
            self.on = false
            self.checkMark?.removeFromSuperlayer()
        }
        self.animateCheckMark = saveAnimationSetting
    }

}
