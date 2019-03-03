//
//  NewAccountViewController.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/03/03.
//  Copyright © 2019年 asahi. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func returnPage(_ sender: Any) {
            navigationController?.popViewController(animated: true)
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
