//
//  TimeLine.swift
//  HakodateRamenMap
//
//  Created by Fuuya Yamada on 2019/03/02.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit

@IBDesignable class timelineForm: UITextField {
    
    @IBInspectable var bottomBorderColor: UIColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        addBorder(color: self.bottomBorderColor)
    }
    
    func addBorder(color: UIColor) -> Void{
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - 1.0, width: self.frame.width, height: 1.0)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
