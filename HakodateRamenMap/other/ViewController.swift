//
//  ViewController.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/02/19.
//  Copyright © 2019年 asahi. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UITabBar.appearance().barTintColor = UIColor.rgba(red: 242, green: 92, blue: 0, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = .white
        tabBar.tintColor = .white
    }


}

