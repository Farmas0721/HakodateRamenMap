//
//  FollowerViewController.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/06/04.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit

class FollowerViewController: FollowBaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
