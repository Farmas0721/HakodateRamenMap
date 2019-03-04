//
//  inputForm.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/03/03.
//  Copyright © 2019年 asahi. All rights reserved.
//

import UIKit

@IBDesignable class TextFieldSettings: UITextField {

    @IBInspectable var bottomBorderColor: UIColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0){
        didSet{
            addBorderBottom(color: bottomBorderColor)
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0){
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
        }
    }
    
    private func addBorderBottom(color: UIColor){
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - 1.0, width: self.frame.width, height: 1.0)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

@IBDesignable class ButtonSettings: UIButton {
    @IBInspectable var radious: CGFloat = 0 {
        didSet{
            layer.cornerRadius = radious
        }
    }
    
}
