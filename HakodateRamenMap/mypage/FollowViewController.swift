//
//  FollowViewController.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/06/04.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit

class FollowViewController: FollowBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

}
