//
//  loginButton.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/03/03.
//  Copyright © 2019年 asahi. All rights reserved.
//

import UIKit


@IBDesignable class loginButton: UITextField {
    
    @IBInspectable var bottomBorderColor: UIColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        addBorderBottom(color: self.bottomBorderColor)
    }
    
    func addBorderBottom(color: UIColor) -> Void{
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - 1.0, width: self.frame.width, height: 1.0)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
