//
//  ViewController.swift
//  CheckBoxSwift
//
//  Created by Richard Hyman on 2/18/19.
//  Copyright © 2019 Richard Hyman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RAHCheckboxDelegate {
    
    var checkbox1:      RAHCheckbox?
    var checkbox3:      RAHCheckbox?

    @IBOutlet weak var checkboxLabel: UILabel?
    @IBOutlet weak var checkbox2: RAHCheckbox?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkbox1 = RAHCheckbox.init(frame: CGRect(x:52, y:100, width:100, height:25))
                    //  this checkbox will be 100 x 100
        checkbox1?.delegate = self
        
        
        //  modify checkbox appearance
        //  the checkbox is initially checked on or off; default is off
        checkbox1?.setOn(true, animated: false)
        //  the checkmark is animated when checked on or
        //  (if NO) the static, but slightly more stylish checkmark is displayed
        //  default is YES
        checkbox1?.animateMark(true)
        //  change the duration of the animation; default is 0.5 secs
        checkbox1!.set(animationDuration: 0.35)

        //  modify checkbox (only) characteristics
        // change the background color of the checkbox; default is white
        checkbox1!.set(backgroundColor: UIColor(red: 0.5, green: 1.0, blue: 1.0, alpha: 0.2))
        // change the color and width of the border of the box; default is medium gray
        checkbox1!.set(boxBorderWidth: 4)
        checkbox1!.set(boxBorderColor: UIColor(red: 0.0, green: 0.0, blue: 0.8, alpha: 1.0))
        
        //  modify checkmark characteristics
        //  change checkmark color; the default is black
        checkbox1!.set(checkmarkColor: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
        //  change the stroke width used to draw the checkmark;
        //  default is 10% of full control width
        checkbox1!.set(checkmarkStrokeWidth: checkbox1!.frame.size.width*0.14)
        //  use the XMark instead of a checkmark; default is NO
        checkbox1?.use(XMark: false)
        self.view.addSubview(checkbox1!)
        
        self.checkbox2?.adjustFrame(rect: CGRect(x:52, y:220, width:100, height:25))
        self.checkbox2?.animateMark(false)
        self.checkbox2?.setOn(true, animated: false)
        
        checkbox3 = RAHCheckbox.init(frame: CGRect(x:52, y:340, width:100, height:25))
        checkbox3?.setOn(true, animated: false)
        checkbox3?.use(XMark: true)
        checkbox3?.set(checkmarkColor: UIColor.blue)
        checkbox3?.animateMark(true)  //  this is the default value
        checkbox3?.set(animationDuration: 1.0)
        self.view.addSubview(checkbox3!)
    }
    
    //   delegated from RAHCheckbox
    func checkboxChangedValue(isOn: Bool) {
        if(isOn) {
            self.checkboxLabel?.text = "Checkbox 1 is checked on."
        } else {
            self.checkboxLabel?.text = "Checkbox 1 is checked off."
        }
    }

}

