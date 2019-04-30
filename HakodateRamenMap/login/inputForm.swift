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
    
    @IBInspectable var leftIconImage: UIImage = UIImage() {
        didSet {
            setLeftView(image: leftIconImage)
        }
    }
    
    private func addBorderBottom(color: UIColor){
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - 1.0, width: self.frame.width, height: 1.0)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
    private func setLeftView(image: UIImage){
        self.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 3, y: 3, width: 15, height: 15))
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        backgroundView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.leftView = backgroundView
    }
}

@IBDesignable class ButtonSettings: UIButton {
    @IBInspectable var radious: CGFloat = 0 {
        didSet{
            layer.cornerRadius = radious
        }
    }
    
}
